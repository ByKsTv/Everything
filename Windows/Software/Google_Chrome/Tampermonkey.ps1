# Tampermonkey 5.5+

$ScriptUrls = @(
    'https://adsbypasser.github.io/releases/adsbypasser.full.user.js'
)

$Id = 'gcalenpjmijncebpfijmoaglllgpjagf' # Tampermonkey BETA
$Path = 'C:\ProgramData\Tampermonkey\tm.json'
$Url = 'http://localhost:12121/tm.json'
$Chrome = "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"

New-Item -ItemType Directory -Path ([IO.Path]::GetDirectoryName($Path)) -Force | Out-Null

$i = 0
$scripts = @(
    foreach ($u in $ScriptUrls) {
        $i = $i + 1
        $t = (Invoke-WebRequest -Uri $u -UseBasicParsing).Content
        [ordered]@{
            name     = [IO.Path]::GetFileName(([Uri]$u).AbsolutePath)
            enabled  = $true
            position = $i
            uuid     = [guid]::NewGuid().Guid
            source   = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($t))
        }
    }
)

$json = [ordered]@{
    version  = '1'
    scripts  = $scripts
    settings = [ordered]@{
        configMode = 100
    }
} | ConvertTo-Json -Depth 6 -Compress

$enc = [Text.UTF8Encoding]::new($false)
[IO.File]::WriteAllText($Path, $json, $enc)

$sha = [Security.Cryptography.SHA256]::Create()
$hashBytes = $sha.ComputeHash($enc.GetBytes($json))
$hash = '1:' + ([BitConverter]::ToString($hashBytes).Replace('-', '').ToLowerInvariant())
$sha.Dispose()

$Policy = 'HKLM:\Software\Policies\Google\Chrome\3rdparty\extensions\' + $Id + '\jsonImport\1'
New-Item -Path $Policy -Force | Out-Null
New-ItemProperty -Path $Policy -Name 'hash' -Value $hash -PropertyType String -Force | Out-Null
New-ItemProperty -Path $Policy -Name 'url' -Value $Url -PropertyType String -Force | Out-Null
New-ItemProperty -Path $Policy -Name 'haltOnError' -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path $Policy -Name 'installAsSystemScripts' -Value 0 -PropertyType DWord -Force | Out-Null

$listener = [Net.HttpListener]::new()
$listener.Prefixes.Add('http://localhost:12121/')
$listener.Start()

Get-Process -Name chrome -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Process -FilePath $Chrome

$done = $false
while (-not $done) {
    $c = $listener.GetContext()
    if ($c.Request.RawUrl -match '^/tm\.json$') {
        $b = $enc.GetBytes($json)
        $c.Response.StatusCode = 200
        $c.Response.ContentType = 'application/json; charset=utf-8'
        $c.Response.ContentLength64 = $b.Length
        $c.Response.OutputStream.Write($b, 0, $b.Length)
        $c.Response.OutputStream.Close()
        $done = $true
    } else {
        $c.Response.StatusCode = 404
        $c.Response.Close()
    }
}

Start-Sleep -Seconds 5
$listener.Stop()
Remove-Item $Policy -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item $Path -Force -ErrorAction SilentlyContinue

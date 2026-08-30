Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if (-not ('System.Net.Http.HttpClient' -as [type])) {
    Add-Type -AssemblyName System.Net.Http
}

#region Helpers
function Write-Status([string]$Template, [hashtable]$Values = @{}) {
    $roleColors = @{ name = 'Yellow'; version = 'Magenta'; url = 'Cyan'; path = 'DarkCyan' }
    [Console]::BackgroundColor = 'Black'
    foreach ($part in [regex]::Split($Template, '(\{[a-zA-Z]+\})')) {
        $roleMatch = [regex]::Match($part, '^\{(?<role>[a-zA-Z]+)\}$')
        if ($roleMatch.Success) {
            $role = $roleMatch.Groups['role'].Value
            $color = if ($roleColors.ContainsKey($role)) {
                $roleColors[$role]
            } else {
                'White'
            }
            [Console]::ForegroundColor = $color
            [Console]::Write("'$($Values[$role])'")
        } else {
            [Console]::ForegroundColor = 'Green'
            [Console]::Write($part)
        }
    }
    [Console]::ResetColor()
    [Console]::WriteLine()
}

function Format-ByteSize([long]$Bytes) {
    if ($Bytes -ge 1GB) {
        return '{0:N2} GB' -f ($Bytes / 1GB)
    }
    if ($Bytes -ge 1MB) {
        return '{0:N2} MB' -f ($Bytes / 1MB)
    }
    if ($Bytes -ge 1KB) {
        return '{0:N2} KB' -f ($Bytes / 1KB)
    }
    return "$Bytes B"
}

function Invoke-FileDownload([Net.Http.HttpClient]$Client, [string]$Uri, [string]$Destination) {
    $bufferSize = 80KB
    $buffer = [byte[]]::new($bufferSize)
    $stopwatch = [Diagnostics.Stopwatch]::StartNew()
    $lastPercent = -1
    $lastReportSeconds = 0.0
    $totalRead = 0L

    try {
        $response = $Client.GetAsync($Uri, [Net.Http.HttpCompletionOption]::ResponseHeadersRead).GetAwaiter().GetResult()
        $response.EnsureSuccessStatusCode() | Out-Null
        $contentLength = $response.Content.Headers.ContentLength

        $responseStream = $response.Content.ReadAsStreamAsync().GetAwaiter().GetResult()
        $fileStream = [IO.File]::Create($Destination)
        try {
            while (($bytesRead = $responseStream.Read($buffer, 0, $bufferSize)) -gt 0) {
                $fileStream.Write($buffer, 0, $bytesRead)
                $totalRead += $bytesRead

                $elapsedSeconds = $stopwatch.Elapsed.TotalSeconds
                if ($elapsedSeconds - $lastReportSeconds -ge 1.0) {
                    $speed = "$(Format-ByteSize ([long]($totalRead / [Math]::Max($elapsedSeconds, 0.001))))/s"
                    if ($contentLength) {
                        $percent = [int](($totalRead / $contentLength) * 100)
                        if ($percent -ne $lastPercent) {
                            Write-Progress -Activity 'Downloading Deno' -Status "$(Format-ByteSize $totalRead) of $(Format-ByteSize $contentLength) ($speed)" -PercentComplete $percent
                            $lastPercent = $percent
                        }
                    } else {
                        Write-Progress -Activity 'Downloading Deno' -Status "$(Format-ByteSize $totalRead) ($speed)"
                    }
                    $lastReportSeconds = $elapsedSeconds
                }
            }
        } finally {
            $fileStream.Dispose()
            $responseStream.Dispose()
        }

        if ($totalRead -eq 0) {
            throw "Downloaded file '$Destination' is empty."
        }
    } finally {
        Write-Progress -Activity 'Downloading Deno' -Completed
    }
}
#endregion

#region Setup
$Owner = 'denoland'
$Repo = 'deno'
$AssetFileName = 'deno-x86_64-pc-windows-msvc.zip'
$Destination = [IO.Path]::Combine($env:USERPROFILE, 'Deno', 'Deno.exe')
#endregion

#region ResolveTag
# Resolve the latest tag via the /releases/latest redirect instead of api.github.com --
# unauthenticated calls to that endpoint aren't subject to the API's 60-requests/hour limit.
$redirectHandler = [Net.Http.HttpClientHandler]::new()
$redirectHandler.AllowAutoRedirect = $false
$redirectClient = [Net.Http.HttpClient]::new($redirectHandler)
$redirectClient.Timeout = [TimeSpan]::FromSeconds(30)
$redirectClient.DefaultRequestHeaders.UserAgent.ParseAdd('PowerShell-Deno-Updater')

try {
    $latestResponse = $redirectClient.GetAsync("https://github.com/$Owner/$Repo/releases/latest").GetAwaiter().GetResult()
    $location = $latestResponse.Headers.Location.ToString()
    $tagMatch = [regex]::Match($location, '/releases/tag/(?<tag>[^/]+)$')
    if (-not $tagMatch.Success) {
        throw "Could not parse release tag from redirect location '$location'."
    }
    $Tag = $tagMatch.Groups['tag'].Value
    $LatestVersion = $Tag -replace '^v', ''
} finally {
    $redirectClient.Dispose()
    $redirectHandler.Dispose()
}
#endregion

#region VersionCheck
$InstalledVersion = $null
if ([IO.File]::Exists($Destination)) {
    $InstalledVersion = [Diagnostics.FileVersionInfo]::GetVersionInfo($Destination).ProductVersion
}
#endregion

if ((-not $InstalledVersion) -or ($InstalledVersion -notmatch [regex]::Escape($LatestVersion))) {
    #region AssetLookup
    # /releases/expanded_assets/<tag> is the partial GitHub's own JS fetches to render the
    # Assets list -- the static /releases/tag/<tag> page ships that section as an empty
    # "Loading" placeholder, so it can't be scraped directly.
    $ExpandedAssetsUri = "https://github.com/$Owner/$Repo/releases/expanded_assets/$Tag"

    $assetsHandler = [Net.Http.HttpClientHandler]::new()
    $assetsClient = [Net.Http.HttpClient]::new($assetsHandler)
    $assetsClient.Timeout = [TimeSpan]::FromSeconds(30)
    $assetsClient.DefaultRequestHeaders.UserAgent.ParseAdd('PowerShell-Deno-Updater')
    try {
        $assetsHtml = $assetsClient.GetStringAsync($ExpandedAssetsUri).GetAwaiter().GetResult()
    } finally {
        $assetsClient.Dispose()
        $assetsHandler.Dispose()
    }

    # Require a literal '/' right before the filename and a literal closing quote right
    # after it (from the surrounding href="..." template) -- this pins the match to the
    # exact filename without a '$' end-of-string anchor, which would never fire here since
    # the fetched document has more content after each individual href. The '/' prefix
    # alone already excludes sibling assets like 'denort-...'/'libdenort-...', since
    # neither contains '/deno-x86_64-pc-windows-msvc.zip' as a substring.
    $assetPattern = '/' + [regex]::Escape($AssetFileName)
    $assetMatches = [regex]::Matches($assetsHtml, "href=""(?<href>[^""]*$assetPattern)""")
    if ($assetMatches.Count -eq 0) {
        throw "No matching asset '$AssetFileName' found at '$ExpandedAssetsUri'."
    }

    $baseUri = [Uri]::new($ExpandedAssetsUri)
    $resolvedUris = @($assetMatches | ForEach-Object {
            [Uri]::new($baseUri, $_.Groups['href'].Value).AbsoluteUri
        } | Select-Object -Unique)

    if ($resolvedUris.Count -gt 1) {
        throw "Multiple distinct matches for '$AssetFileName' found at '$ExpandedAssetsUri': $($resolvedUris -join ', ')"
    }

    $DDL = $resolvedUris[0]
    $SavePath = [IO.Path]::Combine($env:TEMP, $AssetFileName)
    #endregion

    Write-Status 'Downloading {name} version {version} from {url} to {path}' @{
        name    = 'Deno'
        version = $LatestVersion
        url     = $DDL
        path    = $SavePath
    }

    #region Download
    $downloadHandler = [Net.Http.HttpClientHandler]::new()
    $downloadClient = [Net.Http.HttpClient]::new($downloadHandler)
    $downloadClient.Timeout = [TimeSpan]::FromSeconds(30)
    $downloadClient.DefaultRequestHeaders.UserAgent.ParseAdd('PowerShell-Deno-Updater')
    try {
        Invoke-FileDownload -Client $downloadClient -Uri $DDL -Destination $SavePath
    } finally {
        $downloadClient.Dispose()
        $downloadHandler.Dispose()
    }
    #endregion

    #region Install
    $ExtractPath = Split-Path $Destination -Parent
    Write-Status 'Extracting {name} from {path} to {url}' @{
        name = $AssetFileName
        path = $SavePath
        url  = $ExtractPath
    }
    Expand-Archive -Path $SavePath -DestinationPath $ExtractPath -Force

    $OldPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::User)
    if (-not $OldPath.Contains($ExtractPath)) {
        [Environment]::SetEnvironmentVariable('Path', "$OldPath;$ExtractPath", [EnvironmentVariableTarget]::User)
        $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')
    }
    #endregion
}

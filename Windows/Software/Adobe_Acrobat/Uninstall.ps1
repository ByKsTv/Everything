Get-Process -Name 'acrotray', 'AdobeCollabSync', 'AcroCEF', 'Acrobat' -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

$apps = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match 'Adobe Acrobat' }
foreach ($app in $apps) {
    if ($app.PSChildName -match '^\{[0-9A-Fa-f-]{36}\}$') {
        Start-Process -FilePath "$env:SystemRoot\System32\msiexec.exe" -ArgumentList '/x', $app.PSChildName, '/qn', '/norestart' -Wait
    } elseif ($app.UninstallString -match '\{[0-9A-Fa-f-]{36}\}') {
        Start-Process -FilePath "$env:SystemRoot\System32\msiexec.exe" -ArgumentList '/x', $Matches[0], '/qn', '/norestart' -Wait
    } elseif ($app.QuietUninstallString) {
        Start-Process -FilePath "$env:SystemRoot\System32\cmd.exe" -ArgumentList '/c', $app.QuietUninstallString -Wait
    }
}

# https://www.adobe.com/devnet-docs/acrobatetk/tools/Labs/cleaner.html#downloads
$DDL = 'https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/2100120135/x64/AdobeAcroCleaner_DC2021.exe'
$FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
$SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'AdobeAcroCleaner'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

$Argument = '/silent /cleanlevel=1'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Running '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'AdobeAcroCleaner'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $SavePath -ArgumentList $Argument -Wait

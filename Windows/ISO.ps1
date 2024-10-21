[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Rufus: Show application settings: Check for updates: Disabled'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Akeo Consulting\Rufus') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Akeo Consulting\Rufus' -Force
}
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Akeo Consulting\Rufus' -Name 'UpdateCheckInterval' -Value -1 -PropertyType DWord -Force

$Rufus_DDL = ((Invoke-WebRequest -UseBasicParsing -Uri 'https://rufus.ie/en/').Links | Where-Object { ($_.outerHTML -match '.exe') } | Select-Object -First 1).href
$Rufus_Filename = [System.IO.Path]::GetFileName(([System.Uri]$Rufus_DDL).AbsolutePath)
$Rufus_SavePath = [System.IO.Path]::Combine($env:TEMP, $Rufus_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Rufus'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Rufus_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Rufus_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($Rufus_DDL, $Rufus_SavePath)

$Windows_DDL = ((Invoke-WebRequest -UseBasicParsing -Uri 'https://massgrave.dev/windows_ltsc_links').Links | Where-Object { $_.outerHTML -match 'windows' -and $_.outerHTML -match '10' -and $_.outerHTML -match 'iot' -and $_.outerHTML -match 'enterprise' -and $_.outerHTML -match 'ltsc' -and $_.outerHTML -match 'x64' } | Select-Object -First 1).href
$Windows_Filename = [System.IO.Path]::GetFileName(([System.Uri]$Windows_DDL).AbsolutePath)
$Windows_SavePath = [System.IO.Path]::Combine($env:TEMP, $Windows_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Windows 10 IoT Enterprise LTSC x64'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Windows_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Windows_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($Windows_DDL, $Windows_SavePath)

$Rufus_Argument = "--gui --iso=$Windows_SavePath"
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Starting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Rufus'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Rufus_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Rufus_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $Rufus_SavePath -ArgumentList $Rufus_Argument
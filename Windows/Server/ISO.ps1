[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Rufus: Show application settings: Check for updates: Disabled'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -LiteralPath 'HKCU:\SOFTWARE\Akeo Consulting\Rufus') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Akeo Consulting\Rufus' -Force
}
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Akeo Consulting\Rufus' -Name 'UpdateCheckInterval' -Value -1 -PropertyType DWord -Force

$Rufus_DDL = ((Invoke-WebRequest -UseBasicParsing -Uri 'https://rufus.ie/en/').Links | Where-Object { $_.outerHTML -match '.exe' } | Select-Object -First 1).href
$Rufus_Filename = [IO.Path]::GetFileName(([URI]$Rufus_DDL).AbsolutePath)
$Rufus_SavePath = [IO.Path]::Combine($env:TEMP, $Rufus_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Rufus'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Rufus_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Rufus_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($Rufus_DDL, $Rufus_SavePath)

$Windows_DDL = ((Invoke-WebRequest -UseBasicParsing -Uri 'https://massgrave.dev/windows_server_links').Links | Where-Object { $_.outerHTML -match 'en-us' -and $_.outerHTML -match 'windows' -and $_.outerHTML -match 'server' -and $_.outerHTML -match 'x64' } | Select-Object -First 1).href
$Windows_Filename = [IO.Path]::GetFileName(([URI]$Windows_DDL).AbsolutePath)
$Windows_SavePath = [IO.Path]::Combine($env:TEMP, $Windows_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Windows Server 2025'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Windows_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Windows_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($Windows_DDL, $Windows_SavePath)

$Rufus_Argument = "--gui --iso=$Windows_SavePath"
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Starting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Rufus'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Rufus_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Rufus_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $Rufus_SavePath -ArgumentList $Rufus_Argument -Wait

$USB_Unattend_Drive = (Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 }).DeviceID
if ($USB_Unattend_Drive) {
    $USB_Unattend_DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/server/autounattend.xml'
    $USB_Unattend_Filename = [IO.Path]::GetFileName(([URI]$USB_Unattend_DDL).AbsolutePath)
    $USB_Unattend_SavePath = [IO.Path]::Combine($USB_Unattend_Drive, $USB_Unattend_Filename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$USB_Unattend_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$USB_Unattend_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$USB_Unattend_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($USB_Unattend_DDL, $USB_Unattend_SavePath)
}
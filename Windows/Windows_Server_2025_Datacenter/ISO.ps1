[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Rufus: Show application settings: Check for updates: Disabled'); [Console]::ResetColor(); [Console]::WriteLine()
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Akeo Consulting\Rufus')) {
    New-Item 'HKCU:\SOFTWARE\Akeo Consulting\Rufus' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Akeo Consulting\Rufus' -Name 'UpdateCheckInterval' -Value -1 -PropertyType DWord -Force

$Rufus_DDL = ((Invoke-WebRequest -UseBasicParsing -Uri 'https://rufus.ie/en/').Links | Where-Object { $_.outerHTML -match '.exe' } | Select-Object -First 1).href
$Rufus_FileName = [IO.Path]::GetFileName(([URI]$Rufus_DDL).AbsolutePath)
$Rufus_SavePath = [IO.Path]::Combine($env:TEMP, $Rufus_FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Rufus'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Rufus_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Rufus_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($Rufus_DDL, $Rufus_SavePath)

$Windows_DDL = ((Invoke-WebRequest -UseBasicParsing -Uri 'https://massgrave.dev/windows-server-links').Links | Where-Object { $_.outerHTML -match 'en-us' } | Select-Object -First 1).href
Start-Process $Windows_DDL

Add-Type -AssemblyName System.Windows.Forms
$Popup_Usermanual = New-Object System.Windows.Forms.Form -Property @{ TopMost = $true }
$Popup_Text = 'Manually download the ISO file and click OK when download completed.'
[Windows.Forms.MessageBox]::Show($Popup_Usermanual, $Popup_Text, '', 'OK') | Out-Null

$DownloadsDir = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
$Windows_SavePath = (Get-ChildItem -Path $DownloadsDir -File | Where-Object { $_.Name -match 'en-us_windows' }).FullName

$Argument = "--gui --iso=$Windows_SavePath"
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Starting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Rufus'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Rufus_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $Rufus_SavePath -ArgumentList $Argument -Wait

$USB_Unattend_Drive = (Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 }).DeviceID
if ($USB_Unattend_Drive) {
    $USB_Unattend_DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Windows_Server_2025_Datacenter/autounattend.xml'
    $USB_Unattend_FileName = [IO.Path]::GetFileName(([URI]$USB_Unattend_DDL).AbsolutePath)
    $USB_Unattend_SavePath = [IO.Path]::Combine($USB_Unattend_Drive, $USB_Unattend_FileName)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$USB_Unattend_FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$USB_Unattend_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$USB_Unattend_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($USB_Unattend_DDL, $USB_Unattend_SavePath)

    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/USB_Driver/Download.ps1')
    $USB_Driver_SavePath_Drive = [IO.Path]::Combine($USB_Unattend_Drive, 'Drivers')
    if (-not (Test-Path $USB_Driver_SavePath_Drive)) {
        New-Item $USB_Driver_SavePath_Drive -ItemType Directory
    }
    Copy-Item -Path $Dir_SavePath -Recurse -Destination $USB_Driver_SavePath_Drive
    Invoke-Item $USB_Driver_SavePath_Drive
}
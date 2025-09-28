$DDL = 'https://downloads.nordcdn.com/apps/windows/NordVPN/latest/NordVPNInstall.exe'
$FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
$SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'NordVPN'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

$Argument = '/verysilent'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'NordVPN'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $SavePath -ArgumentList $Argument -Wait

$DesktopShortcut = "$env:PUBLIC\Desktop\NordVPN.lnk"
if (Test-Path -Path $DesktopShortcut) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Deleting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'NordVPN'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' desktop shortcut from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DesktopShortcut'"); [Console]::ResetColor(); [Console]::WriteLine()
    Remove-Item -Path $DesktopShortcut
}

# Settings > General > Launch the app at Windows startup > Off
if ($null -ne (Get-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run').GetValue('NordVPN')) {
    Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'NordVPN'
}

Start-Process powershell.exe -ArgumentList "-NoProfile -Command Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/NordVPN/User.ps1')"
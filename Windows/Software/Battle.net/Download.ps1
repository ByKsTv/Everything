$DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Battle.net/Settings_v0.ini'
$FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
$Dir = "$HOME\Documents\Overwatch\Settings"
$SavePath = [IO.Path]::Combine($Dir, $FileName)

if (-not (Test-Path $SavePath)) {
    New-Item -Path $SavePath -ItemType File -Force

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Overwatch'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' settings from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)
}

$Dir = "$env:APPDATA\Battle.net"
if (-not (Test-Path $Dir)) {
    New-Item -Path $Dir -ItemType Directory -Force
}

$DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Battle.net/Battle.net.json'
$FileName = 'Battle.net.config'
$SavePath = [IO.Path]::Combine($Dir, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Battle.net'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' settings from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

$DDL = 'https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe'
$FileName = 'Battle.net-Setup.exe'
$SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Battle.net'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)
                
$Argument = "--lang=enUS --installpath=`"${env:ProgramFiles(x86)}\Battle.net`""
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Battle.net'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $SavePath -ArgumentList $Argument

do {
    Start-Sleep -Milliseconds 1000 
} until (Get-Process | Where-Object { $_.MainWindowTitle -match 'Battle.net Login' })


# Task Manager: Startup apps: Delete: Battle.net
if ($null -ne (Get-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run').GetValue('Battle.net')) {
    Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'Battle.net'
}

Start-Process powershell.exe -ArgumentList "-NoProfile -Command Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Battle.net/User.ps1')"
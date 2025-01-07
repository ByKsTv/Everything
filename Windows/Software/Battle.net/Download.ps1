$OverWatch_RemoteSettings_DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Battle.net/Settings_v0.ini'
$OverWatch_RemoteSettings_Filename = [IO.Path]::GetFileName(([URI]$OverWatch_RemoteSettings_DDL).AbsolutePath)
$OverWatch_LocalSettings_Dir = "$HOME\Documents\Overwatch\Settings"
$OverWatch_LocalSettings_SavePath = [IO.Path]::Combine($OverWatch_LocalSettings_Dir, $OverWatch_RemoteSettings_Filename)

if (-not (Test-Path $OverWatch_LocalSettings_SavePath)) {
    New-Item -Path $OverWatch_LocalSettings_SavePath -ItemType File -Force

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Overwatch'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' settings from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$OverWatch_RemoteSettings_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$OverWatch_LocalSettings_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($OverWatch_RemoteSettings_DDL, $OverWatch_LocalSettings_SavePath)
}

$BattleNET_AppData_Dir = "$env:APPDATA\Battle.net"
if (-not (Test-Path $BattleNET_AppData_Dir)) {
    New-Item -Path $BattleNET_AppData_Dir -ItemType Directory -Force
}

$BattleNET_AppData_DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Battle.net/Battle.net.config'
$BattleNET_AppData_Filename = [IO.Path]::GetFileName(([URI]$BattleNET_AppData_DDL).AbsolutePath)
$BattleNET_AppData_SavePath = [IO.Path]::Combine($BattleNET_AppData_Dir, $BattleNET_AppData_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Battle.net'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' settings from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_AppData_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_AppData_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($BattleNET_AppData_DDL, $BattleNET_AppData_SavePath)

$BattleNET_DDL = 'https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe'
$BattleNET_Filename = 'Battle.net-Setup.exe'
$BattleNET_SavePath = [IO.Path]::Combine($env:TEMP, $BattleNET_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Battle.net'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($BattleNET_DDL, $BattleNET_SavePath)
                
$BattleNET_Argument = '--lang=enUS --installpath="C:\Program Files (x86)\Battle.net"'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Battle.net'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $BattleNET_SavePath -ArgumentList $BattleNET_Argument
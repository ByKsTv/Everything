$BattleNET_DDL = 'https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe'
$BattleNET_Filename = 'Battle.net-Setup.exe'
$BattleNET_SavePath = [IO.Path]::Combine($env:TEMP, $BattleNET_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Battle.net'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($BattleNET_DDL, $BattleNET_SavePath)
                
$BattleNET_Argument = '--lang=enUS --installpath="C:\Program Files (x86)\Battle.net"'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Battle.net'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $BattleNET_SavePath -ArgumentList $BattleNET_Argument

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Waiting for '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Battle.net'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' login page to appear'); [Console]::ResetColor(); [Console]::WriteLine()
while ($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'Battle.net Login' } -ErrorAction SilentlyContinue)) {
    Start-Sleep -Milliseconds 1000
}
Stop-Process -Name 'Battle.net'
        
$BattleNet_Config = [IO.Path]::Combine($env:APPDATA, 'Battle.net', 'Battle.net.config')
if (-not ($BattleNet_Config)) {
    New-Item $BattleNet_Config -ItemType File -Force
}
$BattleNet_JSON = Get-Content $BattleNet_Config -Raw | ConvertFrom-Json
        
if (-not ($BattleNet_JSON.Client.AutoLogin)) {
    $BattleNet_JSON.Client | Add-Member -MemberType NoteProperty -Name 'AutoLogin' -Value 'true'
}
if (-not ($BattleNet_JSON.Client.GameLaunchWindowBehavior)) {
    $BattleNet_JSON.Client | Add-Member -MemberType NoteProperty -Name 'GameLaunchWindowBehavior' -Value '2'
}
if (-not ($BattleNet_JSON.Client.DefaultStartupScreen)) {
    $BattleNet_JSON.Client | Add-Member -MemberType NoteProperty -Name 'DefaultStartupScreen' -Value '1'
}
if (-not ($BattleNet_JSON.Client.Install)) {
    $BattleNet_JSON.Client | Add-Member -MemberType NoteProperty -Name 'Install' -Value @{ }
}
if (-not ($BattleNet_JSON.Client.Install.PauseUpdatesWhenLaunching)) {
    $BattleNet_JSON.Client.Install | Add-Member -MemberType NoteProperty -Name 'PauseUpdatesWhenLaunching' -Value 'false'
}
if (-not ($BattleNet_JSON.Client.Install.DownloadLimitNextPatchInBps)) {
    $BattleNet_JSON.Client.Install | Add-Member -MemberType NoteProperty -Name 'DownloadLimitNextPatchInBps' -Value '0'
}
if (-not ($BattleNet_JSON.Client.Install.CreateDesktopShortcut)) {
    $BattleNet_JSON.Client.Install | Add-Member -MemberType NoteProperty -Name 'CreateDesktopShortcut' -Value '0'
}
        
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Battle.net: Keep me logged in'); [Console]::ResetColor(); [Console]::WriteLine()
$BattleNet_JSON.Client.AutoLogin = 'true'

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Battle.net: App: ON GAME LAUNCH: Exit Battle.net completely'); [Console]::ResetColor(); [Console]::WriteLine()
$BattleNet_JSON.Client.GameLaunchWindowBehavior = '2'

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Battle.net: App: ON STARTUP, VIEW: Last Viewed Game Page'); [Console]::ResetColor(); [Console]::WriteLine()
$BattleNet_JSON.Client.DefaultStartupScreen = '1'

$BattleNet_JSON.Client.Install = @{ }

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Battle.net: Downloads: Game updates: Pause updates when I launch a game: Off'); [Console]::ResetColor(); [Console]::WriteLine()
$BattleNet_JSON.Client.Install.PauseUpdatesWhenLaunching = 'false'

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Battle.net: Downloads: Download Limits: Pre-release Content: No limit'); [Console]::ResetColor(); [Console]::WriteLine()
$BattleNet_JSON.Client.Install.DownloadLimitNextPatchInBps = '0'

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Battle.net: Downloads: Game Installation: Automatically create a desktop icon for games during installtion: Off'); [Console]::ResetColor(); [Console]::WriteLine()
$BattleNet_JSON.Client.Install.CreateDesktopShortcut = 'false'
        
$BattleNet_JSON | ConvertTo-Json -Depth 10 | Set-Content $BattleNet_Config
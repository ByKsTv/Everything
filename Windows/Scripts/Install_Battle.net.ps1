$BattleNet_Config = [IO.Path]::Combine($env:APPDATA, 'Battle.net', 'Battle.net.config')
if (-not (Test-Path $BattleNet_Config)) {
    New-Item -ItemType Directory -Path (Split-Path -Path $BattleNet_Config) -Force
}
$BattleNet_JSON = @{
    Client = @{
        
        # Battle.net: Keep me logged in
        AutoLogin = 'true'

        # Battle.net: App: ON GAME LAUNCH: Exit Battle.net completely
        GameLaunchWindowBehavior = '2'
        
        # Battle.net: App: ON STARTUP, VIEW: Last Viewed Game Page
        DefaultStartupScreen = '1'

        Install = @{

            # Battle.net: Downloads: Game updates: Pause updates when I launch a game: Off
            PauseUpdatesWhenLaunching = 'false'
            
            # Battle.net: Downloads: Download Limits: Pre-release Content: No limit
            DownloadLimitNextPatchInBps = '0'
            
            # Battle.net: Downloads: Game Installation: Automatically create a desktop icon for games during installtion: Off
            CreateDesktopShortcut = 'false'
        }
    }
}
$BattleNet_JSON | ConvertTo-Json -Depth 10 | Set-Content -Path $BattleNet_Config

$BattleNET_DDL = 'https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe'
$BattleNET_Filename = 'Battle.net-Setup.exe'
$BattleNET_SavePath = [IO.Path]::Combine($env:TEMP, $BattleNET_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Battle.net'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($BattleNET_DDL, $BattleNET_SavePath)
                
$BattleNET_Argument = '--lang=enUS --installpath="C:\Program Files (x86)\Battle.net"'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Battle.net'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $BattleNET_SavePath -ArgumentList $BattleNET_Argument -Wait

if ($null -ne (Get-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run').GetValue('Battle.net')) {
	Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'Battle.net'
}
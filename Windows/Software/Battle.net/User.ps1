[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Waiting for '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'User'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to login to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Battle.net'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' account'); [Console]::ResetColor(); [Console]::WriteLine()

do {
    $BattleNET_UserLogin_File = (Get-ChildItem "$env:AppData\Battle.net" -Filter *.config | Where-Object { $_.Name -ne 'battle.net.config' }).Name
    Start-Sleep 1
} until ($BattleNET_UserLogin_File)

Get-Process -Name 'Battle.net' -ErrorAction SilentlyContinue | Stop-Process -Force

$BattleNET_UserLogin_Settings_DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Battle.net/User.json'
$BattleNET_UserLogin_Settings_Path = [IO.Path]::Combine("$env:AppData\Battle.net", $BattleNET_UserLogin_File)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Battle.net'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' settings from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_UserLogin_Settings_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_UserLogin_Settings_Path'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($BattleNET_UserLogin_Settings_DDL, $BattleNET_UserLogin_Settings_Path)
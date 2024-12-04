$BattleNET_DDL = 'https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe'
$BattleNET_Filename = 'Battle.net-Setup.exe'
$BattleNET_SavePath = [IO.Path]::Combine($env:TEMP, $BattleNET_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Battle.net'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($BattleNET_DDL, $BattleNET_SavePath)
                
$BattleNET_Argument = '--lang=enUS --installpath="C:\Program Files (x86)\Battle.net"'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Battle.net'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BattleNET_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $BattleNET_SavePath -ArgumentList $BattleNET_Argument
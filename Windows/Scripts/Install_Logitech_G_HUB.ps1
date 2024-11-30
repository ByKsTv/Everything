$LogitechGHUB_DDL = 'https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe'
$LogitechGHUB_Filename = [IO.Path]::GetFileName(([URI]$LogitechGHUB_DDL).AbsolutePath)
$LogitechGHUB_SavePath = [IO.Path]::Combine($env:TEMP, $LogitechGHUB_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Logitech G HUB'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LogitechGHUB_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LogitechGHUB_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($LogitechGHUB_DDL, $LogitechGHUB_SavePath)

$LogitechGHUB_Argument = '--silent'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Logitech G HUB'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LogitechGHUB_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LogitechGHUB_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $LogitechGHUB_SavePath -ArgumentList $LogitechGHUB_Argument
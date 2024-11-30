$NordVPN_DDL = 'https://downloads.nordcdn.com/apps/windows/NordVPN/latest/NordVPNInstall.exe'
$NordVPN_Filename = [IO.Path]::GetFileName(([URI]$NordVPN_DDL).AbsolutePath)
$NordVPN_SavePath = [IO.Path]::Combine($env:TEMP, $NordVPN_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'NordVPN'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NordVPN_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NordVPN_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($NordVPN_DDL, $NordVPN_SavePath)

$NordVPN_Argument = '/verysilent'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'NordVPN'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NordVPN_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NordVPN_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $NordVPN_SavePath -ArgumentList $NordVPN_Argument
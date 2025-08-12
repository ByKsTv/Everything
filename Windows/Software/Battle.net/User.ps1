[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Waiting for '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'User'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to login to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Battle.net'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' account'); [Console]::ResetColor(); [Console]::WriteLine()

do {
    $UserLogin_File = (Get-ChildItem -Path "$env:AppData\Battle.net" -Filter '*.config' | Where-Object { $_.Name -ne 'battle.net.config' }).Name
    Start-Sleep -Milliseconds 1000
} until ($UserLogin_File)

Get-Process -Name 'Battle.net' -ErrorAction SilentlyContinue | Stop-Process -Force

$DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Battle.net/User.json'
$SavePath = [IO.Path]::Combine("$env:AppData\Battle.net", $UserLogin_File)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Battle.net'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' settings from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Waiting for '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'NordVPN'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to open '); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process -FilePath "$env:ProgramFiles\NordVPN\NordVPN.exe"

do {
    $UserLogin_File = (Get-ChildItem -Path "$env:ProgramData\NordVPN\settings" -Filter '*.json' | Where-Object { $_.Name -notmatch '.bak' }).FullName
    Start-Sleep -Milliseconds 1000
} until ($UserLogin_File)

Get-Process -Name 'NordVPN' -ErrorAction SilentlyContinue | Stop-Process -Force

$DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/NordVPN/User.json'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'NordVPN'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' settings from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$UserLogin_File'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $UserLogin_File)

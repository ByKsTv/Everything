Write-Host 'qBittorrent: Downloading' -ForegroundColor green -BackgroundColor black
$qBittorrent = New-Object System.Net.WebClient
$qBittorrent.Headers.Add('user-agent', 'Wget')
$qBittorrent.DownloadFile('https://sourceforge.net/projects/qbittorrent/files/latest/download', "$ENV:temp\qBittorrent.exe")

Write-Host 'qBittorrent: Installing' -ForegroundColor green -BackgroundColor black
Start-Process $ENV:temp\qBittorrent.exe -ArgumentList '/S'

Write-Host 'qBittorrent: Using custom settings' -ForegroundColor green -BackgroundColor black
if (!(Test-Path -Path "$env:APPDATA\qBittorrent\qBittorrent.ini")) {
    Write-Host 'qBittorrent: Creating qBittorrent folder' -ForegroundColor green -BackgroundColor black
    New-Item -Path "$env:APPDATA\qBittorrent" -Value qBittorrent -ItemType Directory
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/qBittorrent.ini', "$env:APPDATA\qBittorrent\qBittorrent.ini")
}
Write-Host 'Logitech G HUB: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe', "$env:TEMP\lghub_installer.exe")

Write-Host 'Logitech G HUB: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\lghub_installer.exe -ArgumentList '--silent'
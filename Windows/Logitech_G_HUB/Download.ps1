Write-Host 'Logitech G HUB > Download' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe', "$env:TEMP\lghub_installer.exe")
Write-Host 'Logitech G HUB > Install' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\lghub_installer.exe -ArgumentList '--silent'
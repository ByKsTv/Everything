Write-Host 'Telegram: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://telegram.org/dl/desktop/win64', "$env:TEMP\Telegram.exe")

Write-Host 'Telegram: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\Telegram.exe -ArgumentList '/VERYSILENT'
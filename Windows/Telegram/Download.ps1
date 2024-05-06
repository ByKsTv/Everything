Write-Host 'Telegram > Download' -ForegroundColor green -BackgroundColor black
Invoke-WebRequest -Uri 'https://telegram.org/dl/desktop/win64' -OutFile $env:TEMP\Telegram.exe
Write-Host 'Telegram > Install' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\Telegram.exe -Args '/VERYSILENT'
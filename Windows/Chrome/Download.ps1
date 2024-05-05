Write-Host 'Chrome Setup' -ForegroundColor green -BackgroundColor black
Invoke-WebRequest -Uri https://dl.google.com/chrome/install/latest/chrome_installer.exe -OutFile $env:TEMP\chrome_installer.exe
Start-Process $env:TEMP\chrome_installer.exe
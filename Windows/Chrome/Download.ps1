Write-Host 'Chrome > Download' -ForegroundColor green -BackgroundColor black
#Invoke-WebRequest -Uri https://dl.google.com/chrome/install/latest/chrome_installer.exe -OutFile $env:TEMP\chrome_installer.exe
(New-Object System.Net.WebClient).DownloadFile('https://dl.google.com/chrome/install/latest/chrome_installer.exe', "$env:TEMP\chrome_installer.exe")
Write-Host 'Chrome > Install' -ForegroundColor green -BackgroundColor black
Start-Process $env:TEMP\chrome_installer.exe
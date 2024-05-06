Write-Host 'NordVPN > Download' -ForegroundColor green -BackgroundColor black
Invoke-WebRequest -Uri "https://downloads.nordcdn.com/apps/windows/NordVPN/latest/NordVPNInstall.exe" -OutFile $env:TEMP\NordVPNInstall.exe
Write-Host 'NordVPN > Install' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\NordVPNInstall.exe -Args "/silent"
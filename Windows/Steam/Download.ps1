Write-Host 'Steam > Download' -ForegroundColor green -BackgroundColor black
Invoke-WebRequest -Uri 'https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe' -OutFile $env:TEMP\SteamSetup.exe
Write-Host 'Steam > Install' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\SteamSetup.exe -Args '/S' -Wait
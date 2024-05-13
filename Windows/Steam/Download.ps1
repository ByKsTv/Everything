Write-Host 'Steam: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe', "$env:TEMP\SteamSetup.exe")

Write-Host 'Steam: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\SteamSetup.exe -ArgumentList '/S'
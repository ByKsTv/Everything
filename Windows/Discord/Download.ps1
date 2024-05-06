Write-Host 'Discord > Download' -ForegroundColor green -BackgroundColor black
#Invoke-WebRequest -Uri 'https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x64' -OutFile $env:TEMP\DiscordSetup.exe
(New-Object System.Net.WebClient).DownloadFile('https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x64', "$env:TEMP\DiscordSetup.exe")
Write-Host 'Discord > Install' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\DiscordSetup.exe -Args '/S'
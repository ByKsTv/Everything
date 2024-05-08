Write-Host 'Discord > Download' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x64', "$env:TEMP\DiscordSetup.exe")
Write-Host 'Discord > Install' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\DiscordSetup.exe -ArgumentList '/S'
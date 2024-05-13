Write-Host 'Battle.net: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe', "$env:TEMP\Battle.net-Setup.exe")

Write-Host 'Battle.net: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\Battle.net-Setup.exe -ArgumentList '--lang=enUS --installpath="C:\Program Files (x86)\Battle.net"'
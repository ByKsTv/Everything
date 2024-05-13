Write-Host 'AnyDesk: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://download.anydesk.com/AnyDesk.exe', "$env:TEMP\AnyDesk.exe")

Write-Host 'AnyDesk: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\AnyDesk.exe -ArgumentList '--install "C:\Program Files (x86)\AnyDesk" --create-shortcuts --create-desktop-icon --silent'
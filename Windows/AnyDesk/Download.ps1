Write-Host 'AnyDesk > Download' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://download.anydesk.com/AnyDesk.exe', "$env:TEMP\AnyDesk.exe")
Write-Host 'AnyDesk > Install' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\AnyDesk.exe -ArgumentList '--install "C:\Program Files (x86)\AnyDesk" --create-shortcuts --create-desktop-icon --silent'
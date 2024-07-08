Write-Host 'Zoom: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://zoom.us/client/latest/ZoomInstaller.exe?archType=x64', "$env:TEMP\ZoomInstallerFull-x64.exe")

Write-Host 'Zoom: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\ZoomInstallerFull-x64.exe
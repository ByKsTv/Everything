Write-Host 'Google Chrome: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi', "$env:TEMP\googlechromestandaloneenterprise64.msi")

Write-Host 'Google Chrome: Installing' -ForegroundColor green -BackgroundColor black
Start-Process $env:TEMP\googlechromestandaloneenterprise64.msi -ArgumentList '/quiet' -Wait

Write-Host 'Google Chrome: Starting' -ForegroundColor green -BackgroundColor black
Start-Process "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"
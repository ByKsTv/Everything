Write-Host 'Chrome > Download' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi', "$env:TEMP\googlechromestandaloneenterprise64.msi")
Write-Host 'Chrome > Install' -ForegroundColor green -BackgroundColor black
Start-Process $env:TEMP\googlechromestandaloneenterprise64.msi -ArgumentList '/quiet' -Wait
Write-Host 'Chrome > Open' -ForegroundColor green -BackgroundColor black
Start-Process "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"
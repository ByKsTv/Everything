Write-Host 'Google Chrome: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi', "$env:TEMP\googlechromestandaloneenterprise64.msi")

Write-Host 'Google Chrome: Installing' -ForegroundColor green -BackgroundColor black
Start-Process $env:TEMP\googlechromestandaloneenterprise64.msi -ArgumentList '/quiet' -Wait

Write-Host 'Google Chrome: Starting' -ForegroundColor green -BackgroundColor black
Start-Process "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"

Write-Host 'Google Chrome: Opening default apps on Windows Settings' -ForegroundColor green -BackgroundColor black
Start-Process "ms-settings:defaultapps"

Write-Host 'Google Chrome: Waiting for user to set up default browser' -ForegroundColor green -BackgroundColor black
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show('Set up Google Chrome as Default Browser.

Press OK after Finished.' , 'Default Browser Notification' , 0, 64)
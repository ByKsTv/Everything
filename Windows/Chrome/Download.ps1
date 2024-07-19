Write-Host 'Google Chrome: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi', "$env:TEMP\googlechromestandaloneenterprise64.msi")

Write-Host 'Google Chrome: Installing' -ForegroundColor green -BackgroundColor black
Start-Process $env:TEMP\googlechromestandaloneenterprise64.msi -ArgumentList '/quiet' -Wait

Write-Host 'Google Chrome: Downloading group policy' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://dl.google.com/dl/edgedl/chrome/policy/policy_templates.zip', "$env:TEMP\policy_templates_chrome.zip")

Write-Host 'Google Chrome: Extracting group policy' -ForegroundColor green -BackgroundColor black
Expand-Archive -Path "$env:TEMP\policy_templates_chrome.zip" -DestinationPath "$env:TEMP\policy_templates_chrome" -ErrorAction SilentlyContinue

Write-Host 'Google Chrome: Importing group policy' -ForegroundColor green -BackgroundColor black
Move-Item -Path "$env:TEMP\policy_templates_chrome\windows\admx\chrome.admx" -Destination "$env:windir\PolicyDefinitions" -ErrorAction SilentlyContinue
Move-Item -Path "$env:TEMP\policy_templates_chrome\windows\admx\google.admx" -Destination "$env:windir\PolicyDefinitions" -ErrorAction SilentlyContinue
Move-Item -Path "$env:TEMP\policy_templates_chrome\windows\admx\en-US\chrome.adml" -Destination "$env:windir\PolicyDefinitions\en-US" -ErrorAction SilentlyContinue
Move-Item -Path "$env:TEMP\policy_templates_chrome\windows\admx\en-US\google.adml" -Destination "$env:windir\PolicyDefinitions\en-US" -ErrorAction SilentlyContinue

Write-Host 'Google Chrome: Opening default apps on Windows Settings' -ForegroundColor green -BackgroundColor black
Start-Process 'ms-settings:defaultapps'

Write-Host 'Google Chrome: Waiting for user to set up default browser' -ForegroundColor green -BackgroundColor black
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show('Set up Google Chrome as Default Browser.

Press OK after Finished.' , 'Default Browser Notification' , 0, 64)
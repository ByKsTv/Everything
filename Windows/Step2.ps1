Write-Host 'Step2: Task Scheduler: Removing current step' -ForegroundColor green -BackgroundColor black
Unregister-ScheduledTask -TaskName Step2 -Confirm:$false

Write-Host 'Step2: Windows Update: Checking for updates' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath "$env:SystemRoot\System32\UsoClient.exe" -ArgumentList StartInteractiveScan

Write-Host 'Step2: Windows Key: Activating' -ForegroundColor green -BackgroundColor black
& ([ScriptBlock]::Create(((New-Object System.Net.WebClient).DownloadString('https://get.activated.win/')))) /HWID

Write-Host 'Step2: Mozila Firefox Arkenfox: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Arkenfox.ps1')

Write-Host 'Step2: Windows Settings: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Settings.ps1')

Write-Host 'Step2: Mozila Firefox Extensions: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Extensions.ps1')

Write-Host 'Step2: Google Chrome Extensions: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Chrome/Extensions.ps1')

Write-Host 'Step2: Software Selection: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software_Selection.ps1')

# I don't think we need it
# Write-Host 'Step2: Windows Resource Protection: Searching for Integrity Violations' -ForegroundColor green -BackgroundColor black
# sfc /scannow

# Write-Host 'Step2: Searching for component store corruption' -ForegroundColor green -BackgroundColor black
# dism /Online /Cleanup-image /Scanhealth

# Write-Host 'Step2: Restoring health' -ForegroundColor green -BackgroundColor black
# dism /Online /Cleanup-image /Restorehealth

# Write-Host 'Step2: Cleaning up' -ForegroundColor green -BackgroundColor black
# dism /online /cleanup-image /startcomponentcleanup
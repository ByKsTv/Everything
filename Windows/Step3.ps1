Write-Host 'Step3: Task Scheduler: Removing current step' -ForegroundColor green -BackgroundColor black
Unregister-ScheduledTask -TaskName Step3 -Confirm:$false

Write-Host 'Step3: Mozila Firefox Extensions: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Extensions.ps1')

Write-Host 'Step3: Google Chrome Extensions: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Chrome/Extensions.ps1')

Write-Host 'Step3: Software Selection: Initiating' -ForegroundColor green -BackgroundColor black
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
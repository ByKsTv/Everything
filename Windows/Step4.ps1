Write-Host 'Task Scheduler: Removing current step' -ForegroundColor green -BackgroundColor black
Unregister-ScheduledTask -TaskName Step4 -Confirm:$false

Write-Host 'Windows Update: Checking for updates' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath "$env:SystemRoot\System32\UsoClient.exe" -ArgumentList StartInteractiveScan

Write-Host 'O&O ShutUp10++: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/OO_ShutUp10/Download.ps1')

Write-Host 'Mozila Firefox Arkenfox: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Arkenfox.ps1')

Write-Host 'Windows Group Policy: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Group_Policy.ps1')

Write-Host 'Windows Settings: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Settings.ps1')

Write-Host 'Windows Network Settings: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Network.ps1')

Write-Host 'Mozila Firefox Extensions: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Extensions.ps1')

Write-Host 'Google Chrome Extensions: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Chrome/Extensions.ps1')

Write-Host 'Software Selection: Initiating' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software_Selection.ps1')
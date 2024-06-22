Write-Host 'Microsoft Store: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://github.com/kkkgo/LTSC-Add-MicrosoftStore/archive/refs/heads/master.zip', "$env:TEMP\LTSC-Add-MicrosoftStore.zip")

Write-Host 'Microsoft Store: Extracting' -ForegroundColor green -BackgroundColor black
Expand-Archive -Path "$env:TEMP\LTSC-Add-MicrosoftStore.zip" -DestinationPath "$env:TEMP\LTSC-Add-MicrosoftStore" -Force

Write-Host 'Microsoft Store: Setting Unattended' -ForegroundColor green -BackgroundColor black
(Get-Content "$env:TEMP\LTSC-Add-MicrosoftStore\LTSC-Add-MicrosoftStore-master\Add-Store.cmd").Replace('pause >nul', '') | Set-Content "$env:TEMP\LTSC-Add-MicrosoftStore\LTSC-Add-MicrosoftStore-master\Add-Store.cmd"

Write-Host 'Microsoft Store: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath "$env:TEMP\LTSC-Add-MicrosoftStore\LTSC-Add-MicrosoftStore-master\Add-Store.cmd"
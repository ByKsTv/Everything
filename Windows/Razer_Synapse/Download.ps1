Write-Host 'Razer Synapse: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://rzr.to/synapse-3-pc-download', "$env:TEMP\Synapse.exe")

Write-Host 'Razer Synapse: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\Synapse.exe
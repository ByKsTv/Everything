Write-Host 'Razer Synapse > Download' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://rzr.to/synapse-3-pc-download', "$env:TEMP\Synapse.exe")
Write-Host 'Razer Synapse > Install' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\Synapse.exe
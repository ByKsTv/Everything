Write-Host 'PuTTY: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile((Invoke-WebRequest -UseBasicParsing -Uri 'https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'putty-64bit') } | Select-Object -First 1 | Select-Object -ExpandProperty href), "$env:TEMP\PuTTY.msi")

Write-Host 'PuTTY: Installing' -ForegroundColor green -BackgroundColor black
Start-Process $env:TEMP\PuTTY.msi -ArgumentList '/quiet' -Wait

Write-Host 'PuTTY > Get latest' -ForegroundColor green -BackgroundColor black
$PuTTY1 = (Invoke-WebRequest -UseBasicParsing -Uri 'https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'putty-64bit') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
Write-Host 'PuTTY > Download' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile("$PuTTY1", "$env:TEMP\PuTTY.msi")
Write-Host 'PuTTY > Install' -ForegroundColor green -BackgroundColor black
Start-Process $env:TEMP\PuTTY.msi -ArgumentList '/quiet' -Wait
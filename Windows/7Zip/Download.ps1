Write-Host '7-Zip: Getting latest release' -ForegroundColor green -BackgroundColor black
$dlurl = 'https://7-zip.org/' + (Invoke-WebRequest -UseBasicParsing -Uri 'https://7-zip.org/' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'Download') -and ($_.href -like 'a/*') -and ($_.href -like '*-x64.exe') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
$installerPath = Join-Path $env:TEMP (Split-Path $dlurl -Leaf)

Write-Host '7-Zip: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile($dlurl, $installerPath)

Write-Host '7-Zip: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $installerPath -ArgumentList '/S' -Wait
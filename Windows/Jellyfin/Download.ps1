Write-Host 'Jellyfin > Get latest' -ForegroundColor green -BackgroundColor black
$JellyfinLatest = (Invoke-WebRequest -UseBasicParsing -Uri 'https://repo.jellyfin.org/?path=/server/windows/latest-stable/amd64' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'x64.exe') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
$JellyfinURL = 'https://repo.jellyfin.org' + $JellyfinLatest
Write-Host 'Jellyfin > Download' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile($JellyfinURL, "$env:TEMP\Jellyfin.exe")
Write-Host 'Jellyfin > Install' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\Jellyfin.exe -Args '/S'
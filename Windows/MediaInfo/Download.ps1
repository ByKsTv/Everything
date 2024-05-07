Write-Host 'Mediainfo > Get latest' -ForegroundColor green -BackgroundColor black
$MediaInfoHREF = (Invoke-WebRequest -UseBasicParsing -Uri 'https://mediaarea.net/en/MediaInfo/Download/Windows' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'GUI') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
$MediaInfoDL = 'https:' + $MediaInfoHREF
Write-Host 'Mediainfo > Download' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile($MediaInfoDL, "$env:TEMP\MediaInfo.exe")
Write-Host 'Mediainfo > Install' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\MediaInfo.exe -Args '/S'
Write-Host 'Mediainfo > Custom Settings' -ForegroundColor green -BackgroundColor black
$MediaInfoSetting='
Output = Tree
Donated = 1
'
if (!(Test-Path -Path $env:APPDATA\MediaInfo)) {
	Write-Host 'APPDATA > Roaming > MediaInfo' -ForegroundColor green -BackgroundColor black
	New-Item -Path $env:APPDATA\MediaInfo -Value MediaInfo -ItemType Directory
}
if (!(Test-Path -Path $env:APPDATA\MediaInfo\Plugin)) {
	Write-Host 'APPDATA > Roaming > MediaInfo > Plugin' -ForegroundColor green -BackgroundColor black
	New-Item -Path $env:APPDATA\MediaInfo\Plugin -Value Plugin -ItemType Directory
}
Set-Content -Path $env:APPDATA\MediaInfo\Plugin\MediaInfo.cfg -Value $MediaInfoSetting -Force
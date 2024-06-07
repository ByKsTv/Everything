Write-Host 'Mediainfo: Get latest release' -ForegroundColor green -BackgroundColor black
$MediaInfoHREF = (Invoke-WebRequest -UseBasicParsing -Uri 'https://mediaarea.net/en/MediaInfo/Download/Windows' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'GUI') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
$MediaInfoDL = 'https:' + $MediaInfoHREF

Write-Host 'Mediainfo: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile($MediaInfoDL, "$env:TEMP\MediaInfo.exe")

Write-Host 'Mediainfo: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\MediaInfo.exe -ArgumentList '/S'

Write-Host 'Mediainfo: Checking folders' -ForegroundColor green -BackgroundColor black
if (!(Test-Path -Path $env:APPDATA\MediaInfo)) {
	New-Item -Path $env:APPDATA\MediaInfo -Value MediaInfo -ItemType Directory
}
if (!(Test-Path -Path $env:APPDATA\MediaInfo\Plugin)) {
	New-Item -Path $env:APPDATA\MediaInfo\Plugin -Value Plugin -ItemType Directory
}

Write-Host 'Mediainfo: Using custom settings' -ForegroundColor green -BackgroundColor black
Set-Content -Path $env:APPDATA\MediaInfo\Plugin\MediaInfo.cfg -Value 'Output = Tree 
Donated = 1 
ShellInfoTip = 1 ' -Force
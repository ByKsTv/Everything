Write-Host 'Adobe Photoshop: Initiating qBittorrent' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1')

Write-Host 'Adobe Photoshop: Getting magnet' -ForegroundColor green -BackgroundColor black
$Photoshop1 = (Invoke-WebRequest -UseBasicParsing -Uri 'https://w14.monkrus.ws/search/label/Photoshop' | Select-Object -ExpandProperty Links | Where-Object { (($_.outerHTML -notmatch 'Elements') -and ($_.outerHTML -notmatch 'Collection') -and ($_.outerHTML -match 'Multilingual')) } | Select-Object -First 1 | Select-Object -ExpandProperty href)
$Photoshop2 = (Invoke-WebRequest -UseBasicParsing -Uri $Photoshop1 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'uniondht.org') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
if ($null -eq $Photoshop2) {
    $Photoshop2 = (Invoke-WebRequest -UseBasicParsing -Uri $Photoshop2 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'pb.wtf') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
}
$Photoshop3 = (Invoke-WebRequest -UseBasicParsing -Uri $Photoshop2 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'magnet') } | Select-Object -First 1 | Select-Object -ExpandProperty href)

Write-Host 'Adobe Photoshop: Deleting qBittorrent log file' -ForegroundColor green -BackgroundColor black
if (Test-Path "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log") {
    Remove-Item "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log" -Force -ErrorAction SilentlyContinue
}

Write-Host 'Adobe Photoshop: Deleting temp folder' -ForegroundColor green -BackgroundColor black
Remove-Item -Path "$env:TEMP\*Photoshop*" -Force -ErrorAction SilentlyContinue

Write-Host 'Adobe Photoshop: Opening magnet' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath "$env:ProgramFiles\qBittorrent\qBittorrent.exe" -ArgumentList "--skip-dialog=true --add-paused=false --save-path=$env:TEMP ""$($Photoshop3)"""

Write-Host 'Adobe Photoshop: Waiting for folder to be created' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-ChildItem -Directory -Path "$env:TEMP" -Filter '*Photoshop*' -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}
$PhotoshopTempDir = Get-ChildItem -Directory -Path "$env:TEMP" -Filter '*Photoshop*' | Select-Object FullName -ExpandProperty 'FullName'

Write-Host 'Adobe Photoshop: Adding Defender Exclusion' -ForegroundColor green -BackgroundColor black
Add-MpPreference -ExclusionPath "$PhotoshopTempDir"

Write-Host 'Adobe Photoshop: Waiting for ISO file to be created' -ForegroundColor green -BackgroundColor black
While ($null -eq (Get-ChildItem -Path "$PhotoshopTempDir" -Filter '*iso*' | Select-Object FullName -ExpandProperty 'FullName' -ErrorAction SilentlyContinue)) {
    Start-Sleep -Milliseconds 1000
}
$PhotoshopTempISO = Get-ChildItem -Path "$PhotoshopTempDir" -Filter '*iso*' | Select-Object FullName -ExpandProperty 'FullName'

Write-Host 'Adobe Photoshop: Waiting download to complete' -ForegroundColor green -BackgroundColor black
$null = Get-Content "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log" -Wait | Where-Object { $_ -match 'Removed torrent. Torrent: .*Photoshop*' } | Select-Object -First 1

Write-Host 'Adobe Photoshop: Initiating 7-Zip' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')

Write-Host 'Adobe Photoshop: Extracting ISO' -ForegroundColor green -BackgroundColor black
& "$env:ProgramFiles\7-Zip\7z.exe" x "$PhotoshopTempISO" -o"$PhotoshopTempDir" -y
    
Write-Host 'Adobe Photoshop: Opening Installer' -ForegroundColor green -BackgroundColor black
$PhotoshopTempInstaller = Get-ChildItem -Path "$PhotoshopTempDir" -Filter '*exe*' | Select-Object FullName -ExpandProperty 'FullName'
Start-Process $PhotoshopTempInstaller
    
Write-Host 'Adobe Photoshop: Waiting for installer to open' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Photoshop * Installer' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}

Write-Host 'Adobe Photoshop: Waiting for installer to close' -ForegroundColor green -BackgroundColor black
while (($true -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Photoshop * Installer' } -ErrorAction SilentlyContinue))) {
    Write-Host 'Adobe Photoshop: Installing' -ForegroundColor green -BackgroundColor black
    $wshell = New-Object -ComObject wscript.shell
    $wshell.SendKeys('{ENTER}')
    Start-Sleep -Milliseconds 1000
}

Write-Host 'Adobe Photoshop: Waiting for installer to open' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Photoshop * Installer' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}

Write-Host 'Adobe Photoshop: Waiting for installer to close' -ForegroundColor green -BackgroundColor black
while (($true -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Photoshop * Installer' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}
    
Write-Host 'Adobe Photoshop: Removing Defender Exclusion' -ForegroundColor green -BackgroundColor black
Remove-MpPreference -ExclusionPath "$PhotoshopTempDir"
Write-Host 'Adobe Acrobat: Initiating qBittorrent' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1')

Write-Host 'Adobe Acrobat: Getting magnet' -ForegroundColor green -BackgroundColor black
$Adrobat1 = (Invoke-WebRequest -UseBasicParsing -Uri 'https://w14.monkrus.ws/search/label/Acrobat' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'x64') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
$Adrobat2 = (Invoke-WebRequest -UseBasicParsing -Uri $Adrobat1 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'uniondht.org') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
if ($null -eq $Adrobat2) {
    $Adrobat2 = (Invoke-WebRequest -UseBasicParsing -Uri $Adrobat1 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'pb.wtf') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
}
$Adrobat3 = (Invoke-WebRequest -UseBasicParsing -Uri $Adrobat2 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'magnet') } | Select-Object -First 1 | Select-Object -ExpandProperty href)

Write-Host 'Adobe Photoshop: Deleting qBittorrent log file' -ForegroundColor green -BackgroundColor black
if (Test-Path "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log") {
    Remove-Item "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log" -Force -ErrorAction SilentlyContinue
}

Write-Host 'Adobe Photoshop: Deleting temp folder' -ForegroundColor green -BackgroundColor black
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host 'Adobe Acrobat: Opening magnet' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath "$env:ProgramFiles\qBittorrent\qBittorrent.exe" -ArgumentList "--skip-dialog=true --add-paused=false --save-path=$env:TEMP ""$($Adrobat3)"""

Write-Host 'Adobe Acrobat: Waiting for folder to be created' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-ChildItem -Directory -Path "$env:TEMP" -Filter '*Acrobat*' -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}
$AcrobatTempDir = Get-ChildItem -Directory -Path "$env:TEMP" -Filter '*Acrobat*' | Select-Object FullName -ExpandProperty 'FullName'

Write-Host 'Adobe Acrobat: Adding Defender Exclusion' -ForegroundColor green -BackgroundColor black
Add-MpPreference -ExclusionPath "$AcrobatTempDir"

Write-Host 'Adobe Acrobat: Waiting for ISO file to be created' -ForegroundColor green -BackgroundColor black
While ($null -eq (Get-ChildItem -Path "$AcrobatTempDir" -Filter '*iso*' | Select-Object FullName -ExpandProperty 'FullName' -ErrorAction SilentlyContinue)) {
    Start-Sleep -Milliseconds 1000
}
$AcrobatTempISO = Get-ChildItem -Path "$AcrobatTempDir" -Filter '*iso*' | Select-Object FullName -ExpandProperty 'FullName'

Write-Host 'Adobe Acrobat: Waiting download to complete' -ForegroundColor green -BackgroundColor black
$null = Get-Content "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log" -Wait | Where-Object { $_ -match 'Removed torrent. Torrent: .*Acrobat*' } | Select-Object -First 1

Write-Host 'Adobe Acrobat: Initiating 7-Zip' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')

Write-Host 'Adobe Acrobat: Extracting ISO' -ForegroundColor green -BackgroundColor black
& "$env:ProgramFiles\7-Zip\7z.exe" x "$AcrobatTempISO" -o"$AcrobatTempDir" -y
    
Write-Host 'Adobe Acrobat: Opening Installer' -ForegroundColor green -BackgroundColor black
$AcrobatTEMPinstaller = Get-ChildItem -Path "$AcrobatTempDir" -Filter '*exe*' | Select-Object FullName -ExpandProperty 'FullName'
Start-Process $AcrobatTEMPinstaller
    
Write-Host 'Adobe Acrobat: Waiting for installer to open' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Acrobat * Installer' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}

Write-Host 'Adobe Acrobat: Waiting for installer to close' -ForegroundColor green -BackgroundColor black
while (($true -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Acrobat * Installer' } -ErrorAction SilentlyContinue))) {
    Write-Host 'Adobe Acrobat: Installing' -ForegroundColor green -BackgroundColor black
    $wshell = New-Object -ComObject wscript.shell
    $wshell.SendKeys('{ENTER}')
    Start-Sleep -Milliseconds 1000
}
    
Write-Host 'Adobe Acrobat: Waiting for process to open' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-Process | Where-Object { $_.Name -like 'crack' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}

Write-Host 'Adobe Acrobat: Waiting for process to close' -ForegroundColor green -BackgroundColor black
while (($true -eq (Get-Process | Where-Object { $_.Name -like 'crack' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}
    
Write-Host 'Adobe Acrobat: Removing Defender Exclusion' -ForegroundColor green -BackgroundColor black
Remove-MpPreference -ExclusionPath "$AcrobatTempDir"
Write-Host 'Adobe Lightroom Classic: Initiating qBittorrent' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1')

Write-Host 'Adobe Lightroom Classic: Getting magnet' -ForegroundColor green -BackgroundColor black
$Lightroom_Classic1 = (Invoke-WebRequest -UseBasicParsing -Uri 'https://w14.monkrus.ws/search/label/Lightroom' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'Classic') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
$Lightroom_Classic2 = (Invoke-WebRequest -UseBasicParsing -Uri $Lightroom_Classic1 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'uniondht.org') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
if ($null -eq $Lightroom_Classic2) {
    $Lightroom_Classic2 = (Invoke-WebRequest -UseBasicParsing -Uri $Lightroom_Classic2 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'pb.wtf') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
}
$Lightroom_Classic3 = (Invoke-WebRequest -UseBasicParsing -Uri $Lightroom_Classic2 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'magnet') } | Select-Object -First 1 | Select-Object -ExpandProperty href)

Write-Host 'Adobe Lightroom Classic: Deleting qBittorrent log file' -ForegroundColor green -BackgroundColor black
if (Test-Path "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log") {
    Remove-Item "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log" -Force -ErrorAction SilentlyContinue
}

Write-Host 'Adobe Lightroom Classic: Deleting temp folder' -ForegroundColor green -BackgroundColor black
Remove-Item -Path "$env:TEMP\*Classic*" -Force -ErrorAction SilentlyContinue

Write-Host 'Adobe Lightroom Classic: Opening magnet' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath "$env:ProgramFiles\qBittorrent\qBittorrent.exe" -ArgumentList "--skip-dialog=true --add-paused=false --save-path=$env:TEMP ""$($Lightroom_Classic3)"""

Write-Host 'Adobe Lightroom Classic: Waiting for folder to be created' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-ChildItem -Directory -Path "$env:TEMP" -Filter '*Classic*' -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}
$Lightroom_ClassicTempDir = Get-ChildItem -Directory -Path "$env:TEMP" -Filter '*Classic*' | Select-Object FullName -ExpandProperty 'FullName'

Write-Host 'Adobe Lightroom Classic: Adding Defender Exclusion' -ForegroundColor green -BackgroundColor black
Add-MpPreference -ExclusionPath "$Lightroom_ClassicTempDir"

Write-Host 'Adobe Lightroom Classic: Waiting for ISO file to be created' -ForegroundColor green -BackgroundColor black
While ($null -eq (Get-ChildItem -Path "$Lightroom_ClassicTempDir" -Filter '*iso*' | Select-Object FullName -ExpandProperty 'FullName' -ErrorAction SilentlyContinue)) {
    Start-Sleep -Milliseconds 1000
}
$Lightroom_ClassicTempISO = Get-ChildItem -Path "$Lightroom_ClassicTempDir" -Filter '*iso*' | Select-Object FullName -ExpandProperty 'FullName'

Write-Host 'Adobe Lightroom Classic: Waiting download to complete' -ForegroundColor green -BackgroundColor black
$null = Get-Content "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log" -Wait | Where-Object { $_ -match 'Removed torrent. Torrent: .*Classic*' } | Select-Object -First 1

Write-Host 'Adobe Lightroom Classic: Initiating 7-Zip' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')

Write-Host 'Adobe Lightroom Classic: Extracting ISO' -ForegroundColor green -BackgroundColor black
& "$env:ProgramFiles\7-Zip\7z.exe" x "$Lightroom_ClassicTempISO" -o"$Lightroom_ClassicTempDir" -y
    
Write-Host 'Adobe Lightroom Classic: Opening Installer' -ForegroundColor green -BackgroundColor black
$Lightroom_ClassicTempInstaller = Get-ChildItem -Path "$Lightroom_ClassicTempDir" -Filter '*exe*' | Select-Object FullName -ExpandProperty 'FullName'
Start-Process $Lightroom_ClassicTempInstaller
    
Write-Host 'Adobe Lightroom Classic: Waiting for installer to open' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Lightroom * Installer' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}

Write-Host 'Adobe Lightroom Classic: Waiting for installer to close' -ForegroundColor green -BackgroundColor black
while (($true -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Lightroom * Installer' } -ErrorAction SilentlyContinue))) {
    Write-Host 'Adobe Lightroom Classic: Installing' -ForegroundColor green -BackgroundColor black
    $wshell = New-Object -ComObject wscript.shell
    $wshell.SendKeys('{ENTER}')
    Start-Sleep -Milliseconds 1000
}

Write-Host 'Adobe Lightroom Classic: Waiting for installer to open' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Lightroom * Installer' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}

Write-Host 'Adobe Lightroom Classic: Waiting for installer to close' -ForegroundColor green -BackgroundColor black
while (($true -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Lightroom * Installer' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}
    
Write-Host 'Adobe Lightroom Classic: Removing Defender Exclusion' -ForegroundColor green -BackgroundColor black
Remove-MpPreference -ExclusionPath "$Lightroom_ClassicTempDir"
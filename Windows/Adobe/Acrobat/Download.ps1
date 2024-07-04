Write-Host 'Adobe Acrbat Pro: Initiating qBittorrent' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1')

Write-Host 'Adobe Acrbat Pro: Getting magnet' -ForegroundColor green -BackgroundColor black
$Adrobat1 = (Invoke-WebRequest -UseBasicParsing -Uri 'https://w14.monkrus.ws/search/label/Acrobat' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'x64') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
$Adrobat2 = (Invoke-WebRequest -UseBasicParsing -Uri $Adrobat1 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'uniondht.org') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
$Adrobat3 = (Invoke-WebRequest -UseBasicParsing -Uri $Adrobat2 | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'magnet') } | Select-Object -First 1 | Select-Object -ExpandProperty href)

Write-Host 'Adobe Acrbat Pro: Cleaning log file' -ForegroundColor green -BackgroundColor black
if (Test-Path "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log") {
    Remove-Item "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log"
}

Write-Host 'Adobe Acrbat Pro: Opening magnet' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath "$env:ProgramFiles\qBittorrent\qBittorrent.exe" -ArgumentList "--skip-dialog=true --add-paused=false --save-path=$env:TEMP $Adrobat3"

Write-Host 'Adobe Acrbat Pro: Waiting for folder to be created' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-ChildItem -Directory -Path "$env:TEMP" -Filter '*Acrobat.*' -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}
$AdobeTempDir = Get-ChildItem -Directory -Path "$env:TEMP" -Filter '*Acrobat.*' | Select-Object FullName -ExpandProperty 'FullName'

Write-Host 'Adobe Acrbat Pro: Adding Defender Exclusion' -ForegroundColor green -BackgroundColor black
Add-MpPreference -ExclusionPath "$AdobeTempDir"

Write-Host 'Adobe Acrbat Pro: Waiting for ISO file to be created' -ForegroundColor green -BackgroundColor black
While ($null -eq (Get-ChildItem -Path "$AdobeTempDir" -Filter '*iso*' | Select-Object FullName -ExpandProperty 'FullName' -ErrorAction SilentlyContinue)) {
    Start-Sleep -Milliseconds 1000
}
$AdobeTempIso = Get-ChildItem -Path "$AdobeTempDir" -Filter '*iso*' | Select-Object FullName -ExpandProperty 'FullName'

Write-Host 'Adobe Acrbat Pro: Waiting download to complete' -ForegroundColor green -BackgroundColor black
$null = Get-Content "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log" -Wait | Where-Object { $_ -match 'Removed torrent.' } | Select-Object -First 1

Write-Host 'Adobe Acrbat Pro: Initiating 7-Zip' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')

Write-Host 'Adobe Acrbat Pro: Extracting ISO' -ForegroundColor green -BackgroundColor black
& "$env:ProgramFiles\7-Zip\7z.exe" x "$AdobeTempIso" -o"$AdobeTempDir" -y
    
Write-Host 'Adobe Acrbat Pro: Opening Installer' -ForegroundColor green -BackgroundColor black
$AdobeTempInstaller = Get-ChildItem -Path "$AdobeTempDir" -Filter '*exe*' | Select-Object FullName -ExpandProperty 'FullName'
Start-Process $AdobeTempInstaller
    
Write-Host 'Adobe Acrbat Pro: Waiting for installer' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-Process | Where-Object { $_.MainWindowTitle -like 'Adobe Acrobat Pro * x64 Installer' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}
    
Write-Host 'Adobe Acrbat Pro: Installing' -ForegroundColor green -BackgroundColor black
$wshell = New-Object -ComObject wscript.shell
$wshell.SendKeys('{ENTER}')
    
Write-Host 'Adobe Acrbat Pro: Waiting for process to open' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-Process | Where-Object { $_.Name -like 'crack' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}

Write-Host 'Adobe Acrbat Pro: Waiting for process to close' -ForegroundColor green -BackgroundColor black
while (($true -eq (Get-Process | Where-Object { $_.Name -like 'crack' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}
    
Write-Host 'Adobe Acrbat Pro: Removing Defender Exclusion' -ForegroundColor green -BackgroundColor black
Remove-MpPreference -ExclusionPath "$AdobeTempDir"
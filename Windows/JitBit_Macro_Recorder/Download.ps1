Write-Host 'JitBit Macro Recorder: Initiating qBittorrent' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1')

Write-Host 'JitBit Macro Recorder: Getting magnet' -ForegroundColor green -BackgroundColor black
$JitBit1 = (Invoke-WebRequest -UseBasicParsing -Uri 'https://rutracker.org/forum/viewtopic.php?t=6357418' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'magnet') } | Select-Object -First 1 | Select-Object -ExpandProperty href)

Write-Host 'JitBit Macro Recorder: Deleting qBittorrent log file' -ForegroundColor green -BackgroundColor black
if (Test-Path "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log") {
    Remove-Item "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log" -Force -ErrorAction SilentlyContinue
}

Write-Host 'JitBit Macro Recorder: Deleting temp folder' -ForegroundColor green -BackgroundColor black
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host 'JitBit Macro Recorder: Opening magnet' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath "$env:ProgramFiles\qBittorrent\qBittorrent.exe" -ArgumentList "--skip-dialog=true --add-paused=false --save-path=$env:TEMP ""$($JitBit1)"""

Write-Host 'JitBit Macro Recorder: Waiting for folder to be created' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-ChildItem -Directory -Path "$env:TEMP" -Filter '*JitBit*' -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}
$JitBitTempDir = Get-ChildItem -Directory -Path "$env:TEMP" -Filter '*JitBit*' | Select-Object FullName -ExpandProperty 'FullName'

Write-Host 'JitBit Macro Recorder: Adding Defender Exclusion' -ForegroundColor green -BackgroundColor black
Add-MpPreference -ExclusionPath "$JitBitTempDir"

Write-Host 'JitBit Macro Recorder: Waiting for installer file to be created' -ForegroundColor green -BackgroundColor black
While ($null -eq (Get-ChildItem -Path "$JitBitTempDir" -Filter '*exe*' | Select-Object FullName -ExpandProperty 'FullName' -ErrorAction SilentlyContinue)) {
    Start-Sleep -Milliseconds 1000
}
$JitBitTempInstaller = Get-ChildItem -Path "$JitBitTempDir" -Filter '*exe*' | Select-Object FullName -ExpandProperty 'FullName'

Write-Host 'JitBit Macro Recorder: Waiting download to complete' -ForegroundColor green -BackgroundColor black
$null = Get-Content "$env:LOCALAPPDATA\qBittorrent\logs\qbittorrent.log" -Wait | Where-Object { $_ -match 'Removed torrent. Torrent: .*JitBit*' } | Select-Object -First 1

Write-Host 'JitBit Macro Recorder: Installing' -ForegroundColor green -BackgroundColor black
Start-Process $JitBitTempInstaller -ArgumentList '/verysilent /Tasks=create_start_menu_entry' -Wait

Write-Host 'JitBit Macro Recorder: Removing Defender Exclusion' -ForegroundColor green -BackgroundColor black
Remove-MpPreference -ExclusionPath "$JitBitTempDir"

Write-Host 'Jitbit Macro Recorder: Settings: General: Disable the welcome screen: On' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Force 
}

Write-Host 'Jitbit Macro Recorder: Disabling Startup Screen' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'DisableStartupScreen' -Value 'True' -PropertyType String -Force

Write-Host 'Jitbit Macro Recorder: Settings: Playback settings: Continuous reply: Infinite playback' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'NumberOfPlaybacks' -Value 0 -PropertyType DWord -Force

Write-Host 'Jitbit Macro Recorder: Settings: Playback settings: Hide the topmost playing... bar: Off' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'HidePlayWnd' -Value 'False' -PropertyType String -Force

Write-Host 'Jitbit Macro Recorder: Settings: General: Move the playback toolbar to the right: On' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'PlayRecFormsOnTheRight' -Value 'True' -PropertyType String -Force

Write-Host 'Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Play / Pause / Resume playback: F8' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'PausePlayKey' -Value 119 -PropertyType DWord -Force

Write-Host 'Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Abort playback: F9' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'AbortPlayKey' -Value 120 -PropertyType DWord -Force

Write-Host 'Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Step-by-step playback: F10' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'StepByStepPlayKey' -Value 121 -PropertyType DWord -Force

Write-Host 'Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Start / Pause / Resume recording: F11' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'RecordKey' -Value 122 -PropertyType DWord -Force

Write-Host 'Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Abort recording: F12' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'AbortRecKey' -Value 123 -PropertyType DWord -Force
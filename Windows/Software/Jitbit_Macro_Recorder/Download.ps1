[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Jitbit Macro Recorder: Settings: General: Disable the welcome screen: On'); [Console]::ResetColor(); [Console]::WriteLine()
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder')) {
    New-Item 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Force
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Jitbit Macro Recorder: Disabling Startup Screen'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'DisableStartupScreen' -Value 'True' -PropertyType String -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Jitbit Macro Recorder: Settings: Playback settings: Continuous reply: Infinite playback'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'NumberOfPlaybacks' -Value 0 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Jitbit Macro Recorder: Settings: Playback settings: Hide the topmost playing... bar: Off'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'HidePlayWnd' -Value 'False' -PropertyType String -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Jitbit Macro Recorder: Settings: General: Move the playback toolbar to the right: On'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'PlayRecFormsOnTheRight' -Value 'True' -PropertyType String -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Play / Pause / Resume playback: F8'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'PausePlayKey' -Value 119 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Abort playback: F9'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'AbortPlayKey' -Value 120 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Step-by-step playback: F10'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'StepByStepPlayKey' -Value 121 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Start / Pause / Resume recording: F11'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'RecordKey' -Value 122 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Jitbit Macro Recorder: Settings: Keyboard shortcuts (hotkeys): Abort recording: F12'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -Path 'HKCU:\SOFTWARE\Jitbit\Macro Recorder' -Name 'AbortRecKey' -Value 123 -PropertyType DWord -Force

$Label = 'https://rutracker.org/forum/viewtopic.php?t=6357418'
$Title = ((Invoke-WebRequest -UseBasicParsing -Uri $Label).Links | Where-Object { $_.outerHTML -match 'Jitbit' } | Select-Object -First 1).outerHTML -replace '.*?>(.*?)</a>', '$1'
$Magnet = ((Invoke-WebRequest -UseBasicParsing -Uri $Label).Links | Where-Object { $_.outerHTML -match 'magnet' } | Select-Object -First 1).href
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/qBittorrent/Download.ps1')
$Log = [IO.Path]::Combine($env:LOCALAPPDATA, 'qBittorrent', 'logs', 'qbittorrent.log')
if (Test-Path $Log) {
    Remove-Item $Log -Force -ErrorAction SilentlyContinue
}
Remove-Item -Path "$env:TEMP\*Jitbit*" -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
$Argument = "--skip-dialog=true --add-stopped=false --save-path=$env:TEMP ""$($Magnet)"""
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Title'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process qBittorrent.exe -ArgumentList $Argument
while (-not ($TempDir = (Get-ChildItem $env:TEMP -Directory -Filter '*Jitbit*' | Select-Object -First 1).FullName)) {
    Start-Sleep -Milliseconds 1000
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TempDir'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
Add-MpPreference -ExclusionPath $TempDir

while (-not ($TempEXE = (Get-ChildItem $TempDir -Filter '*.exe' | Select-Object -First 1).FullName)) {
    Start-Sleep -Milliseconds 1000
}
do {
    Start-Sleep -Milliseconds 1000
} until ((Get-Content $Log -ErrorAction SilentlyContinue) -match 'Torrent download finished. Torrent: .*Jitbit*')

$Argument = '/verysilent /Tasks=create_start_menu_entry'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Title'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TempEXE'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $TempEXE -ArgumentList $Argument -Wait

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Removing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TempDir'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Defender Exclusions'"); [Console]::ResetColor(); [Console]::WriteLine()
Remove-MpPreference -ExclusionPath $TempDir

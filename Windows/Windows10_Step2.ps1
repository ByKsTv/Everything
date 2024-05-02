Unregister-ScheduledTask -TaskName Windows10_Step2 -Confirm:$false
Write-Host 'Settings > Update & Security > Check for updates' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath "$env:SystemRoot\System32\UsoClient.exe" -ArgumentList StartInteractiveScan
Write-Host 'NuGet > Uninstall' -ForegroundColor green -BackgroundColor black
takeown /R /F 'C:\Program Files\PackageManagement'
icacls 'C:\Program Files\PackageManagement' /grant Everyone:F /T
if ((Test-Path -LiteralPath 'C:\Program Files\PackageManagement') -eq $true) {
    Remove-Item -Path ('C:\Program Files\PackageManagement') -Force -Recurse
}
if ((Test-Path -LiteralPath "$env:LOCALAPPDATA\PackageManagement") -eq $true) {
    Remove-Item -Path ("$env:LOCALAPPDATA\PackageManagement") -Force -Recurse
}
if ((Test-Path -LiteralPath "$env:APPDATA\NuGet") -eq $true) {
    Remove-Item -Path ("$env:APPDATA\NuGet") -Force -Recurse
}
Write-Host 'PSWindowsUpdate > Uninstall' -ForegroundColor green -BackgroundColor black
Uninstall-Module PSWindowsUpdate -Force
Write-Host 'Settings > Update & Security > Activation' -ForegroundColor green -BackgroundColor black
& ([ScriptBlock]::Create((Invoke-RestMethod https://massgrave.dev/get))) /HWID
Write-Host 'Optional features > Disable' -ForegroundColor green -BackgroundColor black
Remove-WindowsCapability -Name 'App.StepsRecorder~~~~0.0.1.0' -Online
Remove-WindowsCapability -Name 'App.Support.QuickAssist~~~~0.0.1.0' -Online
Remove-WindowsCapability -Name 'Browser.InternetExplorer~~~~0.0.11.0' -Online
Remove-WindowsCapability -Name 'Media.WindowsMediaPlayer~~~~0.0.12.0' -Online
Remove-WindowsCapability -Name 'Microsoft.Windows.MSPaint~~~~0.0.1.0' -Online
Remove-WindowsCapability -Name 'Microsoft.Windows.WordPad~~~~0.0.1.0' -Online
Remove-WindowsCapability -Name 'Hello.Face.18967~~~~0.0.1.0' -Online
Remove-WindowsCapability -Name 'OneCoreUAP.OneSync~~~~0.0.1.0' -Online
Remove-WindowsCapability -Name 'MathRecognizer~~~~0.0.1.0' -Online
Remove-WindowsCapability -Name 'OpenSSH.Client~~~~0.0.1.0' -Online
Write-Host 'Windows features > Disable' -ForegroundColor green -BackgroundColor black
Disable-WindowsOptionalFeature -FeatureName 'LegacyComponents' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'MicrosoftWindowsPowerShellV2' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'MicrosoftWindowsPowershellV2Root' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'Printing-XPSServices-Features' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'WorkFolders-Client' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'MediaPlayback' -Online -NoRestart
Write-Host 'Sophia Script > Download' -ForegroundColor green -BackgroundColor black
Invoke-RestMethod https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/Download_Sophia.ps1 | Invoke-Expression
$CurrentSophiaScriptPath = Get-Location
Write-Host 'Latest Sophia Script > Download' -ForegroundColor green -BackgroundColor black
Invoke-WebRequest -Uri https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/src/Sophia_Script_for_Windows_10_LTSC_2021/Sophia.ps1 -OutFile $CurrentSophiaScriptPath\Sophia.ps1
Invoke-WebRequest -Uri https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/src/Sophia_Script_for_Windows_10_LTSC_2021/Functions.ps1 -OutFile $CurrentSophiaScriptPath\Functions.ps1
Invoke-WebRequest -Uri https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/src/Sophia_Script_for_Windows_10_LTSC_2021/Module/Sophia.psm1 -OutFile $CurrentSophiaScriptPath\Module\Sophia.psm1
Write-Host 'Scheduled tasks > Disable' -ForegroundColor green -BackgroundColor black
Disable-ScheduledTask -TaskName 'Consolidator' -TaskPath '\Microsoft\Windows\Customer Experience Improvement Program\'
Disable-ScheduledTask -TaskName 'DmClient' -TaskPath '\Microsoft\Windows\Feedback\Siuf\'
Disable-ScheduledTask -TaskName 'DmClientOnScenarioDownload' -TaskPath '\Microsoft\Windows\Feedback\Siuf\'
Disable-ScheduledTask -TaskName 'FamilySafetyMonitor' -TaskPath '\Microsoft\Windows\Shell\'
Disable-ScheduledTask -TaskName 'FamilySafetyRefreshTask' -TaskPath '\Microsoft\Windows\Shell\'
Disable-ScheduledTask -TaskName 'MapsToastTask' -TaskPath '\Microsoft\Windows\Maps\'
Disable-ScheduledTask -TaskName 'MapsUpdateTask' -TaskPath '\Microsoft\Windows\Maps\'
Disable-ScheduledTask -TaskName 'Microsoft Compatibility Appraiser' -TaskPath '\Microsoft\Windows\Application Experience\'
Disable-ScheduledTask -TaskName 'Microsoft-Windows-DiskDiagnosticDataCollector' -TaskPath '\Microsoft\Windows\DiskDiagnostic\'
Disable-ScheduledTask -TaskName 'PcaPatchDbTask' -TaskPath '\Microsoft\Windows\Application Experience\'
Disable-ScheduledTask -TaskName 'ProgramDataUpdater' -TaskPath '\Microsoft\Windows\Application Experience\'
Disable-ScheduledTask -TaskName 'Proxy' -TaskPath '\Microsoft\Windows\Autochk\'
Disable-ScheduledTask -TaskName 'QueueReporting' -TaskPath '\Microsoft\Windows\Windows Error Reporting\'
Disable-ScheduledTask -TaskName 'StartupAppTask' -TaskPath '\Microsoft\Windows\Application Experience\'
Disable-ScheduledTask -TaskName 'UsbCeip' -TaskPath '\Microsoft\Windows\Customer Experience Improvement Program\'
Disable-ScheduledTask -TaskName 'XblGameSaveTask' -TaskPath '\Microsoft\XblGameSave\'
Disable-ScheduledTask -TaskName 'PcaPatchDbTask' -TaskPath '\Microsoft\Windows\Application Experience'
Disable-ScheduledTask -TaskName 'WinSAT' -TaskPath '\Microsoft\Windows\Maintenance'
Write-Host 'Sophia Script > Custom Settings > Apply' -ForegroundColor green -BackgroundColor black
(Get-Content -Raw Sophia.ps1) -replace 'Clear-Host', '' -replace 'InitialActions -Warning', 'InitialActions' -replace 'ThisPC -Show', '' -replace '# UserFolders -ThreeDObjects Hide -Desktop Hide -Documents Hide -Downloads Hide -Music Hide -Pictures Hide -Videos Hide', 'UserFolders -ThreeDObjects Hide -Desktop Hide -Documents Hide -Downloads Hide -Music Hide -Pictures Hide -Videos Hide' -replace 'SecondsInSystemClock -Show', '' -replace 'AeroShaking -Enable', '' -replace '# AeroShaking -Disable', 'AeroShaking -Disable' -replace 'Cursors -Dark', '' -replace 'StorageSense -Enable', '' -replace 'PowerPlan -High', '' -replace 'IPv6Component -Disable', '' -replace 'Set-UserShellFolderLocation -Root', '' -replace 'RecommendedTroubleshooting -Automatically', '' -replace 'ThumbnailCacheRemoval -Disable', '' -replace 'SaveRestartableApps -Enable', '' -replace 'RKNBypass -Enable', '' -replace 'PinToStart -Tiles ControlPanel, DevicesPrinters', '' -replace '# PinToStart -UnpinAll -Tiles ControlPanel, DevicesPrinters', '' -replace '# PinToStart -UnpinAll', 'PinToStart -UnpinAll' -replace 'Set-AppGraphicsPerformance', '' | Set-Content Sophia.ps1
Write-Host 'Toast Notifications > Disable' -ForegroundColor green -BackgroundColor black
$SophiaScriptToastRegex = '(?ms)(?<=^\s*#region Toast notifications\s*).*?(?=\s*#endregion Toast notifications)'
(Get-Content -Raw Module/Sophia.psm1) -replace $SophiaScriptToastRegex, '' -replace 'PendingActions', '' | Set-Content Module/Sophia.psm1
Write-Host 'Sophia Script > Run' -ForegroundColor green -BackgroundColor black
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
.\Sophia.ps1
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Arkenfox.ps1 | Invoke-Expression
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Windows10_Step2_Settings.ps1 | Invoke-Expression
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Windows10_Step2_Network.ps1 | Invoke-Expression
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Extensions.ps1 | Invoke-Expression
Add-Type -AssemblyName System.Windows.Forms
$MPVAnswer = [System.Windows.Forms.MessageBox]::Show('Install mpv?' , 'mpv' , 4, 32)
if ($MPVAnswer -eq 'Yes') {
    Write-Host 'mpv > Install' -ForegroundColor green -BackgroundColor black
    Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/Download_Install_AutoUpdate.ps1 | Invoke-Expression
}
Write-Host 'Microsoft Paint Setup' -ForegroundColor green -BackgroundColor black
Add-WindowsCapability -Online -Name 'Microsoft.Windows.MSPaint~~~~0.0.1.0'
Start-Sleep 20
$EdgeUninstallAnswer = [System.Windows.Forms.MessageBox]::Show('Uninstall Edge?' , 'Edge' , 4, 32)
if ($EdgeUninstallAnswer -eq 'Yes') {
    Write-Host 'Microsoft Edge > Uninstall' -ForegroundColor green -BackgroundColor black
    #Invoke-RestMethod https://raw.githubusercontent.com/ChrisTitusTech/winutil/main/edgeremoval.ps1 | Invoke-Expression
    Invoke-RestMethod https://raw.githubusercontent.com/ChrisTitusTech/winutil/d0bde83333730a4536497451af747daba11e5039/edgeremoval.ps1 | Invoke-Expression
}
Write-Host 'Restart' -ForegroundColor cyan -BackgroundColor black
shutdown /r /t 00
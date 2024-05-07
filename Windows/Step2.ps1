Unregister-ScheduledTask -TaskName Step2 -Confirm:$false
$NextStep = 'Step3'
(New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/$NextStep.ps1", "$env:TEMP\$NextStep.ps1")
Write-Host "Task Scheduler > $NextStep" -ForegroundColor green -BackgroundColor black
$NextStep_Principal = New-ScheduledTaskPrincipal -UserId $env:computername\$env:USERNAME -RunLevel Highest
$NextStep_Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Maximized -ExecutionPolicy Bypass -File $env:TEMP\$NextStep.ps1"
$NextStep_Trigger = New-ScheduledTaskTrigger -AtLogOn
$NextStep_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
$NextStep_Parameters = @{
    TaskName  = $NextStep
    Principal = $NextStep_Principal
    Action    = $NextStep_Action
    Trigger   = $NextStep_Trigger
    Settings  = $NextStep_Settings
}
Register-ScheduledTask @NextStep_Parameters -Force
Write-Host 'NuGet > Uninstall' -ForegroundColor green -BackgroundColor black
icacls 'C:\Program Files\PackageManagement' /grant Users:F
Remove-Item -Path ('C:\Program Files\PackageManagement') -Force -Recurse
Remove-Item -Path ("$env:LOCALAPPDATA\PackageManagement") -Force -Recurse
Remove-Item -Path ("$env:APPDATA\NuGet") -Force -Recurse
Write-Host 'PSWindowsUpdate > Uninstall' -ForegroundColor green -BackgroundColor black
Uninstall-Module PSWindowsUpdate -Force
Write-Host 'Settings > Update & Security > Activation' -ForegroundColor green -BackgroundColor black
& ([ScriptBlock]::Create(((New-Object System.Net.WebClient).DownloadString('https://massgrave.dev/get')))) /HWID
Write-Host 'Scheduled tasks > Disable' -ForegroundColor green -BackgroundColor black
Disable-ScheduledTask -TaskName 'Consolidator' -TaskPath '\Microsoft\Windows\Customer Experience Improvement Program\'
Disable-ScheduledTask -TaskName 'DmClient' -TaskPath '\Microsoft\Windows\Feedback\Siuf\'
Disable-ScheduledTask -TaskName 'DmClientOnScenarioDownload' -TaskPath '\Microsoft\Windows\Feedback\Siuf\'
Disable-ScheduledTask -TaskName 'FamilySafetyMonitor' -TaskPath '\Microsoft\Windows\Shell\'
Disable-ScheduledTask -TaskName 'FamilySafetyRefreshTask' -TaskPath '\Microsoft\Windows\Shell\'
Disable-ScheduledTask -TaskName 'MapsToastTask' -TaskPath '\Microsoft\Windows\Maps\'
Disable-ScheduledTask -TaskName 'MapsUpdateTask' -TaskPath '\Microsoft\Windows\Maps\'
Disable-ScheduledTask -TaskName 'MareBackup' -TaskPath '\Microsoft\Windows\Application Experience\'
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
Write-Host 'Restart' -ForegroundColor cyan -BackgroundColor black
shutdown /r /t 00
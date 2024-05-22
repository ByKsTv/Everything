Write-Host 'Step2: Setting UI: Setting Title' -ForegroundColor green -BackgroundColor black
$host.UI.RawUI.WindowTitle = 'Step2'

Write-Host 'Step2: Task Scheduler: Removing current step' -ForegroundColor green -BackgroundColor black
Unregister-ScheduledTask -TaskName Step2 -Confirm:$false

Write-Host 'Step2: Initiating next step' -ForegroundColor green -BackgroundColor black
$NextStep = 'Step3'
(New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/$NextStep.ps1", "$env:TEMP\$NextStep.ps1")

Write-Host "Step2: Task Scheduler: Adding $NextStep" -ForegroundColor green -BackgroundColor black
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

Write-Host 'Step2: NuGet: Uninstalling' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path "$env:ProgramFiles\PackageManagement")) {
    Write-Host "Step2: NuGet: Deleting $env:ProgramFiles\PackageManagement" -ForegroundColor green -BackgroundColor black
    icacls "$env:ProgramFiles\PackageManagement" /grant Users:F
    Remove-Item -Path ("$env:ProgramFiles\PackageManagement") -Force -Recurse
}
if ((Test-Path -Path "$env:LOCALAPPDATA\PackageManagement")) {
    Write-Host "Step2: NuGet: Deleting $env:LOCALAPPDATA\PackageManagement" -ForegroundColor green -BackgroundColor black
    Remove-Item -Path ("$env:LOCALAPPDATA\PackageManagement") -Force -Recurse
}
if ((Test-Path -Path "$env:APPDATA\PackageManagement")) {
    Write-Host "Step2: NuGet: Deleting $env:APPDATA\PackageManagement" -ForegroundColor green -BackgroundColor black
    Remove-Item -Path ("$env:APPDATA\PackageManagement") -Force -Recurse
}

Write-Host 'Step2: PSWindowsUpdate: Uninstalling' -ForegroundColor green -BackgroundColor black
Uninstall-Module PSWindowsUpdate -Force
if ((Test-Path -Path "$env:ProgramFiles\PackageManagement")) {
    Write-Host "Step2: NuGet: Deleting $env:ProgramFiles\PackageManagement" -ForegroundColor green -BackgroundColor black
    icacls "$env:ProgramFiles\PackageManagement" /grant Users:F
    Remove-Item -Path ("$env:ProgramFiles\PackageManagement") -Force -Recurse
}
if ((Test-Path -Path "$env:LOCALAPPDATA\PackageManagement")) {
    Write-Host "Step2: NuGet: Deleting $env:LOCALAPPDATA\PackageManagement" -ForegroundColor green -BackgroundColor black
    Remove-Item -Path ("$env:LOCALAPPDATA\PackageManagement") -Force -Recurse
}
if ((Test-Path -Path "$env:APPDATA\PackageManagement")) {
    Write-Host "Step2: NuGet: Deleting $env:APPDATA\PackageManagement" -ForegroundColor green -BackgroundColor black
    Remove-Item -Path ("$env:APPDATA\PackageManagement") -Force -Recurse
}

Write-Host 'Step2: Windows Key: Activating' -ForegroundColor green -BackgroundColor black
& ([ScriptBlock]::Create(((New-Object System.Net.WebClient).DownloadString('https://massgrave.dev/get')))) /HWID

Write-Host 'Step2: Scheduled tasks: Disabling telemetry' -ForegroundColor green -BackgroundColor black
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

Write-Host 'Step2: Windows Capabilities: Disabling' -ForegroundColor green -BackgroundColor black
# Get-WindowsCapability -Online | Where-Object { $_.State -ne 'NotPresent' }
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
Remove-WindowsCapability -Name 'DirectX.Configuration.Database~~~~0.0.1.0' -Online
# Notepad
Add-WindowsCapability -Name 'Microsoft.Windows.Notepad~~~~0.0.1.0' -Online
# PowerShell ISE
Add-WindowsCapability -Name 'Microsoft.Windows.PowerShell.ISE~~~~0.0.1.0' -Online
# Windows Fax and Scan
Add-WindowsCapability -Name 'Print.Fax.Scan~~~~0.0.1.0' -Online
# Print Managment
Add-WindowsCapability -Name 'Print.Management.Console~~~~0.0.1.0' -Online

Write-Host 'Step2: Windows Optional Features: Disabling' -ForegroundColor green -BackgroundColor black
# Get-WindowsOptionalFeature -Online | Where-Object { $_.State -like 'Enabled' }
Disable-WindowsOptionalFeature -FeatureName 'LegacyComponents' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'MicrosoftWindowsPowerShellV2' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'MicrosoftWindowsPowershellV2Root' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'Printing-XPSServices-Features' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'WorkFolders-Client' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'MediaPlayback' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'WCF-Services45' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'WCF-TCP-PortSharing45' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'Printing-PrintToPDFServices-Features' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'MSRDC-Infrastructure' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'NetFx4-AdvSrvs' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'SearchEngine-Client-Package' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'Microsoft-SnippingTool' -Online -NoRestart
Disable-WindowsOptionalFeature -FeatureName 'Printing-Foundation-InternetPrinting-Client' -Online -NoRestart
# RDP
Enable-WindowsOptionalFeature -FeatureName 'Microsoft-RemoteDesktopConnection' -Online -NoRestart
# Print
Enable-WindowsOptionalFeature -FeatureName 'Printing-Foundation-Features' -Online -NoRestart
# SMB
if (Get-SmbClientNetworkInterface | Where-Object { $_.RdmaCapable -eq $false } ) {
    Disable-WindowsOptionalFeature -FeatureName 'SmbDirect' -Online -NoRestart
}
elseif (Get-SmbClientNetworkInterface | Where-Object { $_.RdmaCapable -eq $true } ) {
    Enable-WindowsOptionalFeature -FeatureName 'SmbDirect' -Online -NoRestart
}

Write-Host 'Step2: Windows Packages: Removing Windows Backup app' -ForegroundColor green -BackgroundColor black
Remove-WindowsPackage -PackageName 'Microsoft-Windows-UserExperience-Desktop-Package~31bf3856ad364e35~amd64~~10.0.19041.4291' -Online -NoRestart
Remove-WindowsPackage -PackageName 'Microsoft-Windows-UserExperience-Desktop-Package~31bf3856ad364e35~amd64~~10.0.19041.4355' -Online -NoRestart

Write-Host 'Step2: Restarting' -ForegroundColor green -BackgroundColor black
shutdown /r /t 00
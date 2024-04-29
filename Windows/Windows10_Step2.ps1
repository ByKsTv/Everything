Unregister-ScheduledTask -TaskName Windows10_Step2 -Confirm:$false
$Windows10Step3 = 'Windows10_Step3'
Invoke-WebRequest -Uri https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/$Windows10Step3.ps1 -OutFile $env:TEMP\$Windows10Step3.ps1
Write-Host "Task Scheduler > $Windows10Step3" -ForegroundColor green -BackgroundColor black
$Windows10Step3_Principal = New-ScheduledTaskPrincipal -UserId $env:computername\$env:USERNAME -RunLevel Highest
$Windows10Step3_Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Maximized -ExecutionPolicy Bypass -File $env:TEMP\$Windows10Step3.ps1"
$Windows10Step3_Trigger = New-ScheduledTaskTrigger -AtLogOn
$Windows10Step3_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
$Windows10Step3_Parameters = @{
    TaskName  = $Windows10Step3
    Principal = $Windows10Step3_Principal
    Action    = $Windows10Step3_Action
    Trigger   = $Windows10Step3_Trigger
    Settings  = $Windows10Step3_Settings
}
Register-ScheduledTask @Windows10Step3_Parameters -Force
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
Write-Host 'Restart' -ForegroundColor cyan -BackgroundColor black
shutdown /r /t 00
Unregister-ScheduledTask -TaskName Windows10_Step4 -Confirm:$false
$Windows10Step5 = 'Windows10_Step5'
Invoke-WebRequest -Uri https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/$Windows10Step5.ps1 -OutFile $env:TEMP\$Windows10Step5.ps1
Write-Host "Task Scheduler > $Windows10Step5" -ForegroundColor green -BackgroundColor black
$Windows10Step5_Principal = New-ScheduledTaskPrincipal -UserId $env:computername\$env:USERNAME -RunLevel Highest
$Windows10Step5_Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Maximized -ExecutionPolicy Bypass -File $env:TEMP\$Windows10Step5.ps1"
$Windows10Step5_Trigger = New-ScheduledTaskTrigger -AtLogOn
$Windows10Step5_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
$Windows10Step5_Parameters = @{
    TaskName  = $Windows10Step5
    Principal = $Windows10Step5_Principal
    Action    = $Windows10Step5_Action
    Trigger   = $Windows10Step5_Trigger
    Settings  = $Windows10Step5_Settings
}
Register-ScheduledTask @Windows10Step5_Parameters -Force
Write-Host "$env:TEMP\Winutil.log > Delete" -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath "$env:TEMP\Winutil.log") -eq $true) {
    Remove-Item -Path $env:TEMP\Winutil.log
}
Write-Host 'Sophia Script > Download' -ForegroundColor green -BackgroundColor black
Invoke-RestMethod https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/Download_Sophia.ps1 | Invoke-Expression
$CurrentSophiaScriptPath = Get-Location
Write-Host 'Latest Sophia Script > Download' -ForegroundColor green -BackgroundColor black
Invoke-WebRequest -Uri https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/src/Sophia_Script_for_Windows_10_LTSC_2021/Sophia.ps1 -OutFile $CurrentSophiaScriptPath\Sophia.ps1
Invoke-WebRequest -Uri https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/src/Sophia_Script_for_Windows_10_LTSC_2021/Functions.ps1 -OutFile $CurrentSophiaScriptPath\Functions.ps1
Invoke-WebRequest -Uri https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/src/Sophia_Script_for_Windows_10_LTSC_2021/Module/Sophia.psm1 -OutFile $CurrentSophiaScriptPath\Module\Sophia.psm1
Write-Host 'Scheduled tasks > Disable' -ForegroundColor green -BackgroundColor black
Disable-ScheduledTask -TaskName MapsToastTask -TaskPath '\Microsoft\Windows\Maps\'
Disable-ScheduledTask -TaskName FamilySafetyMonitor -TaskPath '\Microsoft\Windows\Shell\'
Disable-ScheduledTask -TaskName FamilySafetyRefreshTask -TaskPath '\Microsoft\Windows\Shell\'
Disable-ScheduledTask -TaskName XblGameSaveTask -TaskPath '\Microsoft\XblGameSave\'
Write-Host 'Custom Settings > Apply' -ForegroundColor green -BackgroundColor black
(Get-Content -Raw Sophia.ps1) -replace 'Clear-Host', '' -replace 'InitialActions -Warning', 'InitialActions' -replace 'ThisPC -Show', '' -replace '# UserFolders -ThreeDObjects Hide -Desktop Hide -Documents Hide -Downloads Hide -Music Hide -Pictures Hide -Videos Hide', 'UserFolders -ThreeDObjects Hide -Desktop Hide -Documents Hide -Downloads Hide -Music Hide -Pictures Hide -Videos Hide' -replace 'SecondsInSystemClock -Show', '' -replace 'AeroShaking -Enable', '' -replace '# AeroShaking -Disable', 'AeroShaking -Disable' -replace 'Cursors -Dark', '' -replace 'StorageSense -Enable', '' -replace 'PowerPlan -High', '' -replace 'IPv6Component -Disable', '' -replace 'Set-UserShellFolderLocation -Root', '' -replace 'RecommendedTroubleshooting -Automatically', '' -replace 'ThumbnailCacheRemoval -Disable', '' -replace 'SaveRestartableApps -Enable', '' -replace 'RKNBypass -Enable', '' -replace 'PinToStart -Tiles ControlPanel, DevicesPrinters', '' -replace '# PinToStart -UnpinAll -Tiles ControlPanel, DevicesPrinters', '' -replace '# PinToStart -UnpinAll', 'PinToStart -UnpinAll' -replace 'Set-AppGraphicsPerformance', '' | Set-Content Sophia.ps1
Write-Host 'Toast Notifications > Disable' -ForegroundColor green -BackgroundColor black
$SophiaScriptToastRegex = '(?ms)(?<=^\s*#region Toast notifications\s*).*?(?=\s*#endregion Toast notifications)'
(Get-Content -Raw Module/Sophia.psm1) -replace $SophiaScriptToastRegex, '' | Set-Content Module/Sophia.psm1
Write-Host 'Sophia Script > Run' -ForegroundColor green -BackgroundColor black
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
.\Sophia.ps1
Write-Host 'Microsoft Paint Setup' -ForegroundColor green -BackgroundColor black
Add-WindowsCapability -Online -Name 'Microsoft.Windows.MSPaint~~~~0.0.1.0'
Write-Host 'Restart' -ForegroundColor cyan -BackgroundColor black
shutdown /r /t 00
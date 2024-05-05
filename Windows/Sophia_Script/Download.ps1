Write-Host 'Sophia Script > Download > Releases' -ForegroundColor green -BackgroundColor black
Invoke-RestMethod https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/Download_Sophia.ps1 | Invoke-Expression
$CurrentSophiaScriptPath = Get-Location
Write-Host 'Sophia Script > Download > Master' -ForegroundColor green -BackgroundColor black
Invoke-WebRequest -Uri https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/src/Sophia_Script_for_Windows_10_LTSC_2021/Sophia.ps1 -OutFile $CurrentSophiaScriptPath\Sophia.ps1
Invoke-WebRequest -Uri https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/src/Sophia_Script_for_Windows_10_LTSC_2021/Functions.ps1 -OutFile $CurrentSophiaScriptPath\Functions.ps1
Invoke-WebRequest -Uri https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/src/Sophia_Script_for_Windows_10_LTSC_2021/Module/Sophia.psm1 -OutFile $CurrentSophiaScriptPath\Module\Sophia.psm1
Write-Host 'Sophia Script > Custom Settings > Apply' -ForegroundColor green -BackgroundColor black
(Get-Content -Raw Sophia.ps1) -replace 'Clear-Host', '' -replace 'InitialActions -Warning', 'InitialActions' -replace 'ThisPC -Show', '' -replace '# UserFolders -ThreeDObjects Hide -Desktop Hide -Documents Hide -Downloads Hide -Music Hide -Pictures Hide -Videos Hide', 'UserFolders -ThreeDObjects Hide -Desktop Hide -Documents Hide -Downloads Hide -Music Hide -Pictures Hide -Videos Hide' -replace 'SecondsInSystemClock -Show', '' -replace 'AeroShaking -Enable', '' -replace '# AeroShaking -Disable', 'AeroShaking -Disable' -replace 'Cursors -Dark', '' -replace 'StorageSense -Enable', '' -replace 'PowerPlan -High', '' -replace 'IPv6Component -Disable', '' -replace 'Set-UserShellFolderLocation -Root', '' -replace 'RecommendedTroubleshooting -Automatically', '' -replace 'ThumbnailCacheRemoval -Disable', '' -replace 'SaveRestartableApps -Enable', '' -replace 'RKNBypass -Enable', '' -replace 'PinToStart -Tiles ControlPanel, DevicesPrinters', '' -replace '# PinToStart -UnpinAll -Tiles ControlPanel, DevicesPrinters', '' -replace '# PinToStart -UnpinAll', 'PinToStart -UnpinAll' -replace 'Set-AppGraphicsPerformance', '' | Set-Content Sophia.ps1
Write-Host 'Sophia Script > Toast Notifications > Disable' -ForegroundColor green -BackgroundColor black
$SophiaScriptToastRegex = '(?ms)(?<=^\s*#region Toast notifications\s*).*?(?=\s*#endregion Toast notifications)'
(Get-Content -Raw Module/Sophia.psm1) -replace $SophiaScriptToastRegex, '' | Set-Content Module/Sophia.psm1
Write-Host 'Sophia Script > Run' -ForegroundColor green -BackgroundColor black
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
.\Sophia.ps1
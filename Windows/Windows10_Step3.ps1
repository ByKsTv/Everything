Unregister-ScheduledTask -TaskName Windows10_Step3 -Confirm:$false
$Windows10Step4 = 'Windows10_Step4'
Invoke-WebRequest -Uri https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/$Windows10Step4.ps1 -OutFile $env:TEMP\$Windows10Step4.ps1
Write-Host "Task Scheduler > $Windows10Step4" -ForegroundColor green -BackgroundColor black
$Windows10Step4_Principal = New-ScheduledTaskPrincipal -UserId $env:computername\$env:USERNAME -RunLevel Highest
$Windows10Step4_Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Maximized -ExecutionPolicy Bypass -File $env:TEMP\$Windows10Step4.ps1"
$Windows10Step4_Trigger = New-ScheduledTaskTrigger -AtLogOn
$Windows10Step4_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
$Windows10Step4_Parameters = @{
    TaskName  = $Windows10Step4
    Principal = $Windows10Step4_Principal
    Action    = $Windows10Step4_Action
    Trigger   = $Windows10Step4_Trigger
    Settings  = $Windows10Step4_Settings
}
Register-ScheduledTask @Windows10Step4_Parameters -Force
Write-Host 'Winutil > Download' -ForegroundColor green -BackgroundColor black
Invoke-WebRequest -Uri https://raw.githubusercontent.com/ChrisTitusTech/winutil/main/winutil.ps1 -OutFile $env:TEMP\winutil.ps1
Write-Host "Winutil > Restart at finish > Don't install Chocolatey > Don't install features and apps" -ForegroundColor green -BackgroundColor black
$winutilRegex1 = '(?ms)(?<=^\s*Write-Host "Installing features..."\s*).*?(?=\s*Write-Host "Done.")'
(Get-Content -Raw $env:TEMP\winutil.ps1) -replace $winutilRegex1, '' -replace 'Write-Host "--     Tweaks are Finished    ---"', 'shutdown /r /t 00' -replace 'Clear-Host', '' -replace 'function Install-WinUtilChoco {', 'function Install-WinUtilChoco {return' | Set-Content $env:TEMP\winutil.ps1
Write-Host 'Winutil > Desktop Profile Tweaks' -ForegroundColor green -BackgroundColor black
Invoke-WebRequest -Uri https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Windows10_Step3_DesktopProfile.json -OutFile $env:TEMP\DesktopProfile.json
Write-Host 'Winutil > Run' -ForegroundColor green -BackgroundColor black
Invoke-Expression "& { $(Invoke-RestMethod $env:TEMP\winutil.ps1) } -Config $env:TEMP\DesktopProfile.json -Run"
Add-Type -AssemblyName System.Windows.Forms
$CurrentMPVPath = Get-Location
$MPV_Updater = 'MPV Updater'
$MPV_Updater_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $MPV_Updater }
if ($MPV_Updater_Exists) {
}
else {
    Write-Host "Task Scheduler > $MPV_Updater" -ForegroundColor green -BackgroundColor black
    $MPV_Updater_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $MPV_Updater_Action = New-ScheduledTaskAction -Execute "$CurrentMPVPath\updater.bat"
    $MPV_Updater_Trigger = New-ScheduledTaskTrigger -AtLogOn
    $MPV_Updater_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
    $MPV_Updater_Parameters = @{
        TaskName  = $MPV_Updater
        Principal = $MPV_Updater_Principal
        Action    = $MPV_Updater_Action
        Trigger   = $MPV_Updater_Trigger
        Settings  = $MPV_Updater_Settings
    }
    Register-ScheduledTask @MPV_Updater_Parameters -Force
}
Start-ScheduledTask -TaskName $MPV_Updater
Start-Sleep 2
[System.Windows.Forms.SendKeys]::SendWait('{Y 2}')
Start-Sleep 1
[System.Windows.Forms.SendKeys]::SendWait('{1}')
Start-Sleep 10
Start-Process -FilePath $CurrentMPVPath\installer\mpv-install.bat -ArgumentList /u
if ((Test-Path -LiteralPath "$CurrentMPVPath\Install_Update.ps1") -eq $true) {
    Remove-Item -Path ("$CurrentMPVPath\Install_Update.ps1") -Force
}
if ((Test-Path -LiteralPath "$CurrentMPVPath\README.md") -eq $true) {
    Remove-Item -Path ("$CurrentMPVPath\README.md") -Force
}
exit
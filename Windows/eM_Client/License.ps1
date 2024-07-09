$eM_Client_License_Fix = 'eM Client License Fix'
$eM_Client_License_Fix_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $eM_Client_License_Fix }
if (!($eM_Client_License_Fix_Exists)) {
    Write-Host "Task Scheduler > $eM_Client_License_Fix" -ForegroundColor green -BackgroundColor black
    $eM_Client_License_Fix_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $eM_Client_License_Fix_Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Minimized Remove-Item -Path '$env:APPDATA\eM Client\Local Folders\folders.dat'"
    $eM_Client_License_Fix_Trigger = New-ScheduledTaskTrigger -AtLogOn
    $eM_Client_License_Fix_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
    $eM_Client_License_Fix_Parameters = @{
        TaskName  = $eM_Client_License_Fix
        Principal = $eM_Client_License_Fix_Principal
        Action    = $eM_Client_License_Fix_Action
        Trigger   = $eM_Client_License_Fix_Trigger
        Settings  = $eM_Client_License_Fix_Settings
    }
    Register-ScheduledTask @eM_Client_License_Fix_Parameters -Force
}
Start-ScheduledTask -TaskName $eM_Client_License_Fix
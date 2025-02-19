$eM_Client_License_Fix_TaskName = 'eM Client License Fix'
if (-not (Get-ScheduledTask -TaskName $eM_Client_License_Fix_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$eM_Client_License_Fix_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $eM_Client_License_Fix_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$eM_Client_License_Fix_TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/eM_Client/License.ps1')`""
    $eM_Client_License_Fix_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $eM_Client_License_Fix_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $eM_Client_License_Fix_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $eM_Client_License_Fix_TaskName -Action $eM_Client_License_Fix_TaskAction -Trigger $eM_Client_License_Fix_TaskTrigger -Principal $eM_Client_License_Fix_TaskPrincipal -Settings $eM_Client_License_Fix_TaskSettings -Force
}

Remove-Item -Path "$env:APPDATA\eM Client\Local Folders\folders.dat"
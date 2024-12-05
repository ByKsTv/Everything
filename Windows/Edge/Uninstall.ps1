$EdgeUninstaller_TaskName = 'Edge Uninstaller'
if (-not (Get-ScheduledTask -TaskName $EdgeUninstaller_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$EdgeUninstaller_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $EdgeUninstaller_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Microsoft_Edge/Uninstall.ps1')"
    $EdgeUninstaller_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $EdgeUninstaller_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $EdgeUninstaller_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $EdgeUninstaller_TaskName -Action $EdgeUninstaller_TaskAction -Trigger $EdgeUninstaller_TaskTrigger -Principal $EdgeUninstaller_TaskPrincipal -Settings $EdgeUninstaller_TaskSettings -Force
}

$Task = Get-ScheduledTask -TaskName $EdgeUninstaller_TaskName -ErrorAction SilentlyContinue
if ($Task) {
    $Updated_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Windows/Software/Microsoft_Edge/Uninstall.ps1')"
    $Updated_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:COMPUTERNAME\$env:USERNAME" -RunLevel Highest
    Register-ScheduledTask -TaskName $EdgeUninstaller_TaskName -Action $Updated_TaskAction -Trigger $Task.Triggers -Principal $Updated_TaskPrincipal -Settings $Task.Settings -Force
}
$Task.Dispose()

# Delete this folder on 01/01/2025
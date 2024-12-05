$TranslucentTB_TaskName = 'TranslucentTB Updater'
if (-not (Get-ScheduledTask -TaskName $TranslucentTB_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TranslucentTB_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TranslucentTB_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/TranslucentTB/Download.ps1')"
    $TranslucentTB_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TranslucentTB_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TranslucentTB_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TranslucentTB_TaskName -Action $TranslucentTB_TaskAction -Trigger $TranslucentTB_TaskTrigger -Principal $TranslucentTB_TaskPrincipal -Settings $TranslucentTB_TaskSettings -Force
}

$Task = Get-ScheduledTask -TaskName $TranslucentTB_TaskName -ErrorAction SilentlyContinue
if ($Task) {
    $Updated_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/TranslucentTB/Download.ps1')"
    $Updated_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:COMPUTERNAME\$env:USERNAME" -RunLevel Highest
    Register-ScheduledTask -TaskName $TranslucentTB_TaskName -Action $Updated_TaskAction -Trigger $Task.Triggers -Principal $Updated_TaskPrincipal -Settings $Task.Settings -Force
}
$Task.Dispose()

# Delete this folder on 01/01/2025
$NVCleanstall_TaskName = 'NVCleanstall Updater'
if (-not (Get-ScheduledTask -TaskName $NVCleanstall_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NVCleanstall_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $NVCleanstall_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/NVCleanstall/Download.ps1')"
    $NVCleanstall_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $NVCleanstall_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $NVCleanstall_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $NVCleanstall_TaskName -Action $NVCleanstall_TaskAction -Trigger $NVCleanstall_TaskTrigger -Principal $NVCleanstall_TaskPrincipal -Settings $NVCleanstall_TaskSettings -Force
}

$Task = Get-ScheduledTask -TaskName $NVCleanstall_TaskName -ErrorAction SilentlyContinue
if ($Task) {
    $Updated_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/NVCleanstall/Download.ps1')"
    $Updated_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:COMPUTERNAME\$env:USERNAME" -RunLevel Highest
    Register-ScheduledTask -TaskName $NVCleanstall_TaskName -Action $Updated_TaskAction -Trigger $Task.Triggers -Principal $Updated_TaskPrincipal -Settings $Task.Settings -Force
}
$Task.Dispose()

# Delete this folder on 01/01/2025
$NotepadPlusPlus_TaskName = 'Notepad++ Updater'
if (-not (Get-ScheduledTask -TaskName $NotepadPlusPlus_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NotepadPlusPlus_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $NotepadPlusPlus_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Notepad++/Download.ps1')"
    $NotepadPlusPlus_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $NotepadPlusPlus_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $NotepadPlusPlus_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $NotepadPlusPlus_TaskName -Action $NotepadPlusPlus_TaskAction -Trigger $NotepadPlusPlus_TaskTrigger -Principal $NotepadPlusPlus_TaskPrincipal -Settings $NotepadPlusPlus_TaskSettings -Force
}

$Task = Get-ScheduledTask -TaskName $NotepadPlusPlus_TaskName -ErrorAction SilentlyContinue
if ($Task) {
    $Updated_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Notepad++/Download.ps1')"
    $NotepadPlusPlus_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $Updated_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:COMPUTERNAME\$env:USERNAME" -RunLevel Highest
    Register-ScheduledTask -TaskName $NotepadPlusPlus_TaskName -Action $Updated_TaskAction -Trigger $Task.Triggers -Principal $Updated_TaskPrincipal -Settings $Task.Settings -Force
}
$Task.Dispose()

# Delete this folder on 01/01/2025
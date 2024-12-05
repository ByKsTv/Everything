$7Zip_TaskName = '7-Zip Updater'
if (-not (Get-ScheduledTask -TaskName $7Zip_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$7Zip_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $7Zip_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')"
    $7Zip_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $7Zip_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $7Zip_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $7Zip_TaskName -Action $7Zip_TaskAction -Trigger $7Zip_TaskTrigger -Principal $7Zip_TaskPrincipal -Settings $7Zip_TaskSettings -Force
}

$Task = Get-ScheduledTask -TaskName $7Zip_TaskName -ErrorAction SilentlyContinue
if ($Task) {
    $Updated_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/7-Zip/Download.ps1')"
    $Updated_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:COMPUTERNAME\$env:USERNAME" -RunLevel Highest
    Register-ScheduledTask -TaskName $7Zip_TaskName -Action $Updated_TaskAction -Trigger $Task.Triggers -Principal $Updated_TaskPrincipal -Settings $Task.Settings -Force
}
$Task.Dispose()

# Delete this folder on 01/01/2025
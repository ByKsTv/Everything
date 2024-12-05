$Telegram_TaskName = 'Telegram Updater'
if (-not (Get-ScheduledTask -TaskName $Telegram_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Telegram_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $Telegram_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Telegram/Download.ps1')"
    $Telegram_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $Telegram_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $Telegram_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $Telegram_TaskName -Action $Telegram_TaskAction -Trigger $Telegram_TaskTrigger -Principal $Telegram_TaskPrincipal -Settings $Telegram_TaskSettings -Force
}

$Task = Get-ScheduledTask -TaskName $Telegram_TaskName -ErrorAction SilentlyContinue
if ($Task) {
    $Updated_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Telegram/Download.ps1')"
    $Updated_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:COMPUTERNAME\$env:USERNAME" -RunLevel Highest
    Register-ScheduledTask -TaskName $Telegram_TaskName -Action $Updated_TaskAction -Trigger $Task.Triggers -Principal $Updated_TaskPrincipal -Settings $Task.Settings -Force
}
$Task.Dispose()

# Delete this folder on 01/01/2025
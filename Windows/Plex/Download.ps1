$PlexMediaServer_TaskName = 'PlexMediaServer Updater'
if (-not (Get-ScheduledTask -TaskName $PlexMediaServer_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$PlexMediaServer_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $PlexMediaServer_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Plex_Media_Server/Download.ps1')"
    $PlexMediaServer_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $PlexMediaServer_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $PlexMediaServer_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $PlexMediaServer_TaskName -Action $PlexMediaServer_TaskAction -Trigger $PlexMediaServer_TaskTrigger -Principal $PlexMediaServer_TaskPrincipal -Settings $PlexMediaServer_TaskSettings -Force
}

$Task = Get-ScheduledTask -TaskName $PlexMediaServer_TaskName -ErrorAction SilentlyContinue
if ($Task) {
    $Updated_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Plex_Media_Server/Download.ps1')"
    $Updated_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:COMPUTERNAME\$env:USERNAME" -RunLevel Highest
    Register-ScheduledTask -TaskName $PlexMediaServer_TaskName -Action $Updated_TaskAction -Trigger $Task.Triggers -Principal $Updated_TaskPrincipal -Settings $Task.Settings -Force
}
$Task.Dispose()

# Delete this folder on 01/01/2025
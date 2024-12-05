$Mediainfo_TaskName = 'Mediainfo Updater'
if (-not (Get-ScheduledTask -TaskName $Mediainfo_TaskName -ErrorAction SilentlyContinue)) {
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Mediainfo_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
	$Mediainfo_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/MediaInfo/Download.ps1')"
	$Mediainfo_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
	$Mediainfo_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
	$Mediainfo_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
	Register-ScheduledTask -TaskName $Mediainfo_TaskName -Action $Mediainfo_TaskAction -Trigger $Mediainfo_TaskTrigger -Principal $Mediainfo_TaskPrincipal -Settings $Mediainfo_TaskSettings -Force
}

$Task = Get-ScheduledTask -TaskName $Mediainfo_TaskName -ErrorAction SilentlyContinue
if ($Task) {
    $Updated_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/MediaInfo/Download.ps1')"
    $Updated_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:COMPUTERNAME\$env:USERNAME" -RunLevel Highest
    Register-ScheduledTask -TaskName $Mediainfo_TaskName -Action $Updated_TaskAction -Trigger $Task.Triggers -Principal $Updated_TaskPrincipal -Settings $Task.Settings -Force
}
$Task.Dispose()

# Delete this folder on 01/01/2025
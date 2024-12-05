$DotNET_TaskName = '.NET Updater'
if (-not (Get-ScheduledTask -TaskName $DotNET_TaskName -ErrorAction SilentlyContinue)) {
	[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
	$DotNET_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/.NET/Download.ps1')"
	$DotNET_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
	$DotNET_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
	$DotNET_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
	Register-ScheduledTask -TaskName $DotNET_TaskName -Action $DotNET_TaskAction -Trigger $DotNET_TaskTrigger -Principal $DotNET_TaskPrincipal -Settings $DotNET_TaskSettings -Force
}

$Task = Get-ScheduledTask -TaskName $DotNET_TaskName -ErrorAction SilentlyContinue
if ($Task) {
    $Updated_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/.NET/Download.ps1')"
    $Updated_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:COMPUTERNAME\$env:USERNAME" -RunLevel Highest
    Register-ScheduledTask -TaskName $DotNET_TaskName -Action $Updated_TaskAction -Trigger $Task.Triggers -Principal $Updated_TaskPrincipal -Settings $Task.Settings -Force
}
$Task.Dispose()

# Delete this folder on 01/01/2025
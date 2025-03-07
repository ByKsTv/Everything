$MPV_TaskName = 'MPV Updater'
if (-not (Get-ScheduledTask -TaskName $MPV_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $MPV_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$MPV_TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/Updater.ps1')`""
    $MPV_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $MPV_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $MPV_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $MPV_TaskName -Action $MPV_TaskAction -Trigger $MPV_TaskTrigger -Principal $MPV_TaskPrincipal -Settings $MPV_TaskSettings -Force
}

$MPV_InstallPath = Split-Path ((Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\mpv.exe' -ErrorAction SilentlyContinue).'(default)')
$MPV_UpdaterBAT = [IO.Path]::Combine($MPV_InstallPath, 'updater.bat')

& $MPV_UpdaterBAT
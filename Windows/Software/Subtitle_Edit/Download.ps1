$SubtitleEdit_TaskName = 'Subtitle Edit Updater'
if (-not (Get-ScheduledTask -TaskName $SubtitleEdit_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SubtitleEdit_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $SubtitleEdit_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Subtitle_Edit/Download.ps1')"
    $SubtitleEdit_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $SubtitleEdit_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $SubtitleEdit_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $SubtitleEdit_TaskName -Action $SubtitleEdit_TaskAction -Trigger $SubtitleEdit_TaskTrigger -Principal $SubtitleEdit_TaskPrincipal -Settings $SubtitleEdit_TaskSettings -Force
}

$SubtitleEditInstalledVersion = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SubtitleEdit_is1' -ErrorAction SilentlyContinue).DisplayVersion
$SubtitleEditLatestVersion = Invoke-RestMethod -UseBasicParsing -Uri 'https://api.github.com/repos/SubtitleEdit/subtitleedit/releases/latest'
$SubtitleEditLatestVersionUnV = $SubtitleEditLatestVersion.tag_name.TrimStart('v')

if ($SubtitleEditInstalledVersion) {
    if ($SubtitleEditInstalledVersion -notmatch '\.\d+\.\d+$') {
        $SubtitleEditInstalledVersion += '.0'
    }
    $installedVersionNormalized = [Version]$SubtitleEditInstalledVersion
}
else {
    $installedVersionNormalized = [Version]'0.0.0'
}
$latestVersionNormalized = [Version]$SubtitleEditLatestVersionUnV

if ($installedVersionNormalized -lt $latestVersionNormalized) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Subtitle Edit: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile(($SubtitleEditLatestVersion.assets | Where-Object name -Like '*exe*').browser_download_url, "$env:TEMP\SubtitleEditSetup.exe")

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Subtitle Edit: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process -FilePath "$env:TEMP\SubtitleEditSetup.exe" -ArgumentList '/verysilent'
}
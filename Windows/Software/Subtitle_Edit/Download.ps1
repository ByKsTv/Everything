$TaskName = 'Subtitle Edit Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Subtitle_Edit/Download.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

$InstalledVersion = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SubtitleEdit_is1' -ErrorAction SilentlyContinue).DisplayVersion
$LatestVersion = Invoke-RestMethod -UseBasicParsing -Uri 'https://api.github.com/repos/SubtitleEdit/subtitleedit/releases/latest'
$LatestVersionUnV = ($LatestVersion).tag_name.TrimStart('v')

if ($InstalledVersion) {
    if ($InstalledVersion -notmatch '\.\d+\.\d+$') {
        $InstalledVersion += '.0'
    }
    $installedVersionNormalized = [Version]$InstalledVersion
}
else {
    $installedVersionNormalized = [Version]'0.0.0'
}
$latestVersionNormalized = [Version]$LatestVersionUnV

if ($installedVersionNormalized -lt $latestVersionNormalized) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Subtitle Edit: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile(($LatestVersion.assets | Where-Object { $_.name -match 'exe' }).browser_download_url, "$env:TEMP\SubtitleEditSetup.exe")

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Subtitle Edit: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process -FilePath "$env:TEMP\SubtitleEditSetup.exe" -ArgumentList '/verysilent' -Wait
}
$SubtitleEdit = 'Subtitle Edit Updater'
$SubtitleEdit_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $SubtitleEdit }
if (!($SubtitleEdit_Exists)) {
    Write-Host "Subtitle Edit: Task Scheduler: Adding $SubtitleEdit" -ForegroundColor green -BackgroundColor black
    $SubtitleEdit_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $SubtitleEdit_Action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/SubtitleEdit/Download.ps1')"
    $SubtitleEdit_Trigger = New-ScheduledTaskTrigger -AtLogOn
    $SubtitleEdit_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
    $SubtitleEdit_Parameters = @{
        TaskName  = $SubtitleEdit
        Principal = $SubtitleEdit_Principal
        Action    = $SubtitleEdit_Action
        Trigger   = $SubtitleEdit_Trigger
        Settings  = $SubtitleEdit_Settings
    }
    Register-ScheduledTask @SubtitleEdit_Parameters -Force
}

$SubtitleEditInstalledVersion = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SubtitleEdit_is1' -ErrorAction SilentlyContinue).DisplayVersion
$SubtitleEditLatestVersion = Invoke-RestMethod -Uri 'https://api.github.com/repos/SubtitleEdit/subtitleedit/releases/latest' -UseBasicParsing
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
    Write-Host 'Subtitle Edit: Downloading' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile(($SubtitleEditLatestVersion.assets | Where-Object name -Like '*exe*').browser_download_url, "$env:TEMP\SubtitleEditSetup.exe")

    Write-Host 'Subtitle Edit: Installing' -ForegroundColor green -BackgroundColor black
    Start-Process -FilePath "$env:TEMP\SubtitleEditSetup.exe" -ArgumentList '/verysilent'
}
$SubtitleEdit = 'Subtitle Edit Updater'
$SubtitleEdit_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $SubtitleEdit }
if (!($SubtitleEdit_Exists)) {
    Write-Host "Subtitle Edit: Task Scheduler: Adding $SubtitleEdit" -ForegroundColor green -BackgroundColor black
    $SubtitleEdit_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $SubtitleEdit_Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Subtitle_Edit/Download.ps1')"
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

# Not ready since there's a mismatch version numbers
$SubtitleEditInstalledVer = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\SubtitleEdit_is1' -ErrorAction SilentlyContinue).DisplayVersion
$SubtitleEditLatestVer = (Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/SubtitleEdit/subtitleedit/releases/latest').tag_name

if (($null -eq $SubtitleEditInstalledVer) -or ($SubtitleEditInstalledVer -notmatch $SubtitleEditLatestVer)) {
    Write-Host "Subtitle Edit: Downloading $SubtitleEditLatestVer" -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/SubtitleEdit/subtitleedit/releases/latest').assets | Where-Object name -Like '*exe*').browser_download_url, "$env:TEMP\SubtitleEdit-$SubtitleEditLatestVer.exe")
    
    Write-Host "Subtitle Edit: Installing $SubtitleEditLatestVer" -ForegroundColor green -BackgroundColor black
    Start-Process -FilePath "$env:TEMP\SubtitleEdit-$SubtitleEditLatestVer.exe" -ArgumentList '/verysilent'
}
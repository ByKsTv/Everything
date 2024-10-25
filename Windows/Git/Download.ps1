$GitUpdater = 'Git Updater'
$GitUpdater_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $GitUpdater }
if (!($GitUpdater_Exists)) {
    Write-Host "Git Updater: Task Scheduler: Adding $GitUpdater" -ForegroundColor green -BackgroundColor black
    $GitUpdater_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $GitUpdater_Action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Git/Download.ps1')"
    $GitUpdater_Trigger = New-ScheduledTaskTrigger -AtLogOn
    $GitUpdater_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
    $GitUpdater_Parameters = @{
        TaskName  = $GitUpdater
        Principal = $GitUpdater_Principal
        Action    = $GitUpdater_Action
        Trigger   = $GitUpdater_Trigger
        Settings  = $GitUpdater_Settings
    }
    Register-ScheduledTask @GitUpdater_Parameters -Force
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Git: Checking if updated'); [Console]::ResetColor(); [Console]::WriteLine()
$GitInstalledVer = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Git_is1' -ErrorAction SilentlyContinue).DisplayVersion
$GitLatestVer = ((((Invoke-RestMethod 'https://api.github.com/repos/git-for-windows/git/releases/latest').assets | Where-Object name -Like '*64-bit.exe').name).Replace('Git-', '')).Replace('-64-bit.exe', '')

if (($null -eq $GitInstalledVer) -or ($GitInstalledVer -notmatch $GitLatestVer)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Git: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod 'https://api.github.com/repos/git-for-windows/git/releases/latest').assets | Where-Object name -Like '*64-bit.exe').browser_download_url, "$env:TEMP\Git-Latest.exe")

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Git: Using custom settings'); [Console]::ResetColor(); [Console]::WriteLine()
    # https://github.com/git-for-windows/git/wiki/Silent-or-Unattended-Installation
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Git/Download.ini', "$env:TEMP\Git_Download.inf")

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Git: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process -FilePath "$env:TEMP\Git-Latest.exe" -ArgumentList "/SP- /VERYSILENT /SUPPRESSMSGBOXES /NOCANCEL /NORESTART /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /LOADINF=""$env:TEMP\Git_Download.inf"""
}
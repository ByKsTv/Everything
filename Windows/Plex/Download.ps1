$PlexMediaServer = 'PlexMediaServer Updater'
$PlexMediaServer_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $PlexMediaServer }
if (!($PlexMediaServer_Exists)) {
    Write-Host "Plex: Task Scheduler: Adding $PlexMediaServer" -ForegroundColor green -BackgroundColor black
    $PlexMediaServer_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $PlexMediaServer_Action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Plex/Download.ps1')"
    $PlexMediaServer_Trigger = New-ScheduledTaskTrigger -AtLogOn
    $PlexMediaServer_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
    $PlexMediaServer_Parameters = @{
        TaskName  = $PlexMediaServer
        Principal = $PlexMediaServer_Principal
        Action    = $PlexMediaServer_Action
        Trigger   = $PlexMediaServer_Trigger
        Settings  = $PlexMediaServer_Settings
    }
    Register-ScheduledTask @PlexMediaServer_Parameters -Force
}

Write-Host 'Plex: Getting current version' -ForegroundColor green -BackgroundColor black
$Plex_Installed = Get-ChildItem -Directory -Path "$env:LOCALAPPDATA\Plex Media Server\Updates" | Sort-Object -Descending -Property Name | Select-Object -First 1 -ExpandProperty 'Name'

Write-Host 'Plex: Getting latest release' -ForegroundColor green -BackgroundColor black
# https://github.com/mkevenaar/chocolatey-packages/blob/master/automatic/plexmediaserver/update.ps1
$PlexTimeStamp = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
$PlexFeedURL = 'https://plex.tv/pms/downloads/5.json?_=' + $PlexTimeStamp
$PlexURL = Invoke-RestMethod -Uri $PlexFeedURL
$PlexURL64bit = ($PlexURL.computer.windows.releases | Where-Object -Property build -EQ windows-x86_64).url
$PlexLatestVersion = $PlexURL.computer.windows.version

if (($null -eq $Plex_Installed) -or ($Plex_Installed -notmatch $PlexLatestVersion)) {
    Write-Host "Plex: Downloading $PlexLatestVersion" -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile("$PlexURL64bit", "$env:TEMP\PlexMediaServer-$PlexLatestVersion.exe")

    Write-Host "Plex: Installing $PlexLatestVersion" -ForegroundColor green -BackgroundColor black
    Start-Process -FilePath "$env:TEMP\$env:TEMP\PlexMediaServer-$PlexLatestVersion.exe" -ArgumentList '/quiet /VERYSILENT'
}
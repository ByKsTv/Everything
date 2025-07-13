$TaskName = 'PlexMediaServer Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Plex_Media_Server/Download.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Plex: Getting current version'); [Console]::ResetColor(); [Console]::WriteLine()
$Installed1 = Get-Package -Name 'Plex Media Server*' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'Version'
$Installed2 = (Get-ChildItem -Directory -Path "$env:ProgramFiles\Plex\Plex Media Server\Resources\Plug-ins-*" -ErrorAction SilentlyContinue | Sort-Object -Descending -Property Name | Select-Object -First 1 -ExpandProperty 'Name').Replace('Plug-ins-', '')
$Installed = $Installed1 + '-' + $Installed2

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Plex: Getting latest release'); [Console]::ResetColor(); [Console]::WriteLine()
# https://github.com/mkevenaar/chocolatey-packages/blob/master/automatic/plexmediaserver/update.ps1
$PlexTimeStamp = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
$PlexFeedURL = 'https://plex.tv/pms/downloads/5.json?_=' + $PlexTimeStamp
$PlexURL = Invoke-RestMethod -Uri $PlexFeedURL
$PlexURL64bit = $PlexURL | Select-Object -ExpandProperty 'computer' | Select-Object -ExpandProperty 'windows' | Select-Object -ExpandProperty 'releases' | Where-Object { $_.build -eq 'windows-x86_64' } | Select-Object -ExpandProperty 'url'
$PlexLatestVersion = $PlexURL | Select-Object -ExpandProperty 'computer' | Select-Object -ExpandProperty 'windows' | Select-Object -ExpandProperty 'version'

if (($null -eq $Installed) -or ($Installed -notmatch $PlexLatestVersion)) {
    Write-Host "Plex: Downloading $PlexLatestVersion" -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile("$PlexURL64bit", "$env:TEMP\PlexMediaServer-$PlexLatestVersion-x86_64.exe")

    Write-Host "Plex: Installing $PlexLatestVersion" -ForegroundColor green -BackgroundColor black
    Start-Process -FilePath "$env:TEMP\PlexMediaServer-$PlexLatestVersion-x86_64.exe" -ArgumentList '/quiet /VERYSILENT'
}
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
$Installed = (Get-Item "$env:ProgramFiles\Plex\Plex Media Server\Plex Media Server.exe" -ErrorAction Ignore).VersionInfo.ProductVersion

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Plex: Getting latest release'); [Console]::ResetColor(); [Console]::WriteLine()
# https://github.com/mkevenaar/chocolatey-packages/blob/master/automatic/plexmediaserver/update.ps1
$PlexTimeStamp = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
$PlexFeedURL = 'https://plex.tv/pms/downloads/5.json?_=' + $PlexTimeStamp
$PlexURL = Invoke-RestMethod -Uri $PlexFeedURL
$PlexURL64bit = (((($PlexURL).computer).windows).releases | Where-Object { $_.build -eq 'windows-x86_64' }).url
$PlexLatestVersion = ((($PlexURL).computer).windows).version

if (($null -eq $Installed) -or ($Installed -notmatch $PlexLatestVersion)) {
    # https://support.plex.tv/articles/201105343-advanced-hidden-server-settings/#toc-1

    if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Plex, Inc.\Plex Media Server')) {
        New-Item 'HKCU:\SOFTWARE\Plex, Inc.\Plex Media Server' -Force

        New-ItemProperty -Path 'HKCU:\SOFTWARE\Plex, Inc.\Plex Media Server' -Name 'AcceptedEULA' -Value 1 -PropertyType DWord -Force

        # `Settings` -> `General` -> `Send crash reports to Plex` -> Off.
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Plex, Inc.\Plex Media Server' -Name 'sendCrashReports' -Value 0 -PropertyType DWord -Force

        # `Settings` -> `General` -> `Support Away Mode when preventing system sleep` -> Off.
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Plex, Inc.\Plex Media Server' -Name 'AwayModeSupported' -Value 0 -PropertyType DWord -Force

        # `Settings` -> `General` -> `Enable Plex Media Server debug logging` -> Off.
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Plex, Inc.\Plex Media Server' -Name 'logDebug' -Value 0 -PropertyType DWord -Force

        # `Settings` -> `General` -> `Enable Plex Media Server verbose logging` -> Off.
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Plex, Inc.\Plex Media Server' -Name 'LogVerbose' -Value 0 -PropertyType DWord -Force

        # `Settings` -> `General` -> `Server version updates` -> `Automatically during scheduled maintenance`.
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Plex, Inc.\Plex Media Server' -Name 'ButlerTaskUpdateServer' -Value 'always' -PropertyType String -Force

        # `Settings` -> `Library` -> `Scan my library automatically` -> On.
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Plex, Inc.\Plex Media Server' -Name 'FSEventLibraryUpdatesEnabled' -Value 1 -PropertyType DWord -Force

        # `Settings` -> `Library` -> `Run a partial scan when changes are detected` -> On.
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Plex, Inc.\Plex Media Server' -Name 'FSEventLibraryPartialScanEnabled' -Value 1 -PropertyType DWord -Force

        # `Settings` -> `Library` -> `Scan my library periodically` -> `every 15 minutes`.
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Plex, Inc.\Plex Media Server' -Name 'ScheduledLibraryUpdatesEnabled' -Value 1 -PropertyType DWord -Force
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Plex, Inc.\Plex Media Server' -Name 'ScheduledLibraryUpdateInterval' -Value 384 -PropertyType DWord -Force

        # `Settings` -> `Transcoder` -> `Transcoder quality` -> `Make my CPU hurt`.
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Plex, Inc.\Plex Media Server' -Name 'TranscoderQuality' -Value 3 -PropertyType DWord -Force

        # `Settings` -> `Transcoder` -> `Background transcoding x264 preset` -> `Very slow`.
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Plex, Inc.\Plex Media Server' -Name 'TranscoderH264BackgroundPreset' -Value 'veryslow' -PropertyType String -Force

        # `Settings` -> `Scheduled Tasks` -> `Update all libraries during maintenance` -> On.
        New-ItemProperty -Path 'HKCU:\SOFTWARE\Plex, Inc.\Plex Media Server' -Name 'ButlerTaskRefreshLibraries' -Value 3 -PropertyType DWord -Force
    }

    Write-Host "Plex: Downloading $PlexLatestVersion" -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile("$PlexURL64bit", "$env:TEMP\PlexMediaServer-$PlexLatestVersion-x86_64.exe")

    Write-Host "Plex: Installing $PlexLatestVersion" -ForegroundColor green -BackgroundColor black
    Start-Process -FilePath "$env:TEMP\PlexMediaServer-$PlexLatestVersion-x86_64.exe" -ArgumentList '/quiet /VERYSILENT' # Do not add `-Wait`
}

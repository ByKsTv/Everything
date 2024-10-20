$qBittorrent_TaskName = 'qBittorrent Updater'
if (-not (Get-ScheduledTask -TaskName $qBittorrent_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$qBittorrent_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $qBittorrent_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1')"
    $qBittorrent_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $qBittorrent_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $qBittorrent_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $qBittorrent_TaskName -Action $qBittorrent_TaskAction -Trigger $qBittorrent_TaskTrigger -Principal $qBittorrent_TaskPrincipal -Settings $qBittorrent_TaskSettings -Force
}

$qBittorrent_InstalledVersion = (Get-Package -Name 'qBittorrent' -ErrorAction SilentlyContinue).Version
$qBittorrent_LatestVersion = ((Invoke-RestMethod https://api.github.com/repos/qbittorrent/qbittorrent/tags).Name | Where-Object { $_ -NotMatch 'beta' -And $_ -NotMatch 'rc' } | Select-Object -First 1).Replace('release-', '')

if ($null -eq $qBittorrent_InstalledVersion -or $qBittorrent_InstalledVersion -notmatch $qBittorrent_LatestVersion) {
    $qBittorrent_RemoteINI = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/qBittorrent.ini'
    $qBittorrent_LocalINI = "$env:APPDATA\qBittorrent\qBittorrent.ini"
    if (-not (Test-Path -Path $qBittorrent_LocalINI)) {
        New-Item -Path $qBittorrent_LocalINI -ItemType File -Force
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' custom settings from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$qBittorrent_RemoteINI'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$qBittorrent_LocalINI'"); [Console]::ResetColor(); [Console]::WriteLine()
        (New-Object System.Net.WebClient).DownloadFile($qBittorrent_RemoteINI, $qBittorrent_LocalINI)
    }
    
    $qBittorrent_SourceForge = ((Invoke-WebRequest -UseBasicParsing -Uri 'https://raw.githubusercontent.com/qbittorrent/qBittorrent-website/refs/heads/master/_site/download.html').Links | Where-Object { ($_.outerHTML -match 'sourceforge' -and $_.outerHTML -match '.exe' -and $_.outerHTML -notmatch '.asc' -and $_.outerHTML -match 'lt20' ) }).href
    $qBittorrent_DDL = ((Invoke-WebRequest -Uri $qBittorrent_SourceForge -UseBasicParsing).links | Where-Object { $_.'data-release-url' -ne $null }).'data-release-url'
    $qBittorrent_Filename = [System.IO.Path]::GetFileName(([System.Uri]$qBittorrent_DDL).AbsolutePath)
    $qBittorrent_SavePath = [System.IO.Path]::Combine($env:TEMP, $qBittorrent_Filename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$qBittorrent_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$qBittorrent_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$qBittorrent_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($qBittorrent_DDL, $qBittorrent_SavePath)
    
    $qBittorrent_Argument = '/S'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$qBittorrent_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$qBittorrent_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$qBittorrent_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $qBittorrent_SavePath -ArgumentList $qBittorrent_Argument
}
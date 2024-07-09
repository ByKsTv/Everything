$qBittorrent = 'qBittorrent Updater'
$qBittorrent_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $qBittorrent }
if (!($qBittorrent_Exists)) {
    Write-Host "qBittorrent: Task Scheduler: Adding $qBittorrent" -ForegroundColor green -BackgroundColor black
    $qBittorrent_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $qBittorrent_Action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1')"
    $qBittorrent_Trigger = New-ScheduledTaskTrigger -AtLogOn
    $qBittorrent_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
    $qBittorrent_Parameters = @{
        TaskName  = $qBittorrent
        Principal = $qBittorrent_Principal
        Action    = $qBittorrent_Action
        Trigger   = $qBittorrent_Trigger
        Settings  = $qBittorrent_Settings
    }
    Register-ScheduledTask @qBittorrent_Parameters -Force
}

Write-Host 'qBittorrent: Getting current version' -ForegroundColor green -BackgroundColor black
$qBittorrent_Installed = Get-Package -Name 'qBittorrent' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'Version'

Write-Host 'qBittorrent: Getting latest version' -ForegroundColor green -BackgroundColor black
$qBittorrent_Latest = ((Invoke-RestMethod https://api.github.com/repos/qbittorrent/qbittorrent/tags).Name | Where-Object { $_ -NotMatch 'beta' -And $_ -NotMatch 'rc' } | Select-Object -First 1).Replace('release-', '')

if (($null -eq $qBittorrent_Installed) -or ($qBittorrent_Installed -notmatch $qBittorrent_Latest)) {
    Write-Host "qBittorrent: Downloading $qBittorrent_Latest" -ForegroundColor green -BackgroundColor black
    $qBittorrent_SourceForge = (Invoke-WebRequest -UseBasicParsing -Uri 'https://www.qbittorrent.org/download' | Select-Object -ExpandProperty Links | Where-Object { ($_.outerHTML -match 'SourceForge') } | Select-Object -First 1 | Select-Object -ExpandProperty href)
    $qBittorrentURL = (Invoke-WebRequest -Uri "$qBittorrent_SourceForge" -UseBasicParsing).links.'data-release-url'
    (New-Object System.Net.WebClient).DownloadFile("$qBittorrentURL", "$ENV:temp\qBittorrent.exe")
    
    Write-Host "qBittorrent: Installing $qBittorrent_Latest" -ForegroundColor green -BackgroundColor black
    Start-Process "$ENV:temp\qBittorrent.exe" -ArgumentList '/S' -Wait
    
    if (!(Test-Path -Path "$env:APPDATA\qBittorrent\qBittorrent.ini")) {
        Write-Host 'qBittorrent: Creating qBittorrent folder' -ForegroundColor green -BackgroundColor black
        New-Item -Path "$env:APPDATA\qBittorrent" -Value qBittorrent -ItemType Directory
        Write-Host 'qBittorrent: Using custom settings' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/qBittorrent.ini', "$env:APPDATA\qBittorrent\qBittorrent.ini")
    }
}
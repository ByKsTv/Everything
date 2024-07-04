$qBittorrent = 'qBittorrent Updater'
$qBittorrent_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $qBittorrent }
if (!($qBittorrent_Exists)) {
    Write-Host "qBittorrent: Task Scheduler: Adding $qBittorrent" -ForegroundColor green -BackgroundColor black
    $qBittorrent_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $qBittorrent_Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1')"
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
    # (New-Object System.Net.WebClient).DownloadFile((Invoke-WebRequest 'https://sourceforge.net/projects/qbittorrent/files/latest/download' -UseBasicParsing).links.'data-release-url', "$ENV:temp\qBittorrent.exe")
    (New-Object System.Net.WebClient).DownloadFile((Invoke-WebRequest 'https://sourceforge.net/projects/qbittorrent/files/qbittorrent-win32/qbittorrent-4.6.5/qbittorrent_4.6.5_x64_setup.exe/download' -UseBasicParsing).links.'data-release-url', "$ENV:temp\qBittorrent.exe")
    
    Write-Host "qBittorrent: Installing $qBittorrent_Latest" -ForegroundColor green -BackgroundColor black
    Start-Process "$ENV:temp\qBittorrent.exe" -ArgumentList '/S'
    
    if (!(Test-Path -Path "$env:APPDATA\qBittorrent\qBittorrent.ini")) {
        Write-Host 'qBittorrent: Creating qBittorrent folder' -ForegroundColor green -BackgroundColor black
        New-Item -Path "$env:APPDATA\qBittorrent" -Value qBittorrent -ItemType Directory
        Write-Host 'qBittorrent: Using custom settings' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/qBittorrent.ini', "$env:APPDATA\qBittorrent\qBittorrent.ini")
    }
}
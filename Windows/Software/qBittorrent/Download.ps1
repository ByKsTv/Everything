$TaskName = 'qBittorrent Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/qBittorrent/Download.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

$GitHub = Invoke-RestMethod -Uri 'https://api.github.com/repos/qbittorrent/qbittorrent/releases/latest'
$LatestVersion = ($GitHub).name.Replace('qBittorrent v', '')
$InstalledVersion = (Get-Package -Name 'qBittorrent' -ErrorAction SilentlyContinue).Version

if (-not ($InstalledVersion)) {
    $RemoteINI = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/qBittorrent/qBittorrent.ini'
    $LocalINI = [IO.Path]::Combine($env:APPDATA, 'qBittorrent', 'qBittorrent.ini')
    if (-not (Test-Path -Path $LocalINI)) {
        New-Item -Path $LocalINI -ItemType File -Force
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' custom settings from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$RemoteINI'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LocalINI'"); [Console]::ResetColor(); [Console]::WriteLine()
        (New-Object System.Net.WebClient).DownloadFile($RemoteINI, $LocalINI)
    }
}

if (-not (Get-Process -Name 'qBittorrent' -ErrorAction SilentlyContinue)) {
    if (($null -eq $InstalledVersion) -or ($InstalledVersion -notmatch $LatestVersion)) {
        $DDL = (($GitHub).assets | Where-Object { $_.Name -match '.exe' -and $_.Name -notmatch '.asc' -and $_.Name -notmatch 'lt2' }).browser_download_url
        $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
        $SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
        (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)
    
        $Argument = '/S'
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
        Start-Process $SavePath -ArgumentList $Argument -Wait

        $DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/qBittorrent/Theme/OLED.qbtheme'
        $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
        $SavePath = [IO.Path]::Combine($env:APPDATA, 'qBittorrent', $FileName)
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
        (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)
    }
}

$ShortCut = [IO.Path]::Combine($env:ProgramData, 'Microsoft', 'Windows', 'Start Menu', 'Programs', 'qBittorrent', 'qBittorrent.lnk')
if (Test-Path $ShortCut) {
    $Destination = [IO.Path]::GetDirectoryName((New-Object -ComObject WScript.Shell).CreateShortcut($ShortCut).TargetPath)
    $OLD_PATH = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::User)
    if (-not ($OLD_PATH.Contains($Destination))) {
        $NEW_PATH = "$OLD_PATH;$Destination"
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'qBittorrent'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Destination'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'PATH'"); [Console]::ResetColor(); [Console]::WriteLine()
        [Environment]::SetEnvironmentVariable('Path', $NEW_PATH, [EnvironmentVariableTarget]::User)
        $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')
    }
}
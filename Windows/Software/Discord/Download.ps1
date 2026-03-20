$TaskName = 'Discord Client Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Discord/Download.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

$InstalledVersion = (Get-Package -Name 'Discord' -ErrorAction SilentlyContinue).Version
$Discord_DDL = (Invoke-WebRequest -UseBasicParsing -Uri 'https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x64' -MaximumRedirection 0 -ErrorAction SilentlyContinue).Headers.Location
# $LatestVersion = [regex]::Match($Discord_DDL, '\d+\.\d+\.\d+').Value
$LatestVersion = [regex]::Match($Discord_DDL, '(?<=/x64/)[^/]+').Value

if (($null -eq $InstalledVersion) -or ($InstalledVersion -notmatch $LatestVersion)) {
    if (Get-Process -Name 'Discord' -ErrorAction SilentlyContinue) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Closing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Discord'"); [Console]::ResetColor(); [Console]::WriteLine()
        Get-Process -Name 'Discord' -ErrorAction SilentlyContinue | ForEach-Object {
            $_.CloseMainWindow() | Out-Null
        }
        Start-Sleep -Milliseconds 1000
        Get-Process -Name 'Discord' -ErrorAction SilentlyContinue | Stop-Process -Force
    }

    $Dir = "$env:APPDATA\discord"
    if (-not (Test-Path $Dir)) {
        New-Item -Path $Dir -ItemType Directory -Force
    }

    $DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Discord/settings.json'
    $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
    $SavePath = [IO.Path]::Combine($Dir, $FileName)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Discord'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' settings from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

    $FileName = [IO.Path]::GetFileName(([URI]$Discord_DDL).AbsolutePath)
    $SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Discord'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($Discord_DDL, $SavePath)

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Discord'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $SavePath

    $InstallerPopup = 'Discord Updater'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Waiting for window '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$InstallerPopup'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to open '); [Console]::ResetColor(); [Console]::WriteLine()
    while (-not (Get-Process | Where-Object { $_.MainWindowTitle -eq $InstallerPopup } )) {
        Start-Sleep -Milliseconds 1000
    }
    
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Waiting for window '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$InstallerPopup'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to close '); [Console]::ResetColor(); [Console]::WriteLine()
    while ((Get-Process | Where-Object { $_.MainWindowTitle -eq $InstallerPopup } )) {
        Start-Sleep -Milliseconds 1000
    }
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Closing Discord process'); [Console]::ResetColor(); [Console]::WriteLine()
    Get-Process -Name 'Discord' -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

    $DesktopShortcut = "$($env:USERPROFILE)\Desktop\Discord.lnk"
    if (Test-Path -Path $DesktopShortcut) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Deleting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Discord'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' desktop shortcut from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DesktopShortcut'"); [Console]::ResetColor(); [Console]::WriteLine()
        Remove-Item -Path $DesktopShortcut
    }
    
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Disabling Discord startup'); [Console]::ResetColor(); [Console]::WriteLine()
    if ($null -ne (Get-Item -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run').GetValue('Discord')) {
        Remove-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run' -Name 'Discord' -Force
    }
    if ($null -ne (Get-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run').GetValue('Discord')) {
        Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'Discord' -Force
    }
    if (Test-Path -Path "$env:ProgramData\SquirrelMachineInstalls\Discord.exe") {
        Remove-Item -Path "$env:ProgramData\SquirrelMachineInstalls\Discord.exe" -Force
    }
}
$Discord_TaskName = 'Discord Client Updater'
if (-not (Get-ScheduledTask -TaskName $Discord_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $Discord_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$Discord_TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Discord/Download.ps1')`""
    $Discord_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $Discord_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $Discord_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $Discord_TaskName -Action $Discord_TaskAction -Trigger $Discord_TaskTrigger -Principal $Discord_TaskPrincipal -Settings $Discord_TaskSettings -Force
}

$Discord_InstalledVersion = (Get-Package -Name 'Discord' -ErrorAction SilentlyContinue).Version
$Discord_DDL = (Invoke-WebRequest -UseBasicParsing -Uri 'https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x64' -MaximumRedirection 0 -ErrorAction SilentlyContinue).Headers.Location
$Discord_LatestVersion = [regex]::Match($Discord_DDL, '\d+(\.\d+)+').Value

if ($null -eq $Discord_InstalledVersion -or $Discord_InstalledVersion -notmatch $Discord_LatestVersion) {
    if (Get-Process -Name 'Discord' -ErrorAction SilentlyContinue) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Closing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Discord'"); [Console]::ResetColor(); [Console]::WriteLine()
        Get-Process -Name 'Discord' -ErrorAction SilentlyContinue | ForEach-Object {
            $_.CloseMainWindow() | Out-Null
        }
        Start-Sleep -Milliseconds 1000
        Get-Process -Name 'Discord' -ErrorAction SilentlyContinue | Stop-Process -Force
    }

    $Discord_AppData_Dir = "$env:APPDATA\discord"
    if (-not (Test-Path $Discord_AppData_Dir)) {
        New-Item -Path $Discord_AppData_Dir -ItemType Directory -Force
    }

    $Discord_AppData_DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Discord/settings.json'
    $Discord_AppData_Filename = [IO.Path]::GetFileName(([URI]$Discord_AppData_DDL).AbsolutePath)
    $Discord_AppData_SavePath = [IO.Path]::Combine($Discord_AppData_Dir, $Discord_AppData_Filename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Discord'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' settings from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_AppData_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_AppData_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($Discord_AppData_DDL, $Discord_AppData_SavePath)

    $Discord_Filename = [IO.Path]::GetFileName(([URI]$Discord_DDL).AbsolutePath)
    $Discord_SavePath = [IO.Path]::Combine($env:TEMP, $Discord_Filename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Discord'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($Discord_DDL, $Discord_SavePath)

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Discord'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $Discord_SavePath

    $Discord_InstallerPopup = 'Discord Updater'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Waiting for window '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_InstallerPopup'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to open '); [Console]::ResetColor(); [Console]::WriteLine()
    while (-not (Get-Process | Where-Object { $_.MainWindowTitle -eq $Discord_InstallerPopup } )) {
        Start-Sleep -Milliseconds 1000
    }
    
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Waiting for window '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_InstallerPopup'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to close '); [Console]::ResetColor(); [Console]::WriteLine()
    while ((Get-Process | Where-Object { $_.MainWindowTitle -eq $Discord_InstallerPopup } )) {
        Start-Sleep -Milliseconds 1000
    }
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Closing Discord process'); [Console]::ResetColor(); [Console]::WriteLine()
    Get-Process -Name 'Discord' -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

    $Discord_DesktopShortcut = "$($env:USERPROFILE)\Desktop\Discord.lnk"
    if (Test-Path -Path $Discord_DesktopShortcut) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Deleting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Discord'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' desktop shortcut from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_DesktopShortcut'"); [Console]::ResetColor(); [Console]::WriteLine()
        Remove-Item -Path $Discord_DesktopShortcut
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
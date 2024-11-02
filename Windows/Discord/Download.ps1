$Discord_TaskName = 'Discord Updater'
if (-not (Get-ScheduledTask -TaskName $Discord_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $Discord_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Discord/Download.ps1')"
    $Discord_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $Discord_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $Discord_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $Discord_TaskName -Action $Discord_TaskAction -Trigger $Discord_TaskTrigger -Principal $Discord_TaskPrincipal -Settings $Discord_TaskSettings -Force
}

$Discord_InstalledVersion = (Get-Package -Name 'Discord' -ErrorAction SilentlyContinue).Version
$Discord_DDL = (Invoke-WebRequest -UseBasicParsing -Uri 'https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x64' -MaximumRedirection 0 -ErrorAction SilentlyContinue).Headers.Location
$Discord_LatestVersion = [regex]::Match($Discord_DDL, '\d+(\.\d+)+').Value

if ($null -eq $Discord_InstalledVersion -or $Discord_InstalledVersion -notmatch $Discord_LatestVersion) {
    $Discord_Filename = [System.IO.Path]::GetFileName(([System.Uri]$Discord_DDL).AbsolutePath)
    $Discord_SavePath = [System.IO.Path]::Combine($env:TEMP, $Discord_Filename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Discord'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($Discord_DDL, $Discord_SavePath)

    $Discord_Argument = '/S'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Discord'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_LatestVersion'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Discord_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $Discord_SavePath -ArgumentList $Discord_Argument -Wait

    while (!(Get-Process | Where-Object { $_.MainWindowTitle -Like 'Discord Updater' } )) {
        Start-Sleep -Milliseconds 1000
    }
    while ((Get-Process | Where-Object { $_.MainWindowTitle -Like 'Discord Updater' } )) {
        Start-Sleep -Milliseconds 1000
    }
    (Get-Process | Where-Object { $_.MainWindowTitle -Like '*Discord*' }).Kill() | Out-Null

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Discord: Deleting Desktop Shortcut'); [Console]::ResetColor(); [Console]::WriteLine()
    if ((Test-Path -Path "$($env:USERPROFILE)\Desktop\Discord.lnk") -eq $true) {
        Remove-Item -Path "$($env:USERPROFILE)\Desktop\Discord.lnk"
    }
    
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Discord: Disabling Startup'); [Console]::ResetColor(); [Console]::WriteLine()
    Remove-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run' -Name Discord -Force
    Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name Discord -Force
    Remove-Item -Path "$env:ProgramData\SquirrelMachineInstalls\Discord.exe" -Force
}
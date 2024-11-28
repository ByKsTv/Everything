$NVCleanstall_TaskName = 'NVCleanstall Updater'
if (-not (Get-ScheduledTask -TaskName $NVCleanstall_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NVCleanstall_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $NVCleanstall_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/NVCleanstall/Download.ps1')"
    $NVCleanstall_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $NVCleanstall_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $NVCleanstall_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $NVCleanstall_TaskName -Action $NVCleanstall_TaskAction -Trigger $NVCleanstall_TaskTrigger -Principal $NVCleanstall_TaskPrincipal -Settings $NVCleanstall_TaskSettings -Force
}

$NVCleanstall_InstalledVersion = (Get-Package -Name 'NVCleanstall' -ErrorAction SilentlyContinue).Version
$NVCleanstall_LatestVersionFilename = [regex]::Match((Invoke-WebRequest -Uri 'https://www.techpowerup.com/download/techpowerup-nvcleanstall/' -UseBasicParsing).Content, 'NVCleanstall_\d+\.\d+\.\d+\.exe').Value
$NVCleanstall_LatestVersion = ([regex]::Match($NVCleanstall_LatestVersionFilename, '\d+\.\d+\.\d+')).Value

if ($null -eq $NVCleanstall_InstalledVersion -or $NVCleanstall_InstalledVersion -notmatch $NVCleanstall_LatestVersion) {
    $NVCleanstall_Settings_URL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/NVCleanstall/settings.json'
    $NVCleanstall_Settings_Reg = 'HKCU:\SOFTWARE\techPowerUp\NVCleanstall'
    $NVCleanstall_Settings_RegTweak = [IO.Path]::Combine($NVCleanstall_Settings_Reg, 'PreviousTweaks')
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'NVCleanstall'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' custom settings from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NVCleanstall_Settings_URL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NVCleanstall_Settings_RegTweak'"); [Console]::ResetColor(); [Console]::WriteLine()
    if ((Test-Path -Path $NVCleanstall_Settings_Reg) -ne $true) {
        New-Item $NVCleanstall_Settings_Reg -Force
    }
    $NVCleanstall_Settings = (New-Object System.Net.WebClient).DownloadString($NVCleanstall_Settings_URL)
    New-ItemProperty -Path $NVCleanstall_Settings_Reg -Name 'PreviousTweaks' -Value $NVCleanstall_Settings -PropertyType String -Force

    # https://github.com/microsoft/winget-pkgs/tree/master/manifests/t/TechPowerUp/NVCleanstall
    $NVCleanstall_DDL = "https://us2-dl.techpowerup.com/files/$NVCleanstall_LatestVersionFilename"
    $NVCleanstall_Filename = [IO.Path]::GetFileName(([URI]$NVCleanstall_DDL).AbsolutePath)
    $NVCleanstall_SavePath = [IO.Path]::Combine($env:TEMP, $NVCleanstall_Filename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'NVCleanstall'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NVCleanstall_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NVCleanstall_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    $NVCleanstall_WebClient = New-Object System.Net.WebClient
    $NVCleanstall_WebClient.Headers['User-Agent'] = 'winget-create'
    $NVCleanstall_WebClient.DownloadFile($NVCleanstall_DDL, $NVCleanstall_SavePath)

    $NVCleanstall_Argument = '/install /tasks="DriverUpdateCheck" /verysilent'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'NVCleanstall'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NVCleanstall_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$NVCleanstall_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $NVCleanstall_SavePath -ArgumentList $NVCleanstall_Argument -Wait
}
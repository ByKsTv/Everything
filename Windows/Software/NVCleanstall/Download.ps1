$TaskName = 'NVCleanstall Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/NVCleanstall/Download.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

$InstalledVersion = Get-Package -Name 'NVCleanstall' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'Version'
$LatestVersionFileName = [regex]::Match((Invoke-WebRequest -Uri 'https://www.techpowerup.com/download/techpowerup-nvcleanstall/' -UseBasicParsing).Content, 'NVCleanstall_\d+\.\d+\.\d+\.exe').Value
$LatestVersion = ([regex]::Match($LatestVersionFileName, '\d+\.\d+\.\d+')).Value

if (($null -eq $InstalledVersion) -or ($InstalledVersion -notmatch $LatestVersion)) {
    $Settings_URL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/NVCleanstall/settings.json'
    $Settings_Reg = 'HKCU:\SOFTWARE\techPowerUp\NVCleanstall'
    $Settings_RegTweak = [IO.Path]::Combine($Settings_Reg, 'PreviousTweaks')
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'NVCleanstall'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' custom settings from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Settings_URL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Settings_RegTweak'"); [Console]::ResetColor(); [Console]::WriteLine()
    if (-not (Test-Path -Path $Settings_Reg)) {
        New-Item $Settings_Reg -Force
    }
    $Settings = (New-Object System.Net.WebClient).DownloadString($Settings_URL)
    New-ItemProperty -Path $Settings_Reg -Name 'PreviousTweaks' -Value $Settings -PropertyType String -Force

    # https://github.com/microsoft/winget-pkgs/tree/master/manifests/t/TechPowerUp/NVCleanstall
    $DDL = "https://us2-dl.techpowerup.com/files/$LatestVersionFileName"
    $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
    $SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'NVCleanstall'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    $NVCleanstall_WebClient = New-Object System.Net.WebClient
    $NVCleanstall_WebClient.Headers['User-Agent'] = 'winget-create'
    $NVCleanstall_WebClient.DownloadFile($DDL, $SavePath)

    $Argument = '/install /tasks="DriverUpdateCheck" /verysilent'
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'NVCleanstall'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Process $SavePath -ArgumentList $Argument -Wait
}
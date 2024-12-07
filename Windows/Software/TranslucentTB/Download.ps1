$TranslucentTB_TaskName = 'TranslucentTB Updater'
if (-not (Get-ScheduledTask -TaskName $TranslucentTB_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TranslucentTB_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TranslucentTB_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/TranslucentTB/Download.ps1')"
    $TranslucentTB_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TranslucentTB_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TranslucentTB_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TranslucentTB_TaskName -Action $TranslucentTB_TaskAction -Trigger $TranslucentTB_TaskTrigger -Principal $TranslucentTB_TaskPrincipal -Settings $TranslucentTB_TaskSettings -Force
}

$TranslucentTBPackage = (Get-AppxPackage | Where-Object { $_.Name -like '*TranslucentTB*' } -ErrorAction SilentlyContinue).Version
$TranslucentTBLatestVersion = (Invoke-RestMethod -UseBasicParsing -Uri https://api.github.com/repos/TranslucentTB/TranslucentTB/releases/latest).tag_name
$TranslucentTBInstalledVersionParts = ($TranslucentTBInstalledVersion -split '\.' | Select-Object -First 2) -join '.'
$TranslucentTBLatestVersionParts = ($TranslucentTBLatestVersion -split '\.' | Select-Object -First 2) -join '.'

if ($null -eq $TranslucentTBPackage) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('TranslucentTB: Using custom settings'); [Console]::ResetColor(); [Console]::WriteLine()
    $TranslucentTBLoc = Get-Item -Path "$env:LOCALAPPDATA\Packages\*TranslucentTB*\RoamingState\"
    $TranslucentTBSettingsLoc = "$TranslucentTBLoc\settings.json"
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/TranslucentTB/settings.json', "$TranslucentTBSettingsLoc")

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('TranslucentTB: Hiding pop-up'); [Console]::ResetColor(); [Console]::WriteLine()
    New-ItemProperty -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\*TranslucentTB*' -Name 'WasEverActivated' -Value 1 -PropertyType DWord -Force
}

if ($TranslucentTBInstalledVersionParts -ne $TranslucentTBLatestVersionParts) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('TranslucentTB: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Uri 'https://api.github.com/repos/TranslucentTB/TranslucentTB/releases/latest').assets | Where-Object name -Like '*appinstaller*').browser_download_url, "$env:TEMP\TranslucentTB.appinstaller")

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('TranslucentTB: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
    Add-AppxPackage -AppInstallerFile "$env:TEMP\TranslucentTB.appinstaller"
}
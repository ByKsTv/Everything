$TranslucentTB = 'TranslucentTB Updater'
$TranslucentTB_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $TranslucentTB }
if (!($TranslucentTB_Exists)) {
    Write-Host "TranslucentTB: Task Scheduler: Adding $TranslucentTB" -ForegroundColor green -BackgroundColor black
    $TranslucentTB_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TranslucentTB_Action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/TranslucentTB/Download.ps1')"
    $TranslucentTB_Trigger = New-ScheduledTaskTrigger -AtLogOn
    $TranslucentTB_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
    $TranslucentTB_Parameters = @{
        TaskName  = $TranslucentTB
        Principal = $TranslucentTB_Principal
        Action    = $TranslucentTB_Action
        Trigger   = $TranslucentTB_Trigger
        Settings  = $TranslucentTB_Settings
    }
    Register-ScheduledTask @TranslucentTB_Parameters -Force
}

$TranslucentTBPackage = Get-AppxPackage | Where-Object { $_.Name -like '*TranslucentTB*' }
if ($TranslucentTBPackage) {
    $TranslucentTBInstalledVersion = $TranslucentTBPackage.Version
}
$TranslucentTBLatestVersion = (Invoke-RestMethod -Uri https://api.github.com/repos/TranslucentTB/TranslucentTB/releases/latest -UseBasicParsing).tag_name
$TranslucentTBInstalledVersionParts = ($TranslucentTBInstalledVersion -split '\.' | Select-Object -First 2) -join '.'
$TranslucentTBLatestVersionParts = ($TranslucentTBLatestVersion -split '\.' | Select-Object -First 2) -join '.'

if ($null -eq $TranslucentTBPackage) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('TranslucentTB: Using custom settings'); [Console]::ResetColor(); [Console]::WriteLine()
    $TranslucentTBLoc = Get-Item -Path "$env:LOCALAPPDATA\Packages\*TranslucentTB*\RoamingState\"
    $TranslucentTBSettingsLoc = "$TranslucentTBLoc\settings.json"
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/TranslucentTB/settings.json', "$TranslucentTBSettingsLoc")

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('TranslucentTB: Hiding pop-up'); [Console]::ResetColor(); [Console]::WriteLine()
    New-ItemProperty -Path 'HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\*TranslucentTB*' -Name 'WasEverActivated' -Value 1 -PropertyType DWord -Force
}

if ($TranslucentTBInstalledVersionParts -ne $TranslucentTBLatestVersionParts) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('TranslucentTB: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/TranslucentTB/TranslucentTB/releases/latest').assets | Where-Object name -Like '*appinstaller*').browser_download_url, "$env:TEMP\TranslucentTB.appinstaller")

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('TranslucentTB: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
    Add-AppxPackage -AppInstallerFile "$env:TEMP\TranslucentTB.appinstaller"
}
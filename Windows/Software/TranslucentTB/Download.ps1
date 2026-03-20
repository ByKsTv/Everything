$TaskName = 'TranslucentTB Updater'
if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/TranslucentTB/Download.ps1')`""
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
}

# $Package = (Get-AppxPackage | Where-Object { $_.Name -match 'TranslucentTB' } -ErrorAction SilentlyContinue).Version
$LatestVersion = (Invoke-RestMethod -UseBasicParsing -Uri https://api.github.com/repos/TranslucentTB/TranslucentTB/releases/latest).tag_name
$InstalledVersionParts = ($InstalledVersion -split '\.' | Select-Object -First 2) -join '.'
$LatestVersionParts = ($LatestVersion -split '\.' | Select-Object -First 2) -join '.'

# Doesn't exist before installing
# if ($null -eq $Package) {
#     [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('TranslucentTB: Using custom settings'); [Console]::ResetColor(); [Console]::WriteLine()
#     $Loc = Get-Item -Path "$env:LOCALAPPDATA\Packages\*TranslucentTB*\RoamingState\"
#     $SettingsLoc = "$Loc\settings.json"
#     (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/TranslucentTB/settings.json', "$SettingsLoc")

#     [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('TranslucentTB: Hiding pop-up'); [Console]::ResetColor(); [Console]::WriteLine()
#     New-ItemProperty -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\*TranslucentTB*' -Name 'WasEverActivated' -Value 1 -PropertyType DWord -Force
# }

if ($InstalledVersionParts -ne $LatestVersionParts) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('TranslucentTB: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile((((Invoke-RestMethod -Uri 'https://api.github.com/repos/TranslucentTB/TranslucentTB/releases/latest').assets | Where-Object { $_.name -match 'appinstaller' }).browser_download_url), "$env:TEMP\TranslucentTB.appinstaller")

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('TranslucentTB: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
    Add-AppxPackage -AppInstallerFile "$env:TEMP\TranslucentTB.appinstaller"
}
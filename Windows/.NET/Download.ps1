$DotNET_TaskName = '.NET Updater'
if (-not (Get-ScheduledTask -TaskName $DotNET_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DotNET_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $DotNET_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/.NET/Download.ps1')"
    $DotNET_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $DotNET_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $DotNET_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $DotNET_TaskName -Action $DotNET_TaskAction -Trigger $DotNET_TaskTrigger -Principal $DotNET_TaskPrincipal -Settings $DotNET_TaskSettings -Force
}

$Task = Get-ScheduledTask -TaskName $DotNET_TaskName -ErrorAction SilentlyContinue
if ($Task) {
    $Updated_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/.NET/Download.ps1')"
    $Updated_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:COMPUTERNAME\$env:USERNAME" -RunLevel Highest
    Register-ScheduledTask -TaskName $DotNET_TaskName -Action $Updated_TaskAction -Trigger $Task.Triggers -Principal $Updated_TaskPrincipal -Settings $Task.Settings -Force
}
$Task.Dispose()

# Delete this folder on 01/01/2025

$Firefox_Profiles = [IO.Path]::Combine($env:APPDATA, 'Mozilla', 'Firefox', 'Profiles')
if (Test-Path $Firefox_Profiles) {
    $Firefox_Profile = (Get-ChildItem $Firefox_Profiles -Directory -Filter '*.default-release' | Select-Object -First 1).FullName
    if (Test-Path $Firefox_Profile) {

        $Arkenfox_Overrides_TaskName = 'Arkenfox Overrides'
        if (-not (Get-ScheduledTask -TaskName $Arkenfox_Overrides_TaskName -ErrorAction SilentlyContinue)) {
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Arkenfox_Overrides_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
            $Arkenfox_Overrides_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-WebRequest -Uri https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/user-overrides.js -OutFile $Firefox_Profile\user-overrides.js"
            $Arkenfox_Overrides_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
            $Arkenfox_Overrides_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
            $Arkenfox_Overrides_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
            Register-ScheduledTask -TaskName $Arkenfox_Overrides_TaskName -Action $Arkenfox_Overrides_TaskAction -Trigger $Arkenfox_Overrides_TaskTrigger -Principal $Arkenfox_Overrides_TaskPrincipal -Settings $Arkenfox_Overrides_TaskSettings -Force
        }

        $Task = Get-ScheduledTask -TaskName $Arkenfox_Overrides_TaskName -ErrorAction SilentlyContinue
        if ($Task) {
            $Updated_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-WebRequest -Uri https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/user-overrides.js -OutFile $Firefox_Profile\user-overrides.js"
            $Updated_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:COMPUTERNAME\$env:USERNAME" -RunLevel Highest
            Register-ScheduledTask -TaskName $Arkenfox_Overrides_TaskName -Action $Updated_TaskAction -Trigger $Task.Triggers -Principal $Updated_TaskPrincipal -Settings $Task.Settings -Force
        }
        $Task.Dispose()

        # Delete this folder on 01/01/2025
    }
}
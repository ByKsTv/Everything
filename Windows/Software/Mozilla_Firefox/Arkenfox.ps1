$Firefox_Profiles = [IO.Path]::Combine($env:APPDATA, 'Mozilla', 'Firefox', 'Profiles')
if (Test-Path $Firefox_Profiles) {
    $Firefox_Profile = (Get-ChildItem $Firefox_Profiles -Directory -Filter '*.default-release' | Select-Object -First 1).FullName
    if (Test-Path $Firefox_Profile) {
        if (Get-Process -Name firefox -ErrorAction SilentlyContinue) {
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Closing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Mozilla Firefox'"); [Console]::ResetColor(); [Console]::WriteLine()
            Stop-Process -Name firefox -Force
        }
        
        $Firefox_userChromecss_DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/userChrome.css'
        $Firefox_userChromecss_Filename = [IO.Path]::GetFileName(([URI]$Firefox_userChromecss_DDL).AbsolutePath)
        $Firefox_userChromecssSavePath = [IO.Path]::Combine($Firefox_Profile, 'chrome', $Firefox_userChromecss_Filename)
        if (-not (Test-Path $Firefox_userChromecssSavePath)) {
            New-Item $Firefox_userChromecssSavePath -ItemType File -Force
        }
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_userChromecss_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_userChromecss_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_userChromecssSavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
        (New-Object System.Net.WebClient).DownloadFile($Firefox_userChromecss_DDL, $Firefox_userChromecssSavePath)

        $Firefox_ScriptsURLs = @(
            'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/user-overrides.js',
            'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/search.json.mozlz4',
            'https://raw.githubusercontent.com/arkenfox/user.js/master/updater.bat',
            'https://raw.githubusercontent.com/arkenfox/user.js/master/prefsCleaner.bat',
            'https://raw.githubusercontent.com/arkenfox/user.js/master/user.js'
        
        )
        foreach ($Firefox_ScriptURL in $Firefox_ScriptsURLs) {
            $Firefox_ScriptFilename = [IO.Path]::GetFileName(([URI]$Firefox_ScriptURL).AbsolutePath)
            $Firefox_ScriptSavePath = [IO.Path]::Combine($Firefox_Profile, $Firefox_ScriptFilename)
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_ScriptFilename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_ScriptURL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_ScriptSavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object Net.WebClient).DownloadFile($Firefox_ScriptURL, $Firefox_ScriptSavePath)
        }

        $Arkenfox_Update_TaskName = 'Arkenfox Update'
        if (-not (Get-ScheduledTask -TaskName $Arkenfox_Update_TaskName -ErrorAction SilentlyContinue)) {
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Arkenfox_Update_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
            $Arkenfox_Update_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN $Firefox_Profile\updater.bat -unattended -updatebatch ^&exit"
            $Arkenfox_Update_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
            $Arkenfox_Update_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
            $Arkenfox_Update_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
            Register-ScheduledTask -TaskName $Arkenfox_Update_TaskName -Action $Arkenfox_Update_TaskAction -Trigger $Arkenfox_Update_TaskTrigger -Principal $Arkenfox_Update_TaskPrincipal -Settings $Arkenfox_Update_TaskSettings -Force
        }

        $Arkenfox_Clean_TaskName = 'Arkenfox Clean'
        if (-not (Get-ScheduledTask -TaskName $Arkenfox_Clean_TaskName -ErrorAction SilentlyContinue)) {
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Arkenfox_Clean_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
            $Arkenfox_Clean_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN $Firefox_Profile\prefsCleaner.bat -unattended ^&exit"
            $Arkenfox_Clean_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
            $Arkenfox_Clean_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
            $Arkenfox_Clean_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
            Register-ScheduledTask -TaskName $Arkenfox_Clean_TaskName -Action $Arkenfox_Clean_TaskAction -Trigger $Arkenfox_Clean_TaskTrigger -Principal $Arkenfox_Clean_TaskPrincipal -Settings $Arkenfox_Clean_TaskSettings -Force
        }

        $Arkenfox_Overrides_TaskName = 'Arkenfox Overrides'
        if (-not (Get-ScheduledTask -TaskName $Arkenfox_Overrides_TaskName -ErrorAction SilentlyContinue)) {
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Arkenfox_Overrides_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
            $Arkenfox_Overrides_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-WebRequest -Uri https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/user-overrides.js -OutFile $Firefox_Profile\user-overrides.js"
            $Arkenfox_Overrides_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
            $Arkenfox_Overrides_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
            $Arkenfox_Overrides_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
            Register-ScheduledTask -TaskName $Arkenfox_Overrides_TaskName -Action $Arkenfox_Overrides_TaskAction -Trigger $Arkenfox_Overrides_TaskTrigger -Principal $Arkenfox_Overrides_TaskPrincipal -Settings $Arkenfox_Overrides_TaskSettings -Force
        }
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Starting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Arkenfox_Update_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
        Start-ScheduledTask -TaskName $Arkenfox_Update_TaskName

        $Firefox_DirsToDelete = 'datareporting', 'crashes', 'saved-telemetry-pings', 'minidumps'
        foreach ($Firefox_DirToDelete in $Firefox_DirsToDelete) {
            $Firefox_TelemetryDir = [IO.Path]::Combine($Firefox_Profile, $Firefox_DirToDelete)
            if (Test-Path $Firefox_TelemetryDir) {
                [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Deleting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_DirToDelete'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' folder from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_TelemetryDir'"); [Console]::ResetColor(); [Console]::WriteLine()
                Remove-Item $Firefox_TelemetryDir -Force -Recurse
            }
        }
    }
}
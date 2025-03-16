$Arkenfox_TaskName = 'Arkenfox Updater'
if (-not (Get-ScheduledTask -TaskName $Arkenfox_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Arkenfox_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $Arkenfox_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$Arkenfox_TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/Arkenfox.ps1')`""
    $Arkenfox_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $Arkenfox_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $Arkenfox_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $Arkenfox_TaskName -Action $Arkenfox_TaskAction -Trigger $Arkenfox_TaskTrigger -Principal $Arkenfox_TaskPrincipal -Settings $Arkenfox_TaskSettings -Force
}

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
        
        Start-Process -FilePath "$Firefox_Profile\updater.bat" -ArgumentList "-unattended", "-updatebatch" -Wait

        Start-Process -FilePath "$Firefox_Profile\prefsCleaner.bat" -ArgumentList "-unattended" -Wait

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
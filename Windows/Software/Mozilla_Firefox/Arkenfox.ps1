$InstalledSoftware = (Get-Package).Name
if ($InstalledSoftware -match 'Mozilla Firefox') {
    $TaskName = 'Arkenfox Updater'
    if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
        $TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized -Command `"`$Host.UI.RawUI.WindowTitle = '$TaskName'; while (!(Resolve-DnsName google.com -ErrorAction SilentlyContinue)) { Start-Sleep -Seconds 1 }; Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/Arkenfox.ps1')`""
        $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
        $TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
        $TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
        Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Principal $TaskPrincipal -Settings $TaskSettings -Force
    }
}

$Firefox_Profiles = [IO.Path]::Combine($env:APPDATA, 'Mozilla', 'Firefox', 'Profiles')
if (Test-Path $Firefox_Profiles) {
    $Firefox_Profile = (Get-ChildItem $Firefox_Profiles -Directory -Filter '*.default-release' | Select-Object -First 1).FullName
    if (Test-Path $Firefox_Profile) {
        if (Get-Process -Name firefox -ErrorAction SilentlyContinue) {
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Closing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Mozilla Firefox'"); [Console]::ResetColor(); [Console]::WriteLine()
            Stop-Process -Name firefox -Force
        }

        # Temporary disable firefox from running by renaming
        $FireFox_EXE = "$env:ProgramFiles\Mozilla Firefox\firefox.exe"
        Rename-Item -Path $FireFox_EXE -NewName 'firefox.bak'

        $DDLs = @(
            'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/userChrome.css',
            'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/userContent.css'
        )
        foreach ($DDL in $DDLs) {
            $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
            $SavePath = [IO.Path]::Combine($Firefox_Profile, 'chrome', $FileName)
            if (-not (Test-Path $SavePath)) {
                New-Item $SavePath -ItemType File -Force
            }
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)
        }

        $DDLs = @(
            'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/user-overrides.js',
            'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/search.json.mozlz4',
            'https://raw.githubusercontent.com/arkenfox/user.js/master/updater.bat',
            'https://raw.githubusercontent.com/arkenfox/user.js/master/prefsCleaner.bat',
            'https://raw.githubusercontent.com/arkenfox/user.js/master/user.js'

        )
        foreach ($DDL in $DDLs) {
            $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
            $SavePath = [IO.Path]::Combine($Firefox_Profile, $FileName)
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object Net.WebClient).DownloadFile($DDL, $SavePath)
        }

        $Files = @(
            [IO.Path]::Combine($Firefox_Profile, 'updater.bat')
            [IO.Path]::Combine($Firefox_Profile, 'prefsCleaner.bat')
        )

        foreach ($File in $Files) {
            if (Test-Path -LiteralPath $File) {
                $Lines = Get-Content -LiteralPath $File
                $Lines = $Lines | Where-Object { $_ -notmatch '^\s*@?\s*TIMEOUT(\.EXE)?(\s|$)' }
                Set-Content -LiteralPath $File -Value $Lines
            }
        }

        Start-Process -FilePath "$Firefox_Profile\updater.bat" -ArgumentList '-unattended', '-updatebatch' -Wait

        Start-Process -FilePath "$Firefox_Profile\prefsCleaner.bat" -ArgumentList '-unattended' -Wait

        $DirsToDelete = 'datareporting', 'crashes', 'saved-telemetry-pings', 'minidumps'
        foreach ($Dir in $DirsToDelete) {
            $TelemetryDir = [IO.Path]::Combine($Firefox_Profile, $Dir)
            if (Test-Path $TelemetryDir) {
                [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Deleting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Dir'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' folder from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$TelemetryDir'"); [Console]::ResetColor(); [Console]::WriteLine()
                Remove-Item $TelemetryDir -Force -Recurse
            }
        }

        $CrashHelper = "$env:ProgramFiles\Mozilla Firefox\crashhelper.exe"
        if (Test-Path $CrashHelper) {
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Deleting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$CrashHelper'"); [Console]::ResetColor(); [Console]::WriteLine()
            Remove-Item $CrashHelper -Force -Recurse
        }

        $CrashReporter = "$env:ProgramFiles\Mozilla Firefox\crashreporter.exe"
        if (Test-Path $CrashReporter) {
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Deleting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$CrashReporter'"); [Console]::ResetColor(); [Console]::WriteLine()
            Remove-Item $CrashReporter -Force -Recurse
        }

        # Enable firefox from running by renaming
        $FireFox_BAK = "$env:ProgramFiles\Mozilla Firefox\firefox.bak"
        Rename-Item -Path $FireFox_BAK -NewName 'firefox.exe'
    }

    Get-ChildItem -LiteralPath $Firefox_Profile -File | Where-Object {
        $_.Name -match '^(prefs|user)-backup-\d{8}_\d{6}\.js$'
    } | ForEach-Object {
        Remove-Item -LiteralPath $_.FullName -Force
    }
}

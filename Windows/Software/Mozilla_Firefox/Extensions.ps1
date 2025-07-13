$Firefox_Profiles = [IO.Path]::Combine($env:APPDATA, 'Mozilla', 'Firefox', 'Profiles')
if (Test-Path $Firefox_Profiles) {
    $Firefox_Profile = Get-ChildItem $Firefox_Profiles -Directory -Filter '*.default-release' | Select-Object -First 1 | Select-Object -ExpandProperty 'FullName'
    if (Test-Path $Firefox_Profile) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Closing browser'); [Console]::ResetColor(); [Console]::WriteLine()
        Stop-Process -Name firefox -Force -ErrorAction SilentlyContinue

        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Adding uBlock Origin'); [Console]::ResetColor(); [Console]::WriteLine()
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Adding Violentmonkey'); [Console]::ResetColor(); [Console]::WriteLine()
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Adding ClearURLs'); [Console]::ResetColor(); [Console]::WriteLine()
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Adding Buster: Captcha Solver for Humans'); [Console]::ResetColor(); [Console]::WriteLine()
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Adding The Camelizer - Price Tracker'); [Console]::ResetColor(); [Console]::WriteLine()

        # https://github.com/letsdoautomation/powershell/tree/main/Firefox%20deploy%20Extension
        $settings =
        [PSCustomObject]@{
            Path  = 'SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install'
            Value = 'https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi'
            Name  = ++$count
        },
        [PSCustomObject]@{
            Path  = 'SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install'
            Value = 'https://addons.mozilla.org/firefox/downloads/latest/violentmonkey/latest.xpi'
            Name  = ++$count
        },
        [PSCustomObject]@{
            Path  = 'SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install'
            Value = 'https://addons.mozilla.org/firefox/downloads/latest/buster-captcha-solver/latest.xpi'
            Name  = ++$count
        },
        [PSCustomObject]@{
            Path  = 'SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install'
            Value = 'https://addons.mozilla.org/firefox/downloads/latest/the-camelizer-price-history-ch/latest.xpi'
            Name  = ++$count
        } | Group-Object Path
        foreach ($setting in $settings) {
            $registry = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($setting.Name, $true)
            if ($null -eq $registry) {
                $registry = [Microsoft.Win32.Registry]::LocalMachine.CreateSubKey($setting.Name, $true)
            }
            $setting.Group | ForEach-Object {
                $registry.SetValue($_.name, $_.value)
            }
            $registry.Dispose()
        }

        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: uBlock Origin: Using custom settings'); [Console]::ResetColor(); [Console]::WriteLine()
        # https://github.com/gorhill/uBlock/issues/2986#issuecomment-333198882
        New-Item -Path 'HKLM:\SOFTWARE\Mozilla\ManagedStorage\uBlock0@raymondhill.net' -Force
        New-ItemProperty -Path 'HKLM:\SOFTWARE\Mozilla\ManagedStorage\uBlock0@raymondhill.net' -Name '(default)' -Value "$env:TEMP\uBlock_Origin_Backup_Restore.json" -PropertyType String -Force
        $uBlockDownloadLocation = "$env:TEMP\uBlock_Origin_Backup.json"
        (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/uBlock_Origin/Backup.json', "$uBlockDownloadLocation")
        $uBlockTemplate = '{"name": "uBlock0@raymondhill.net","description": "ignored","type": "storage","data": {"adminSettings": '
        $uBlockLatestContent = Get-Content $uBlockDownloadLocation
        $uBlockFinishTemplate = $uBlockTemplate += $uBlockLatestContent += '}}'
        New-Item "$env:TEMP\uBlock_Origin_Backup_Restore.json" -Value $uBlockFinishTemplate -Force
        Start-Sleep -Milliseconds 1000
    
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Starting browser'); [Console]::ResetColor(); [Console]::WriteLine()
        [Diagnostics.Process]::Start('firefox.exe')

        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Waiting for browser'); [Console]::ResetColor(); [Console]::WriteLine()
        while ($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' } -ErrorAction SilentlyContinue)) {
            Start-Sleep -Milliseconds 1000
        }
        Start-Sleep -Milliseconds 20000
        
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Adding option to set foreground'); [Console]::ResetColor(); [Console]::WriteLine()
        if (-not ([Management.Automation.PSTypeName]'SFW').Type) {
            Add-Type @'
        using System;
        using System.Runtime.InteropServices;
        public class SFW {
            [DllImport("user32.dll")]
            [return: MarshalAs(UnmanagedType.Bool)]
            public static extern bool SetForegroundWindow(IntPtr hWnd);
        }
'@
        }
    }
    
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Setting foreground'); [Console]::ResetColor(); [Console]::WriteLine()
    [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Opening AdsBypasser'); [Console]::ResetColor(); [Console]::WriteLine()
    [Diagnostics.Process]::Start('firefox.exe', 'https://adsbypasser.github.io/releases/adsbypasser.full.es7.user.js')
    Start-Sleep -Milliseconds 5000

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Setting foreground'); [Console]::ResetColor(); [Console]::WriteLine()
    [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)
    Start-Sleep -Milliseconds 2000
    
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Installing AdsBypasser'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object -ComObject wscript.shell).SendKeys('^{ENTER}')

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Cleaning up'); [Console]::ResetColor(); [Console]::WriteLine()
    if (Test-Path -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install') {
        Remove-Item 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install' -Force
    }
    if (Test-Path -Path 'HKLM:\SOFTWARE\Mozilla\ManagedStorage\uBlock0@raymondhill.net') {
        Remove-Item 'HKLM:\SOFTWARE\Mozilla\ManagedStorage\uBlock0@raymondhill.net' -Force
    }
}
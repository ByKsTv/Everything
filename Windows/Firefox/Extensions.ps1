if ((Test-Path -Path $env:APPDATA\Mozilla\Firefox\Profiles) -eq $true) {
    $FirefoxProfiles = Get-ChildItem -Directory -Path "$env:APPDATA\Mozilla\Firefox\Profiles" -Filter '*.default-release'
    $CurrentFirefoxProfile = "$env:APPDATA\Mozilla\Firefox\Profiles\$FirefoxProfiles"
    if ((Test-Path -Path $CurrentFirefoxProfile) -eq $true) {
        Write-Host 'Mozilla Firefox Extensions: Closing browser' -ForegroundColor green -BackgroundColor black
        Stop-Process -Name firefox -Force -ErrorAction SilentlyContinue

        Write-Host "Mozilla Firefox Extensions: Adding 'uBlock Origin'" -ForegroundColor green -BackgroundColor black
        Write-Host "Mozilla Firefox Extensions: Adding 'Tampermonkey'" -ForegroundColor green -BackgroundColor black
        Write-Host "Mozilla Firefox Extensions: Adding 'ClearURLs'" -ForegroundColor green -BackgroundColor black
        Write-Host "Mozilla Firefox Extensions: Adding 'I'm not robot captcha clicker'" -ForegroundColor green -BackgroundColor black
        Write-Host "Mozilla Firefox Extensions: Adding 'Buster: Captcha Solver for Humans'" -ForegroundColor green -BackgroundColor black
        Write-Host "Mozilla Firefox Extensions: Adding 'The Camelizer - Price Tracker'" -ForegroundColor green -BackgroundColor black

        # https://github.com/letsdoautomation/powershell/tree/main/Firefox%20deploy%20Extension
        $settings =
        [PSCustomObject]@{
            Path  = 'SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install'
            Value = 'https://addons.mozilla.org/firefox/downloads/file/4261710/ublock_origin-1.57.2.xpi'
            Name  = ++$count
        },
        [PSCustomObject]@{
            Path  = 'SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install'
            Value = 'https://addons.mozilla.org/firefox/downloads/file/4282688/tampermonkey-5.1.1.xpi'
            Name  = ++$count
        },
        [PSCustomObject]@{
            Path  = 'SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install'
            Value = 'https://addons.mozilla.org/firefox/downloads/file/4064884/clearurls-1.26.1.xpi'
            Name  = ++$count
        },
        [PSCustomObject]@{
            Path  = 'SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install'
            Value = 'https://addons.mozilla.org/firefox/downloads/file/3897119/i_m_not_robot_captcha_clicker-1.3.1.xpi'
            Name  = ++$count
        },
        [PSCustomObject]@{
            Path  = 'SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install'
            Value = 'https://addons.mozilla.org/firefox/downloads/file/4044701/buster_captcha_solver-2.0.1.xpi'
            Name  = ++$count
        },
        [PSCustomObject]@{
            Path  = 'SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install'
            Value = 'https://addons.mozilla.org/firefox/downloads/file/4075638/the_camelizer_price_history_ch-3.0.15.xpi'
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

        # https://github.com/gorhill/uBlock/issues/2986#issuecomment-333198882

        # if ((Test-Path -Path "$env:ProgramFiles\Mozilla Firefox") -ne $true) {
        #     New-Item -Path "$env:ProgramFiles\Mozilla Firefox" -Force -ItemType Directory
        # }

        New-Item -Path 'HKLM:\SOFTWARE\Mozilla\ManagedStorage\uBlock0@raymondhill.net' -Force
        New-ItemProperty -Path 'HKLM:\SOFTWARE\Mozilla\ManagedStorage\uBlock0@raymondhill.net' -Name '(default)' -Value "$env:TEMP\uBlock_Origin_Backup_Restore.json" -PropertyType String -Force

        $uBlockDownloadLocation = "$env:TEMP\uBlock_Origin_Backup.json"
        Invoke-WebRequest -Uri https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/uBlock_Origin/Backup.json -OutFile $uBlockDownloadLocation
        $uBlockTemplate = '{"name": "uBlock0@raymondhill.net","description": "ignored","type": "storage","data": {"adminSettings": '
        $uBlockLatestContent = Get-Content $uBlockDownloadLocation
        $uBlockFinishTemplate = $uBlockTemplate += $uBlockLatestContent += '}}'
        New-Item "$env:TEMP\uBlock_Origin_Backup_Restore.json" -Value $uBlockFinishTemplate -Force
        Start-Sleep -Milliseconds 1000
        
        # experimental
        # New-Item -Path 'HKLM:\SOFTWARE\Mozilla\ManagedStorage\firefox@tampermonkey.net' -Force
        # New-ItemProperty -Path 'HKLM:\SOFTWARE\Mozilla\ManagedStorage\firefox@tampermonkey.net' -Name '(default)' -Value "$env:ProgramFiles\Mozilla Firefox\tampermonkey.json" -PropertyType String -Force
        # $Tampermonkey='{"name": "firefox@tampermonkey.net","description": "ignored","type": "storage","data": {"adminSettings": {"created_by":"Tampermonkey","version":"1","scripts":[{"name":"AdsBypasser","options":{"check_for_updates":true,"user_modified":null,"comment":null,"compatopts_for_requires":true,"compat_wrappedjsobject":false,"compat_metadata":false,"compat_foreach":false,"compat_powerful_this":null,"sandbox":null,"noframes":null,"unwrap":null,"run_at":null,"tab_types":null,"override":{"use_includes":[],"orig_includes":["http://*","https://*"],"merge_includes":true,"use_matches":[],"orig_matches":[],"merge_matches":true,"use_excludes":[],"orig_excludes":[],"merge_excludes":true,"use_connects":[],"orig_connects":["*"],"merge_connects":true,"use_blockers":[],"orig_run_at":"document-start","orig_noframes":true}},"storage":{"ts":1716736230041,"data":{}},"enabled":true,"position":1,"file_url":"https://adsbypasser.github.io/releases/adsbypasser.full.es7.user.js"}}'
        # New-Item "$env:ProgramFiles\Mozilla Firefox\tampermonkey.json" -Value $Tampermonkey -Force

        Write-Host 'Mozilla Firefox Extensions: Starting browser' -ForegroundColor green -BackgroundColor black
        [System.Diagnostics.Process]::Start('firefox.exe')

        Write-Host 'Mozilla Firefox Extensions: Waiting for browser' -ForegroundColor green -BackgroundColor black
        while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' } -ErrorAction SilentlyContinue))) {
        }
        Start-Sleep -Milliseconds 25000
        
        Write-Host 'Mozilla Firefox Extensions: Adding option to set foreground' -ForegroundColor green -BackgroundColor black
        if (-not ([System.Management.Automation.PSTypeName]'SFW').Type) {
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
    
    Write-Host 'Mozilla Firefox Extensions: Setting foreground' -ForegroundColor green -BackgroundColor black
    [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)

    Write-Host "Mozilla Firefox Extensions: Adding 'AdsBypasser' to 'Tampermonkey'" -ForegroundColor green -BackgroundColor black
    [System.Diagnostics.Process]::Start('firefox.exe', 'https://adsbypasser.github.io/releases/adsbypasser.full.es7.user.js')
    Start-Sleep -Milliseconds 3000

    Write-Host 'Mozilla Firefox Extensions: Setting foreground' -ForegroundColor green -BackgroundColor black
    [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)
    Start-Sleep -Milliseconds 1000
    
    Write-Host "Mozilla Firefox Extensions: Installing 'AdsBypasser' to 'Tampermonkey'" -ForegroundColor green -BackgroundColor black
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')

    # Start-Sleep -Milliseconds 1000
    # Stop-Process -Name firefox -Force -ErrorAction SilentlyContinue
    # Write-Host 'Mozilla Firefox Extensions: Starting browser' -ForegroundColor green -BackgroundColor black
    # [System.Diagnostics.Process]::Start('firefox.exe')
    # Start-Sleep -Milliseconds 10000
    
    # Write-Host "Mozilla Firefox Extensions: Downloading 'uBlock Origin' custom settings" -ForegroundColor green -BackgroundColor black
    # (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/uBlock_Origin/Backup.json', "$env:TEMP\uBlock_Origin_Backup.json")
    
    # Write-Host "Mozilla Firefox Extensions: Starting 'uBlock Origin' settings" -ForegroundColor green -BackgroundColor black
    # $uBlockPattern = 'uBlock.+?([a-f0-9]{8}-([a-f0-9]{4}-){3}[a-f0-9]{12})\\'
    # $uBlockUUID = (Select-String -Pattern $uBlockPattern -Path $CurrentFirefoxProfile\prefs.js).Matches.Groups[1].Value
    # [System.Diagnostics.Process]::Start('firefox.exe', "moz-extension://$uBlockUUID/dashboard.html#settings.html")
    # Start-Sleep -Milliseconds 2000

    # Write-Host 'Mozilla Firefox Extensions: Setting foreground' -ForegroundColor green -BackgroundColor black
    # [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)
    # Start-Sleep -Milliseconds 1000

    # Write-Host "Mozilla Firefox Extensions: Starting 'Restore from file' on 'uBlock Origin' settings" -ForegroundColor green -BackgroundColor black
    # [System.Windows.Forms.SendKeys]::SendWait('+{TAB 2}')
    # [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    # Start-Sleep -Milliseconds 1000

    # Write-Host "Mozilla Firefox Extensions: Selecting folder to restore backup from on 'uBlock Origin' settings" -ForegroundColor green -BackgroundColor black
    # [System.Windows.Forms.SendKeys]::SendWait('{F4}')
    # Start-Sleep -Milliseconds 100
    # [System.Windows.Forms.SendKeys]::SendWait('^a')
    # Start-Sleep -Milliseconds 100
    # [System.Windows.Forms.SendKeys]::SendWait($env:TEMP)
    # [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    # Start-Sleep -Milliseconds 1000
    # [System.Windows.Forms.SendKeys]::SendWait('%n')
    # Start-Sleep -Milliseconds 1000

    # Write-Host "Mozilla Firefox Extensions: Selecting file to restore backup from on 'uBlock Origin' settings" -ForegroundColor green -BackgroundColor black
    # [System.Windows.Forms.SendKeys]::SendWait('uBlock_Origin_Backup.json')
    # [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    # Start-Sleep -Milliseconds 1000
    # [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')

    Write-Host 'Mozilla Firefox Extensions: Cleaning up' -ForegroundColor green -BackgroundColor black
    if ((Test-Path -Path HKLM:\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install) -eq $true) {
        Remove-Item HKLM:\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install -Force
    }
    if ((Test-Path -Path 'HKLM:\SOFTWARE\Mozilla\ManagedStorage\uBlock0@raymondhill.net') -eq $true) {
        Remove-Item 'HKLM:\SOFTWARE\Mozilla\ManagedStorage\uBlock0@raymondhill.net' -Force
    }
}
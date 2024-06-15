if ((Test-Path -Path $env:APPDATA\Mozilla\Firefox\Profiles) -eq $true) {
    $FirefoxProfiles = Get-ChildItem -Directory -Path "$env:APPDATA\Mozilla\Firefox\Profiles" -Filter '*.default-release'
    $CurrentFirefoxProfile = "$env:APPDATA\Mozilla\Firefox\Profiles\$FirefoxProfiles"
    if ((Test-Path -Path $CurrentFirefoxProfile) -eq $true) {
        Write-Host 'Mozilla Firefox Extensions: Closing browser' -ForegroundColor green -BackgroundColor black
        Stop-Process -Name firefox -Force -ErrorAction SilentlyContinue

        Write-Host 'Mozilla Firefox Extensions: Adding uBlock Origin' -ForegroundColor green -BackgroundColor black
        Write-Host 'Mozilla Firefox Extensions: Adding Violentmonkey' -ForegroundColor green -BackgroundColor black
        Write-Host 'Mozilla Firefox Extensions: Adding ClearURLs' -ForegroundColor green -BackgroundColor black
        Write-Host "Mozilla Firefox Extensions: Adding I'm not robot captcha clicker" -ForegroundColor green -BackgroundColor black
        Write-Host 'Mozilla Firefox Extensions: Adding Buster: Captcha Solver for Humans' -ForegroundColor green -BackgroundColor black
        Write-Host 'Mozilla Firefox Extensions: Adding The Camelizer - Price Tracker' -ForegroundColor green -BackgroundColor black

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
            Value = 'https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi'
            Name  = ++$count
        },
        [PSCustomObject]@{
            Path  = 'SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install'
            Value = 'https://addons.mozilla.org/firefox/downloads/latest/i-m-not-robot-captcha-clicker/latest.xpi'
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

        Write-Host 'Mozilla Firefox Extensions: uBlock Origin: Using custom settings' -ForegroundColor green -BackgroundColor black
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
    
        Write-Host 'Mozilla Firefox Extensions: Starting browser' -ForegroundColor green -BackgroundColor black
        [System.Diagnostics.Process]::Start('firefox.exe')

        Write-Host 'Mozilla Firefox Extensions: Waiting for browser' -ForegroundColor green -BackgroundColor black
        while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' } -ErrorAction SilentlyContinue))) {
            Start-Sleep -Milliseconds 1000
        }
        Start-Sleep -Milliseconds 20000
        
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

    Write-Host 'Mozilla Firefox Extensions: Adding AdsBypasser to Violentmonkey' -ForegroundColor green -BackgroundColor black
    [System.Diagnostics.Process]::Start('firefox.exe', 'https://adsbypasser.github.io/releases/adsbypasser.full.es7.user.js')
    Start-Sleep -Milliseconds 5000

    Write-Host 'Mozilla Firefox Extensions: Setting foreground' -ForegroundColor green -BackgroundColor black
    [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)
    Start-Sleep -Milliseconds 1000
    
    Write-Host 'Mozilla Firefox Extensions: Installing AdsBypasser to Violentmonkey' -ForegroundColor green -BackgroundColor black
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.SendKeys]::SendWait('^{ENTER}')

    Write-Host 'Mozilla Firefox Extensions: Cleaning up' -ForegroundColor green -BackgroundColor black
    if ((Test-Path -Path HKLM:\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install) -eq $true) {
        Remove-Item HKLM:\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install -Force
    }
    if ((Test-Path -Path 'HKLM:\SOFTWARE\Mozilla\ManagedStorage\uBlock0@raymondhill.net') -eq $true) {
        Remove-Item 'HKLM:\SOFTWARE\Mozilla\ManagedStorage\uBlock0@raymondhill.net' -Force
    }
}
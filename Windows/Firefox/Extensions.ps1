if ((Test-Path -Path $env:APPDATA\Mozilla\Firefox\Profiles) -eq $true) {
    $FirefoxProfiles = Get-ChildItem -Directory -Path "$env:APPDATA\Mozilla\Firefox\Profiles" -Filter '*.default-release'
    $CurrentFirefoxProfile = "$env:APPDATA\Mozilla\Firefox\Profiles\$FirefoxProfiles"
    if ((Test-Path -Path $CurrentFirefoxProfile) -eq $true) {
        Write-Host 'Firefox Extensions Setup (https://github.com/letsdoautomation/powershell/tree/main/Firefox%20deploy%20Extension)' -ForegroundColor green -BackgroundColor black
        Stop-Process -Name firefox -Force
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
        [System.Diagnostics.Process]::Start('firefox.exe')
        Write-Host 'Firefox > Waiting for browser' -ForegroundColor green -BackgroundColor black
        while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' } -ErrorAction SilentlyContinue))) {
        }
        Start-Sleep -Milliseconds 10000
        Write-Host 'Firefox > Set Foreground' -ForegroundColor green -BackgroundColor black
        [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)
        Write-Host 'AdsBypasser' -ForegroundColor green -BackgroundColor black
        [System.Diagnostics.Process]::Start('firefox.exe', 'https://adsbypasser.github.io/releases/adsbypasser.full.es7.user.js')
        Start-Sleep -Milliseconds 3000
        [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)
        Start-Sleep -Milliseconds 1000
        Write-Host 'Tampermonkey > AdsBypasser > Install' -ForegroundColor green -BackgroundColor black
        [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
        (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/uBlock_Origin/Backup.txt', "$env:TEMP\uBlock_Origin_Backup.txt")
        $uBlockPattern = 'uBlock.+?([a-f0-9]{8}-([a-f0-9]{4}-){3}[a-f0-9]{12})\\'
        $uBlockUUID = (Select-String -Pattern $uBlockPattern -Path $CurrentFirefoxProfile\prefs.js).Matches.Groups[1].Value
        [System.Diagnostics.Process]::Start('firefox.exe', "moz-extension://$uBlockUUID/dashboard.html#settings.html")
        Start-Sleep -Milliseconds 2000
        [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)
        Start-Sleep -Milliseconds 1000
        Write-Host 'uBlock Origin > Restore from file' -ForegroundColor green -BackgroundColor black
        [System.Windows.Forms.SendKeys]::SendWait('+{TAB 2}')
        [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
        Start-Sleep -Milliseconds 1000
        Write-Host 'uBlock Origin > Restore from file > Select folder' -ForegroundColor green -BackgroundColor black
        [System.Windows.Forms.SendKeys]::SendWait('{F4}')
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.SendKeys]::SendWait('^a')
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.SendKeys]::SendWait($env:TEMP)
        [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
        Start-Sleep -Milliseconds 1000
        [System.Windows.Forms.SendKeys]::SendWait('%n')
        Start-Sleep -Milliseconds 1000
        Write-Host 'uBlock Origin > Restore from file > Select file' -ForegroundColor green -BackgroundColor black
        [System.Windows.Forms.SendKeys]::SendWait('uBlock_Origin_Backup.txt')
        [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
        Start-Sleep -Milliseconds 1000
        [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
        Start-Sleep -Milliseconds 1000
        Remove-Item HKLM:\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install -Force
    }
}
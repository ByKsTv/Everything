if ((Test-Path -Path $env:APPDATA\Mozilla\Firefox\Profiles) -eq $true) {
    $FirefoxProfiles = Get-ChildItem -Directory -Path "$env:APPDATA\Mozilla\Firefox\Profiles" -Filter '*.default-release'
    $CurrentFirefoxProfile = "$env:APPDATA\Mozilla\Firefox\Profiles\$FirefoxProfiles"
    if ((Test-Path -Path $CurrentFirefoxProfile) -eq $true) {
        Write-Host 'Mozila Firefox Extensions: Closing browser' -ForegroundColor green -BackgroundColor black
        Stop-Process -Name firefox -Force

        Write-Host "Mozila Firefox Extensions: Adding 'uBlock Origin'" -ForegroundColor green -BackgroundColor black
        Write-Host "Mozila Firefox Extensions: Adding 'Tampermonkey'" -ForegroundColor green -BackgroundColor black
        Write-Host "Mozila Firefox Extensions: Adding 'ClearURLs'" -ForegroundColor green -BackgroundColor black
        Write-Host "Mozila Firefox Extensions: Adding 'I'm not robot captcha clicker'" -ForegroundColor green -BackgroundColor black
        Write-Host "Mozila Firefox Extensions: Adding 'Buster: Captcha Solver for Humans'" -ForegroundColor green -BackgroundColor black
        Write-Host "Mozila Firefox Extensions: Adding 'The Camelizer - Price Tracker'" -ForegroundColor green -BackgroundColor black

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

        Write-Host 'Mozila Firefox Extensions: Starting browser' -ForegroundColor green -BackgroundColor black
        [System.Diagnostics.Process]::Start('firefox.exe')

        Write-Host 'Mozila Firefox Extensions: Waiting for browser' -ForegroundColor green -BackgroundColor black
        while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' } -ErrorAction SilentlyContinue))) {
        }
        Start-Sleep -Milliseconds 10000
    }

    Write-Host 'Mozila Firefox Extensions: Setting foreground' -ForegroundColor green -BackgroundColor black
    (New-Object -ComObject WScript.Shell).AppActivate((Get-Process firefox).MainWindowTitle)

    Write-Host "Mozila Firefox Extensions: Adding 'AdsBypasser' to 'Tampermonkey'" -ForegroundColor green -BackgroundColor black
    [System.Diagnostics.Process]::Start('firefox.exe', 'https://adsbypasser.github.io/releases/adsbypasser.full.es7.user.js')
    Start-Sleep -Milliseconds 3000

    Write-Host 'Mozila Firefox Extensions: Setting foreground' -ForegroundColor green -BackgroundColor black
    (New-Object -ComObject WScript.Shell).AppActivate((Get-Process firefox).MainWindowTitle)
    Start-Sleep -Milliseconds 1000
    
    Write-Host "Mozila Firefox Extensions: Installing 'AdsBypasser' to 'Tampermonkey'" -ForegroundColor green -BackgroundColor black
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    
    Write-Host "Mozila Firefox Extensions: Downloading 'uBlock Origin' custom settings" -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/uBlock_Origin/Backup.txt', "$env:TEMP\uBlock_Origin_Backup.txt")
    
    Write-Host "Mozila Firefox Extensions: Starting 'uBlock Origin' settings" -ForegroundColor green -BackgroundColor black
    $uBlockPattern = 'uBlock.+?([a-f0-9]{8}-([a-f0-9]{4}-){3}[a-f0-9]{12})\\'
    $uBlockUUID = (Select-String -Pattern $uBlockPattern -Path $CurrentFirefoxProfile\prefs.js).Matches.Groups[1].Value
    [System.Diagnostics.Process]::Start('firefox.exe', "moz-extension://$uBlockUUID/dashboard.html#settings.html")
    Start-Sleep -Milliseconds 2000

    Write-Host 'Mozila Firefox Extensions: Setting foreground' -ForegroundColor green -BackgroundColor black
    (New-Object -ComObject WScript.Shell).AppActivate((Get-Process firefox).MainWindowTitle)
    Start-Sleep -Milliseconds 1000

    Write-Host "Mozila Firefox Extensions: Starting 'Restore from file' on 'uBlock Origin' settings" -ForegroundColor green -BackgroundColor black
    [System.Windows.Forms.SendKeys]::SendWait('+{TAB 2}')
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    Start-Sleep -Milliseconds 1000

    Write-Host "Mozila Firefox Extensions: Selecting folder to restore backup from on 'uBlock Origin' settings" -ForegroundColor green -BackgroundColor black
    [System.Windows.Forms.SendKeys]::SendWait('{F4}')
    Start-Sleep -Milliseconds 100
    [System.Windows.Forms.SendKeys]::SendWait('^a')
    Start-Sleep -Milliseconds 100
    [System.Windows.Forms.SendKeys]::SendWait($env:TEMP)
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    Start-Sleep -Milliseconds 1000
    [System.Windows.Forms.SendKeys]::SendWait('%n')
    Start-Sleep -Milliseconds 1000

    Write-Host "Mozila Firefox Extensions: Selecting file to restore backup from on 'uBlock Origin' settings" -ForegroundColor green -BackgroundColor black
    [System.Windows.Forms.SendKeys]::SendWait('uBlock_Origin_Backup.txt')
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    Start-Sleep -Milliseconds 1000
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')

    Write-Host 'Mozila Firefox Extensions: Cleaning up' -ForegroundColor green -BackgroundColor black
    Remove-Item HKLM:\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install -Force
}
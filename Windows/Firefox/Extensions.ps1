if ((Test-Path -LiteralPath $env:APPDATA\Mozilla\Firefox\Profiles) -eq $true) {
    $FirefoxProfiles = Get-ChildItem -Directory -Path "$env:APPDATA\Mozilla\Firefox\Profiles" -Filter '*.default-release'
    $CurrentFirefoxProfile = "$env:APPDATA\Mozilla\Firefox\Profiles\$FirefoxProfiles"
    if ((Test-Path -LiteralPath $CurrentFirefoxProfile) -eq $true) {
        Write-Host 'Firefox Extensions Setup' -ForegroundColor green -BackgroundColor black
        $OpenWithFirefox = New-Object System.Diagnostics.Process
        $OpenWithFirefox.StartInfo.Filename = 'firefox.exe'
        (New-Object System.Net.WebClient).DownloadFile('https://addons.mozilla.org/firefox/downloads/file/4261710/ublock_origin-1.57.2.xpi', "$env:TEMP\ublock_origin.xpi")
        Write-Host 'uBlock Origin' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/uBlock_Origin/Backup.txt', "$env:TEMP\uBlock_Origin_Backup.txt")
        $OpenWithFirefox.StartInfo.Arguments = "$env:TEMP\ublock_origin.xpi"
        $OpenWithFirefox.start()
        Start-Sleep -Milliseconds 6000
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 1000
        Write-Host 'uBlock Origin > Add' -ForegroundColor green -BackgroundColor black
        [System.Windows.Forms.SendKeys]::SendWait('%a')
        Start-Sleep -Milliseconds 500
        Write-Host 'uBlock Origin > Okay' -ForegroundColor green -BackgroundColor black
        [System.Windows.Forms.SendKeys]::SendWait('%o')
        Start-Sleep -Milliseconds 500
        $uBlockPattern = 'uBlock.+?([a-f0-9]{8}-([a-f0-9]{4}-){3}[a-f0-9]{12})\\'
        $uBlockUUID = (Select-String -Pattern $uBlockPattern -Path $CurrentFirefoxProfile\prefs.js).Matches.Groups[1].Value
        $OpenWithFirefox.StartInfo.Arguments = "moz-extension://$uBlockUUID/dashboard.html#settings.html"
        $OpenWithFirefox.start()
        Start-Sleep -Milliseconds 3000
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
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
        Write-Host 'ClearURLs' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://addons.mozilla.org/firefox/downloads/file/4064884/clearurls-1.26.1.xpi', "$env:TEMP\clearurls.xpi")
        $OpenWithFirefox.StartInfo.Arguments = "$env:TEMP\clearurls.xpi"
        $OpenWithFirefox.start()
        Start-Sleep -Milliseconds 3000
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 1000
        Write-Host 'ClearURLs > Add' -ForegroundColor green -BackgroundColor black
        [System.Windows.Forms.SendKeys]::SendWait('%a')
        Start-Sleep -Milliseconds 500
        Write-Host 'ClearURLs > Okay' -ForegroundColor green -BackgroundColor black
        [System.Windows.Forms.SendKeys]::SendWait('%o')
        Start-Sleep -Milliseconds 500
        Write-Host 'Im not robot captcha clicker' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://addons.mozilla.org/firefox/downloads/file/3897119/i_m_not_robot_captcha_clicker-1.3.1.xpi', "$env:TEMP\i_m_not_robot_captcha_clicker.xpi")
        $OpenWithFirefox.StartInfo.Arguments = "$env:TEMP\i_m_not_robot_captcha_clicker.xpi"
        $OpenWithFirefox.start()
        Start-Sleep -Milliseconds 3000
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 1000
        Write-Host 'Im not robot captcha clicker > Add' -ForegroundColor green -BackgroundColor black
        [System.Windows.Forms.SendKeys]::SendWait('%a')
        Start-Sleep -Milliseconds 500
        Write-Host 'Im not robot captcha clicker > Okay' -ForegroundColor green -BackgroundColor black
        [System.Windows.Forms.SendKeys]::SendWait('%o')
        Start-Sleep -Milliseconds 500
        Write-Host 'Buster' -ForegroundColor green -BackgroundColor black
        $OpenWithFirefox.StartInfo.Arguments = "$env:TEMP\buster_captcha_solver.xpi"
        (New-Object System.Net.WebClient).DownloadFile('https://addons.mozilla.org/firefox/downloads/file/4044701/buster_captcha_solver-2.0.1.xpi', "$env:TEMP\buster_captcha_solver.xpi")
        $OpenWithFirefox.start()
        Start-Sleep -Milliseconds 3000
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 1000
        Write-Host 'Buster > Add' -ForegroundColor green -BackgroundColor black
        [System.Windows.Forms.SendKeys]::SendWait('%a')
        Start-Sleep -Milliseconds 500
        Write-Host 'Buster > Okay' -ForegroundColor green -BackgroundColor black
        [System.Windows.Forms.SendKeys]::SendWait('%o')
        Start-Sleep -Milliseconds 500
        Write-Host 'Camelizer' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://addons.mozilla.org/firefox/downloads/file/4075638/the_camelizer_price_history_ch-3.0.15.xpi', "$env:TEMP\the_camelizer_price_history_ch.xpi")
        $OpenWithFirefox.StartInfo.Arguments = "$env:TEMP\the_camelizer_price_history_ch.xpi"
        $OpenWithFirefox.start()
        Start-Sleep -Milliseconds 3000
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 1000
        Write-Host 'Camelizer > Add' -ForegroundColor green -BackgroundColor black
        [System.Windows.Forms.SendKeys]::SendWait('%a')
        Start-Sleep -Milliseconds 500
        Write-Host 'Camelizer > Okay' -ForegroundColor green -BackgroundColor black
        [System.Windows.Forms.SendKeys]::SendWait('%o')
        Start-Sleep -Milliseconds 500
        Write-Host 'Tampermonkey' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://addons.mozilla.org/firefox/downloads/file/4250678/tampermonkey-5.1.0.xpi', "$env:TEMP\tampermonkey.xpi")
        $OpenWithFirefox.StartInfo.Arguments = "$env:TEMP\tampermonkey.xpi"
        $OpenWithFirefox.start()
        Start-Sleep -Milliseconds 3000
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 1000
        Write-Host 'Tampermonkey > Add' -ForegroundColor green -BackgroundColor black
        [System.Windows.Forms.SendKeys]::SendWait('%a')
        Start-Sleep -Milliseconds 500
        Write-Host 'Tampermonkey > Okay' -ForegroundColor green -BackgroundColor black
        [System.Windows.Forms.SendKeys]::SendWait('%o')
        Start-Sleep -Milliseconds 5000
        Write-Host 'AdsBypasser' -ForegroundColor green -BackgroundColor black
        $OpenWithFirefox.StartInfo.Arguments = 'https://adsbypasser.github.io/releases/adsbypasser.full.es7.user.js'
        $OpenWithFirefox.start()
        Start-Sleep -Milliseconds 3000
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 1000
        Write-Host 'Tampermonkey > AdsBypasser > Install' -ForegroundColor green -BackgroundColor black
        [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    }
}
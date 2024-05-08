if ((Test-Path -LiteralPath $env:APPDATA\Mozilla\Firefox\Profiles) -eq $true) {
    $FirefoxProfiles = Get-ChildItem -Directory -Path "$env:APPDATA\Mozilla\Firefox\Profiles" -Filter '*.default-release'
    $CurrentFirefoxProfile = "$env:APPDATA\Mozilla\Firefox\Profiles\$FirefoxProfiles"
    if ((Test-Path -LiteralPath $CurrentFirefoxProfile) -eq $true) {
        Write-Host 'Firefox Extensions Setup' -ForegroundColor green -BackgroundColor black
        $OpenWithFirefox = New-Object System.Diagnostics.Process
        $OpenWithFirefox.StartInfo.Filename = 'firefox.exe'
        $OpenWithFirefox.StartInfo.Arguments = 'https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/'
        $OpenWithFirefox.start()
        Start-Sleep -Milliseconds 2000
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.SendKeys]::SendWait('^+k')
        Start-Sleep -Milliseconds 2000
        [System.Windows.Forms.SendKeys]::SendWait("document.getElementsByClassName{(}'Button Button--action AMInstallButton-button Button--puffy'{)}{[}0{]}.click{(}{)}")
        [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
        Start-Sleep -Milliseconds 1000
        [System.Windows.Forms.SendKeys]::SendWait('^+i')
        Start-Sleep -Milliseconds 2000
        [System.Windows.Forms.SendKeys]::SendWait('%a')
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('%o')
        $OpenWithFirefox.StartInfo.Arguments = 'https://addons.mozilla.org/en-US/firefox/addon/clearurls/'
        $OpenWithFirefox.start()
        Start-Sleep -Milliseconds 2000
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('^+k')
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('{UP}')
        [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
        Start-Sleep -Milliseconds 1000
        [System.Windows.Forms.SendKeys]::SendWait('^+i')
        Start-Sleep -Milliseconds 1000
        [System.Windows.Forms.SendKeys]::SendWait('%a')
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('%o')
        $OpenWithFirefox.StartInfo.Arguments = 'https://addons.mozilla.org/en-US/firefox/addon/i-m-not-robot-captcha-clicker/'
        $OpenWithFirefox.start()
        Start-Sleep -Milliseconds 2000
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('^+k')
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('{UP}')
        [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
        Start-Sleep -Milliseconds 1000
        [System.Windows.Forms.SendKeys]::SendWait('^+i')
        Start-Sleep -Milliseconds 1000
        [System.Windows.Forms.SendKeys]::SendWait('%a')
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('%o')
        $OpenWithFirefox.StartInfo.Arguments = 'https://addons.mozilla.org/en-US/firefox/addon/buster-captcha-solver/'
        $OpenWithFirefox.start()
        Start-Sleep -Milliseconds 2000
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('^+k')
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('{UP}')
        [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
        Start-Sleep -Milliseconds 1000
        [System.Windows.Forms.SendKeys]::SendWait('^+i')
        Start-Sleep -Milliseconds 1000
        [System.Windows.Forms.SendKeys]::SendWait('%a')
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('%o')
        $OpenWithFirefox.StartInfo.Arguments = 'https://addons.mozilla.org/en-US/firefox/addon/the-camelizer-price-history-ch/'
        $OpenWithFirefox.start()
        Start-Sleep -Milliseconds 2000
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('^+k')
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('{UP}')
        [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
        Start-Sleep -Milliseconds 1000
        [System.Windows.Forms.SendKeys]::SendWait('^+i')
        Start-Sleep -Milliseconds 1000
        [System.Windows.Forms.SendKeys]::SendWait('%a')
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('%o')
        $OpenWithFirefox.StartInfo.Arguments = 'https://addons.mozilla.org/en-US/firefox/addon/tampermonkey/'
        $OpenWithFirefox.start()
        Start-Sleep -Milliseconds 2000
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 100
        [System.Windows.Forms.SendKeys]::SendWait('%{TAB}')
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('^+k')
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('{UP}')
        [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
        Start-Sleep -Milliseconds 1000
        [System.Windows.Forms.SendKeys]::SendWait('^+i')
        Start-Sleep -Milliseconds 1000
        [System.Windows.Forms.SendKeys]::SendWait('%a')
        Start-Sleep -Milliseconds 5000
        [System.Windows.Forms.SendKeys]::SendWait('%o')
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
        (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/uBlock_Origin/Backup.txt', "$env:TEMP\uBlock_Origin_Backup.txt")
        $uBlockPattern = 'uBlock.+?([a-f0-9]{8}-([a-f0-9]{4}-){3}[a-f0-9]{12})\\'
        $uBlockUUID = (Select-String -Pattern $uBlockPattern -Path $CurrentFirefoxProfile\prefs.js).Matches.Groups[1].Value
        $OpenWithFirefox.StartInfo.Arguments = "moz-extension://$uBlockUUID/dashboard.html#settings.html"
        $OpenWithFirefox.start()
        Start-Sleep -Milliseconds 2000
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
    }
}
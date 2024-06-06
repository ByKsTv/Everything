$InstalledSoftware = Get-Package | Select-Object -Property 'Name'

if ($InstalledSoftware -match 'Google Chrome') {
    Write-Host 'Google Chrome Extensions: Closing browser' -ForegroundColor green -BackgroundColor black
    Stop-Process -Name Chrome -Force -ErrorAction SilentlyContinue

    Write-Host "Google Chrome Extensions: Adding 'uBlock Origin'" -ForegroundColor green -BackgroundColor black
    Write-Host "Google Chrome Extensions: Adding 'Tampermonkey'" -ForegroundColor green -BackgroundColor black
    Write-Host "Google Chrome Extensions: Adding 'ClearURLs'" -ForegroundColor green -BackgroundColor black
    Write-Host "Google Chrome Extensions: Adding 'I'm not robot captcha clicker'" -ForegroundColor green -BackgroundColor black
    Write-Host "Google Chrome Extensions: Adding 'Buster: Captcha Solver for Humans'" -ForegroundColor green -BackgroundColor black
    Write-Host "Google Chrome Extensions: Adding 'The Camelizer - Price Tracker'" -ForegroundColor green -BackgroundColor black

    # https://github.com/letsdoautomation/powershell/tree/main/Install%20Google%20Chrome%20Extensions
    $extensions = 'cjpalhdlnbpafiamejdnhcphjbkeiagm', 'dhdgffkkebhmkfjojejmpbldmpobfkfo', 'lckanjgmijmafbedllaakclkaicjfmnk', 'ceipnlhmjohemhfpbjdgeigkababhmjc', 'mpbjkejclgfgadiemmefgebjfooflfhl', 'ghnomdcacenbmilgjigehppbamfndblo'
    $key_path = 'Software\Policies\Google\Chrome\ExtensionInstallForcelist'
    $registry = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($key_path, $true)
    $extensions | ForEach-Object {
        if ($null -eq $registry) {
            $registry = [Microsoft.Win32.Registry]::LocalMachine.CreateSubKey($key_path, $true)
            $registry.SetValue('1', $_)
        }
        else {
            $values = $registry.GetValueNames().ForEach({ $registry.GetValue($_) })
            if ($_ -notin $values) {
                $maximum = $registry.GetValueNames().Where({ $_ -match '\d' }) | Measure-Object -Maximum | Select-Object -expand maximum
                $maximum += 1
                $registry.SetValue($maximum, $_)
            }
        }
    }
    $registry.Dispose()

    Write-Host 'Google Chrome Extensions: Starting browser' -ForegroundColor green -BackgroundColor black
    [System.Diagnostics.Process]::Start('Chrome.exe')
    Start-Sleep -Milliseconds 1000

    Write-Host 'Google Chrome Extensions: Opening Registry Key' -ForegroundColor green -BackgroundColor black
    $ChromeExtensionsKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Software\Microsoft\Windows\CurrentVersion\Applets\Regedit', $true)
    $ChromeExtensionsKey.SetValue('LastKey', 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist', [Microsoft.Win32.RegistryValueKind]::String)
    $ChromeExtensionsKey.Close()
    [void]([System.Diagnostics.Process]::Start('regedit.exe'))

    Write-Host 'Google Chrome Extensions: Waiting for browser' -ForegroundColor green -BackgroundColor black
    while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'Chrome' } -ErrorAction SilentlyContinue))) {
        Start-Sleep -Milliseconds 1000
    }
    Start-Sleep -Milliseconds 10000

    Write-Host 'Google Chrome Extensions: Adding option to set foreground' -ForegroundColor green -BackgroundColor black
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

    Write-Host 'Google Chrome Extensions: Setting foreground' -ForegroundColor green -BackgroundColor black
    [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'Chrome' }).MainWindowHandle)

    Write-Host "Google Chrome Extensions: Adding 'AdsBypasser' to 'Tampermonkey'" -ForegroundColor green -BackgroundColor black
    [System.Diagnostics.Process]::Start('Chrome.exe', 'https://adsbypasser.github.io/releases/adsbypasser.full.es7.user.js')
    Start-Sleep -Milliseconds 3000

    Write-Host 'Google Chrome Extensions: Setting foreground' -ForegroundColor green -BackgroundColor black
    [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'Chrome' }).MainWindowHandle)
    Start-Sleep -Milliseconds 1000

    Write-Host "Google Chrome Extensions: Installing 'AdsBypasser' to 'Tampermonkey'" -ForegroundColor green -BackgroundColor black
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')

    Write-Host "Google Chrome Extensions: Downloading 'uBlock Origin' custom settings" -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/uBlock_Origin/Backup.json', "$env:TEMP\uBlock_Origin_Backup.json")
    [System.Diagnostics.Process]::Start('Chrome.exe', 'chrome-extension://cjpalhdlnbpafiamejdnhcphjbkeiagm/dashboard.html#settings.html')
    Start-Sleep -Milliseconds 2000

    Write-Host 'Google Chrome Extensions: Setting foreground' -ForegroundColor green -BackgroundColor black
    [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'Chrome' }).MainWindowHandle)
    Start-Sleep -Milliseconds 1000

    Write-Host "Google Chrome Extensions: Starting 'Restore from file' on 'uBlock Origin' settings" -ForegroundColor green -BackgroundColor black
    [System.Windows.Forms.SendKeys]::SendWait('+{TAB 5}')
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    Start-Sleep -Milliseconds 1000

    Write-Host "Google Chrome Extensions: Selecting folder to restore backup from on 'uBlock Origin' settings" -ForegroundColor green -BackgroundColor black
    [System.Windows.Forms.SendKeys]::SendWait('{F4}')
    Start-Sleep -Milliseconds 100
    [System.Windows.Forms.SendKeys]::SendWait('^a')
    Start-Sleep -Milliseconds 100
    [System.Windows.Forms.SendKeys]::SendWait($env:TEMP)
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    Start-Sleep -Milliseconds 1000
    [System.Windows.Forms.SendKeys]::SendWait('%n')
    Start-Sleep -Milliseconds 1000

    Write-Host "Google Chrome Extensions: Selecting file to restore backup from on 'uBlock Origin' settings" -ForegroundColor green -BackgroundColor black
    [System.Windows.Forms.SendKeys]::SendWait('uBlock_Origin_Backup.json')
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    Start-Sleep -Milliseconds 1000
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
}
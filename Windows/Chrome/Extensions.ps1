if ((Test-Path -Path "$env:ProgramFiles\Google\Chrome\Application") -eq $true) {
    Write-Host 'Chrome Extensions Setup (https://github.com/letsdoautomation/powershell/tree/main/Install%20Google%20Chrome%20Extensions)' -ForegroundColor green -BackgroundColor black
    Stop-Process -Name Chrome -Force
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
    [System.Diagnostics.Process]::Start('Chrome.exe')
    Start-Sleep -Milliseconds 1000
    Write-Host 'Chrome > Chrome Extensions Registry Key' -ForegroundColor green -BackgroundColor black
    $ChromeExtensionsKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Software\Microsoft\Windows\CurrentVersion\Applets\Regedit', $true)
    $ChromeExtensionsKey.SetValue('LastKey', 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist', [Microsoft.Win32.RegistryValueKind]::String)
    $ChromeExtensionsKey.Close()
    [void]([System.Diagnostics.Process]::Start('regedit.exe'))
    Write-Host 'Chrome > Waiting for browser' -ForegroundColor green -BackgroundColor black
    while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'Chrome' } -ErrorAction SilentlyContinue))) {
    }
    Start-Sleep -Milliseconds 10000
    Write-Host 'Chrome > Set Foreground' -ForegroundColor green -BackgroundColor black
    while (($null -eq (Get-Process -Name 'Chrome' -ErrorAction SilentlyContinue))) {
    }
    Start-Sleep -Milliseconds 1000
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
    [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'Chrome' }).MainWindowHandle)
    Write-Host 'AdsBypasser' -ForegroundColor green -BackgroundColor black
    [System.Diagnostics.Process]::Start('Chrome.exe', 'https://adsbypasser.github.io/releases/adsbypasser.full.es7.user.js')
    Start-Sleep -Milliseconds 3000
    [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'Chrome' }).MainWindowHandle)
    Start-Sleep -Milliseconds 1000
    Write-Host 'Tampermonkey > AdsBypasser > Install' -ForegroundColor green -BackgroundColor black
    [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/uBlock_Origin/Backup.txt', "$env:TEMP\uBlock_Origin_Backup.txt")
    [System.Diagnostics.Process]::Start('Chrome.exe', 'chrome-extension://cjpalhdlnbpafiamejdnhcphjbkeiagm/dashboard.html#settings.html')
    Start-Sleep -Milliseconds 2000
    [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'Chrome' }).MainWindowHandle)
    Start-Sleep -Milliseconds 1000
    Write-Host 'uBlock Origin > Restore from file' -ForegroundColor green -BackgroundColor black
    [System.Windows.Forms.SendKeys]::SendWait('+{TAB 5}')
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
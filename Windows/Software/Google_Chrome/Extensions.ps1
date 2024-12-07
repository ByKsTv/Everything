$InstalledSoftware = Get-Package | Select-Object -Property 'Name'

if ($InstalledSoftware -match 'Google Chrome') {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Closing browser'); [Console]::ResetColor(); [Console]::WriteLine()
    Stop-Process -Name Chrome -Force -ErrorAction SilentlyContinue

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Adding uBlock Origin'); [Console]::ResetColor(); [Console]::WriteLine()
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Adding Violentmonkey'); [Console]::ResetColor(); [Console]::WriteLine()
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Adding ClearURLs'); [Console]::ResetColor(); [Console]::WriteLine()
    Write-Host "Google Chrome Extensions: Adding I'm not robot captcha clicker" -ForegroundColor green -BackgroundColor black
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Adding Buster: Captcha Solver for Humans'); [Console]::ResetColor(); [Console]::WriteLine()
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Adding The Camelizer - Price Tracker'); [Console]::ResetColor(); [Console]::WriteLine()

    # https://github.com/letsdoautomation/powershell/tree/main/Install%20Google%20Chrome%20Extensions
    $extensions = 'cjpalhdlnbpafiamejdnhcphjbkeiagm', 'jinjaccalgkegednnccohejagnlnfdag', 'mpbjkejclgfgadiemmefgebjfooflfhl', 'ghnomdcacenbmilgjigehppbamfndblo'
    $key_path = 'SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist'
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

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: uBlock Origin: Using custom settings'); [Console]::ResetColor(); [Console]::WriteLine()
    # https://www.reddit.com/r/sysadmin/comments/u9fg8c/comment/i5tudv7/
    New-Item -Path 'HKLM:\SOFTWARE\Policies\Google\Chrome\3rdparty\extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm\policy' -Force
    $uBlockDownloadLocation = "$env:TEMP\uBlock_Origin_Backup.json"
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/uBlock_Origin/Backup.json', "$uBlockDownloadLocation")
    $uBlockLatestContent = Get-Content $uBlockDownloadLocation
    New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Google\Chrome\3rdparty\extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm\policy' -Name 'adminSettings' -Value "$uBlockLatestContent" -PropertyType String -Force

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Starting browser'); [Console]::ResetColor(); [Console]::WriteLine()
    [System.Diagnostics.Process]::Start('Chrome.exe')
    Start-Sleep -Milliseconds 1000

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Waiting for browser'); [Console]::ResetColor(); [Console]::WriteLine()
    while ($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'Chrome' } -ErrorAction SilentlyContinue)) {
        Start-Sleep -Milliseconds 1000
    }
    Start-Sleep -Milliseconds 20000

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Adding option to set foreground'); [Console]::ResetColor(); [Console]::WriteLine()
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

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Setting foreground'); [Console]::ResetColor(); [Console]::WriteLine()
    [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'Chrome' }).MainWindowHandle)

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Opening AdsBypasser'); [Console]::ResetColor(); [Console]::WriteLine()
    [System.Diagnostics.Process]::Start('Chrome.exe', 'https://adsbypasser.github.io/releases/adsbypasser.full.es7.user.js')
    Start-Sleep -Milliseconds 5000

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Setting foreground'); [Console]::ResetColor(); [Console]::WriteLine()
    [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'Chrome' }).MainWindowHandle)
    Start-Sleep -Milliseconds 1000

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Installing AdsBypasser'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object -ComObject wscript.shell).SendKeys('^{ENTER}')
    
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Cleaning up'); [Console]::ResetColor(); [Console]::WriteLine()
    if ((Test-Path -Path HKLM:\SOFTWARE\Policies\Google\Chrome\3rdparty\extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm\policy) -eq $true) {
        Remove-Item HKLM:\SOFTWARE\Policies\Google\Chrome\3rdparty\extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm\policy -Force
    }
}
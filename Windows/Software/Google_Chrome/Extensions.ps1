$InstalledSoftware = (Get-Package).Name

if ($InstalledSoftware -match 'Google Chrome') {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Closing browser'); [Console]::ResetColor(); [Console]::WriteLine()
    Stop-Process -Name Chrome -Force -ErrorAction SilentlyContinue

    # Delete previous installed lists using policies
    Remove-Item -Path 'HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist' -Force -ErrorAction SilentlyContinue
    New-Item -Path 'HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist' -Force

    # https://github.com/letsdoautomation/powershell/tree/main/Install%20Google%20Chrome%20Extensions
    $extensions = 'ddkjiahejlhfcafbddmgiahcphecmpfh', 'dhdgffkkebhmkfjojejmpbldmpobfkfo', 'mpbjkejclgfgadiemmefgebjfooflfhl', 'ghnomdcacenbmilgjigehppbamfndblo'
    $key_path = 'SOFTWARE\Policies\Google\Chrome\ExtensionInstallForcelist'
    $registry = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($key_path, $true)
    $extensions | ForEach-Object {
        if ($null -eq $registry) {
            $registry = [Microsoft.Win32.Registry]::LocalMachine.CreateSubKey($key_path, $true)
            $registry.SetValue('1', $_)
        } else {
            $values = $registry.GetValueNames().ForEach({ $registry.GetValue($_) })
            if ($_ -notin $values) {
                $maximum = $registry.GetValueNames().Where({ $_ -match '\d' }) | Measure-Object -Maximum | Select-Object -expand maximum
                $maximum += 1
                $registry.SetValue($maximum, $_)
            }
        }
    }
    $registry.Dispose()

    # [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: uBlock Origin: Using custom settings'); [Console]::ResetColor(); [Console]::WriteLine()
    # # https://www.reddit.com/r/sysadmin/comments/u9fg8c/comment/i5tudv7/
    # New-Item -Path 'HKLM:\SOFTWARE\Policies\Google\Chrome\3rdparty\extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm\policy' -Force
    # $uBlockDownloadLocation = "$env:TEMP\uBlock_Origin_Backup.json"
    # (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Internet/uBlock_Origin/Backup.json', "$uBlockDownloadLocation")
    # $uBlockLatestContent = Get-Content $uBlockDownloadLocation
    # New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Google\Chrome\3rdparty\extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm\policy' -Name 'adminSettings' -Value "$uBlockLatestContent" -PropertyType String -Force

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Starting browser'); [Console]::ResetColor(); [Console]::WriteLine()
    $ChromeEXE = [IO.Path]::Combine($env:LOCALAPPDATA, 'Google', 'Chrome', 'Application', 'chrome.exe')
    Start-Process $ChromeEXE
    Start-Sleep -Milliseconds 1000

    #     [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Waiting for browser'); [Console]::ResetColor(); [Console]::WriteLine()
    #     while ($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'Chrome' } -ErrorAction SilentlyContinue)) {
    #         Start-Sleep -Milliseconds 1000
    #     }
    #     Start-Sleep -Milliseconds 20000

    #     [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Adding option to set foreground'); [Console]::ResetColor(); [Console]::WriteLine()
    #     if (-not ([Management.Automation.PSTypeName]'SFW').Type) {
    #         Add-Type @'
    #     using System;
    #     using System.Runtime.InteropServices;
    #     public class SFW {
    #        [DllImport("user32.dll")]
    #        [return: MarshalAs(UnmanagedType.Bool)]
    #        public static extern bool SetForegroundWindow(IntPtr hWnd);
    #     }
    # '@
    #     }

    #     $UserScripts_URLs = @(
    #         'https://adsbypasser.github.io/releases/adsbypasser.full.user.js'
    #         'https://raw.githubusercontent.com/ByKsTv/Everything/main/Websites/Scripts/AliExpress_ViewMore.user.js'
    #         'https://raw.githubusercontent.com/ByKsTv/Everything/main/Websites/Scripts/Amazon_CleanURL.user.js'
    #     )
    #     foreach ($UserScripts_URL in $UserScripts_URLs) {
    #         Start-Process $UserScripts_URL
    #         Start-Sleep -Seconds 5
    #         [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'Chrome' }).MainWindowHandle) | Out-Null
    #         (New-Object -ComObject wscript.shell).SendKeys('^{ENTER}')
    #     }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Cleaning up'); [Console]::ResetColor(); [Console]::WriteLine()
    if (Test-Path -Path 'HKLM:\SOFTWARE\Policies\Google\Chrome\3rdparty\extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm\policy') {
        Remove-Item 'HKLM:\SOFTWARE\Policies\Google\Chrome\3rdparty\extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm\policy' -Force
    }
}

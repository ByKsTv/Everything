$Firefox_Profiles = [IO.Path]::Combine($env:APPDATA, 'Mozilla', 'Firefox', 'Profiles')
if (Test-Path $Firefox_Profiles) {
    $Firefox_Profile = (Get-ChildItem $Firefox_Profiles -Directory -Filter '*.default-release' | Select-Object -First 1).FullName
    if (Test-Path $Firefox_Profile) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Closing browser'); [Console]::ResetColor(); [Console]::WriteLine()
        Stop-Process -Name firefox -Force -ErrorAction SilentlyContinue

        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
        $Extensions_RegPath = 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox\Extensions'
        New-Item -Path $Extensions_RegPath -Name 'Install' -Force
        $Install_RegPath = [IO.Path]::Combine($Extensions_RegPath, 'Install')
        $ExtensionsList = @(
            'https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi'
            'https://addons.mozilla.org/firefox/downloads/latest/violentmonkey/latest.xpi'
            'https://addons.mozilla.org/firefox/downloads/latest/disable-page-visibility/latest.xpi'
            'https://addons.mozilla.org/firefox/downloads/latest/buster-captcha-solver/latest.xpi'
            'https://addons.mozilla.org/firefox/downloads/latest/the-camelizer-price-history-ch/latest.xpi'
        )
        $ExtensionNumber = 1
        $ExtensionsList | ForEach-Object {
            New-ItemProperty -Path $Install_RegPath -Name $ExtensionNumber -Value $_ -PropertyType String -Force
            $ExtensionNumber++
        }

        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: uBlock Origin: Using custom settings'); [Console]::ResetColor(); [Console]::WriteLine()
        $DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Internet/uBlock_Origin/Backup.json'
        $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
        $SavePath = [Uri]::UnescapeDataString([IO.Path]::Combine($env:TEMP, $FileName))
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'uBlock Origin Backup File'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
        (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

        New-Item -Path 'HKLM:\SOFTWARE\Mozilla\ManagedStorage\uBlock0@raymondhill.net' -Force
        New-ItemProperty -Path 'HKLM:\SOFTWARE\Mozilla\ManagedStorage\uBlock0@raymondhill.net' -Name '(default)' -Value $SavePath -PropertyType String -Force
        [IO.File]::WriteAllText($SavePath, '{"name": "uBlock0@raymondhill.net","description": "ignored","type": "storage","data": {"adminSettings": ' + (Get-Content $SavePath -Raw) + '}}')
        Start-Sleep -Milliseconds 1000
    
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Starting browser'); [Console]::ResetColor(); [Console]::WriteLine()
        [Diagnostics.Process]::Start('firefox.exe') | Out-Null

        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Waiting for browser'); [Console]::ResetColor(); [Console]::WriteLine()
        while ($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' } -ErrorAction SilentlyContinue)) {
            Start-Sleep -Milliseconds 1000
        }
        Start-Sleep -Milliseconds 20000
        
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Adding option to set foreground'); [Console]::ResetColor(); [Console]::WriteLine()
        if (-not ([Management.Automation.PSTypeName]'SFW').Type) {
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
    
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Setting foreground'); [Console]::ResetColor(); [Console]::WriteLine()
    [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }).MainWindowHandle) | Out-Null

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Opening AdsBypasser'); [Console]::ResetColor(); [Console]::WriteLine()
    [Diagnostics.Process]::Start('firefox.exe', 'https://adsbypasser.github.io/releases/adsbypasser.full.es7.user.js') | Out-Null
    Start-Sleep -Milliseconds 5000

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Setting foreground'); [Console]::ResetColor(); [Console]::WriteLine()
    [SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }).MainWindowHandle) | Out-Null
    Start-Sleep -Milliseconds 2000
    
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Installing AdsBypasser'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object -ComObject wscript.shell).SendKeys('^{ENTER}')

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Cleaning up'); [Console]::ResetColor(); [Console]::WriteLine()
    if (Test-Path -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install') {
        Remove-Item 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox\Extensions\Install' -Force
    }
    if (Test-Path -Path 'HKLM:\SOFTWARE\Mozilla\ManagedStorage\uBlock0@raymondhill.net') {
        Remove-Item 'HKLM:\SOFTWARE\Mozilla\ManagedStorage\uBlock0@raymondhill.net' -Force
    }
}
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/Group_Policy_Templates.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Pre.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/Group_Policy.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Post.ps1')

$Firefox_DDL = (Invoke-WebRequest -UseBasicParsing -Uri 'https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US' -MaximumRedirection 0 -ErrorAction SilentlyContinue).Headers.Location
$Firefox_Filename = [IO.Path]::GetFileName(([URI]$Firefox_DDL).AbsolutePath)
$Firefox_SavePath = [Uri]::UnescapeDataString([IO.Path]::Combine($env:TEMP, $Firefox_Filename))
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Mozilla Firefox'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($Firefox_DDL, $Firefox_SavePath)

$Firefox_Argument = '/S'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Mozilla Firefox'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $Firefox_SavePath -ArgumentList $Firefox_Argument -Wait

$Firefox_DesktopShortcut = [IO.Path]::Combine($env:PUBLIC, 'Desktop', 'Firefox.lnk')
if (Test-Path -Path $Firefox_DesktopShortcut) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Deleting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Mozilla Firefox'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' desktop shortcut from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_DesktopShortcut'"); [Console]::ResetColor(); [Console]::WriteLine()
    Remove-Item -Path $Firefox_DesktopShortcut
}

$Firefox_Destination = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like '*Firefox*' }).InstallLocation
$Firefox_OLD_PATH = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::User)
if ($Firefox_OLD_PATH -notlike "*$Firefox_Destination*") {
    $Firefox_NEW_PATH = "$Firefox_OLD_PATH;$Firefox_Destination"
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Mozilla Firefox'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_Destination'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'PATH'"); [Console]::ResetColor(); [Console]::WriteLine()
    [Environment]::SetEnvironmentVariable('Path', $Firefox_NEW_PATH, [EnvironmentVariableTarget]::User)
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')
}

$Firefox_EXEDestination = [IO.Path]::Combine($Firefox_Destination, 'firefox.exe')
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Starting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Mozilla Firefox'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_EXEDestination'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $Firefox_EXEDestination

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Waiting for browser'); [Console]::ResetColor(); [Console]::WriteLine()
while ($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' } -ErrorAction SilentlyContinue)) {
    Start-Sleep -Milliseconds 1000
}
Start-Sleep -Milliseconds 10000

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Adding option to set foreground'); [Console]::ResetColor(); [Console]::WriteLine()
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

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Setting foreground'); [Console]::ResetColor(); [Console]::WriteLine()
[SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)
Start-Sleep -Milliseconds 1000

Write-Host "Mozilla Firefox: Unchecking 'Import from browser'" -ForegroundColor green -BackgroundColor black
(New-Object -ComObject wscript.shell).SendKeys('{TAB}')
(New-Object -ComObject wscript.shell).SendKeys('{TAB}')
(New-Object -ComObject wscript.shell).SendKeys('{TAB}')

# If Windows is not Windows 10 - Needs another tab to select import from browser
$BuildNumber = [int](Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "CurrentBuild").CurrentBuild
if ($BuildNumber -ge 22000) {
    Write-Host "Mozilla Firefox: The operating system is not Windows 10 - Sending another ALT key" -ForegroundColor green -BackgroundColor black
    (New-Object -ComObject wscript.shell).SendKeys('{TAB}')
}
(New-Object -ComObject wscript.shell).SendKeys(' ')
Start-Sleep -Milliseconds 100

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Setting as default browser'); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object -ComObject wscript.shell).SendKeys('{TAB}')
(New-Object -ComObject wscript.shell).SendKeys('{ENTER}')
Start-Sleep -Milliseconds 1000

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Waiting for user to sign in'); [Console]::ResetColor(); [Console]::WriteLine()
[Diagnostics.Process]::Start('firefox.exe', 'https://accounts.firefox.com/?context=fx_desktop_v3&entrypoint=fxa_toolbar_button&action=email&service=sync')
Start-Sleep -Milliseconds 1000

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Setting foreground'); [Console]::ResetColor(); [Console]::WriteLine()
[SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Deleting Scheduled Tasks'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Mozilla') -eq $true) {
    Unregister-ScheduledTask -TaskName 'Firefox Background Update*' -Confirm:$false
    Unregister-ScheduledTask -TaskName 'Firefox Default Browser Agent*' -Confirm:$false
    $scheduleObject = New-Object -ComObject Schedule.Service
    $scheduleObject.connect()
    $rootFolder = $scheduleObject.GetFolder('\')
    $rootFolder.DeleteFolder('Mozilla', $null)
    Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Mozilla' -Force -Recurse -ErrorAction SilentlyContinue
}
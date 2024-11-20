$Firefox_PolicyTemplates_DDL = ((Invoke-RestMethod -Uri 'https://api.github.com/repos/mozilla/policy-templates/releases/latest').assets | Where-Object name -Like 'policy_templates*').browser_download_url
$Firefox_PolicyTemplates_Filename = [IO.Path]::GetFileName(([URI]$Firefox_PolicyTemplates_DDL).AbsolutePath)
$Firefox_PolicyTemplates_SavePath = [IO.Path]::Combine($env:TEMP, $Firefox_PolicyTemplates_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_PolicyTemplates_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_PolicyTemplates_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_PolicyTemplates_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($Firefox_PolicyTemplates_DDL, $Firefox_PolicyTemplates_SavePath)

$Firefox_PolicyTemplates_Dir = $Firefox_PolicyTemplates_SavePath.TrimEnd('.zip')
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_PolicyTemplates_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_PolicyTemplates_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_PolicyTemplates_Dir'"); [Console]::ResetColor(); [Console]::WriteLine()
Expand-Archive -Path $Firefox_PolicyTemplates_SavePath -DestinationPath $Firefox_PolicyTemplates_Dir -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Mozilla Firefox Policy Templates'"); [Console]::ResetColor(); [Console]::WriteLine()
Copy-Item "$Firefox_PolicyTemplates_Dir\windows\*.admx" "$env:windir\PolicyDefinitions" -Force
Copy-Item "$Firefox_PolicyTemplates_Dir\windows\en-US\*.adml" "$env:windir\PolicyDefinitions\en-US" -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Setting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Mozilla Firefox Policies'"); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox') -ne $true) {
    New-Item 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox' -Force 
}
# https://mozilla.github.io/policy-templates/
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableDefaultBrowserAgent' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox' -Name 'BackgroundAppUpdate' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox' -Name 'NoDefaultBookmarks' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableTelemetry' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableFeedbackCommands' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableFirefoxStudies' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisablePocket' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableProfileRefresh' -Value 1 -PropertyType DWord -Force

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
$Firefox_OLD_PATH = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
if ($Firefox_OLD_PATH -notlike "*$Firefox_Destination*") {
    $Firefox_NEW_PATH = "$Firefox_OLD_PATH;$Firefox_Destination"
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Mozilla Firefox'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_Destination'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'PATH'"); [Console]::ResetColor(); [Console]::WriteLine()
    [System.Environment]::SetEnvironmentVariable('Path', $Firefox_NEW_PATH, [System.EnvironmentVariableTarget]::User)
    $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
}

$Firefox_EXEDestination = [IO.Path]::Combine($Firefox_Destination, 'firefox.exe')
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Starting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Mozilla Firefox'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_EXEDestination'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $Firefox_EXEDestination

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Waiting for browser'); [Console]::ResetColor(); [Console]::WriteLine()
while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}
Start-Sleep -Milliseconds 10000

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Adding option to set foreground'); [Console]::ResetColor(); [Console]::WriteLine()
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

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Setting foreground'); [Console]::ResetColor(); [Console]::WriteLine()
[SFW]::SetForegroundWindow((Get-Process | Where-Object { $_.mainWindowTitle -match 'firefox' }).MainWindowHandle)
Start-Sleep -Milliseconds 1000

Write-Host "Mozilla Firefox: Unchecking 'Import from browser'" -ForegroundColor green -BackgroundColor black
(New-Object -ComObject wscript.shell).SendKeys('{TAB}')
(New-Object -ComObject wscript.shell).SendKeys('{TAB}')
(New-Object -ComObject wscript.shell).SendKeys('{TAB}')
(New-Object -ComObject wscript.shell).SendKeys(' ')
Start-Sleep -Milliseconds 100

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Setting as default browser'); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object -ComObject wscript.shell).SendKeys('{TAB}')
(New-Object -ComObject wscript.shell).SendKeys('{ENTER}')
Start-Sleep -Milliseconds 1000

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox: Waiting for user to sign in'); [Console]::ResetColor(); [Console]::WriteLine()
[System.Diagnostics.Process]::Start('firefox.exe', 'https://accounts.firefox.com/?context=fx_desktop_v3&entrypoint=fxa_toolbar_button&action=email&service=sync')
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
    Remove-Item -Path 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Mozilla' -Force -Recurse -ErrorAction SilentlyContinue
}
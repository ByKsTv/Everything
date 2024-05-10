if (!(Test-Path -Path $env:ProgramFiles/mpv)) {
    Write-Host 'mpv' -ForegroundColor green -BackgroundColor black
    New-Item -Path $env:ProgramFiles/mpv -Value mpv -ItemType Directory
}
Write-Host 'mpv > permissions > allow' -ForegroundColor green -BackgroundColor black
icacls $env:ProgramFiles/mpv /grant Users:F
if (!(Test-Path -Path $env:ProgramFiles/mpv/installer)) {
    Write-Host 'mpv > installer' -ForegroundColor green -BackgroundColor black
    New-Item -Path $env:ProgramFiles/mpv/installer -Value installer -ItemType Directory
}
if (!(Test-Path -Path $env:ProgramFiles/mpv/scripts)) {
    Write-Host 'mpv > scripts' -ForegroundColor green -BackgroundColor black
    New-Item -Path $env:ProgramFiles/mpv/scripts -Value scripts -ItemType Directory
}
if (!(Test-Path -Path $env:ProgramFiles/mpv/script-opts)) {
    Write-Host 'mpv > script-opts' -ForegroundColor green -BackgroundColor black
    New-Item -Path $env:ProgramFiles/mpv/script-opts -Value script-opts -ItemType Directory
}
Write-Host 'mpv > installer > updater.ps1' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/zhongfly/mpv-packaging/master/mpv-root/installer/updater.ps1', "$env:ProgramFiles/mpv/installer/updater.ps1")
Write-Host 'mpv > updater.bat' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/zhongfly/mpv-packaging/master/mpv-root/updater.bat', "$env:ProgramFiles/mpv/updater.bat")
Write-Host 'mpv > settings.xml' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/settings.xml', "$env:ProgramFiles/mpv/settings.xml")
Write-Host 'mpv > installer' -ForegroundColor green -BackgroundColor black
$MPV_Updater = 'MPV Updater'
$MPV_Updater_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $MPV_Updater }
if (!($MPV_Updater_Exists)) {
    Write-Host "Task Scheduler > $MPV_Updater" -ForegroundColor green -BackgroundColor black
    $MPV_Updater_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $MPV_Updater_Action = New-ScheduledTaskAction -Execute "$env:ProgramFiles\mpv\updater.bat"
    $MPV_Updater_Trigger = New-ScheduledTaskTrigger -AtLogOn
    $MPV_Updater_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
    $MPV_Updater_Parameters = @{
        TaskName  = $MPV_Updater
        Principal = $MPV_Updater_Principal
        Action    = $MPV_Updater_Action
        Trigger   = $MPV_Updater_Trigger
        Settings  = $MPV_Updater_Settings
    }
    Register-ScheduledTask @MPV_Updater_Parameters -Force
}
Start-ScheduledTask -TaskName $MPV_Updater
while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match "cmd.exe" } -ErrorAction SilentlyContinue))) {
}
Write-Host 'mpv > Add option to set cmd to foreground' -ForegroundColor green -BackgroundColor black
Add-Type @'
using System;
using System.Runtime.InteropServices;
public class SFW {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
}
'@
$cmdWindow = Get-Process | Where-Object { $_.mainWindowTitle -match 'cmd.exe' }
Write-Host 'mpv > Set Foreground' -ForegroundColor green -BackgroundColor black
[SFW]::SetForegroundWindow($cmdWindow.MainWindowHandle)
Start-Sleep -Milliseconds 1000
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('y')
[System.Windows.Forms.SendKeys]::SendWait('y')
[System.Windows.Forms.SendKeys]::SendWait('1')
While (!(Test-Path $env:ProgramFiles\mpv\installer\mpv-install.bat -ErrorAction SilentlyContinue)) {
}
do {
    $dirStats = Get-Item $env:ProgramFiles\mpv\installer\mpv-install.bat | Measure-Object -Sum Length
} 
until( ($dirStats.Sum -eq 16984) )
Start-Sleep -Milliseconds 1000
Write-Host 'mpv > Install' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:ProgramFiles\mpv\installer\mpv-install.bat -ArgumentList '/u'
Write-Host 'mpv > mpv.conf' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/mpv.conf', "$env:ProgramFiles/mpv/mpv.conf")
Write-Host 'mpv > input.conf' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/input.conf', "$env:ProgramFiles/mpv/input.conf")
Write-Host 'mpv > script-opts > osc.conf' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/script-opts/osc.conf', "$env:ProgramFiles/mpv/script-opts/osc.conf")
Write-Host 'mpv > scripts > autoload.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mpv-player/mpv/master/TOOLS/lua/autoload.lua', "$env:ProgramFiles/mpv/scripts/autoload.lua")
Write-Host 'mpv > script-opts > autoload.conf' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/script-opts/autoload.conf', "$env:ProgramFiles/mpv/script-opts/autoload.conf")
Write-Host 'mpv > scripts > oled-screensaver.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/script-opts/oled_screensaver.conf', "$env:ProgramFiles/mpv/script-opts/oled_screensaver.conf")
Write-Host 'mpv > script-opts > oled_screensaver.conf' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Akemi/mpv-oled-screensaver/master/oled-screensaver.lua', "$env:ProgramFiles/mpv/scripts/oled-screensaver.lua")
Write-Host 'mpv > scripts > celebi.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/script-opts/celebi.conf', "$env:ProgramFiles/mpv/script-opts/celebi.conf")
Write-Host 'mpv > script-opts > celebi.conf' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/po5/celebi/master/celebi.lua', "$env:ProgramFiles/mpv/scripts/celebi.lua")
Write-Host 'mpv > scripts > trackselect.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/script-opts/trackselect.conf', "$env:ProgramFiles/mpv/script-opts/trackselect.conf")
Write-Host 'mpv > script-opts > trackselect.conf' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/po5/trackselect/master/trackselect.lua', "$env:ProgramFiles/mpv/scripts/trackselect.lua")
Write-Host 'mpv > scripts > cookies-youtube-private.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/scripts/cookies-youtube-private.lua', "$env:ProgramFiles/mpv/scripts/cookies-youtube-private.lua")
Write-Host 'mpv > scripts > hidecursor.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/scripts/hidecursor.lua', "$env:ProgramFiles/mpv/scripts/hidecursor.lua")
Write-Host 'mpv > scripts > show-chapter.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/scripts/show-chapter.lua', "$env:ProgramFiles/mpv/scripts/show-chapter.lua")
Write-Host 'mpv > scripts > toggleconsole.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/scripts/toggleconsole.lua', "$env:ProgramFiles/mpv/scripts/toggleconsole.lua")
Write-Host 'mpv > scripts > youtube-alt-tab.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/scripts/youtube-alt-tab.lua', "$env:ProgramFiles/mpv/scripts/youtube-alt-tab.lua")
$sponsorblockanswer = [System.Windows.Forms.MessageBox]::Show('Add sponsorblock?

Python must be installed.
' , 'mpv scripts' , 4, 32)
if ($sponsorblockanswer -eq 'Yes') {
    if (!(Test-Path -Path $env:ProgramFiles/mpv/scripts/sponsorblock_shared)) {
        Write-Host 'mpv > scripts > sponsorblock_shared' -ForegroundColor green -BackgroundColor black
        New-Item -Path $env:ProgramFiles/mpv/scripts/sponsorblock_shared -Value sponsorblock_shared -ItemType Directory
    }
    Write-Host 'mpv > scripts > sponsorblock.lua' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/po5/mpv_sponsorblock/master/sponsorblock.lua', "$env:ProgramFiles/mpv/scripts/sponsorblock.lua")
    Write-Host 'mpv > script-opts > sponsorblock.conf' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/script-opts/sponsorblock.conf', "$env:ProgramFiles/mpv/script-opts/sponsorblock.conf")
    Write-Host 'mpv > scripts > sponsorblock_shared > sponsorblock.py' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/po5/mpv_sponsorblock/master/sponsorblock_shared/sponsorblock.py', "$env:ProgramFiles/mpv/scripts/sponsorblock_shared/sponsorblock.py")
    Write-Host 'mpv > scripts > sponsorblock_shared > main.lua' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/po5/mpv_sponsorblock/master/sponsorblock_shared/main.lua', "$env:ProgramFiles/mpv/scripts/sponsorblock_shared/main.lua")
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Python/Download.ps1')
}
$deletefileanswer = [System.Windows.Forms.MessageBox]::Show('Add delete file?

Delete key deletes current video file.
' , 'mpv scripts' , 4, 32)
if ($deletefileanswer -eq 'Yes') {
    Write-Host 'mpv > scripts > delete_file.lua' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/zenyd/mpv-scripts/master/delete_file.lua', "$env:ProgramFiles/mpv/scripts/delete_file.lua")
    $autodeletefileanswer = [System.Windows.Forms.MessageBox]::Show('Add auto delete file?

Auto deletes current video file when 15 seconds remaining.
' , 'mpv scripts' , 4, 48)
    if ($autodeletefileanswer -eq 'Yes') {
        Write-Host 'mpv > scripts > delete_file_auto.lua' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/scripts/delete_file_auto.lua', "$env:ProgramFiles/mpv/scripts/delete_file_auto.lua")
    }
}
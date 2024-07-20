Write-Host 'mpv: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/zhongfly/mpv-winbuild/releases/latest').assets | Where-Object name -Like 'mpv-x86_64-v3*' ).browser_download_url, "$env:TEMP\mpv.7z")

Write-Host 'mpv: Extracting' -ForegroundColor green -BackgroundColor black
if ($false -eq (Test-Path "$env:ProgramFiles\7-Zip\7z.exe")) {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')
}
& "$env:ProgramFiles\7-Zip\7z.exe" x "$env:TEMP\mpv.7z" -o"$env:SystemDrive$env:HOMEPATH\mpv" -y

Write-Host 'mpv: Using custom settings for updater.bat' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/settings.xml', "$env:SystemDrive$env:HOMEPATH\mpv\settings.xml")

Write-Host 'mpv: Updating' -ForegroundColor green -BackgroundColor black
$MPV_Updater = 'MPV Updater'
$MPV_Updater_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $MPV_Updater }
if (!($MPV_Updater_Exists)) {
    Write-Host "mpv: Task Scheduler: Adding $MPV_Updater" -ForegroundColor green -BackgroundColor black
    $MPV_Updater_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $MPV_Updater_Action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN $env:SystemDrive$env:HOMEPATH\mpv\updater.bat ^&exit"
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

Write-Host 'mpv: Waiting for updater to start' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'cmd.exe' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}

Write-Host 'mpv: Waiting for updater to finish' -ForegroundColor green -BackgroundColor black
while (!($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'cmd.exe' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}

Write-Host 'mpv: Installing' -ForegroundColor green -BackgroundColor black
Start-Process cmd.exe -ArgumentList "/C start /MIN $env:SystemDrive$env:HOMEPATH\mpv\installer\mpv-install.bat /u ^&exit"

Write-Host 'mpv: Using custom settings for input.conf' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/input.conf', "$env:SystemDrive$env:HOMEPATH\mpv\input.conf")

Write-Host 'mpv: Using custom settings for mpv.conf' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/mpv.conf', "$env:SystemDrive$env:HOMEPATH\mpv\mpv.conf")

if (!(Test-Path -Path "$env:SystemDrive$env:HOMEPATH\mpv\scripts")) {
    Write-Host 'mpv: Creating scripts folder' -ForegroundColor green -BackgroundColor black
    New-Item -Path "$env:SystemDrive$env:HOMEPATH\mpv\scripts" -Value scripts -ItemType Directory
}

if (!(Test-Path -Path "$env:SystemDrive$env:HOMEPATH\mpv\script-opts")) {
    Write-Host 'mpv: Creating script-opts folder' -ForegroundColor green -BackgroundColor black
    New-Item -Path "$env:SystemDrive$env:HOMEPATH\mpv\script-opts" -Value script-opts -ItemType Directory
}

Write-Host 'mpv: Using custom settings for osc.conf' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/script-opts/osc.conf', "$env:SystemDrive$env:HOMEPATH\mpv\script-opts\osc.conf")

Write-Host 'mpv: Adding script autoload.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mpv-player/mpv/master/TOOLS/lua/autoload.lua', "$env:SystemDrive$env:HOMEPATH\mpv\scripts\autoload.lua")

Write-Host 'mpv: Using custom settings for autoload.conf' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/script-opts/autoload.conf', "$env:SystemDrive$env:HOMEPATH\mpv\script-opts\autoload.conf")

Write-Host 'mpv: Adding script oled-screensaver.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Akemi/mpv-oled-screensaver/master/oled-screensaver.lua', "$env:SystemDrive$env:HOMEPATH\mpv\scripts\oled-screensaver.lua")

Write-Host 'mpv: Using custom settings for oled_screensaver.conf' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/script-opts/oled_screensaver.conf', "$env:SystemDrive$env:HOMEPATH\mpv\script-opts\oled_screensaver.conf")

Write-Host 'mpv: Adding script celebi.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/po5/celebi/master/celebi.lua', "$env:SystemDrive$env:HOMEPATH\mpv\scripts\celebi.lua")

Write-Host 'mpv: Using custom settings for celebi.conf' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/script-opts/celebi.conf', "$env:SystemDrive$env:HOMEPATH\mpv\script-opts\celebi.conf")

Write-Host 'mpv: Adding script trackselect.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/po5/trackselect/master/trackselect.lua', "$env:SystemDrive$env:HOMEPATH\mpv\scripts\trackselect.lua")

Write-Host 'mpv: Using custom settings for trackselect.conf' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/script-opts/trackselect.conf', "$env:SystemDrive$env:HOMEPATH\mpv\script-opts\trackselect.conf")

Write-Host 'mpv: Adding script hidecursor.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/scripts/hidecursor.lua', "$env:SystemDrive$env:HOMEPATH\mpv\scripts\hidecursor.lua")

Write-Host 'mpv: Adding script show-chapter.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/scripts/show-chapter.lua', "$env:SystemDrive$env:HOMEPATH\mpv\scripts\show-chapter.lua")

Write-Host 'mpv: Adding script toggleconsole.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/scripts/toggleconsole.lua', "$env:SystemDrive$env:HOMEPATH\mpv\scripts\toggleconsole.lua")

$InstalledSoftware = Get-Package | Select-Object -Property 'Name'
if ($InstalledSoftware -match 'Mozilla Firefox') {
    Write-Host 'mpv: Adding script [firefox]cookies.lua' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/scripts/[firefox]cookies.lua', "$env:SystemDrive$env:HOMEPATH\mpv\scripts\[firefox]cookies.lua")

    Write-Host 'mpv: Adding script [firefox]alt-tab.lua' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/scripts/[firefox]alt-tab.lua', "$env:SystemDrive$env:HOMEPATH\mpv\scripts\[firefox]alt-tab.lua")
}

Add-Type -AssemblyName System.Windows.Forms
$sponsorblockanswer = [System.Windows.Forms.MessageBox]::Show('Add sponsorblock?

Python will be installed.
' , 'mpv scripts' , 4, 32)
if ($sponsorblockanswer -eq 'Yes') {
    if (!(Test-Path -Path "$env:SystemDrive$env:HOMEPATH\mpv\scripts\sponsorblock_shared")) {
        Write-Host 'mpv: Creating sponsorblock_shared folder' -ForegroundColor green -BackgroundColor black
        New-Item -Path "$env:SystemDrive$env:HOMEPATH\mpv\scripts\sponsorblock_shared" -Value sponsorblock_shared -ItemType Directory
    }

    Write-Host 'mpv: Adding script sponsorblock.lua' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/po5/mpv_sponsorblock/master/sponsorblock.lua', "$env:SystemDrive$env:HOMEPATH\mpv\scripts\sponsorblock.lua")
    
    Write-Host 'mpv: Using custom settings for sponsorblock.conf' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/script-opts/sponsorblock.conf', "$env:SystemDrive$env:HOMEPATH\mpv\script-opts\sponsorblock.conf")

    Write-Host 'mpv: Adding script sponsorblock.py' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/po5/mpv_sponsorblock/master/sponsorblock_shared/sponsorblock.py', "$env:SystemDrive$env:HOMEPATH\mpv\scripts\sponsorblock_shared/sponsorblock.py")
    
    Write-Host 'mpv: Adding script main.py' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/po5/mpv_sponsorblock/master/sponsorblock_shared/main.lua', "$env:SystemDrive$env:HOMEPATH\mpv\scripts\sponsorblock_shared/main.lua")
    
    $InstalledSoftware = Get-Package | Select-Object -Property 'Name'
    if (!($InstalledSoftware -match 'Python')) {
        Write-Host 'Python: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Python/Download.ps1')
    }
}

$deletefileanswer = [System.Windows.Forms.MessageBox]::Show('Add delete file?

Delete key deletes current video file.
' , 'mpv scripts' , 4, 32)
if ($deletefileanswer -eq 'Yes') {
    Write-Host 'mpv: Adding script delete_file.lua' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/zenyd/mpv-scripts/master/delete_file.lua', "$env:SystemDrive$env:HOMEPATH\mpv\scripts\delete_file.lua")
    
    $autodeletefileanswer = [System.Windows.Forms.MessageBox]::Show('Add auto delete file?

Auto deletes current video file when 15 seconds remaining.
' , 'mpv scripts' , 4, 48)
    if ($autodeletefileanswer -eq 'Yes') {
        Write-Host 'mpv: Adding script delete_file_auto.lua' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/scripts/delete_file_auto.lua', "$env:SystemDrive$env:HOMEPATH\mpv\scripts\delete_file_auto.lua")
    }
}
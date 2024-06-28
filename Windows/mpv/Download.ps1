Write-Host 'mpv: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/zhongfly/mpv-winbuild/releases/latest').assets | Where-Object name -Like 'mpv-x86_64-v3*' ).browser_download_url, "$env:TEMP\mpv.7z")

Write-Host 'mpv: Extracting' -ForegroundColor green -BackgroundColor black
if ($false -eq (Test-Path "$env:ProgramFiles\7-Zip\7z.exe")) {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')
}
& "$env:ProgramFiles\7-Zip\7z.exe" x "$env:TEMP\mpv.7z" -o"$env:LOCALAPPDATA\mpv" -y

Write-Host 'mpv: Using custom settings for updater.bat' -ForegroundColor green -BackgroundColor black
New-Item -Path "$env:LOCALAPPDATA\mpv\settings.xml" -ItemType File -Value '<settings>
  <channel>daily</channel>
  <arch>x86_64-v3</arch>
  <autodelete>true</autodelete>
  <getffmpeg>true</getffmpeg>
  <getytdl>ytdlp</getytdl>
  <ytdlpchannel>master</ytdlpchannel>
</settings>' -Force

Write-Host 'mpv: Updating' -ForegroundColor green -BackgroundColor black
$MPV_Updater = 'MPV Updater'
$MPV_Updater_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $MPV_Updater }
if (!($MPV_Updater_Exists)) {
    Write-Host "mpv: Task Scheduler: Adding $MPV_Updater" -ForegroundColor green -BackgroundColor black
    $MPV_Updater_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $MPV_Updater_Action = New-ScheduledTaskAction -Execute "$env:LOCALAPPDATA\mpv\updater.bat"
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
Start-Process -FilePath "$env:LOCALAPPDATA\mpv\installer\mpv-install.bat" -ArgumentList '/u'

Write-Host 'mpv: Using custom settings for input.conf' -ForegroundColor green -BackgroundColor black
New-Item -Path "$env:LOCALAPPDATA\mpv\input.conf" -ItemType File -Value @'
# audio
a cycle audio
Ctrl+UP add audio-delay 0.1
Ctrl+DOWN add audio-delay -0.1

# fullscreen
f cycle fullscreen
MBTN_LEFT_DBL cycle fullscreen

# pause
ENTER cycle pause
SPACE cycle pause
MBTN_LEFT cycle pause

# run
GO_BACK run powershell -command "Add-Type -AssemblyName System.Windows.Forms;[System.Windows.Forms.SendKeys]::SendWait('%{TAB}')"

# quit
ESC quit
MENU quit

# screenshot
F12 screenshot

# script: console
` script-binding console/enable

# script: delete_file
BS script-binding delete_file/delete_file
DEL script-binding delete_file/delete_file

# script: stats
F11 script-binding stats/display-stats-toggle
TAB script-binding stats/display-stats-toggle
PLAYPAUSE script-binding stats/display-stats-toggle

# script: toggleconsole
PREV script-binding toggleconsole/__keybinding1

# seek
LEFT seek -1
NEXT seek +85
RIGHT seek +1
WHEEL_LEFT seek -1
WHEEL_RIGHT seek +1

# show
\ show-text ${metadata} 10000

# sub
s cycle sub
CTRL+- set sub-delay 0
CTRL+= add sub-delay -60
CTRL+LEFT add sub-delay -0.1
CTRL+RIGHT add sub-delay +0.1

# volume
UP osd-bar add volume +1
DOWN osd-bar add volume -1
WHEEL_UP osd-bar add volume +1
WHEEL_DOWN osd-bar add volume -1
'@ -Force

Write-Host 'mpv: Using custom settings for mpv.conf' -ForegroundColor green -BackgroundColor black
New-Item -Path "$env:LOCALAPPDATA\mpv\mpv.conf" -ItemType File -Value '# High Quality
profile=high-quality

# Player
fs=yes
keep-open=yes
hr-seek=yes
keep-open-pause=no
auto-window-resize=no
osd-bar-border-size=0.5
image-display-duration=0.4
input-default-bindings=no
watch-later-options-remove=pause

# Demuxer
demuxer-max-bytes=1GiB
demuxer-max-back-bytes=1GiB

# OSD
osd-bar-align-y=-0.98
osd-border-size=1
osd-font-size=30

# Audio
alang=ja,en
volume-max=100

# Video
hwdec=yes
vo=gpu-next
target-colorspace-hint=yes
video-sync=display-resample

# Subtitles
sub-auto=fuzzy
sub-file-paths=Subs;eng

# Screenshot
screenshot-format=png
screenshot-png-compression=0

# YouTube
ytdl-raw-options=mark-watched=,playlist-end=100' -Force

if (!(Test-Path -Path "$env:LOCALAPPDATA\mpv\scripts")) {
    Write-Host 'mpv: Creating scripts folder' -ForegroundColor green -BackgroundColor black
    New-Item -Path "$env:LOCALAPPDATA\mpv\scripts" -Value scripts -ItemType Directory
}

if (!(Test-Path -Path "$env:LOCALAPPDATA\mpv\script-opts")) {
    Write-Host 'mpv: Creating script-opts folder' -ForegroundColor green -BackgroundColor black
    New-Item -Path "$env:LOCALAPPDATA\mpv\script-opts" -Value script-opts -ItemType Directory
}

Write-Host 'mpv: Using custom settings for osc.conf' -ForegroundColor green -BackgroundColor black
New-Item -Path "$env:LOCALAPPDATA\mpv\script-opts\osc.conf" -ItemType File -Value 'idlescreen=no' -Force

Write-Host 'mpv: Adding script autoload.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mpv-player/mpv/master/TOOLS/lua/autoload.lua', "$env:LOCALAPPDATA\mpv\scripts\autoload.lua")

Write-Host 'mpv: Using custom settings for autoload.conf' -ForegroundColor green -BackgroundColor black
New-Item -Path "$env:LOCALAPPDATA\mpv\script-opts\autoload.conf" -ItemType File -Value 'directory_mode=recursive
additional_video_exts=vob
audio=no' -Force

Write-Host 'mpv: Adding script oled-screensaver.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Akemi/mpv-oled-screensaver/master/oled-screensaver.lua', "$env:LOCALAPPDATA\mpv\scripts\oled-screensaver.lua")

Write-Host 'mpv: Using custom settings for oled_screensaver.conf' -ForegroundColor green -BackgroundColor black
New-Item -Path "$env:LOCALAPPDATA\mpv\script-opts\oled_screensaver.conf" -ItemType File -Value 'startAfter=1
alphaStep=255' -Force

Write-Host 'mpv: Adding script celebi.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/po5/celebi/master/celebi.lua', "$env:LOCALAPPDATA\mpv\scripts\celebi.lua")

Write-Host 'mpv: Using custom settings for celebi.conf' -ForegroundColor green -BackgroundColor black
New-Item -Path "$env:LOCALAPPDATA\mpv\script-opts\celebi.conf" -ItemType File -Value 'volume=yes' -Force

Write-Host 'mpv: Adding script trackselect.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/po5/trackselect/master/trackselect.lua', "$env:LOCALAPPDATA\mpv\scripts\trackselect.lua")

Write-Host 'mpv: Using custom settings for trackselect.conf' -ForegroundColor green -BackgroundColor black
New-Item -Path "$env:LOCALAPPDATA\mpv\script-opts\trackselect.conf" -ItemType File -Value 'preferred_audio_lang=jp/ja/en
preferred_audio_channels=8/7/6/5/4/3/2/1
excluded_audio_words=Reanimedia
expected_audio_words=

preferred_sub_lang=en/he/iw
excluded_sub_words=sign/sdh/song
expected_sub_words=' -Force

Write-Host 'mpv: Adding script cookies.firefox-private.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/scripts/cookies.firefox-private.lua', "$env:LOCALAPPDATA\mpv\scripts\cookies.firefox-private.lua")

Write-Host 'mpv: Adding script hidecursor.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/scripts/hidecursor.lua', "$env:LOCALAPPDATA\mpv\scripts\hidecursor.lua")

Write-Host 'mpv: Adding script show-chapter.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/scripts/show-chapter.lua', "$env:LOCALAPPDATA\mpv\scripts\show-chapter.lua")

Write-Host 'mpv: Adding script toggleconsole.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/scripts/toggleconsole.lua', "$env:LOCALAPPDATA\mpv\scripts\toggleconsole.lua")

Write-Host 'mpv: Adding script alt-tab-1-sec-remaining.lua' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/scripts/alt-tab-1-sec-remaining.lua', "$env:LOCALAPPDATA\mpv\scripts\alt-tab-1-sec-remaining.lua")

Add-Type -AssemblyName System.Windows.Forms
$sponsorblockanswer = [System.Windows.Forms.MessageBox]::Show('Add sponsorblock?

Python will be installed.
' , 'mpv scripts' , 4, 32)
if ($sponsorblockanswer -eq 'Yes') {
    if (!(Test-Path -Path "$env:LOCALAPPDATA\mpv\scripts\sponsorblock_shared")) {
        Write-Host 'mpv: Creating sponsorblock_shared folder' -ForegroundColor green -BackgroundColor black
        New-Item -Path "$env:LOCALAPPDATA\mpv\scripts\sponsorblock_shared" -Value sponsorblock_shared -ItemType Directory
    }

    Write-Host 'mpv: Adding script sponsorblock.lua' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/po5/mpv_sponsorblock/master/sponsorblock.lua', "$env:LOCALAPPDATA\mpv\scripts\sponsorblock.lua")
    
    Write-Host 'mpv: Using custom settings for sponsorblock.conf' -ForegroundColor green -BackgroundColor black
    New-Item -Path "$env:LOCALAPPDATA\mpv\script-opts\sponsorblock.conf" -ItemType File -Value 'categories=sponsor,selfpromo,interaction,intro,outro,preview,music_offtopic,filler
skip_categories=sponsor,selfpromo,interaction,intro,outro,preview,music_offtopic,filler
skip_once=yes
report_views=no
fast_forward=no
fast_forward_increase=1
fast_forward_cap=5' -Force

    Write-Host 'mpv: Adding script sponsorblock.py' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/po5/mpv_sponsorblock/master/sponsorblock_shared/sponsorblock.py', "$env:LOCALAPPDATA\mpv\scripts\sponsorblock_shared/sponsorblock.py")
    
    Write-Host 'mpv: Adding script main.py' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/po5/mpv_sponsorblock/master/sponsorblock_shared/main.lua', "$env:LOCALAPPDATA\mpv\scripts\sponsorblock_shared/main.lua")
    
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
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/zenyd/mpv-scripts/master/delete_file.lua', "$env:LOCALAPPDATA\mpv\scripts\delete_file.lua")
    
    $autodeletefileanswer = [System.Windows.Forms.MessageBox]::Show('Add auto delete file?

Auto deletes current video file when 15 seconds remaining.
' , 'mpv scripts' , 4, 48)
    if ($autodeletefileanswer -eq 'Yes') {
        Write-Host 'mpv: Adding script delete_file_auto.lua' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/scripts/delete_file_auto.lua', "$env:LOCALAPPDATA\mpv\scripts\delete_file_auto.lua")
    }
}
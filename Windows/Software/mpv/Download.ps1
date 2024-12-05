$MPV_DDL = ((Invoke-RestMethod 'https://api.github.com/repos/zhongfly/mpv-winbuild/releases/latest').assets | Where-Object name -Like 'mpv-x86_64-v3*').browser_download_url
$MPV_Filename = [IO.Path]::GetFileName(([URI]$MPV_DDL).AbsolutePath)
$MPV_SavePath = [IO.Path]::Combine($env:TEMP, $MPV_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($MPV_DDL, $MPV_SavePath)

$MPV_Destination = [IO.Path]::Combine($env:USERPROFILE, 'mpv')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Software/7-Zip/Download.ps1')
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Destination'"); [Console]::ResetColor(); [Console]::WriteLine()
7z.exe x $MPV_SavePath -o"$MPV_Destination" -y

$MPV_SettingsXML_DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/settings.xml'
$MPV_SettingsXML_Filename = [IO.Path]::GetFileName(([URI]$MPV_SettingsXML_DDL).AbsolutePath)
$MPV_SettingsXML_SavePath = [IO.Path]::Combine($MPV_Destination, $MPV_SettingsXML_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' settings '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_SettingsXML_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_SettingsXML_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_SettingsXML_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($MPV_SettingsXML_DDL, $MPV_SettingsXML_SavePath)

$MPV_Updater = [IO.Path]::Combine($MPV_Destination, 'updater.bat')
$MPV_TaskName = 'MPV Updater'
if (-not (Get-ScheduledTask -TaskName $MPV_TaskName -ErrorAction SilentlyContinue)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_TaskName'"); [Console]::ResetColor(); [Console]::WriteLine()
    $MPV_TaskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN $MPV_Updater ^&exit"
    $MPV_TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
    $MPV_TaskPrincipal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $MPV_TaskSettings = New-ScheduledTaskSettingsSet -Compatibility Win8
    Register-ScheduledTask -TaskName $MPV_TaskName -Action $MPV_TaskAction -Trigger $MPV_TaskTrigger -Principal $MPV_TaskPrincipal -Settings $MPV_TaskSettings -Force
}
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Updating '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Updater'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-ScheduledTask -TaskName $MPV_TaskName
while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'cmd.exe' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}
while (-not ($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'cmd.exe' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}

$MPV_Installer = [IO.Path]::Combine($MPV_Destination, 'installer', 'mpv-install.bat')
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Installer'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process cmd.exe -ArgumentList "/C start /MIN $MPV_Installer /u ^&exit"

$mpv_OLD_PATH = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
if ($mpv_OLD_PATH -notlike "*$MPV_Destination*") {
    $mpv_NEW_PATH = "$mpv_OLD_PATH;$MPV_Destination"
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Destination'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'PATH'"); [Console]::ResetColor(); [Console]::WriteLine()
    [System.Environment]::SetEnvironmentVariable('Path', $mpv_NEW_PATH, [System.EnvironmentVariableTarget]::User)
    $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
}

$MPV_InputCONF_DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/input.conf'
$MPV_InputCONF_Filename = [IO.Path]::GetFileName(([URI]$MPV_InputCONF_DDL).AbsolutePath)
$MPV_InputCONF_SavePath = [IO.Path]::Combine($MPV_Destination, $MPV_InputCONF_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' settings '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_InputCONF_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_InputCONF_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_InputCONF_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($MPV_InputCONF_DDL, $MPV_InputCONF_SavePath)

$MPV_CONF_DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/mpv.conf'
$MPV_CONF_Filename = [IO.Path]::GetFileName(([URI]$MPV_CONF_DDL).AbsolutePath)
$MPV_CONF_SavePath = [IO.Path]::Combine($MPV_Destination, $MPV_CONF_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' settings '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_CONF_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_CONF_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_CONF_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($MPV_CONF_DDL, $MPV_CONF_SavePath)

$MPV_ScriptsPath = [IO.Path]::Combine($MPV_Destination, 'scripts')
if (-not (Test-Path -Path $MPV_ScriptsPath)) {
    New-Item $MPV_ScriptsPath -ItemType Directory -Force
}
$MPV_ScriptsURLs = @(
    'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/scripts/browser-switch.lua',
    'https://raw.githubusercontent.com/po5/celebi/master/celebi.lua',
    'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/scripts/hidecursor.lua',
    'https://raw.githubusercontent.com/Akemi/mpv-oled-screensaver/master/oled-screensaver.lua',
    'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/scripts/toggleconsole.lua',
    'https://raw.githubusercontent.com/po5/trackselect/master/trackselect.lua'

)
foreach ($MPV_ScriptURL in $MPV_ScriptsURLs) {
    $MPV_ScriptFilename = [IO.Path]::GetFileName(([URI]$MPV_ScriptURL).AbsolutePath)
    $MPV_ScriptSavePath = [IO.Path]::Combine($MPV_ScriptsPath, $MPV_ScriptFilename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' userscript '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_ScriptFilename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_ScriptURL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_ScriptSavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object Net.WebClient).DownloadFile($MPV_ScriptURL, $MPV_ScriptSavePath)
}
if ((Get-Package).Name -match 'Mozilla Firefox') {
    $MPV_Scripts_cookies_DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/scripts/firefox-cookies.lua'
    $MPV_Scripts_cookies_Filename = [IO.Path]::GetFileName(([URI]$MPV_Scripts_cookies_DDL).AbsolutePath)
    $MPV_Scripts_cookies_SavePath = [IO.Path]::Combine($MPV_ScriptsPath, $MPV_Scripts_cookies_Filename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' userscript '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Scripts_cookies_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Scripts_cookies_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Scripts_cookies_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($MPV_Scripts_cookies_DDL, $MPV_Scripts_cookies_SavePath)
}

$MPV_ScriptOptsPath = [IO.Path]::Combine($MPV_Destination, 'script-opts')
if (-not (Test-Path -Path $MPV_ScriptOptsPath)) {
    New-Item $MPV_ScriptOptsPath -ItemType Directory -Force
}
$MPV_ScriptOptsURLs = @(
    'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/script-opts/celebi.conf',
    'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/script-opts/oled_screensaver.conf',
    'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/script-opts/osc.conf',
    'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/script-opts/trackselect.conf'
)
foreach ($MPV_ScriptOptURL in $MPV_ScriptOptsURLs) {
    $MPV_ScriptOptFilename = [IO.Path]::GetFileName(([URI]$MPV_ScriptOptURL).AbsolutePath)
    $MPV_ScriptOptSavePath = [IO.Path]::Combine($MPV_ScriptOptsPath, $MPV_ScriptOptFilename)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' userscript settings '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_ScriptOptFilename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_ScriptOptURL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_ScriptOptSavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object Net.WebClient).DownloadFile($MPV_ScriptOptURL, $MPV_ScriptOptSavePath)
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$mpv_Form = New-Object System.Windows.Forms.Form
$mpv_Form.width = 350
$mpv_Form.height = 150
$mpv_Form.Text = 'mpv'
$mpv_Form.StartPosition = 'CenterScreen'
$mpv_Form.Font = New-Object System.Drawing.Font('Tahoma', 11)
$mpv_Form.Topmost = $true
$mpv_Form.MaximizeBox = $false
$mpv_Form.MinimizeBox = $false
$mpv_Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

$mpv_X_Axis = 5
$mpv_Y_Axis = 0
$mpv_Size_X = (($mpv_Form.width) - 25)
$mpv_Size_Y = 26
$mpv_LocationAdd = 26

$CheckBox_SponsorBlock = New-Object System.Windows.Forms.CheckBox
$CheckBox_SponsorBlock.Location = New-Object System.Drawing.Size($mpv_X_Axis, $mpv_Y_Axis)
$mpv_Y_Axis += $mpv_LocationAdd
$CheckBox_SponsorBlock.Size = New-Object System.Drawing.Size($mpv_Size_X, $mpv_Size_Y)
$CheckBox_SponsorBlock.Text = 'SponsorBlock'
$CheckBox_SponsorBlock.Checked = $false
$mpv_Form.Controls.Add($CheckBox_SponsorBlock)

$CheckBox_DeleteFile = New-Object System.Windows.Forms.CheckBox
$CheckBox_DeleteFile.Location = New-Object System.Drawing.Size($mpv_X_Axis, $mpv_Y_Axis)
$mpv_Y_Axis += $mpv_LocationAdd
$CheckBox_DeleteFile.Size = New-Object System.Drawing.Size($mpv_Size_X, $mpv_Size_Y)
$CheckBox_DeleteFile.Text = 'Delete File'
$CheckBox_DeleteFile.Checked = $false
$mpv_Form.Controls.Add($CheckBox_DeleteFile)

$CheckBox_AutoDeleteFile = New-Object System.Windows.Forms.CheckBox
$CheckBox_AutoDeleteFile.Location = New-Object System.Drawing.Size($mpv_X_Axis, $mpv_Y_Axis)
$mpv_Y_Axis += $mpv_LocationAdd
$CheckBox_AutoDeleteFile.Size = New-Object System.Drawing.Size($mpv_Size_X, $mpv_Size_Y)
$CheckBox_AutoDeleteFile.Text = 'Auto Delete File'
$CheckBox_AutoDeleteFile.Checked = $false
$CheckBox_AutoDeleteFile.Enabled = $false
$mpv_Form.Controls.Add($CheckBox_AutoDeleteFile)

$mpv_Form_OK = New-Object System.Windows.Forms.Button
$mpv_Form_OK.Location = New-Object System.Drawing.Size((($mpv_Form.Width) / 3 ), (($mpv_Form.height) - 60))
$mpv_Form_OK.Size = New-Object System.Drawing.Size(57, 20)
$mpv_Form_OK.Text = 'OK'
$mpv_Form_OK.Add_Click({ $mpv_Form.Close() })
$mpv_Form.Controls.Add($mpv_Form_OK)

$mpv_Form_Cancel = New-Object System.Windows.Forms.Button
$mpv_Form_Cancel.Location = New-Object System.Drawing.Size((($mpv_Form.Width) / 2 ), (($mpv_Form.height) - 60))
$mpv_Form_Cancel.Size = New-Object System.Drawing.Size(57, 20)
$mpv_Form_Cancel.Text = 'Cancel'
$mpv_Form_Cancel.Add_Click({ $mpv_Form.Close() })
$mpv_Form.Controls.Add($mpv_Form_Cancel)

$CheckBox_DeleteFile.Add_Click( {
        if ($CheckBox_DeleteFile.Checked -eq $true) {
            $CheckBox_AutoDeleteFile.Enabled = $true
        }
        elseif ($CheckBox_DeleteFile.Checked -eq $false) {
            $CheckBox_AutoDeleteFile.Enabled = $false
        }   
    }
)

$mpv_Form_OK.Add_Click{
    $mpv_Form.Topmost = $false
    if ($CheckBox_SponsorBlock.Checked -eq $true) {

        $MPV_Scripts_sponsorblock_DDL = 'https://raw.githubusercontent.com/po5/mpv_sponsorblock/master/sponsorblock.lua'
        $MPV_Scripts_sponsorblock_Filename = [IO.Path]::GetFileName(([URI]$MPV_Scripts_sponsorblock_DDL).AbsolutePath)
        $MPV_Scripts_sponsorblock_SavePath = [IO.Path]::Combine($MPV_ScriptsPath, $MPV_Scripts_sponsorblock_Filename)
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' userscript '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Scripts_sponsorblock_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Scripts_sponsorblock_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Scripts_sponsorblock_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
        (New-Object System.Net.WebClient).DownloadFile($MPV_Scripts_sponsorblock_DDL, $MPV_Scripts_sponsorblock_SavePath)

        $MPV_ScriptOpts_sponsorblock_DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/script-opts/sponsorblock.conf'
        $MPV_ScriptOpts_sponsorblock_Filename = [IO.Path]::GetFileName(([URI]$MPV_ScriptOpts_sponsorblock_DDL).AbsolutePath)
        $MPV_ScriptOpts_sponsorblock_SavePath = [IO.Path]::Combine($MPV_ScriptOptsPath, $MPV_ScriptOpts_sponsorblock_Filename)
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' userscript settings '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_ScriptOpts_sponsorblock_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_ScriptOpts_sponsorblock_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_ScriptOpts_sponsorblock_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
        (New-Object System.Net.WebClient).DownloadFile($MPV_ScriptOpts_sponsorblock_DDL, $MPV_ScriptOpts_sponsorblock_SavePath)
        
        $MPV_Scripts_DIR_sponsorblock = [IO.Path]::Combine($MPV_ScriptsPath, 'sponsorblock_shared')
        if (-not (Test-Path -Path $MPV_Scripts_DIR_sponsorblock)) {
            New-Item $MPV_Scripts_DIR_sponsorblock -ItemType Directory -Force
        }
        $MPV_Scripts_sponsorblockpy_DDL = 'https://raw.githubusercontent.com/po5/mpv_sponsorblock/master/sponsorblock_shared/sponsorblock.py'
        $MPV_Scripts_sponsorblockpy_Filename = [IO.Path]::GetFileName(([URI]$MPV_Scripts_sponsorblockpy_DDL).AbsolutePath)
        $MPV_Scripts_sponsorblockpy_SavePath = [IO.Path]::Combine($MPV_Scripts_DIR_sponsorblock, $MPV_Scripts_sponsorblockpy_Filename)
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' userscript '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Scripts_sponsorblockpy_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Scripts_sponsorblockpy_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Scripts_sponsorblockpy_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
        (New-Object System.Net.WebClient).DownloadFile($MPV_Scripts_sponsorblockpy_DDL, $MPV_Scripts_sponsorblockpy_SavePath)
		
        $MPV_Scripts_sponsorblockmainlua_DDL = 'https://raw.githubusercontent.com/po5/mpv_sponsorblock/master/sponsorblock_shared/main.lua'
        $MPV_Scripts_sponsorblockmainlua_Filename = [IO.Path]::GetFileName(([URI]$MPV_Scripts_sponsorblockmainlua_DDL).AbsolutePath)
        $MPV_Scripts_sponsorblockmainlua_SavePath = [IO.Path]::Combine($MPV_Scripts_DIR_sponsorblock, $MPV_Scripts_sponsorblockmainlua_Filename)
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' userscript '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Scripts_sponsorblockmainlua_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Scripts_sponsorblockmainlua_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Scripts_sponsorblockmainlua_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
        (New-Object System.Net.WebClient).DownloadFile($MPV_Scripts_sponsorblockmainlua_DDL, $MPV_Scripts_sponsorblockmainlua_SavePath)
		
        $InstalledSoftware = Get-Package | Select-Object -Property 'Name'
        if (-not ($InstalledSoftware -match 'Python')) {
            Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Python/Download.ps1')
        }
    }

    if ($CheckBox_DeleteFile.Checked -eq $true) {
        $MPV_Scripts_deletefile_DDL = 'https://raw.githubusercontent.com/zenyd/mpv-scripts/master/delete_file.lua'
        $MPV_Scripts_deletefile_Filename = [IO.Path]::GetFileName(([URI]$MPV_Scripts_deletefile_DDL).AbsolutePath)
        $MPV_Scripts_deletefile_SavePath = [IO.Path]::Combine($MPV_ScriptsPath, $MPV_Scripts_deletefile_Filename)
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' userscript '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Scripts_deletefile_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Scripts_deletefile_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Scripts_deletefile_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
        (New-Object System.Net.WebClient).DownloadFile($MPV_Scripts_deletefile_DDL, $MPV_Scripts_deletefile_SavePath)
    }

    if ($CheckBox_AutoDeleteFile.Checked -eq $true) {
        $MPV_Scripts_deletefileauto_DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/scripts/delete_file_auto.lua'
        $MPV_Scripts_deletefileauto_Filename = [IO.Path]::GetFileName(([URI]$MPV_Scripts_deletefileauto_DDL).AbsolutePath)
        $MPV_Scripts_deletefileauto_SavePath = [IO.Path]::Combine($MPV_ScriptsPath, $MPV_Scripts_deletefileauto_Filename)
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' userscript '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Scripts_deletefileauto_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Scripts_deletefileauto_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Scripts_deletefileauto_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
        (New-Object System.Net.WebClient).DownloadFile($MPV_Scripts_deletefileauto_DDL, $MPV_Scripts_deletefileauto_SavePath)
    }
}

$mpv_Form.Add_Shown({ $mpv_Form.Activate() })
[void] $mpv_Form.ShowDialog()
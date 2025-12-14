$MPV_DDL = ((Invoke-RestMethod -Uri 'https://api.github.com/repos/zhongfly/mpv-winbuild/releases/latest').assets | Where-Object { $_.name -match 'mpv-x86_64-v3' }).browser_download_url
$MPV_FileName = [IO.Path]::GetFileName(([URI]$MPV_DDL).AbsolutePath)
$MPV_SavePath = [IO.Path]::Combine($env:TEMP, $MPV_FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($MPV_DDL, $MPV_SavePath)

$MPV_Destination = [IO.Path]::Combine($env:USERPROFILE, 'mpv')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/7-Zip/Download.ps1')
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Destination'"); [Console]::ResetColor(); [Console]::WriteLine()
& 7z.exe x $MPV_SavePath -o"$MPV_Destination" -y

$DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/settings.xml'
$FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
$SavePath = [IO.Path]::Combine($MPV_Destination, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' settings '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

$OLD_PATH = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::User)
if (-not ($OLD_PATH.Contains($MPV_Destination))) {
    $NEW_PATH = "$OLD_PATH;$MPV_Destination"
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adding '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$MPV_Destination'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'PATH'"); [Console]::ResetColor(); [Console]::WriteLine()
    [Environment]::SetEnvironmentVariable('Path', $NEW_PATH, [EnvironmentVariableTarget]::User)
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [Environment]::GetEnvironmentVariable('Path', 'User')
}

& mpv.exe --register

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/Updater.ps1')

$DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/input.conf'
$FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
$SavePath = [IO.Path]::Combine($MPV_Destination, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' settings '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

$DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/mpv.conf'
$FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
$SavePath = [IO.Path]::Combine($MPV_Destination, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' settings '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

$DDL = ((Invoke-RestMethod -Uri 'https://api.github.com/repos/igv/FSRCNN-TensorFlow/releases/latest').assets | Where-Object { $_.name -match 'FSRCNNX_x2_16' }).browser_download_url
$FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
$SavePath = [IO.Path]::Combine($MPV_Destination, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

$DDL = ((Invoke-RestMethod -Uri 'https://api.github.com/repos/igv/FSRCNN-TensorFlow/releases/latest').assets | Where-Object { $_.name -match 'FSRCNNX_x2_8' }).browser_download_url
$FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
$SavePath = [IO.Path]::Combine($MPV_Destination, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

$DDL = 'https://gist.githubusercontent.com/igv/a015fc885d5c22e6891820ad89555637/raw/'
$FileName = 'KrigBilateral.glsl'
$SavePath = [IO.Path]::Combine($MPV_Destination, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

$ScriptsPath = [IO.Path]::Combine($MPV_Destination, 'scripts')
if (-not (Test-Path -Path $ScriptsPath)) {
    New-Item $ScriptsPath -ItemType Directory -Force
}
$ScriptsURLs = @(
    'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/scripts/browser-switch.lua',
    'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/scripts/clipboard_monitor.lua',
    'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/scripts/toggle-reader.lua',
    'https://raw.githubusercontent.com/po5/celebi/master/celebi.lua',
    'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/scripts/hidecursor.lua',
    'https://raw.githubusercontent.com/Akemi/mpv-oled-screensaver/master/oled-screensaver.lua',
    'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/scripts/toggleconsole.lua',
    'https://raw.githubusercontent.com/po5/trackselect/master/trackselect.lua'

)
foreach ($ScriptURL in $ScriptsURLs) {
    $FileName = [IO.Path]::GetFileName(([URI]$ScriptURL).AbsolutePath)
    $SavePath = [IO.Path]::Combine($ScriptsPath, $FileName)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' userscript '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ScriptURL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object Net.WebClient).DownloadFile($ScriptURL, $SavePath)
}
if ((Get-Package).Name -match 'Mozilla Firefox') {
    $DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/scripts/firefox-cookies.lua'
    $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
    $SavePath = [IO.Path]::Combine($ScriptsPath, $FileName)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' userscript '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)
}

$ScriptOptsPath = [IO.Path]::Combine($MPV_Destination, 'script-opts')
if (-not (Test-Path -Path $ScriptOptsPath)) {
    New-Item $ScriptOptsPath -ItemType Directory -Force
}
$ScriptOptsURLs = @(
    'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/script-opts/celebi.conf',
    'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/script-opts/oled_screensaver.conf',
    'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/script-opts/osc.conf',
    'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/script-opts/trackselect.conf'
)
foreach ($ScriptOptURL in $ScriptOptsURLs) {
    $FileName = [IO.Path]::GetFileName(([URI]$ScriptOptURL).AbsolutePath)
    $SavePath = [IO.Path]::Combine($ScriptOptsPath, $FileName)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' userscript settings '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ScriptOptURL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object Net.WebClient).DownloadFile($ScriptOptURL, $SavePath)
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object System.Windows.Forms.Form
$Form.width = 350
$Form.height = 150
$Form.Text = 'mpv'
$Form.StartPosition = 'CenterScreen'
$Form.Font = New-Object System.Drawing.Font('Tahoma', 11)
$Form.Topmost = $true
$Form.MaximizeBox = $false
$Form.MinimizeBox = $false
$Form.FormBorderStyle = [Windows.Forms.FormBorderStyle]::FixedDialog

$X_Axis = 5
$Y_Axis = 0
$Size_X = (($Form.width) - 25)
$Size_Y = 26
$LocationAdd = 26

$CheckBox_SponsorBlock = New-Object System.Windows.Forms.CheckBox
$CheckBox_SponsorBlock.Location = New-Object System.Drawing.Size($X_Axis, $Y_Axis)
$Y_Axis += $LocationAdd
$CheckBox_SponsorBlock.Size = New-Object System.Drawing.Size($Size_X, $Size_Y)
$CheckBox_SponsorBlock.Text = 'SponsorBlock'
$CheckBox_SponsorBlock.Checked = $false
$Form.Controls.Add($CheckBox_SponsorBlock)

$CheckBox_DeleteFile = New-Object System.Windows.Forms.CheckBox
$CheckBox_DeleteFile.Location = New-Object System.Drawing.Size($X_Axis, $Y_Axis)
$Y_Axis += $LocationAdd
$CheckBox_DeleteFile.Size = New-Object System.Drawing.Size($Size_X, $Size_Y)
$CheckBox_DeleteFile.Text = 'Delete File'
$CheckBox_DeleteFile.Checked = $false
$Form.Controls.Add($CheckBox_DeleteFile)

$CheckBox_AutoDeleteFile = New-Object System.Windows.Forms.CheckBox
$CheckBox_AutoDeleteFile.Location = New-Object System.Drawing.Size($X_Axis, $Y_Axis)
$Y_Axis += $LocationAdd
$CheckBox_AutoDeleteFile.Size = New-Object System.Drawing.Size($Size_X, $Size_Y)
$CheckBox_AutoDeleteFile.Text = 'Auto Delete File'
$CheckBox_AutoDeleteFile.Checked = $false
$CheckBox_AutoDeleteFile.Enabled = $false
$Form.Controls.Add($CheckBox_AutoDeleteFile)

$Form_OK = New-Object System.Windows.Forms.Button
$Form_OK.Location = New-Object System.Drawing.Size((($Form.Width) / 3 ), (($Form.height) - 60))
$Form_OK.Size = New-Object System.Drawing.Size(57, 20)
$Form_OK.Text = 'OK'
$Form_OK.Add_Click({ $Form.Close() })
$Form.Controls.Add($Form_OK)

$Form_Cancel = New-Object System.Windows.Forms.Button
$Form_Cancel.Location = New-Object System.Drawing.Size((($Form.Width) / 2 ), (($Form.height) - 60))
$Form_Cancel.Size = New-Object System.Drawing.Size(57, 20)
$Form_Cancel.Text = 'Cancel'
$Form_Cancel.Add_Click({ $Form.Close() })
$Form.Controls.Add($Form_Cancel)

$CheckBox_DeleteFile.Add_Click({
        if ($CheckBox_DeleteFile.Checked -eq $true) {
            $CheckBox_AutoDeleteFile.Enabled = $true
        }
        elseif ($CheckBox_DeleteFile.Checked -eq $false) {
            $CheckBox_AutoDeleteFile.Enabled = $false
        }   
    })

$Form_OK.Add_Click({
        $Form.Topmost = $false
        if ($CheckBox_SponsorBlock.Checked -eq $true) {

            $DDL = 'https://raw.githubusercontent.com/po5/mpv_sponsorblock/master/sponsorblock.lua'
            # $DDL = 'https://raw.githubusercontent.com/alopatindev/mpv_sponsorblock/ff13c937f9ba0897f78a828cc7b833081baf73ae/sponsorblock.lua' # PR to add `poi_highlight`
            $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
            $SavePath = [IO.Path]::Combine($ScriptsPath, $FileName)
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' userscript '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

            $DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/script-opts/sponsorblock.conf'
            $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
            $SavePath = [IO.Path]::Combine($ScriptOptsPath, $FileName)
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' userscript settings '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)
        
            $DIR_sponsorblock = [IO.Path]::Combine($ScriptsPath, 'sponsorblock_shared')
            if (-not (Test-Path -Path $DIR_sponsorblock)) {
                New-Item $DIR_sponsorblock -ItemType Directory -Force
            }
            $DDL = 'https://raw.githubusercontent.com/po5/mpv_sponsorblock/master/sponsorblock_shared/sponsorblock.py'
            $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
            $SavePath = [IO.Path]::Combine($DIR_sponsorblock, $FileName)
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' userscript '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)
		
            $DDL = 'https://raw.githubusercontent.com/po5/mpv_sponsorblock/master/sponsorblock_shared/main.lua'
            $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
            $SavePath = [IO.Path]::Combine($DIR_sponsorblock, $FileName)
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' userscript '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)
		
            $InstalledSoftware = (Get-Package).Name
            if (-not ($InstalledSoftware -match 'Python')) {
                Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Python/Download.ps1')
            }
        }

        if ($CheckBox_DeleteFile.Checked -eq $true) {
            $DDL = 'https://raw.githubusercontent.com/zenyd/mpv-scripts/master/delete_file.lua'
            $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
            $SavePath = [IO.Path]::Combine($ScriptsPath, $FileName)
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' userscript '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)
        }

        if ($CheckBox_AutoDeleteFile.Checked -eq $true) {
            $DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/mpv/scripts/delete_file_auto.lua'
            $FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
            $SavePath = [IO.Path]::Combine($ScriptsPath, $FileName)
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'mpv'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' userscript '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)
        }
    })

$Form.Add_Shown({ $Form.Activate() })
[void] $Form.ShowDialog()
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

$mpvExtractPath = "$env:USERPROFILE\mpv"
$path = [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User)
if ($path -notlike "*$mpvExtractPath*") {
    $newPath = "$path;$mpvExtractPath"
    [System.Environment]::SetEnvironmentVariable('Path', $newPath, [System.EnvironmentVariableTarget]::User)
    Write-Host 'mpv: Adding to the PATH environment' -ForegroundColor green -BackgroundColor black
}

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

    if ($CheckBox_DeleteFile.Checked -eq $true) {
        Write-Host 'mpv: Adding script delete_file.lua' -ForegroundColor green -BackgroundColor black
    	(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/zenyd/mpv-scripts/master/delete_file.lua', "$env:SystemDrive$env:HOMEPATH\mpv\scripts\delete_file.lua")
    }

    if ($CheckBox_AutoDeleteFile.Checked -eq $true) {
        Write-Host 'mpv: Adding script delete_file_auto.lua' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/scripts/delete_file_auto.lua', "$env:SystemDrive$env:HOMEPATH\mpv\scripts\delete_file_auto.lua")
    }

}
$mpv_Form.Add_Shown({ $mpv_Form.Activate() })
[void] $mpv_Form.ShowDialog()
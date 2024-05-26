[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')
[void] [System.Windows.Forms.Application]::EnableVisualStyles()

$Form_SoftwareSelection = New-Object System.Windows.Forms.Form
$Form_SoftwareSelection.width = 500
$Form_SoftwareSelection.height = 640
$Form_SoftwareSelection.Text = 'Software Selection'
$Form_SoftwareSelection.StartPosition = 'CenterScreen'
$Form_SoftwareSelection.Font = New-Object System.Drawing.Font('Tahoma', 11)

$InstalledSoftware = Get-Package | Select-Object -Property 'Name'

$CheckBox_7Zip = New-Object System.Windows.Forms.CheckBox
$CheckBox_7Zip.Location = New-Object System.Drawing.Size(30, 20)
$CheckBox_7Zip.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_7Zip.Text = '7-Zip'
$CheckBox_7Zip.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_7Zip)

if ($InstalledSoftware -match '7-Zip') {
    $CheckBox_7Zip.Enabled = $false
    $CheckBox_7Zip.Text += ' (Installed)'
}

$CheckBox_AnyDesk = New-Object System.Windows.Forms.CheckBox
$CheckBox_AnyDesk.Location = New-Object System.Drawing.Size(30, 40)
$CheckBox_AnyDesk.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_AnyDesk.Text = 'AnyDesk'
$CheckBox_AnyDesk.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_AnyDesk)

if ($InstalledSoftware -match 'AnyDesk') {
    $CheckBox_AnyDesk.Enabled = $false
    $CheckBox_AnyDesk.Text += ' (Installed)'
}

$CheckBox_BattleNet = New-Object System.Windows.Forms.CheckBox
$CheckBox_BattleNet.Location = New-Object System.Drawing.Size(30, 60)
$CheckBox_BattleNet.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_BattleNet.Text = 'Battle.net'
$CheckBox_BattleNet.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_BattleNet)

if ($InstalledSoftware -match 'Battle.net') {
    $CheckBox_BattleNet.Enabled = $false
    $CheckBox_BattleNet.Text += ' (Installed)'

}

$CheckBox_CrystalDiskInfo = New-Object System.Windows.Forms.CheckBox
$CheckBox_CrystalDiskInfo.Location = New-Object System.Drawing.Size(30, 80)
$CheckBox_CrystalDiskInfo.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_CrystalDiskInfo.Text = 'CrystalDiskInfo'
$CheckBox_CrystalDiskInfo.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_CrystalDiskInfo)

if ($InstalledSoftware -match 'CrystalDiskInfo') {
    $CheckBox_CrystalDiskInfo.Enabled = $false
    $CheckBox_CrystalDiskInfo.Text += ' (Installed)'
}

$CheckBox_CrystalDiskMark = New-Object System.Windows.Forms.CheckBox
$CheckBox_CrystalDiskMark.Location = New-Object System.Drawing.Size(30, 100)
$CheckBox_CrystalDiskMark.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_CrystalDiskMark.Text = 'CrystalDiskMark'
$CheckBox_CrystalDiskMark.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_CrystalDiskMark)

if ($InstalledSoftware -match 'CrystalDiskMark') {
    $CheckBox_CrystalDiskMark.Enabled = $false
    $CheckBox_CrystalDiskMark.Text += ' (Installed)'
}

$CheckBox_Discord = New-Object System.Windows.Forms.CheckBox
$CheckBox_Discord.Location = New-Object System.Drawing.Size(30, 120)
$CheckBox_Discord.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_Discord.Text = 'Discord'
$CheckBox_Discord.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_Discord)

if ($InstalledSoftware -match 'Discord') {
    $CheckBox_Discord.Enabled = $false
    $CheckBox_Discord.Text += ' (Installed)'
}

$CheckBox_DisplayDriverUninstaller = New-Object System.Windows.Forms.CheckBox
$CheckBox_DisplayDriverUninstaller.Location = New-Object System.Drawing.Size(30, 140)
$CheckBox_DisplayDriverUninstaller.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_DisplayDriverUninstaller.Text = 'Display Driver Uninstaller'
$CheckBox_DisplayDriverUninstaller.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_DisplayDriverUninstaller)

if ($InstalledSoftware -match 'Display Driver Uninstaller') {
    $CheckBox_DisplayDriverUninstaller.Enabled = $false
    $CheckBox_DisplayDriverUninstaller.Text += ' (Installed)'
}

$CheckBox_HyperXNGENUITY = New-Object System.Windows.Forms.CheckBox
$CheckBox_HyperXNGENUITY.Location = New-Object System.Drawing.Size(30, 160)
$CheckBox_HyperXNGENUITY.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_HyperXNGENUITY.Text = 'HyperX NGENUITY'
$CheckBox_HyperXNGENUITY.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_HyperXNGENUITY)

if ((Get-ChildItem $env:ProgramFiles\WindowsApps) -like '*NGENUITY*') {
    $CheckBox_HyperXNGENUITY.Enabled = $false
    $CheckBox_HyperXNGENUITY.Text += ' (Installed)'
}


$CheckBox_Jellyfin = New-Object System.Windows.Forms.CheckBox
$CheckBox_Jellyfin.Location = New-Object System.Drawing.Size(30, 180)
$CheckBox_Jellyfin.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_Jellyfin.Text = 'Jellyfin'
$CheckBox_Jellyfin.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_Jellyfin)

if ($InstalledSoftware -match 'Jellyfin') {
    $CheckBox_Jellyfin.Enabled = $false
    $CheckBox_Jellyfin.Text += ' (Installed)'
}

$CheckBox_LogitechGHUB = New-Object System.Windows.Forms.CheckBox
$CheckBox_LogitechGHUB.Location = New-Object System.Drawing.Size(30, 200)
$CheckBox_LogitechGHUB.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_LogitechGHUB.Text = 'Logitech G HUB'
$CheckBox_LogitechGHUB.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_LogitechGHUB)

if ($InstalledSoftware -match 'Logitech G HUB') {
    $CheckBox_LogitechGHUB.Enabled = $false
    $CheckBox_LogitechGHUB.Text += ' (Installed)'
}

$CheckBox_MediaInfo = New-Object System.Windows.Forms.CheckBox
$CheckBox_MediaInfo.Location = New-Object System.Drawing.Size(30, 220)
$CheckBox_MediaInfo.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_MediaInfo.Text = 'MediaInfo'
$CheckBox_MediaInfo.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_MediaInfo)

if ($InstalledSoftware -match 'MediaInfo') {
    $CheckBox_MediaInfo.Enabled = $false
    $CheckBox_MediaInfo.Text += ' (Installed)'
}

$CheckBox_NVCleanstall = New-Object System.Windows.Forms.CheckBox
$CheckBox_NVCleanstall.Location = New-Object System.Drawing.Size(30, 240)
$CheckBox_NVCleanstall.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_NVCleanstall.Text = 'NVCleanstall'
$CheckBox_NVCleanstall.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_NVCleanstall)

If ((Get-WmiObject Win32_VideoController).Name -like '*NVIDIA*') {
    $CheckBox_NVCleanstall.Text += ' (Compatible GPU)'
}

If ((Get-WmiObject Win32_VideoController).Name -notlike '*NVIDIA*') {
    $CheckBox_NVCleanstall.Text += ' (Incompatible GPU)'
    $CheckBox_NVCleanstall.Enabled = $false
}

if ($InstalledSoftware -match 'NVCleanstall') {
    $CheckBox_NVCleanstall.Enabled = $false
    $CheckBox_NVCleanstall.Text += ' (Installed)'
}

$CheckBox_NordVPN = New-Object System.Windows.Forms.CheckBox
$CheckBox_NordVPN.Location = New-Object System.Drawing.Size(30, 260)
$CheckBox_NordVPN.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_NordVPN.Text = 'NordVPN'
$CheckBox_NordVPN.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_NordVPN)

if ($InstalledSoftware -match 'NordVPN') {
    $CheckBox_NordVPN.Enabled = $false
    $CheckBox_NordVPN.Text += ' (Installed)'
}

$CheckBox_NotepadPlusPlus = New-Object System.Windows.Forms.CheckBox
$CheckBox_NotepadPlusPlus.Location = New-Object System.Drawing.Size(30, 280)
$CheckBox_NotepadPlusPlus.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_NotepadPlusPlus.Text = 'Notepad++'
$CheckBox_NotepadPlusPlus.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_NotepadPlusPlus)

if ($InstalledSoftware -match 'Notepad..') {
    $CheckBox_NotepadPlusPlus.Enabled = $false
    $CheckBox_NotepadPlusPlus.Text += ' (Installed)'
}

$CheckBox_MicrosoftOffice = New-Object System.Windows.Forms.CheckBox
$CheckBox_MicrosoftOffice.Location = New-Object System.Drawing.Size(30, 300)
$CheckBox_MicrosoftOffice.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_MicrosoftOffice.Text = 'Microsoft Office'
$CheckBox_MicrosoftOffice.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_MicrosoftOffice)

if ($InstalledSoftware -match 'Microsoft Office' -or $InstalledSoftware -match 'Microsoft 365') {
    $CheckBox_MicrosoftOffice.Enabled = $false
    $CheckBox_MicrosoftOffice.Text += ' (Installed)'
}

$CheckBox_Plex = New-Object System.Windows.Forms.CheckBox
$CheckBox_Plex.Location = New-Object System.Drawing.Size(30, 320)
$CheckBox_Plex.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_Plex.Text = 'Plex'
$CheckBox_Plex.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_Plex)

if ($InstalledSoftware -match 'Plex') {
    $CheckBox_Plex.Enabled = $false
    $CheckBox_Plex.Text += ' (Installed)'
}

$CheckBox_PuTTY = New-Object System.Windows.Forms.CheckBox
$CheckBox_PuTTY.Location = New-Object System.Drawing.Size(30, 340)
$CheckBox_PuTTY.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_PuTTY.Text = 'PuTTY'
$CheckBox_PuTTY.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_PuTTY)

if ($InstalledSoftware -match 'PuTTY') {
    $CheckBox_PuTTY.Enabled = $false
    $CheckBox_PuTTY.Text += ' (Installed)'
}

$CheckBox_Python = New-Object System.Windows.Forms.CheckBox
$CheckBox_Python.Location = New-Object System.Drawing.Size(30, 360)
$CheckBox_Python.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_Python.Text = 'Python'
$CheckBox_Python.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_Python)

if ($InstalledSoftware -match 'Python') {
    $CheckBox_Python.Enabled = $false
    $CheckBox_Python.Text += ' (Installed)'
}

$CheckBox_RazerSynapse = New-Object System.Windows.Forms.CheckBox
$CheckBox_RazerSynapse.Location = New-Object System.Drawing.Size(30, 380)
$CheckBox_RazerSynapse.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_RazerSynapse.Text = 'Razer Synapse'
$CheckBox_RazerSynapse.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_RazerSynapse)

if ($InstalledSoftware -match 'Razer Synapse') {
    $CheckBox_RazerSynapse.Enabled = $false
    $CheckBox_RazerSynapse.Text += ' (Installed)'
}

$CheckBox_Steam = New-Object System.Windows.Forms.CheckBox
$CheckBox_Steam.Location = New-Object System.Drawing.Size(30, 400)
$CheckBox_Steam.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_Steam.Text = 'Steam'
$CheckBox_Steam.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_Steam)

if ($InstalledSoftware -match 'Steam') {
    $CheckBox_Steam.Enabled = $false
    $CheckBox_Steam.Text += ' (Installed)'
}

$CheckBox_Telegram = New-Object System.Windows.Forms.CheckBox
$CheckBox_Telegram.Location = New-Object System.Drawing.Size(30, 420)
$CheckBox_Telegram.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_Telegram.Text = 'Telegram'
$CheckBox_Telegram.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_Telegram)

if ($InstalledSoftware -match 'Telegram') {
    $CheckBox_Telegram.Enabled = $false
    $CheckBox_Telegram.Text += ' (Installed)'
}

$CheckBox_VisualStudioCode = New-Object System.Windows.Forms.CheckBox
$CheckBox_VisualStudioCode.Location = New-Object System.Drawing.Size(30, 440)
$CheckBox_VisualStudioCode.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_VisualStudioCode.Text = 'Visual Studio Code'
$CheckBox_VisualStudioCode.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_VisualStudioCode)

if ($InstalledSoftware -match 'Visual Studio Code') {
    $CheckBox_VisualStudioCode.Enabled = $false
    $CheckBox_VisualStudioCode.Text += ' (Installed)'
}

$CheckBox_mpv = New-Object System.Windows.Forms.CheckBox
$CheckBox_mpv.Location = New-Object System.Drawing.Size(30, 460)
$CheckBox_mpv.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_mpv.Text = 'mpv'
$CheckBox_mpv.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_mpv)

if ((Test-Path -Path $env:ProgramFiles\mpv)) {
    $CheckBox_mpv.Enabled = $false
    $CheckBox_mpv.Text += ' (Installed)'
}

$CheckBox_qBittorrent = New-Object System.Windows.Forms.CheckBox
$CheckBox_qBittorrent.Location = New-Object System.Drawing.Size(30, 480)
$CheckBox_qBittorrent.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_qBittorrent.Text = 'qBittorrent'
$CheckBox_qBittorrent.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_qBittorrent)

if ($InstalledSoftware -match 'qBittorrent') {
    $CheckBox_qBittorrent.Enabled = $false
    $CheckBox_qBittorrent.Text += ' (Installed)'
}

$CheckBox_UninstallEdge = New-Object System.Windows.Forms.CheckBox
$CheckBox_UninstallEdge.Location = New-Object System.Drawing.Size(30, 500)
$CheckBox_UninstallEdge.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_UninstallEdge.Text = 'Uninstall Edge (Not Recommended)'
$CheckBox_UninstallEdge.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_UninstallEdge)

if (!($InstalledSoftware -match 'Microsoft Edge')) {
    $CheckBox_UninstallEdge.Enabled = $false
    $CheckBox_UninstallEdge.Text += ' (Uninstalled)'
}

$Form_SoftwareSelection_OK = New-Object System.Windows.Forms.Button
$Form_SoftwareSelection_OK.Location = New-Object System.Drawing.Size(100, 540)
$Form_SoftwareSelection_OK.Size = New-Object System.Drawing.Size(100, 40)
$Form_SoftwareSelection_OK.Text = 'OK'
$Form_SoftwareSelection_OK.Add_Click({ $Form_SoftwareSelection.Close() })
$Form_SoftwareSelection.Controls.Add($Form_SoftwareSelection_OK)

$Form_SoftwareSelection_Cancel = New-Object System.Windows.Forms.Button
$Form_SoftwareSelection_Cancel.Location = New-Object System.Drawing.Size(300, 540)
$Form_SoftwareSelection_Cancel.Size = New-Object System.Drawing.Size(100, 40)
$Form_SoftwareSelection_Cancel.Text = 'Cancel'
$Form_SoftwareSelection_Cancel.Add_Click({ $Form_SoftwareSelection.Close() })
$Form_SoftwareSelection.Controls.Add($Form_SoftwareSelection_Cancel)

$Form_SoftwareSelection_OK.Add_Click{
    # Priority: Browser required, manual input
    if ($CheckBox_NVCleanstall.Checked) {
        Write-Host 'Software Selection: NVCleanstall: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/NVCleanstall/Download.ps1')
    }

    # Priority: Browser required, manual input
    if ($CheckBox_Plex.Checked) {
        Write-Host 'Software Selection: Plex: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Plex/Download.ps1')
    }

    # Priority: Manual input
    if ($CheckBox_mpv.Checked) {
        Write-Host 'Software Selection: mpv: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/Download.ps1')
    }

    # Priority: Manual input
    if ($CheckBox_RazerSynapse.Checked) {
        Write-Host 'Software Selection: Razer Synapse: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Razer_Synapse/Download.ps1')
    }

    # Priority: Manual input
    if ($CheckBox_HyperXNGENUITY.Checked) {
        Write-Host 'Software Selection: HyperX NGENUITY: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/HyperX_NGENUITY/Download.ps1')
    }

    if ($CheckBox_7Zip.Checked) {
        Write-Host 'Software Selection: 7-Zip: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')
    }

    if ($CheckBox_AnyDesk.Checked) {
        Write-Host 'Software Selection: AnyDesk: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/AnyDesk/Download.ps1')
    }

    if ($CheckBox_BattleNet.Checked) {
        Write-Host 'Software Selection: Battle.net: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Battle.net/Download.ps1')
    }

    if ($CheckBox_CrystalDiskInfo.Checked) {
        Write-Host 'Software Selection: CrystalDiskInfo: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/CrystalDiskInfo/Download.ps1')
    }

    if ($CheckBox_CrystalDiskMark.Checked) {
        Write-Host 'Software Selection: CrystalDiskMark: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/CrystalDiskMark/Download.ps1')
    }
    
    if ($CheckBox_Discord.Checked) {
        Write-Host 'Software Selection: Discord: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Discord/Download.ps1')
    }

    if ($CheckBox_DisplayDriverUninstaller.Checked) {
        Write-Host 'Software Selection: Display Driver Uninstaller: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Display_Driver_Uninstaller/Download.ps1')
    }

    if ($CheckBox_Jellyfin.Checked) {
        Write-Host 'Software Selection: Jellyfin: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Jellyfin/Download.ps1')
    }

    if ($CheckBox_LogitechGHUB.Checked) {
        Write-Host 'Software Selection: Logitech G HUB: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Logitech_G_HUB/Download.ps1')
    }

    if ($CheckBox_MediaInfo.Checked) {
        Write-Host 'Software Selection: MediaInfo: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/MediaInfo/Download.ps1')
    }

    if ($CheckBox_NordVPN.Checked) {
        Write-Host 'Software Selection: NordVPN: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/NordVPN/Download.ps1')
    }

    if ($CheckBox_NotepadPlusPlus.Checked) {
        Write-Host 'Software Selection: Notepad++: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Notepad_Plus_Plus/Download.ps1')
    }

    if ($CheckBox_PuTTY.Checked) {
        Write-Host 'Software Selection: PuTTY: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/PuTTY/Download.ps1')
    }

    if ($CheckBox_Python.Checked) {
        Write-Host 'Software Selection: Python: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Python/Download.ps1')
    }

    if ($CheckBox_Steam.Checked) {
        Write-Host 'Software Selection: Steam: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Steam/Download.ps1')
    }

    if ($CheckBox_Telegram.Checked) {
        Write-Host 'Software Selection: Telegram: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Telegram/Download.ps1')
    }

    if ($CheckBox_VisualStudioCode.Checked) {
        Write-Host 'Software Selection: Visual Studio Code: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Visual_Studio_Code/Download.ps1')
    }

    if ($CheckBox_qBittorrent.Checked) {
        Write-Host 'Software Selection: qBittorrent: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1')
    }

    # Priority: Manual input
    if ($CheckBox_MicrosoftOffice.Checked) {
        Write-Host 'Software Selection: Microsoft Office: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Office/Download.ps1')
    }

    if ($CheckBox_UninstallEdge.Checked) {
        Write-Host 'Software Selection: Microsoft Edge: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ChrisTitusTech/winutil/d0bde83333730a4536497451af747daba11e5039/edgeremoval.ps1')
        
        #Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ChrisTitusTech/winutil/main/edgeremoval.ps1')
        #explorer.exe
        
        # (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/he3als/EdgeRemover/main/RemoveEdge.ps1', "$env:TEMP\RemoveEdge.ps1")
        # Start-Process -FilePath 'powershell' -Verb RunAs -ArgumentList "-NoP -EP Unrestricted -File `"$env:TEMP\RemoveEdge.ps1`" -UninstallEdge -RemoveEdgeData -NonInteractive"
        
        # # https://github.com/fr33thytweaks/Ultimate-Windows-Optimization-Guide/blob/main/6%20Windows/14%20Edge.ps1
        # # stop edge running
        # $stop = 'MicrosoftEdgeUpdate', 'OneDrive', 'WidgetService', 'Widgets', 'msedge', 'msedgewebview2'
        # $stop | ForEach-Object { Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue }
        # # uninstall copilot
        # Get-AppxPackage -AllUsers *Microsoft.Windows.Ai.Copilot.Provider* | Remove-AppxPackage
        # # disable edge updates regedit
        # reg add 'HKLM\SOFTWARE\Microsoft\EdgeUpdate' /v 'DoNotUpdateToEdgeWithChromium' /t REG_DWORD /d '1' /f | Out-Null
        # # allow edge uninstall regedit
        # reg add 'HKLM\SOFTWARE\WOW6432Node\Microsoft\EdgeUpdateDev' /v 'AllowUninstall' /t REG_SZ /f | Out-Null
        # # new folder to uninstall edge
        # New-Item -Path "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
        # # new file to uninstall edge
        # New-Item -Path "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" -ItemType File -Name 'MicrosoftEdge.exe' -ErrorAction SilentlyContinue | Out-Null
        # # find edge uninstall string
        # $regview = [Microsoft.Win32.RegistryView]::Registry32
        # $microsoft = [Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine, $regview).
        # OpenSubKey('SOFTWARE\Microsoft', $true)
        # $uninstallregkey = $microsoft.OpenSubKey('Windows\CurrentVersion\Uninstall\Microsoft Edge')
        # try {
        #     $uninstallstring = $uninstallregkey.GetValue('UninstallString') + ' --force-uninstall'
        # }
        # catch {
        # }
        # # uninstall edge
        # Start-Process cmd.exe "/c $uninstallstring" -WindowStyle Hidden -Wait
        # # remove folder file
        # Remove-Item -Recurse -Force "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" -ErrorAction SilentlyContinue | Out-Null
        # # find edgeupdate.exe
        # $edgeupdate = @(); 'LocalApplicationData', 'ProgramFilesX86', 'ProgramFiles' | ForEach-Object {
        #     $folder = [Environment]::GetFolderPath($_)
        #     $edgeupdate += Get-ChildItem "$folder\Microsoft\EdgeUpdate\*.*.*.*\MicrosoftEdgeUpdate.exe" -rec -ea 0
        # }
        # # find edgeupdate & allow uninstall regedit
        # $global:REG = 'HKCU:\SOFTWARE', 'HKLM:\SOFTWARE', 'HKCU:\SOFTWARE\Policies', 'HKLM:\SOFTWARE\Policies', 'HKCU:\SOFTWARE\WOW6432Node', 'HKLM:\SOFTWARE\WOW6432Node', 'HKCU:\SOFTWARE\WOW6432Node\Policies', 'HKLM:\SOFTWARE\WOW6432Node\Policies'
        # foreach ($location in $REG) {
        #     Remove-Item "$location\Microsoft\EdgeUpdate" -Recurse -Force -ErrorAction SilentlyContinue 
        # }
        # # uninstall edgeupdate
        # foreach ($path in $edgeupdate) {
        #     if (Test-Path $path) {
        #         Start-Process -Wait $path -Args '/unregsvc' | Out-Null 
        #     }
        #     do {
        #         Start-Sleep 3 
        #     } while ((Get-Process -Name 'setup', 'MicrosoftEdge*' -ErrorAction SilentlyContinue).Path -like '*\Microsoft\Edge*')
        #     if (Test-Path $path) {
        #         Start-Process -Wait $path -Args '/uninstall' | Out-Null 
        #     }
        #     do {
        #         Start-Sleep 3 
        #     } while ((Get-Process -Name 'setup', 'MicrosoftEdge*' -ErrorAction SilentlyContinue).Path -like '*\Microsoft\Edge*')
        # }
        # # remove edgewebview regedit
        # cmd /c "reg delete `"HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft EdgeWebView`" /f >nul 2>&1"
        # cmd /c "reg delete `"HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft EdgeWebView`" /f >nul 2>&1"
        # # remove folders edge edgecore edgeupdate edgewebview temp
        # Remove-Item -Recurse -Force "$env:C:\Program Files (x86)\Microsoft" -ErrorAction SilentlyContinue | Out-Null
        # # remove edge shortcuts
        # Remove-Item -Recurse -Force "$env:C:\Windows\System32\config\systemprofile\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge.lnk" -ErrorAction SilentlyContinue | Out-Null
        # Remove-Item -Recurse -Force "$env:USERPROFILE\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\Microsoft Edge.lnk" -ErrorAction SilentlyContinue | Out-Null
        # Remove-Item -Recurse -Force "$env:USERPROFILE\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Microsoft Edge.lnk" -ErrorAction SilentlyContinue | Out-Null
        # Remove-Item -Recurse -Force "$env:USERPROFILE\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Tombstones\Microsoft Edge.lnk" -ErrorAction SilentlyContinue | Out-Null
        # Remove-Item -Recurse -Force "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" -ErrorAction SilentlyContinue | Out-Null
        # Remove-Item -Recurse -Force "$env:C:\Users\Public\Desktop\Microsoft Edge.lnk" -ErrorAction SilentlyContinue | Out-Null
    }
}

$Form_SoftwareSelection.Add_Shown({ $Form_SoftwareSelection.Activate() })
[void] $Form_SoftwareSelection.ShowDialog()
[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')

$Form = New-Object System.Windows.Forms.Form
$Form.width = 500
$Form.height = 700
$Form.Text = 'Software Selection'

$Font = New-Object System.Drawing.Font('Tahoma', 10)
$Form.Font = $Font

$Check7Zip = New-Object System.Windows.Forms.checkbox
$Check7Zip.Location = New-Object System.Drawing.Size(30, 30)
$Check7Zip.Size = New-Object System.Drawing.Size(250, 20)
$Check7Zip.Text = '7-Zip'
$Check7Zip.Checked = $false
$Form.Controls.Add($Check7Zip)

$CheckAnyDesk = New-Object System.Windows.Forms.checkbox
$CheckAnyDesk.Location = New-Object System.Drawing.Size(30, 50)
$CheckAnyDesk.Size = New-Object System.Drawing.Size(250, 20)
$CheckAnyDesk.Text = 'AnyDesk'
$CheckAnyDesk.Checked = $false
$Form.Controls.Add($CheckAnyDesk)

$CheckBattleNet = New-Object System.Windows.Forms.checkbox
$CheckBattleNet.Location = New-Object System.Drawing.Size(30, 70)
$CheckBattleNet.Size = New-Object System.Drawing.Size(250, 20)
$CheckBattleNet.Text = 'Battle.net'
$CheckBattleNet.Checked = $false
$Form.Controls.Add($CheckBattleNet)

$CheckCrystalDiskInfo = New-Object System.Windows.Forms.checkbox
$CheckCrystalDiskInfo.Location = New-Object System.Drawing.Size(30, 90)
$CheckCrystalDiskInfo.Size = New-Object System.Drawing.Size(250, 20)
$CheckCrystalDiskInfo.Text = 'CrystalDiskInfo'
$CheckCrystalDiskInfo.Checked = $false
$Form.Controls.Add($CheckCrystalDiskInfo)

$CheckCrystalDiskMark = New-Object System.Windows.Forms.checkbox
$CheckCrystalDiskMark.Location = New-Object System.Drawing.Size(30, 110)
$CheckCrystalDiskMark.Size = New-Object System.Drawing.Size(250, 20)
$CheckCrystalDiskMark.Text = 'CrystalDiskMark'
$CheckCrystalDiskMark.Checked = $false
$Form.Controls.Add($CheckCrystalDiskMark)

$CheckDiscord = New-Object System.Windows.Forms.checkbox
$CheckDiscord.Location = New-Object System.Drawing.Size(30, 130)
$CheckDiscord.Size = New-Object System.Drawing.Size(250, 20)
$CheckDiscord.Text = 'Discord'
$CheckDiscord.Checked = $false
$Form.Controls.Add($CheckDiscord)

$CheckDisplayDriverUninstaller = New-Object System.Windows.Forms.checkbox
$CheckDisplayDriverUninstaller.Location = New-Object System.Drawing.Size(30, 150)
$CheckDisplayDriverUninstaller.Size = New-Object System.Drawing.Size(250, 20)
$CheckDisplayDriverUninstaller.Text = 'Display Driver Uninstaller'
$CheckDisplayDriverUninstaller.Checked = $false
$Form.Controls.Add($CheckDisplayDriverUninstaller)

$CheckHyperXNGENUITY = New-Object System.Windows.Forms.checkbox
$CheckHyperXNGENUITY.Location = New-Object System.Drawing.Size(30, 170)
$CheckHyperXNGENUITY.Size = New-Object System.Drawing.Size(250, 20)
$CheckHyperXNGENUITY.Text = 'HyperX NGENUITY'
$CheckHyperXNGENUITY.Checked = $false
$Form.Controls.Add($CheckHyperXNGENUITY)

$CheckJellyfin = New-Object System.Windows.Forms.checkbox
$CheckJellyfin.Location = New-Object System.Drawing.Size(30, 190)
$CheckJellyfin.Size = New-Object System.Drawing.Size(250, 20)
$CheckJellyfin.Text = 'Jellyfin'
$CheckJellyfin.Checked = $false
$Form.Controls.Add($CheckJellyfin)

$CheckLogitechGHUB = New-Object System.Windows.Forms.checkbox
$CheckLogitechGHUB.Location = New-Object System.Drawing.Size(30, 210)
$CheckLogitechGHUB.Size = New-Object System.Drawing.Size(250, 20)
$CheckLogitechGHUB.Text = 'Logitech G HUB'
$CheckLogitechGHUB.Checked = $false
$Form.Controls.Add($CheckLogitechGHUB)

$CheckMediaInfo = New-Object System.Windows.Forms.checkbox
$CheckMediaInfo.Location = New-Object System.Drawing.Size(30, 230)
$CheckMediaInfo.Size = New-Object System.Drawing.Size(250, 20)
$CheckMediaInfo.Text = 'MediaInfo'
$CheckMediaInfo.Checked = $false
$Form.Controls.Add($CheckMediaInfo)

$CheckNVCleanstall = New-Object System.Windows.Forms.checkbox
$CheckNVCleanstall.Location = New-Object System.Drawing.Size(30, 250)
$CheckNVCleanstall.Size = New-Object System.Drawing.Size(250, 20)
$CheckNVCleanstall.Text = 'NVCleanstall'
$CheckNVCleanstall.Checked = $false
$Form.Controls.Add($CheckNVCleanstall)

$CheckNordVPN = New-Object System.Windows.Forms.checkbox
$CheckNordVPN.Location = New-Object System.Drawing.Size(30, 270)
$CheckNordVPN.Size = New-Object System.Drawing.Size(250, 20)
$CheckNordVPN.Text = 'NordVPN'
$CheckNordVPN.Checked = $false
$Form.Controls.Add($CheckNordVPN)

$CheckNotepadPlusPlus = New-Object System.Windows.Forms.checkbox
$CheckNotepadPlusPlus.Location = New-Object System.Drawing.Size(30, 290)
$CheckNotepadPlusPlus.Size = New-Object System.Drawing.Size(250, 20)
$CheckNotepadPlusPlus.Text = 'Notepad++'
$CheckNotepadPlusPlus.Checked = $false
$Form.Controls.Add($CheckNotepadPlusPlus)

$CheckOffice = New-Object System.Windows.Forms.checkbox
$CheckOffice.Location = New-Object System.Drawing.Size(30, 310)
$CheckOffice.Size = New-Object System.Drawing.Size(250, 20)
$CheckOffice.Text = 'Office'
$CheckOffice.Checked = $false
$Form.Controls.Add($CheckOffice)

$CheckPlex = New-Object System.Windows.Forms.checkbox
$CheckPlex.Location = New-Object System.Drawing.Size(30, 330)
$CheckPlex.Size = New-Object System.Drawing.Size(250, 20)
$CheckPlex.Text = 'Plex'
$CheckPlex.Checked = $false
$Form.Controls.Add($CheckPlex)

$CheckPython = New-Object System.Windows.Forms.checkbox
$CheckPython.Location = New-Object System.Drawing.Size(30, 350)
$CheckPython.Size = New-Object System.Drawing.Size(250, 20)
$CheckPython.Text = 'Python'
$CheckPython.Checked = $false
$Form.Controls.Add($CheckPython)

$CheckRazerSynapse = New-Object System.Windows.Forms.checkbox
$CheckRazerSynapse.Location = New-Object System.Drawing.Size(30, 370)
$CheckRazerSynapse.Size = New-Object System.Drawing.Size(250, 20)
$CheckRazerSynapse.Text = 'Razer Synapse'
$CheckRazerSynapse.Checked = $false
$Form.Controls.Add($CheckRazerSynapse)

$CheckSteam = New-Object System.Windows.Forms.checkbox
$CheckSteam.Location = New-Object System.Drawing.Size(30, 390)
$CheckSteam.Size = New-Object System.Drawing.Size(250, 20)
$CheckSteam.Text = 'Steam'
$CheckSteam.Checked = $false
$Form.Controls.Add($CheckSteam)

$CheckTelegram = New-Object System.Windows.Forms.checkbox
$CheckTelegram.Location = New-Object System.Drawing.Size(30, 410)
$CheckTelegram.Size = New-Object System.Drawing.Size(250, 20)
$CheckTelegram.Text = 'Telegram'
$CheckTelegram.Checked = $false
$Form.Controls.Add($CheckTelegram)

$CheckVisualStudioCode = New-Object System.Windows.Forms.checkbox
$CheckVisualStudioCode.Location = New-Object System.Drawing.Size(30, 430)
$CheckVisualStudioCode.Size = New-Object System.Drawing.Size(250, 20)
$CheckVisualStudioCode.Text = 'Visual Studio Code'
$CheckVisualStudioCode.Checked = $false
$Form.Controls.Add($CheckVisualStudioCode)

$Checkmpv = New-Object System.Windows.Forms.checkbox
$Checkmpv.Location = New-Object System.Drawing.Size(30, 450)
$Checkmpv.Size = New-Object System.Drawing.Size(250, 20)
$Checkmpv.Text = 'mpv'
$Checkmpv.Checked = $false
$Form.Controls.Add($Checkmpv)

$CheckqBittorrent = New-Object System.Windows.Forms.checkbox
$CheckqBittorrent.Location = New-Object System.Drawing.Size(30, 470)
$CheckqBittorrent.Size = New-Object System.Drawing.Size(250, 20)
$CheckqBittorrent.Text = 'qBittorrent'
$CheckqBittorrent.Checked = $false
$Form.Controls.Add($CheckqBittorrent)

$CheckUninstallEdge = New-Object System.Windows.Forms.checkbox
$CheckUninstallEdge.Location = New-Object System.Drawing.Size(30, 490)
$CheckUninstallEdge.Size = New-Object System.Drawing.Size(250, 20)
$CheckUninstallEdge.Text = 'Uninstall Edge (Not Recommended)'
$CheckUninstallEdge.Checked = $false
$Form.Controls.Add($CheckUninstallEdge)

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(130, 600)
$OKButton.Size = New-Object System.Drawing.Size(100, 40)
$OKButton.Text = 'OK'
$OKButton.Add_Click({ $Form.Close() })
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(255, 600)
$CancelButton.Size = New-Object System.Drawing.Size(100, 40)
$CancelButton.Text = 'Cancel'
$CancelButton.Add_Click({ $Form.Close() })
$form.Controls.Add($CancelButton)

$OKButton.Add_Click{
    # 1st to activate - browser required without interruptions
    if ($CheckNVCleanstall.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/NVCleanstall/Download.ps1')
    }
    # 2nd to activate - browser required without interruptions
    if ($CheckPlex.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Plex/Download.ps1')
    }
    # 3rd to activate - mpv updater slow to open otherwise
    if ($Checkmpv.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/Download.ps1')
    }
    # 4th to activate - user input required
    if ($CheckRazerSynapse.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Razer_Synapse/Download.ps1')
    }
    # 5th to activate - user input required
    if ($CheckHyperXNGENUITY.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/HyperX_NGENUITY/Download.ps1')
    }
    if ($Check7Zip.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/7Zip/Download.ps1')
    }
    if ($CheckAnyDesk.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/AnyDesk/Download.ps1')
    }
    if ($CheckBattleNet.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Battle.net/Download.ps1')
    }
    if ($CheckCrystalDiskInfo.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/CrystalDiskInfo/Download.ps1')
    }
    if ($CheckCrystalDiskMark.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/CrystalDiskMark/Download.ps1')
    }
    if ($CheckDiscord.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Discord/Download.ps1')
    }
    if ($CheckDisplayDriverUninstaller.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Display_Driver_Uninstaller/Download.ps1')
    }
    if ($CheckJellyfin.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Jellyfin/Download.ps1')
    }
    if ($CheckLogitechGHUB.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Logitech_G_HUB/Download.ps1')
    }
    if ($CheckMediaInfo.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/MediaInfo/Download.ps1')
    }
    if ($CheckNordVPN.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/NordVPN/Download.ps1')
    }
    if ($CheckNotepadPlusPlus.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Notepad_Plus_Plus/Download.ps1')
    }
    if ($CheckPython.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Python/Download.ps1')
    }
    if ($CheckSteam.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Steam/Download.ps1')
    }
    if ($CheckTelegram.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Telegram/Download.ps1')
    }
    if ($CheckVisualStudioCode.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Visual_Studio_Code/Download.ps1')
    }
    if ($CheckqBittorrent.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/qBittorrent/Download.ps1')
    }
    # Last to activate - takes the longest and requires user input to select
    if ($CheckOffice.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Office/Download.ps1')
    }
    if ($CheckUninstallEdge.Checked) {
        Write-Host 'Edge > Uninstall' -ForegroundColor green -BackgroundColor black
        # Option 1 - Working
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ChrisTitusTech/winutil/d0bde83333730a4536497451af747daba11e5039/edgeremoval.ps1')
        # Option 2 - Waiting for script update
        #Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ChrisTitusTech/winutil/main/edgeremoval.ps1')
        # Option 3 - Test it after windows update, after installing edge can't be uninstalled again using this script
        #Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/he3als/EdgeRemover/main/RemoveEdge.ps1')"
        #Start-Sleep -Milliseconds 2000
        #[System.Windows.Forms.SendKeys]::SendWait('2')    }
    }
}
$Form.Add_Shown({ $Form.Activate() })
[void] $Form.ShowDialog()
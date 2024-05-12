[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')

$FormSoftwareSelection = New-Object System.Windows.Forms.Form
$FormSoftwareSelection.width = 500
$FormSoftwareSelection.height = 700
$FormSoftwareSelection.Text = 'Software Selection'

$FontSoftwareSelection = New-Object System.Drawing.Font('Tahoma', 10)
$FormSoftwareSelection.Font = $FontSoftwareSelection

$Check7Zip = New-Object System.Windows.Forms.checkbox
$Check7Zip.Location = New-Object System.Drawing.Size(30, 30)
$Check7Zip.Size = New-Object System.Drawing.Size(250, 20)
$Check7Zip.Text = '7-Zip'
$Check7Zip.Checked = $false
$FormSoftwareSelection.Controls.Add($Check7Zip)

if ((Test-Path -Path $env:ProgramFiles\7-Zip)) {
    $Check7Zip.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $Check7Zip.Text += ' (Installed)'
}

$CheckAnyDesk = New-Object System.Windows.Forms.checkbox
$CheckAnyDesk.Location = New-Object System.Drawing.Size(30, 50)
$CheckAnyDesk.Size = New-Object System.Drawing.Size(250, 20)
$CheckAnyDesk.Text = 'AnyDesk'
$CheckAnyDesk.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckAnyDesk)

if ((Test-Path -Path ${env:ProgramFiles(x86)}\AnyDesk)) {
    $CheckAnyDesk.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckAnyDesk.Text += ' (Installed)'
}

$CheckBattleNet = New-Object System.Windows.Forms.checkbox
$CheckBattleNet.Location = New-Object System.Drawing.Size(30, 70)
$CheckBattleNet.Size = New-Object System.Drawing.Size(250, 20)
$CheckBattleNet.Text = 'Battle.net'
$CheckBattleNet.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckBattleNet)

if ((Test-Path -Path ${env:ProgramFiles(x86)}\Battle.net)) {
    $CheckBattleNet.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckBattleNet.Text += ' (Installed)'

}

$CheckCrystalDiskInfo = New-Object System.Windows.Forms.checkbox
$CheckCrystalDiskInfo.Location = New-Object System.Drawing.Size(30, 90)
$CheckCrystalDiskInfo.Size = New-Object System.Drawing.Size(250, 20)
$CheckCrystalDiskInfo.Text = 'CrystalDiskInfo'
$CheckCrystalDiskInfo.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckCrystalDiskInfo)

if ((Test-Path -Path $env:ProgramFiles\CrystalDiskInfo)) {
    $CheckCrystalDiskInfo.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckCrystalDiskInfo.Text += ' (Installed)'
}

$CheckCrystalDiskMark = New-Object System.Windows.Forms.checkbox
$CheckCrystalDiskMark.Location = New-Object System.Drawing.Size(30, 110)
$CheckCrystalDiskMark.Size = New-Object System.Drawing.Size(250, 20)
$CheckCrystalDiskMark.Text = 'CrystalDiskMark'
$CheckCrystalDiskMark.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckCrystalDiskMark)

if ((Test-Path -Path $env:ProgramFiles\CrystalDiskMark8)) {
    $CheckCrystalDiskMark.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckCrystalDiskMark.Text += ' (Installed)'
}

$CheckDiscord = New-Object System.Windows.Forms.checkbox
$CheckDiscord.Location = New-Object System.Drawing.Size(30, 130)
$CheckDiscord.Size = New-Object System.Drawing.Size(250, 20)
$CheckDiscord.Text = 'Discord'
$CheckDiscord.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckDiscord)

if ((Test-Path -Path $env:LOCALAPPDATA\Discord)) {
    $CheckDiscord.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckDiscord.Text += ' (Installed)'
}

$CheckDisplayDriverUninstaller = New-Object System.Windows.Forms.checkbox
$CheckDisplayDriverUninstaller.Location = New-Object System.Drawing.Size(30, 150)
$CheckDisplayDriverUninstaller.Size = New-Object System.Drawing.Size(250, 20)
$CheckDisplayDriverUninstaller.Text = 'Display Driver Uninstaller'
$CheckDisplayDriverUninstaller.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckDisplayDriverUninstaller)

if ((Test-Path -Path "${env:ProgramFiles(x86)}\Display Driver Uninstaller")) {
    $CheckDisplayDriverUninstaller.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckDisplayDriverUninstaller.Text += ' (Installed)'
}

$CheckHyperXNGENUITY = New-Object System.Windows.Forms.checkbox
$CheckHyperXNGENUITY.Location = New-Object System.Drawing.Size(30, 170)
$CheckHyperXNGENUITY.Size = New-Object System.Drawing.Size(250, 20)
$CheckHyperXNGENUITY.Text = 'HyperX NGENUITY'
$CheckHyperXNGENUITY.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckHyperXNGENUITY)

if ((Get-ChildItem $env:ProgramFiles\WindowsApps) -like '*NGENUITY*') {
    $CheckHyperXNGENUITY.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckHyperXNGENUITY.Text += ' (Installed)'
}


$CheckJellyfin = New-Object System.Windows.Forms.checkbox
$CheckJellyfin.Location = New-Object System.Drawing.Size(30, 190)
$CheckJellyfin.Size = New-Object System.Drawing.Size(250, 20)
$CheckJellyfin.Text = 'Jellyfin'
$CheckJellyfin.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckJellyfin)

if ((Test-Path -Path $env:ProgramFiles\Jellyfin)) {
    $CheckJellyfin.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckJellyfin.Text += ' (Installed)'
}

$CheckLogitechGHUB = New-Object System.Windows.Forms.checkbox
$CheckLogitechGHUB.Location = New-Object System.Drawing.Size(30, 210)
$CheckLogitechGHUB.Size = New-Object System.Drawing.Size(250, 20)
$CheckLogitechGHUB.Text = 'Logitech G HUB'
$CheckLogitechGHUB.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckLogitechGHUB)

if ((Test-Path -Path $env:ProgramFiles\LGHUB)) {
    $CheckLogitechGHUB.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckLogitechGHUB.Text += ' (Installed)'
}

$CheckMediaInfo = New-Object System.Windows.Forms.checkbox
$CheckMediaInfo.Location = New-Object System.Drawing.Size(30, 230)
$CheckMediaInfo.Size = New-Object System.Drawing.Size(250, 20)
$CheckMediaInfo.Text = 'MediaInfo'
$CheckMediaInfo.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckMediaInfo)

if ((Test-Path -Path $env:ProgramFiles\MediaInfo)) {
    $CheckMediaInfo.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckMediaInfo.Text += ' (Installed)'
}

$CheckNVCleanstall = New-Object System.Windows.Forms.checkbox
$CheckNVCleanstall.Location = New-Object System.Drawing.Size(30, 250)
$CheckNVCleanstall.Size = New-Object System.Drawing.Size(250, 20)
$CheckNVCleanstall.Text = 'NVCleanstall'
$CheckNVCleanstall.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckNVCleanstall)

If ((Get-WmiObject Win32_VideoController).Name -like '*NVIDIA*') {
    $CheckNVCleanstall.Text += ' (Compatible GPU)'
}
If ((Get-WmiObject Win32_VideoController).Name -notlike '*NVIDIA*') {
    $CheckNVCleanstall.Text += ' (Incompatible GPU)'
    $CheckNVCleanstall.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#ff0000')
}

if ((Test-Path -Path $env:ProgramFiles\NVCleanstall)) {
    $CheckNVCleanstall.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckNVCleanstall.Text += ' (Installed)'
}

$CheckNordVPN = New-Object System.Windows.Forms.checkbox
$CheckNordVPN.Location = New-Object System.Drawing.Size(30, 270)
$CheckNordVPN.Size = New-Object System.Drawing.Size(250, 20)
$CheckNordVPN.Text = 'NordVPN'
$CheckNordVPN.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckNordVPN)

if ((Test-Path -Path $env:ProgramFiles\NordVPN)) {
    $CheckNordVPN.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckNordVPN.Text += ' (Installed)'
}

$CheckNotepadPlusPlus = New-Object System.Windows.Forms.checkbox
$CheckNotepadPlusPlus.Location = New-Object System.Drawing.Size(30, 290)
$CheckNotepadPlusPlus.Size = New-Object System.Drawing.Size(250, 20)
$CheckNotepadPlusPlus.Text = 'Notepad++'
$CheckNotepadPlusPlus.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckNotepadPlusPlus)

if ((Test-Path -Path $env:ProgramFiles\Notepad++)) {
    $CheckNotepadPlusPlus.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckNotepadPlusPlus.Text += ' (Installed)'
}

$CheckOffice = New-Object System.Windows.Forms.checkbox
$CheckOffice.Location = New-Object System.Drawing.Size(30, 310)
$CheckOffice.Size = New-Object System.Drawing.Size(250, 20)
$CheckOffice.Text = 'Office'
$CheckOffice.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckOffice)

if ((Test-Path -Path "$env:ProgramFiles\Microsoft Office")) {
    $CheckOffice.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckOffice.Text += ' (Installed)'
}

$CheckPlex = New-Object System.Windows.Forms.checkbox
$CheckPlex.Location = New-Object System.Drawing.Size(30, 330)
$CheckPlex.Size = New-Object System.Drawing.Size(250, 20)
$CheckPlex.Text = 'Plex'
$CheckPlex.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckPlex)

if ((Test-Path -Path $env:ProgramFiles\Plex)) {
    $CheckPlex.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckPlex.Text += ' (Installed)'
}

$CheckPuTTY = New-Object System.Windows.Forms.checkbox
$CheckPuTTY.Location = New-Object System.Drawing.Size(30, 350)
$CheckPuTTY.Size = New-Object System.Drawing.Size(250, 20)
$CheckPuTTY.Text = 'PuTTY'
$CheckPuTTY.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckPuTTY)

if ((Test-Path -Path $env:ProgramFiles\PuTTY)) {
    $CheckPuTTY.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckPuTTY.Text += ' (Installed)'
}

$CheckPython = New-Object System.Windows.Forms.checkbox
$CheckPython.Location = New-Object System.Drawing.Size(30, 370)
$CheckPython.Size = New-Object System.Drawing.Size(250, 20)
$CheckPython.Text = 'Python'
$CheckPython.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckPython)

if ((Test-Path -Path $env:LOCALAPPDATA\Programs\Python)) {
    $CheckPython.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckPython.Text += ' (Installed)'
}

$CheckRazerSynapse = New-Object System.Windows.Forms.checkbox
$CheckRazerSynapse.Location = New-Object System.Drawing.Size(30, 390)
$CheckRazerSynapse.Size = New-Object System.Drawing.Size(250, 20)
$CheckRazerSynapse.Text = 'Razer Synapse'
$CheckRazerSynapse.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckRazerSynapse)

if ((Test-Path -Path ${env:ProgramFiles(x86)}\Razer)) {
    $CheckRazerSynapse.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckRazerSynapse.Text += ' (Installed)'
}

$CheckSteam = New-Object System.Windows.Forms.checkbox
$CheckSteam.Location = New-Object System.Drawing.Size(30, 410)
$CheckSteam.Size = New-Object System.Drawing.Size(250, 20)
$CheckSteam.Text = 'Steam'
$CheckSteam.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckSteam)

if ((Test-Path -Path ${env:ProgramFiles(x86)}\Steam)) {
    $CheckSteam.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckSteam.Text += ' (Installed)'
}

$CheckTelegram = New-Object System.Windows.Forms.checkbox
$CheckTelegram.Location = New-Object System.Drawing.Size(30, 430)
$CheckTelegram.Size = New-Object System.Drawing.Size(250, 20)
$CheckTelegram.Text = 'Telegram'
$CheckTelegram.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckTelegram)

if ((Test-Path -Path "$env:APPDATA\Telegram Desktop")) {
    $CheckTelegram.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckTelegram.Text += ' (Installed)'
}

$CheckVisualStudioCode = New-Object System.Windows.Forms.checkbox
$CheckVisualStudioCode.Location = New-Object System.Drawing.Size(30, 450)
$CheckVisualStudioCode.Size = New-Object System.Drawing.Size(250, 20)
$CheckVisualStudioCode.Text = 'Visual Studio Code'
$CheckVisualStudioCode.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckVisualStudioCode)

if ((Test-Path -Path "$env:LOCALAPPDATA\Programs\Microsoft VS Code")) {
    $CheckVisualStudioCode.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckVisualStudioCode.Text += ' (Installed)'
}

$Checkmpv = New-Object System.Windows.Forms.checkbox
$Checkmpv.Location = New-Object System.Drawing.Size(30, 470)
$Checkmpv.Size = New-Object System.Drawing.Size(250, 20)
$Checkmpv.Text = 'mpv'
$Checkmpv.Checked = $false
$FormSoftwareSelection.Controls.Add($Checkmpv)

if ((Test-Path -Path $env:ProgramFiles\mpv)) {
    $Checkmpv.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $Checkmpv.Text += ' (Installed)'
}

$CheckqBittorrent = New-Object System.Windows.Forms.checkbox
$CheckqBittorrent.Location = New-Object System.Drawing.Size(30, 490)
$CheckqBittorrent.Size = New-Object System.Drawing.Size(250, 20)
$CheckqBittorrent.Text = 'qBittorrent'
$CheckqBittorrent.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckqBittorrent)

if ((Test-Path -Path $env:ProgramFiles\qBittorrent)) {
    $CheckqBittorrent.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckqBittorrent.Text += ' (Installed)'
}

$CheckUninstallEdge = New-Object System.Windows.Forms.checkbox
$CheckUninstallEdge.Location = New-Object System.Drawing.Size(30, 510)
$CheckUninstallEdge.Size = New-Object System.Drawing.Size(250, 20)
$CheckUninstallEdge.Text = 'Uninstall Edge (Not Recommended)'
$CheckUninstallEdge.Checked = $false
$FormSoftwareSelection.Controls.Add($CheckUninstallEdge)

if (!(Test-Path -Path ${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe)) {
    $CheckUninstallEdge.ForeColor = [System.Drawing.ColorTranslator]::FromHtml('#009600')
    $CheckUninstallEdge.Text += ' (Uninstalled)'
}

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(130, 600)
$OKButton.Size = New-Object System.Drawing.Size(100, 40)
$OKButton.Text = 'OK'
$OKButton.Add_Click({ $FormSoftwareSelection.Close() })
$FormSoftwareSelection.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(255, 600)
$CancelButton.Size = New-Object System.Drawing.Size(100, 40)
$CancelButton.Text = 'Cancel'
$CancelButton.Add_Click({ $FormSoftwareSelection.Close() })
$FormSoftwareSelection.Controls.Add($CancelButton)

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
    if ($CheckPuTTY.Checked) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/PuTTY/Download.ps1')
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
$FormSoftwareSelection.Add_Shown({ $FormSoftwareSelection.Activate() })
[void] $FormSoftwareSelection.ShowDialog()
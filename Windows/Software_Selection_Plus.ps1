[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')

$Form_SoftwareSelection = New-Object System.Windows.Forms.Form
$Form_SoftwareSelection.width = 500
$Form_SoftwareSelection.height = 220
$Form_SoftwareSelection.Text = 'Software Selection Plus'
$Form_SoftwareSelection.StartPosition = 'CenterScreen'
$Form_SoftwareSelection.Font = New-Object System.Drawing.Font('Tahoma', 11)

$InstalledSoftware = Get-Package | Select-Object -Property 'Name'

$CheckBox_AdobeAcrobat = New-Object System.Windows.Forms.CheckBox
$CheckBox_AdobeAcrobat.Location = New-Object System.Drawing.Size(30, 20)
$CheckBox_AdobeAcrobat.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_AdobeAcrobat.Text = 'Adobe Acrobat'
$CheckBox_AdobeAcrobat.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_AdobeAcrobat)

if ($InstalledSoftware -match 'Adobe Acrobat') {
    $CheckBox_AdobeAcrobat.Enabled = $false
    $CheckBox_AdobeAcrobat.Text += ' (Installed)'
}

$CheckBox_AdobePhotoshop = New-Object System.Windows.Forms.CheckBox
$CheckBox_AdobePhotoshop.Location = New-Object System.Drawing.Size(30, 40)
$CheckBox_AdobePhotoshop.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_AdobePhotoshop.Text = 'Adobe Photoshop'
$CheckBox_AdobePhotoshop.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_AdobePhotoshop)

if ($InstalledSoftware -match 'Adobe Photoshop') {
    $CheckBox_AdobePhotoshop.Enabled = $false
    $CheckBox_AdobePhotoshop.Text += ' (Installed)'
}

$CheckBox_JitBit_Macro_Recorder = New-Object System.Windows.Forms.CheckBox
$CheckBox_JitBit_Macro_Recorder.Location = New-Object System.Drawing.Size(30, 60)
$CheckBox_JitBit_Macro_Recorder.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_JitBit_Macro_Recorder.Text = 'JitBit Macro Recorder'
$CheckBox_JitBit_Macro_Recorder.Checked = $false
$Form_SoftwareSelection.Controls.Add($CheckBox_JitBit_Macro_Recorder)

if ($InstalledSoftware -match 'Macro Recorder') {
    $CheckBox_JitBit_Macro_Recorder.Enabled = $false
    $CheckBox_JitBit_Macro_Recorder.Text += ' (Installed)'
}

$Form_SoftwareSelection_OK = New-Object System.Windows.Forms.Button
$Form_SoftwareSelection_OK.Location = New-Object System.Drawing.Size(100, 120)
$Form_SoftwareSelection_OK.Size = New-Object System.Drawing.Size(100, 40)
$Form_SoftwareSelection_OK.Text = 'OK'
$Form_SoftwareSelection_OK.Add_Click({ $Form_SoftwareSelection.Close() })
$Form_SoftwareSelection.Controls.Add($Form_SoftwareSelection_OK)

$Form_SoftwareSelection_Cancel = New-Object System.Windows.Forms.Button
$Form_SoftwareSelection_Cancel.Location = New-Object System.Drawing.Size(300, 120)
$Form_SoftwareSelection_Cancel.Size = New-Object System.Drawing.Size(100, 40)
$Form_SoftwareSelection_Cancel.Text = 'Cancel'
$Form_SoftwareSelection_Cancel.Add_Click({ $Form_SoftwareSelection.Close() })
$Form_SoftwareSelection.Controls.Add($Form_SoftwareSelection_Cancel)

$Form_SoftwareSelection_OK.Add_Click{
    if ($CheckBox_AdobeAcrobat.Checked) {
        Write-Host 'Software Selection Plus: Adobe Acrobat: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Adobe_Acrobat/Download.ps1')
    }

    if ($CheckBox_AdobePhotoshop.Checked) {
        Write-Host 'Software Selection Plus: Adobe Photoshop: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Adobe_Photoshop/Download.ps1')
    }

    if ($CheckBox_JitBit_Macro_Recorder.Checked) {
        Write-Host 'Software Selection Plus: JitBit Macro Recorder: Initiating' -ForegroundColor green -BackgroundColor black
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/JitBit_Macro_Recorder/Download.ps1')
    }
}

$Form_SoftwareSelection.Add_Shown({ $Form_SoftwareSelection.Activate() })
[void] $Form_SoftwareSelection.ShowDialog()
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form_OfficeSelection = New-Object System.Windows.Forms.Form
$Form_OfficeSelection.width = 900
$Form_OfficeSelection.height = 400
$Form_OfficeSelection.Text = 'Office Selection'
$Form_OfficeSelection.StartPosition = 'CenterScreen'
$Form_OfficeSelection.Font = New-Object System.Drawing.Font('Tahoma', 10)

$CheckBox_Microsoft365ProPlus = New-Object System.Windows.Forms.CheckBox
$CheckBox_Microsoft365ProPlus.Location = New-Object System.Drawing.Size(30, 30)
$CheckBox_Microsoft365ProPlus.Size = New-Object System.Drawing.Size(850, 20)
$CheckBox_Microsoft365ProPlus.Text = 'Microsoft 365 - Pro Plus (Access, Excel, OneDrive, OneNote, Outlook, Powerpoint, Publisher, Skype for Business, Word)'
$CheckBox_Microsoft365ProPlus.Checked = $false
$Form_OfficeSelection.Controls.Add($CheckBox_Microsoft365ProPlus)

$CheckBox_Office2021ProPlus = New-Object System.Windows.Forms.CheckBox
$CheckBox_Office2021ProPlus.Location = New-Object System.Drawing.Size(30, 60)
$CheckBox_Office2021ProPlus.Size = New-Object System.Drawing.Size(850, 20)
$CheckBox_Office2021ProPlus.Text = 'Office 2021 - Pro Plus (Access, Excel, OneDrive, OneNote, Outlook, Powerpoint, Publisher, Word)'
$CheckBox_Office2021ProPlus.Checked = $false
$Form_OfficeSelection.Controls.Add($CheckBox_Office2021ProPlus)

$CheckBox_Office2021Access = New-Object System.Windows.Forms.CheckBox
$CheckBox_Office2021Access.Location = New-Object System.Drawing.Size(30, 90)
$CheckBox_Office2021Access.Size = New-Object System.Drawing.Size(850, 20)
$CheckBox_Office2021Access.Text = 'Office 2021 - Access'
$CheckBox_Office2021Access.Checked = $false
$Form_OfficeSelection.Controls.Add($CheckBox_Office2021Access)

$CheckBox_Office2021Excel = New-Object System.Windows.Forms.CheckBox
$CheckBox_Office2021Excel.Location = New-Object System.Drawing.Size(30, 120)
$CheckBox_Office2021Excel.Size = New-Object System.Drawing.Size(850, 20)
$CheckBox_Office2021Excel.Text = 'Office 2021 - Excel'
$CheckBox_Office2021Excel.Checked = $false
$Form_OfficeSelection.Controls.Add($CheckBox_Office2021Excel)

$CheckBox_Office2021OneNote = New-Object System.Windows.Forms.CheckBox
$CheckBox_Office2021OneNote.Location = New-Object System.Drawing.Size(30, 150)
$CheckBox_Office2021OneNote.Size = New-Object System.Drawing.Size(850, 20)
$CheckBox_Office2021OneNote.Text = 'Office 2021 - OneNote'
$CheckBox_Office2021OneNote.Checked = $false
$Form_OfficeSelection.Controls.Add($CheckBox_Office2021OneNote)

$CheckBox_Office2021Outlook = New-Object System.Windows.Forms.CheckBox
$CheckBox_Office2021Outlook.Location = New-Object System.Drawing.Size(30, 180)
$CheckBox_Office2021Outlook.Size = New-Object System.Drawing.Size(850, 20)
$CheckBox_Office2021Outlook.Text = 'Office 2021 - Outlook'
$CheckBox_Office2021Outlook.Checked = $false
$Form_OfficeSelection.Controls.Add($CheckBox_Office2021Outlook)

$CheckBox_Office2021PowerPoint = New-Object System.Windows.Forms.CheckBox
$CheckBox_Office2021PowerPoint.Location = New-Object System.Drawing.Size(30, 210)
$CheckBox_Office2021PowerPoint.Size = New-Object System.Drawing.Size(850, 20)
$CheckBox_Office2021PowerPoint.Text = 'Office 2021 - PowerPoint'
$CheckBox_Office2021PowerPoint.Checked = $false
$Form_OfficeSelection.Controls.Add($CheckBox_Office2021PowerPoint)

$CheckBox_Office2021Publisher = New-Object System.Windows.Forms.CheckBox
$CheckBox_Office2021Publisher.Location = New-Object System.Drawing.Size(30, 240)
$CheckBox_Office2021Publisher.Size = New-Object System.Drawing.Size(850, 20)
$CheckBox_Office2021Publisher.Text = 'Office 2021 - Publisher'
$CheckBox_Office2021Publisher.Checked = $false
$Form_OfficeSelection.Controls.Add($CheckBox_Office2021Publisher)

$CheckBox_Office2021Word = New-Object System.Windows.Forms.CheckBox
$CheckBox_Office2021Word.Location = New-Object System.Drawing.Size(30, 270)
$CheckBox_Office2021Word.Size = New-Object System.Drawing.Size(850, 20)
$CheckBox_Office2021Word.Text = 'Office 2021 - Word'
$CheckBox_Office2021Word.Checked = $false
$Form_OfficeSelection.Controls.Add($CheckBox_Office2021Word)

$Form_OfficeSelection_OK = New-Object System.Windows.Forms.Button
$Form_OfficeSelection_OK.Location = New-Object System.Drawing.Size((($Form_OfficeSelection.Width) / 3 ), (($Form_OfficeSelection.height) - 65))
$Form_OfficeSelection_OK.Size = New-Object System.Drawing.Size(53, 20)
$Form_OfficeSelection_OK.Text = 'OK'
$Form_OfficeSelection_OK.Add_Click({ $Form_OfficeSelection.Close() })
$Form_OfficeSelection.Controls.Add($Form_OfficeSelection_OK)

$Form_OfficeSelection_Cancel = New-Object System.Windows.Forms.Button
$Form_OfficeSelection_Cancel.Location = New-Object System.Drawing.Size((($Form_OfficeSelection.Width) / 2 ), (($Form_OfficeSelection.height) - 65))
$Form_OfficeSelection_Cancel.Size = New-Object System.Drawing.Size(53, 20)
$Form_OfficeSelection_Cancel.Text = 'Cancel'
$Form_OfficeSelection_Cancel.Add_Click({ $Form_OfficeSelection.Close() })
$Form_OfficeSelection.Controls.Add($Form_OfficeSelection_Cancel)

$Form_OfficeSelection_OK.Add_Click{
	if ($CheckBox_Microsoft365ProPlus.Checked) {
		Write-Host 'Microsoft 365 - Pro Plus (Access, Excel, OneDrive, OneNote, Outlook, Powerpoint, Publisher, Skype for Business, Word): Installing' -ForegroundColor green -BackgroundColor black
		(New-Object System.Net.WebClient).DownloadFile('https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=O365ProPlusRetail&platform=x64&language=en-us&version=O16GA', "$env:TEMP\O365ProPlus.exe")
		Start-Process $env:TEMP\O365ProPlus.exe -Wait
	}

	if ($CheckBox_Office2021ProPlus.Checked) {
		Write-Host 'Office 2021 - Pro Plus (Access, Excel, OneDrive, OneNote, Outlook, Powerpoint, Publisher, Word): Installing' -ForegroundColor green -BackgroundColor black
		(New-Object System.Net.WebClient).DownloadFile('https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=ProPlus2021Retail&platform=x64&language=en-us&version=O16GA', "$env:TEMP\2021ProPlus.exe")
		Start-Process $env:TEMP\2021ProPlus.exe -Wait
	}

	if ($CheckBox_Office2021Access.Checked) {
		Write-Host 'Office 2021 - (Access): Installing' -ForegroundColor green -BackgroundColor black
		(New-Object System.Net.WebClient).DownloadFile('https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=Access2021Retail&platform=x64&language=en-us&version=O16GA', "$env:TEMP\2021Access.exe")
		Start-Process $env:TEMP\2021Access.exe -Wait
	}

	if ($CheckBox_Office2021Excel.Checked) {
		Write-Host 'Office 2021 - Excel: Installing' -ForegroundColor green -BackgroundColor black
		(New-Object System.Net.WebClient).DownloadFile('https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=Excel2021Retail&platform=x64&language=en-us&version=O16GA', "$env:TEMP\2021Excel.exe")
		Start-Process $env:TEMP\2021Excel.exe -Wait
	}

	if ($CheckBox_Office2021OneNote.Checked) {
		Write-Host 'Office 2021 - OneNote: Installing' -ForegroundColor green -BackgroundColor black
		(New-Object System.Net.WebClient).DownloadFile('https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=OneNote2021Retail&platform=x64&language=en-us&version=O16GA', "$env:TEMP\2021OneNote.exe")
		Start-Process $env:TEMP\2021OneNote.exe -Wait
	}

	if ($CheckBox_Office2021Outlook.Checked) {
		Write-Host 'Office 2021 - Outlook: Installing' -ForegroundColor green -BackgroundColor black
		(New-Object System.Net.WebClient).DownloadFile('https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=Outlook2021Retail&platform=x64&language=en-us&version=O16GA', "$env:TEMP\2021Outlook.exe")
		Start-Process $env:TEMP\2021Outlook.exe -Wait
	}

	if ($CheckBox_Office2021PowerPoint.Checked) {
		Write-Host 'Office 2021 - PowerPoint: Installing' -ForegroundColor green -BackgroundColor black
		(New-Object System.Net.WebClient).DownloadFile('https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=PowerPoint2021Retail&platform=x64&language=en-us&version=O16GA', "$env:TEMP\2021PowerPoint.exe")
		Start-Process $env:TEMP\2021PowerPoint.exe -Wait
	}

	if ($CheckBox_Office2021Publisher.Checked) {
		Write-Host 'Office 2021 - Publisher: Installing' -ForegroundColor green -BackgroundColor black
		(New-Object System.Net.WebClient).DownloadFile('https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=Publisher2021Retail&platform=x64&language=en-us&version=O16GA', "$env:TEMP\2021Publisher.exe")
		Start-Process $env:TEMP\2021Publisher.exe -Wait
	}

	if ($CheckBox_Office2021Word.Checked) {
		Write-Host 'Office 2021 - Word: Installing' -ForegroundColor green -BackgroundColor black
		(New-Object System.Net.WebClient).DownloadFile('https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=Word2021Retail&platform=x64&language=en-us&version=O16GA', "$env:TEMP\2021Word.exe")
		Start-Process $env:TEMP\2021Word.exe -Wait
	}
}

$Form_OfficeSelection.Add_Shown({ $Form_OfficeSelection.Activate() })
[void] $Form_OfficeSelection.ShowDialog()

Write-Host 'Office Key: Activating' -ForegroundColor green -BackgroundColor black
& ([ScriptBlock]::Create(((New-Object Net.WebClient).DownloadString('https://get.activated.win/')))) /Ohook

Write-Host 'Office Telemetry: Disabling' -ForegroundColor green -BackgroundColor black
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/abbodi1406/WHD/master/scripts/OC2R_DisableTelemetry.ps1')
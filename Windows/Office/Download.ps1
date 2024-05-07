Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$OfficeForm = New-Object System.Windows.Forms.Form
$OfficeForm.Text = 'Office Selection'
$OfficeForm.Size = New-Object System.Drawing.Size(620, 300)
$OfficeForm.StartPosition = 'CenterScreen'
$OfficeOK = New-Object System.Windows.Forms.Button
$OfficeOK.Location = New-Object System.Drawing.Point(135, 230)
$OfficeOK.Size = New-Object System.Drawing.Size(75, 23)
$OfficeOK.Text = 'OK'
$OfficeOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
$OfficeForm.AcceptButton = $OfficeOK
$OfficeForm.Controls.Add($OfficeOK)
$OfficeCancel = New-Object System.Windows.Forms.Button
$OfficeCancel.Location = New-Object System.Drawing.Point(270, 230)
$OfficeCancel.Size = New-Object System.Drawing.Size(75, 23)
$OfficeCancel.Text = 'Cancel'
$OfficeCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$OfficeForm.CancelButton = $OfficeCancel
$OfficeForm.Controls.Add($OfficeCancel)
$OfficeLabel = New-Object System.Windows.Forms.Label
$OfficeLabel.Location = New-Object System.Drawing.Point(10, 20)
$OfficeLabel.Size = New-Object System.Drawing.Size(280, 20)
$OfficeLabel.Text = 'Please make a selection from the list below:'
$OfficeForm.Controls.Add($OfficeLabel)
$OfficeList = New-Object System.Windows.Forms.Listbox
$OfficeList.Location = New-Object System.Drawing.Point(10, 40)
$OfficeList.Size = New-Object System.Drawing.Size(580, 20)
$OfficeList.SelectionMode = 'MultiExtended'
[void] $OfficeList.Items.Add('Microsoft 365 - Pro Plus (Access, Excel, OneDrive, OneNote, Outlook, Powerpoint, Publisher, Skype for Business, Word)')
[void] $OfficeList.Items.Add('Office 2021 - Pro Plus (Access, Excel, OneDrive, OneNote, Outlook, Powerpoint, Publisher, Word)')
[void] $OfficeList.Items.Add('Office 2021 - Access')
[void] $OfficeList.Items.Add('Office 2021 - Excel')
[void] $OfficeList.Items.Add('Office 2021 - OneNote')
[void] $OfficeList.Items.Add('Office 2021 - Outlook')
[void] $OfficeList.Items.Add('Office 2021 - PowerPoint')
[void] $OfficeList.Items.Add('Office 2021 - Publisher')
[void] $OfficeList.Items.Add('Office 2021 - Word')
$OfficeList.Height = 150
$OfficeForm.Controls.Add($OfficeList)
$OfficeForm.Topmost = $true
$OfficeDialog = $OfficeForm.ShowDialog()
if ($OfficeDialog -eq [System.Windows.Forms.DialogResult]::OK) {
	$OfficeSelected = $OfficeList.SelectedItems
	if ($OfficeSelected -eq 'Microsoft 365 - Pro Plus (Access, Excel, OneDrive, OneNote, Outlook, Powerpoint, Publisher, Skype for Business, Word)') {
		Write-Host 'Microsoft 365 - Pro Plus (Access, Excel, OneDrive, OneNote, Outlook, Powerpoint, Publisher, Skype for Business, Word) > Install' -ForegroundColor green -BackgroundColor black
		(New-Object System.Net.WebClient).DownloadFile('https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=O365ProPlusRetail&platform=x64&language=en-us&version=O16GA', "$env:TEMP\O365ProPlus.exe")
		Start-Process $env:TEMP\O365ProPlus.exe -Wait
	}
	if ($OfficeSelected -eq 'Office 2021 - Pro Plus (Access, Excel, OneDrive, OneNote, Outlook, Powerpoint, Publisher, Word)') {
		Write-Host 'Office 2021 - Pro Plus (Access, Excel, OneDrive, OneNote, Outlook, Powerpoint, Publisher, Word) > Install' -ForegroundColor green -BackgroundColor black
		(New-Object System.Net.WebClient).DownloadFile('https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=ProPlus2021Retail&platform=x64&language=en-us&version=O16GA', "$env:TEMP\2021ProPlus.exe")
		Start-Process $env:TEMP\2021ProPlus.exe -Wait
	}
	if ($OfficeSelected -eq 'Office 2021 - Access') {
		Write-Host 'Office 2021 - (Access) > Install' -ForegroundColor green -BackgroundColor black
		(New-Object System.Net.WebClient).DownloadFile('https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=Access2021Retail&platform=x64&language=en-us&version=O16GA', "$env:TEMP\2021Access.exe")
		Start-Process $env:TEMP\2021Access.exe -Wait
	}
	if ($OfficeSelected -eq 'Office 2021 - Excel') {
		Write-Host 'Office 2021 - Excel > Install' -ForegroundColor green -BackgroundColor black
		(New-Object System.Net.WebClient).DownloadFile('https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=Excel2021Retail&platform=x64&language=en-us&version=O16GA', "$env:TEMP\2021Excel.exe")
		Start-Process $env:TEMP\2021Excel.exe -Wait
	}
	if ($OfficeSelected -eq 'Office 2021 - OneNote') {
		Write-Host 'Office 2021 - OneNote > Install' -ForegroundColor green -BackgroundColor black
		(New-Object System.Net.WebClient).DownloadFile('https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=OneNote2021Retail&platform=x64&language=en-us&version=O16GA', "$env:TEMP\2021OneNote.exe")
		Start-Process $env:TEMP\2021OneNote.exe -Wait
	}
	if ($OfficeSelected -eq 'Office 2021 - Outlook') {
		Write-Host 'Office 2021 - Outlook > Install' -ForegroundColor green -BackgroundColor black
		(New-Object System.Net.WebClient).DownloadFile('https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=Outlook2021Retail&platform=x64&language=en-us&version=O16GA', "$env:TEMP\2021Outlook.exe")
		Start-Process $env:TEMP\2021Outlook.exe -Wait
	}
	if ($OfficeSelected -eq 'Office 2021 - PowerPoint') {
		Write-Host 'Office 2021 - PowerPoint > Install' -ForegroundColor green -BackgroundColor black
		(New-Object System.Net.WebClient).DownloadFile('https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=PowerPoint2021Retail&platform=x64&language=en-us&version=O16GA', "$env:TEMP\2021PowerPoint.exe")
		Start-Process $env:TEMP\2021PowerPoint.exe -Wait
	}
	if ($OfficeSelected -eq 'Office 2021 - Publisher') {
		Write-Host 'Office 2021 - Publisher > Install' -ForegroundColor green -BackgroundColor black
		(New-Object System.Net.WebClient).DownloadFile('https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=Publisher2021Retail&platform=x64&language=en-us&version=O16GA', "$env:TEMP\2021Publisher.exe")
		Start-Process $env:TEMP\2021Publisher.exe -Wait
	}
	if ($OfficeSelected -eq 'Office 2021 - Word') {
		Write-Host 'Office 2021 - Word > Install' -ForegroundColor green -BackgroundColor black
		(New-Object System.Net.WebClient).DownloadFile('https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=Word2021Retail&platform=x64&language=en-us&version=O16GA', "$env:TEMP\2021Word.exe")
		Start-Process $env:TEMP\2021Word.exe -Wait
	}
	Write-Host 'Office > Activate' -ForegroundColor green -BackgroundColor black
	& ([ScriptBlock]::Create(((New-Object Net.WebClient).DownloadString('https://massgrave.dev/get')))) /Ohook
	Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Office/Disable_Telemetry.ps1')
}
$NextStep = 'Step2'
Invoke-WebRequest -Uri https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/$NextStep.ps1 -OutFile $env:TEMP\$NextStep.ps1
Write-Host "Task Scheduler > $NextStep" -ForegroundColor green -BackgroundColor black
$NextStep_Principal = New-ScheduledTaskPrincipal -UserId $env:computername\$env:USERNAME -RunLevel Highest
$NextStep_Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Maximized -ExecutionPolicy Bypass -File $env:TEMP\$NextStep.ps1"
$NextStep_Trigger = New-ScheduledTaskTrigger -AtLogOn
$NextStep_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
$NextStep_Parameters = @{
	TaskName  = $NextStep
	Principal = $NextStep_Principal
	Action    = $NextStep_Action
	Trigger   = $NextStep_Trigger
	Settings  = $NextStep_Settings
}
Register-ScheduledTask @NextStep_Parameters -Force
Write-Host 'Control Panel > Power Options > Ultimate Perofrmance > On' -ForegroundColor green -BackgroundColor black
$powerSchemeName = 'Ultimate Performance'
$powerSchemeGuid = 'e9a42b02-d5df-448d-aa00-03f14749eb61'
$schemes = powercfg /list | Out-String -Stream
$ultimateScheme = $schemes | Where-Object { $_ -match $powerSchemeName }
if ($null -eq $ultimateScheme) {
	Invoke-WebRequest -Uri https://github.com/ByKsTv/Everything/raw/main/Windows/Step1_UltimatePerformance.pow -OutFile $env:TEMP\UltimatePerformance.pow
	powercfg -import $env:TEMP\UltimatePerformance.pow $powerSchemeGuid
}
powercfg /S $powerSchemeGuid
Write-Host 'Settings > Power & Sleep > Screen > When plugged in, turn off after > Never' -ForegroundColor green -BackgroundColor black
powercfg -change -monitor-timeout-ac 0
Write-Host "PC Name > $env:username" -ForegroundColor green -BackgroundColor black
if ($env:computername -ne $env:username) {
	Rename-Computer -NewName $env:username
}
Write-Host "Computer Management > System Tools > Local Users and Groups > Users > $env:username > Password never expires > On" -ForegroundColor green -BackgroundColor black
Set-LocalUser -Name $env:username -PasswordNeverExpires 1
Write-Host "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultUsername > $env:username" -ForegroundColor green -BackgroundColor black
if ((Test-Path -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon') -ne $true) { New-Item 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Force -ea SilentlyContinue }
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'DefaultUsername' -Value $env:username -PropertyType String -Force -ea SilentlyContinue
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$PCPasswordAnswer = [System.Windows.Forms.MessageBox]::Show('Add PC Password?' , 'PC Password' , 4, 32)
if ($PCPasswordAnswer -eq 'Yes') {
	$PCPasswordForm = New-Object System.Windows.Forms.Form
	$PCPasswordForm.Text = 'PC Password'
	$PCPasswordForm.Size = New-Object System.Drawing.Size(300, 200)
	$PCPasswordForm.StartPosition = 'CenterScreen'
	$PCPasswordOK = New-Object System.Windows.Forms.Button
	$PCPasswordOK.Location = New-Object System.Drawing.Point(75, 120)
	$PCPasswordOK.Size = New-Object System.Drawing.Size(75, 23)
	$PCPasswordOK.Text = 'OK'
	$PCPasswordOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
	$PCPasswordForm.AcceptButton = $PCPasswordOK
	$PCPasswordForm.Controls.Add($PCPasswordOK)
	$PCPasswordLabel = New-Object System.Windows.Forms.Label
	$PCPasswordLabel.Location = New-Object System.Drawing.Point(10, 20)
	$PCPasswordLabel.Size = New-Object System.Drawing.Size(280, 20)
	$PCPasswordLabel.Text = 'PC Password:'
	$PCPasswordForm.Controls.Add($PCPasswordLabel)
	$PCPasswordTextBox = New-Object System.Windows.Forms.TextBox
	$PCPasswordTextBox.Location = New-Object System.Drawing.Point(10, 40)
	$PCPasswordTextBox.Size = New-Object System.Drawing.Size(260, 20)
	$PCPasswordForm.Controls.Add($PCPasswordTextBox)
	$PCPasswordForm.Topmost = $true
	$PCPasswordForm.Add_Shown({ $PCPasswordTextBox.Select() })
	$PCPasswordResult = $PCPasswordForm.ShowDialog()
	if ($PCPasswordResult -eq [System.Windows.Forms.DialogResult]::OK) {
		$PCPasswordResultPASS = $PCPasswordTextBox.Text
		Write-Host "PC Password > $PCPasswordResultPASS" -ForegroundColor green -BackgroundColor black
		Set-LocalUser -Name $env:username -Password (ConvertTo-SecureString -AsPlainText $PCPasswordResultPASS -Force)
		Write-Host "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\DefaultPassword > $PCPasswordResultPASS" -ForegroundColor green -BackgroundColor black
		New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'DefaultPassword' -Value $PCPasswordResultPASS -PropertyType String -Force -ea SilentlyContinue
		$PCPasswordAutoLogonAnswer = [System.Windows.Forms.MessageBox]::Show('Enable AutoAdminLogon?' , 'AutoAdminLogon' , 4, 32)
		if ($PCPasswordAutoLogonAnswer -eq 'Yes') {
			Write-Host 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoAdminLogon > On' -ForegroundColor green -BackgroundColor black
			New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon' -Value '1' -PropertyType String -Force -ea SilentlyContinue
		}
		if ($PCPasswordAutoLogonAnswer -eq 'No') {
			Write-Host 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoAdminLogon > Off' -ForegroundColor green -BackgroundColor black
			New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon' -Value '0' -PropertyType String -Force -ea SilentlyContinue
		}
	}
}
if ($PCPasswordAnswer -eq 'No') {
	Write-Host 'PC Password > Disabled' -ForegroundColor green -BackgroundColor black
	Set-LocalUser -Name $env:username -Password ([securestring]::new())
	Write-Host 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\AutoAdminLogon > Off' -ForegroundColor green -BackgroundColor black
	New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon' -Value '0' -PropertyType String -Force -ea SilentlyContinue
}
$RemoteDesktopAnswer = [System.Windows.Forms.MessageBox]::Show('Enable Remote Desktop?

Remote desktop is the ability to connect to this PC from a separate computer. Remote desktop users can access their desktop, open and edit files, and use applications as if they were actually sitting at their desktop computer.
' , 'Remote Desktop' , 4, 32)
if ($RemoteDesktopAnswer -eq 'Yes') {
	Write-Host 'Settings > System > Remote Desktop > Enable Remote Desktop > On' -ForegroundColor green -BackgroundColor black
	Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0
	Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'
}
if ($RemoteDesktopAnswer -eq 'No') {
	Write-Host 'Settings > System > Remote Desktop > Enable Remote Desktop > Off' -ForegroundColor green -BackgroundColor black
	Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 1
	Disable-NetFirewallRule -DisplayGroup 'Remote Desktop'
}
$RemotePowerShellAnswer = [System.Windows.Forms.MessageBox]::Show('Enable Remote PowerShell?
 
Windows PowerShell remoting lets you run any Windows PowerShell command on this PC from a separate computer. You can establish persistent connections, start interactive sessions, and run scripts on remote computers.
' , 'Remote PowerShell' , 4, 32)
if ($RemotePowerShellAnswer -eq 'Yes') {
	Write-Host 'Remote PowerShell > On' -ForegroundColor green -BackgroundColor black
	Set-NetConnectionProfile -NetworkCategory Private
	Enable-PSRemoting -Force
	$RemotePowerShellForm = New-Object System.Windows.Forms.Form
	$RemotePowerShellForm.Text = 'Remote PowerShell'
	$RemotePowerShellForm.Size = New-Object System.Drawing.Size(300, 200)
	$RemotePowerShellForm.StartPosition = 'CenterScreen'
	$RemotePowerShellOK = New-Object System.Windows.Forms.Button
	$RemotePowerShellOK.Location = New-Object System.Drawing.Point(75, 120)
	$RemotePowerShellOK.Size = New-Object System.Drawing.Size(75, 23)
	$RemotePowerShellOK.Text = 'OK'
	$RemotePowerShellOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
	$RemotePowerShellForm.AcceptButton = $RemotePowerShellOK
	$RemotePowerShellForm.Controls.Add($RemotePowerShellOK)
	$RemotePowerShellLabel = New-Object System.Windows.Forms.Label
	$RemotePowerShellLabel.Location = New-Object System.Drawing.Point(10, 20)
	$RemotePowerShellLabel.Size = New-Object System.Drawing.Size(280, 20)
	$RemotePowerShellLabel.Text = 'IP address of the trusted PC:'
	$RemotePowerShellForm.Controls.Add($RemotePowerShellLabel)
	$RemotePowerShellTextBox = New-Object System.Windows.Forms.TextBox
	$RemotePowerShellTextBox.Location = New-Object System.Drawing.Point(10, 40)
	$RemotePowerShellTextBox.Size = New-Object System.Drawing.Size(260, 20)
	$RemotePowerShellForm.Controls.Add($RemotePowerShellTextBox)
	$RemotePowerShellForm.Topmost = $true
	$RemotePowerShellForm.Add_Shown({ $RemotePowerShellTextBox.Select() })
	$RemotePowerShellResult = $RemotePowerShellForm.ShowDialog()
	if ($RemotePowerShellResult -eq [System.Windows.Forms.DialogResult]::OK) {
		$RemotePowerShellResultIP = $RemotePowerShellTextBox.Text
		Write-Host "wsman:\localhost\Client\TrustedHosts > $RemotePowerShellResultIP" -ForegroundColor green -BackgroundColor black
		Set-Item wsman:\localhost\Client\TrustedHosts -Value "$RemotePowerShellResultIP" -Force
	}
}
if ($RemotePowerShellAnswer -eq 'No') {
	Write-Host 'Remote PowerShell > Off' -ForegroundColor green -BackgroundColor black
	Disable-PSRemoting -Force
	Remove-Item -Path WSMan:\Localhost\listener\listener* -Recurse
	Clear-Item wsman:\localhost\client\trustedhosts -Force
	Set-NetFirewallRule -DisplayName 'Windows Remote Management (HTTP-In)' -Enabled False | Select-Object -Property DisplayName, Profile, Enabled
	Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system -Name LocalAccountTokenFilterPolicy -Value 0
	Stop-Service WinRM
	Set-Service WinRM -StartupType Manual
}
$MPVAnswer = [System.Windows.Forms.MessageBox]::Show('Install mpv?' , 'mpv' , 4, 32)
if ($MPVAnswer -eq 'Yes') {
    Write-Host 'mpv > Install' -ForegroundColor green -BackgroundColor black
    Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/Download_Install_AutoUpdate.ps1 | Invoke-Expression
}
$BrowserSelectionForm = New-Object System.Windows.Forms.Form
$BrowserSelectionForm.Text = 'Browser Selection'
$BrowserSelectionForm.Size = New-Object System.Drawing.Size(300, 200)
$BrowserSelectionForm.StartPosition = 'CenterScreen'
$BrowserSelectionOK = New-Object System.Windows.Forms.Button
$BrowserSelectionOK.Location = New-Object System.Drawing.Point(75, 120)
$BrowserSelectionOK.Size = New-Object System.Drawing.Size(75, 23)
$BrowserSelectionOK.Text = 'OK'
$BrowserSelectionOK.DialogResult = [System.Windows.Forms.DialogResult]::OK
$BrowserSelectionForm.AcceptButton = $BrowserSelectionOK
$BrowserSelectionForm.Controls.Add($BrowserSelectionOK)
$BrowserSelectionLabel = New-Object System.Windows.Forms.Label
$BrowserSelectionLabel.Location = New-Object System.Drawing.Point(10, 20)
$BrowserSelectionLabel.Size = New-Object System.Drawing.Size(280, 20)
$BrowserSelectionLabel.Text = 'Please make a selection from the list below:'
$BrowserSelectionForm.Controls.Add($BrowserSelectionLabel)
$BrowserSelectionList = New-Object System.Windows.Forms.Listbox
$BrowserSelectionList.Location = New-Object System.Drawing.Point(10, 40)
$BrowserSelectionList.Size = New-Object System.Drawing.Size(260, 20)
$BrowserSelectionList.SelectionMode = 'MultiExtended'
[void] $BrowserSelectionList.Items.Add('Firefox')
[void] $BrowserSelectionList.Items.Add('Chrome')
$BrowserSelectionList.Height = 70
$BrowserSelectionForm.Controls.Add($BrowserSelectionList)
$BrowserSelectionForm.Topmost = $true
$BrowserSelectionAnswer = $BrowserSelectionForm.ShowDialog()
if ($BrowserSelectionAnswer -eq [System.Windows.Forms.DialogResult]::OK) {
	$BrowserSelectionSelected = $BrowserSelectionList.SelectedItems
	if ($BrowserSelectionSelected -eq 'Firefox') {
		if ((Test-Path -LiteralPath "${env:ProgramFiles(x86)}\Mozilla Firefox") -ne $true) {
			Write-Host 'Firefox Setup' -ForegroundColor green -BackgroundColor black
			Invoke-WebRequest -Uri https://download.mozilla.org/?product=firefox-stub -OutFile $env:TEMP\firefox-stub.exe
			Start-Process $env:TEMP\firefox-stub.exe
		}
	}
	if ($BrowserSelectionSelected -eq 'Chrome') {
		if ((Test-Path -LiteralPath "${env:ProgramFiles(x86)}\Google\Chrome\Application") -ne $true) {
			Write-Host 'Chrome Setup' -ForegroundColor green -BackgroundColor black
			Invoke-WebRequest -Uri https://dl.google.com/chrome/install/latest/chrome_installer.exe -OutFile $env:TEMP\chrome_installer.exe
			Start-Process $env:TEMP\chrome_installer.exe
		}
	}
}
Write-Host 'Settings > Update & Security > Check for updates' -ForegroundColor green -BackgroundColor black
Write-Host 'NuGet > Install' -ForegroundColor green -BackgroundColor black
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Write-Host 'PSWindowsUpdate > Install' -ForegroundColor green -BackgroundColor black
Install-Module PSWindowsUpdate -Force
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
Import-Module PSWindowsUpdate -Force
Get-WindowsUpdate -AcceptAll -AutoReboot -Install
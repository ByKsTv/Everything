Write-Host 'Step1: Initiating next step' -ForegroundColor green -BackgroundColor black
$NextStep = 'Step2'
(New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/$NextStep.ps1", "$env:TEMP\$NextStep.ps1")

Write-Host "Step1: Task Scheduler: Adding $NextStep" -ForegroundColor green -BackgroundColor black
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

Write-Host 'Step1: Windows Update: Checking for updates' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath "$env:SystemRoot\System32\UsoClient.exe" -ArgumentList StartInteractiveScan
Start-Process -FilePath 'ms-settings:windowsupdate'

Write-Host 'Step1: Disabling Restart Apps' -ForegroundColor green -BackgroundColor black
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name RestartApps -PropertyType DWord -Value 0 -Force

Write-Host "Step1: PC Name: Renaming to $env:username" -ForegroundColor green -BackgroundColor black
if ($env:computername -ne $env:username) {
	Rename-Computer -NewName $env:username
}

Write-Host 'Step1: PC Password: Changing to never expires' -ForegroundColor green -BackgroundColor black
Set-LocalUser -Name $env:username -PasswordNeverExpires 1

Write-Host 'Step1: AutoAdminLogon: Adding username' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon') -ne $true) {
 New-Item 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Force 
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'DefaultUsername' -Value $env:username -PropertyType String -Force

[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void] [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')

$Form_Step1 = New-Object System.Windows.Forms.Form
$Form_Step1.width = 500
$Form_Step1.height = 400
$Form_Step1.Text = 'Initial Setup'
$Form_Step1.StartPosition = 'CenterScreen'
$Form_Step1.Font = New-Object System.Drawing.Font('Tahoma', 11)

$CheckBox_PCPassword = New-Object System.Windows.Forms.CheckBox
$CheckBox_PCPassword.Location = New-Object System.Drawing.Size(30, 30)
$CheckBox_PCPassword.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_PCPassword.Text = 'PC Password'
$CheckBox_PCPassword.Checked = $false
$Form_Step1.Controls.Add($CheckBox_PCPassword)

$TextBox_PCPassword = New-Object System.Windows.Forms.TextBox
$TextBox_PCPassword.Location = New-Object System.Drawing.Size(30, 60)
$TextBox_PCPassword.Size = New-Object System.Drawing.Size(400, 20)
$TextBox_PCPassword.Text = 'Password'
$TextBox_PCPassword.Enabled = $false
$Form_Step1.Controls.Add($TextBox_PCPassword)

$CheckBox_PCAutoLogin = New-Object System.Windows.Forms.CheckBox
$CheckBox_PCAutoLogin.Location = New-Object System.Drawing.Size(30, 90)
$CheckBox_PCAutoLogin.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_PCAutoLogin.Text = 'PC Auto Login'
$CheckBox_PCAutoLogin.Checked = $false
$CheckBox_PCAutoLogin.Enabled = $false
$Form_Step1.Controls.Add($CheckBox_PCAutoLogin)

$CheckBox_RemoteDesktop = New-Object System.Windows.Forms.CheckBox
$CheckBox_RemoteDesktop.Location = New-Object System.Drawing.Size(30, 120)
$CheckBox_RemoteDesktop.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_RemoteDesktop.Text = 'Remote Desktop'
$CheckBox_RemoteDesktop.Checked = $false
$Form_Step1.Controls.Add($CheckBox_RemoteDesktop)

$CheckBox_RemotePowerShell = New-Object System.Windows.Forms.CheckBox
$CheckBox_RemotePowerShell.Location = New-Object System.Drawing.Size(30, 150)
$CheckBox_RemotePowerShell.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_RemotePowerShell.Text = 'Remote PowerShell'
$CheckBox_RemotePowerShell.Checked = $false
$Form_Step1.Controls.Add($CheckBox_RemotePowerShell)

$TextBox_RemotePowerShellIP = New-Object System.Windows.Forms.TextBox
$TextBox_RemotePowerShellIP.Location = New-Object System.Drawing.Size(30, 180)
$TextBox_RemotePowerShellIP.Size = New-Object System.Drawing.Size(400, 20)
$TextBox_RemotePowerShellIP.Text = 'IP'
$TextBox_RemotePowerShellIP.Enabled = $false
$Form_Step1.Controls.Add($TextBox_RemotePowerShellIP)

$CheckBox_MozillaFirefox = New-Object System.Windows.Forms.CheckBox
$CheckBox_MozillaFirefox.Location = New-Object System.Drawing.Size(30, 210)
$CheckBox_MozillaFirefox.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_MozillaFirefox.Text = 'Mozilla Firefox'
$CheckBox_MozillaFirefox.Checked = $false
$Form_Step1.Controls.Add($CheckBox_MozillaFirefox)

$CheckBox_GoogleChrome = New-Object System.Windows.Forms.CheckBox
$CheckBox_GoogleChrome.Location = New-Object System.Drawing.Size(30, 240)
$CheckBox_GoogleChrome.Size = New-Object System.Drawing.Size(400, 20)
$CheckBox_GoogleChrome.Text = 'Google Chrome'
$CheckBox_GoogleChrome.Checked = $false
$Form_Step1.Controls.Add($CheckBox_GoogleChrome)

$Form_Step1_OK = New-Object System.Windows.Forms.Button
$Form_Step1_OK.Location = New-Object System.Drawing.Size(100, 300)
$Form_Step1_OK.Size = New-Object System.Drawing.Size(100, 40)
$Form_Step1_OK.Text = 'OK'
$Form_Step1_OK.Add_Click({ $Form_Step1.Close() })
$Form_Step1.Controls.Add($Form_Step1_OK)

$Form_Step1_Cancel = New-Object System.Windows.Forms.Button
$Form_Step1_Cancel.Location = New-Object System.Drawing.Size(300, 300)
$Form_Step1_Cancel.Size = New-Object System.Drawing.Size(100, 40)
$Form_Step1_Cancel.Text = 'Cancel'
$Form_Step1_Cancel.Add_Click({ $Form_Step1.Close() })
$Form_Step1.Controls.Add($Form_Step1_Cancel)

$CheckBox_PCPassword.Add_Click( {
		if ($CheckBox_PCPassword.Checked -eq $true) {
			$TextBox_PCPassword.Enabled = $true
			$CheckBox_PCAutoLogin.Enabled = $true
			$TextBox_PCPassword.Text = ''
		}
		elseif ($CheckBox_PCPassword.Checked -eq $false) {
			$TextBox_PCPassword.Enabled = $false
			$CheckBox_PCAutoLogin.Enabled = $false
			$TextBox_PCPassword.Text = 'Password'
		}   
	}
)

$CheckBox_RemotePowerShell.Add_Click( {
		if ($CheckBox_RemotePowerShell.Checked -eq $true) {
			$TextBox_RemotePowerShellIP.Enabled = $true
			$TextBox_RemotePowerShellIP.Text = ''
		}
		elseif ($CheckBox_RemotePowerShell.Checked -eq $false) {
			$TextBox_RemotePowerShellIP.Enabled = $false
			$TextBox_RemotePowerShellIP.Text = 'IP'
		}
	}
)

$Form_Step1_OK.Add_Click{
	if ($CheckBox_PCPassword.Checked -eq $true) {
		Write-Host 'Step1: PC Password: Adding' -ForegroundColor green -BackgroundColor black
		Set-LocalUser -Name $env:username -Password (ConvertTo-SecureString -AsPlainText $TextBox_PCPassword.Text -Force)
		New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'DefaultPassword' -Value $TextBox_PCPassword.Text -PropertyType String -Force
	}
	elseif ($CheckBox_PCPassword.Checked -eq $false) {
		Write-Host 'Step1: PC Password: Removing' -ForegroundColor green -BackgroundColor black
		Set-LocalUser -Name $env:username -Password ([securestring]::new())
		New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon' -Value '0' -PropertyType String -Force
	}

	if ($CheckBox_PCAutoLogin.Checked -eq $true) {
		Write-Host 'Step1: PC Auto Login: Enabling' -ForegroundColor green -BackgroundColor black
		New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon' -Value '1' -PropertyType String -Force
	}
	elseif ($CheckBox_PCAutoLogin.Checked -eq $false) {
		Write-Host 'Step1: PC Auto Login: Disabling' -ForegroundColor green -BackgroundColor black
		New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon' -Value '0' -PropertyType String -Force
	}

	if ($CheckBox_RemoteDesktop.Checked -eq $true) {
		Write-Host 'Step1: Remote Desktop: Enabling' -ForegroundColor green -BackgroundColor black
		Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0
		Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'
	}
	elseif ($CheckBox_RemoteDesktop.Checked -eq $false) {
		Write-Host 'Step1: Remote Desktop: Disabling' -ForegroundColor green -BackgroundColor black
		Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 1
		Disable-NetFirewallRule -DisplayGroup 'Remote Desktop'
	}

	if ($CheckBox_RemotePowerShell.Checked -eq $true) {
		Write-Host 'Step1: Remote PowerShell: Enabling' -ForegroundColor green -BackgroundColor black
		Set-NetConnectionProfile -NetworkCategory Private
		Enable-PSRemoting -Force
		Write-Host 'Step1: Remote PowerShell: Adding IP' -ForegroundColor green -BackgroundColor black
		Set-Item wsman:\localhost\Client\TrustedHosts -Value $TextBox_RemotePowerShellIP.Text -Force
	}
	elseif ($CheckBox_RemotePowerShell.Checked -eq $false) {
		Write-Host 'Step1: Remote PowerShell: Disabling' -ForegroundColor green -BackgroundColor black
		Disable-PSRemoting -Force
		Remove-Item -Path WSMan:\Localhost\listener\listener* -Recurse
		Clear-Item wsman:\localhost\client\trustedhosts -Force
		Set-NetFirewallRule -DisplayName 'Windows Remote Management (HTTP-In)' -Enabled False | Select-Object -Property DisplayName, Profile, Enabled
		Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system -Name LocalAccountTokenFilterPolicy -Value 0
		Stop-Service WinRM
		Set-Service WinRM -StartupType Manual
	}

	if ($CheckBox_MozillaFirefox.Checked -eq $true) {
		Write-Host 'Step1: Mozilla Firefox: Initiating' -ForegroundColor green -BackgroundColor black
		Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Download.ps1')
	}

	if ($CheckBox_GoogleChrome.Checked -eq $true) {
		Write-Host 'Step1: Google Chrome: Initiating' -ForegroundColor green -BackgroundColor black
		Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Chrome/Download.ps1')
	}
}

$Form_Step1.Add_Shown({ $Form_Step1.Activate() })
[void] $Form_Step1.ShowDialog()
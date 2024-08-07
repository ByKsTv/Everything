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

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$Step1_Form = New-Object System.Windows.Forms.Form
$Step1_Form.width = 350
$Step1_Form.height = 375
$Step1_Form.Text = 'Initial Setup'
$Step1_Form.StartPosition = 'CenterScreen'
$Step1_Form.Font = New-Object System.Drawing.Font('Tahoma', 11)
$Step1_Form.Topmost = $true
$Step1_Form.MaximizeBox = $false
$Step1_Form.MinimizeBox = $false
$Step1_Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

$Step1_X_Axis = 5
$Step1_Y_Axis = 0
$Step1_Size_X = (($Step1_Form.width) - 25)
$Step1_Size_Y = 26
$Step1_LocationAdd = 26

$Step1_KeyboardLayoutTimeZone = New-Object System.Windows.Forms.Label
$Step1_KeyboardLayoutTimeZone.Text = 'Time Zone:'
$Step1_KeyboardLayoutTimeZone.Location = New-Object System.Drawing.Point($Step1_X_Axis, $Step1_Y_Axis)
$Step1_Y_Axis += $Step1_LocationAdd
$Step1_KeyboardLayoutTimeZone.Size = New-Object System.Drawing.Size($Step1_Size_X, $Step1_Size_Y)
$Step1_Form.Controls.Add($Step1_KeyboardLayoutTimeZone)

$Step1_KeyboardLayoutComboBoxTimeZone = New-Object System.Windows.Forms.ComboBox
$Step1_KeyboardLayoutComboBoxTimeZone.Location = New-Object System.Drawing.Point($Step1_X_Axis, $Step1_Y_Axis)
$Step1_Y_Axis += $Step1_LocationAdd
$Step1_KeyboardLayoutComboBoxTimeZone.Size = New-Object System.Drawing.Size($Step1_Size_X, $Step1_Size_Y)
$Step1_KeyboardLayoutComboBoxTimeZone.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$timeZones = [System.TimeZoneInfo]::GetSystemTimeZones() | Sort-Object -Property Id
$null = $timeZones.ForEach({ $Step1_KeyboardLayoutComboBoxTimeZone.Items.Add($_.Id) })
$Step1_Form.Controls.Add($Step1_KeyboardLayoutComboBoxTimeZone)

$Step1_KeyboardLayout = New-Object System.Windows.Forms.Label
$Step1_KeyboardLayout.Text = 'Keyboard Layout:'
$Step1_KeyboardLayout.Location = New-Object System.Drawing.Point($Step1_X_Axis, $Step1_Y_Axis)
$Step1_Y_Axis += $Step1_LocationAdd
$Step1_KeyboardLayout.Size = New-Object System.Drawing.Size($Step1_Size_X, $Step1_Size_Y)
$Step1_Form.Controls.Add($Step1_KeyboardLayout)

$Step1_KeyboardLayoutComboBox = New-Object System.Windows.Forms.ComboBox
$Step1_KeyboardLayoutComboBox.Location = New-Object System.Drawing.Point($Step1_X_Axis, $Step1_Y_Axis)
$Step1_Y_Axis += $Step1_LocationAdd
$Step1_KeyboardLayoutComboBox.Size = New-Object System.Drawing.Size($Step1_Size_X, $Step1_Size_Y)
$Step1_KeyboardLayoutComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$languageTags = @(
	'af-ZA', 'am-ET', 'ar-SA', 'az-Latn-AZ', 'bg-BG', 'bn-IN', 'bs-Latn-BA', 'ca-ES', 'cs-CZ', 'cy-GB',
	'da-DK', 'de-DE', 'el-GR', 'en-GB', 'en-US', 'es-ES', 'es-MX', 'et-EE', 'eu-ES', 'fa-IR', 'fi-FI',
	'fil-PH', 'fr-CA', 'fr-FR', 'ga-IE', 'gl-ES', 'gu-IN', 'he-IL', 'hi-IN', 'hr-HR', 'hu-HU', 'hy-AM',
	'id-ID', 'is-IS', 'it-IT', 'ja-JP', 'ka-GE', 'kk-KZ', 'km-KH', 'kn-IN', 'ko-KR', 'ky-KG', 'lt-LT',
	'lv-LV', 'mk-MK', 'ml-IN', 'mn-MN', 'mr-IN', 'ms-MY', 'mt-MT', 'nb-NO', 'nl-NL', 'pl-PL', 'pt-BR',
	'pt-PT', 'ro-RO', 'ru-RU', 'si-LK', 'sk-SK', 'sl-SI', 'sq-AL', 'sr-Cyrl-RS', 'sv-SE', 'sw-KE', 'ta-IN',
	'te-IN', 'th-TH', 'tr-TR', 'uk-UA', 'ur-PK', 'uz-Latn-UZ', 'vi-VN', 'zh-CN', 'zh-TW', 'af-NA', 'ak-GH',
	'ar-AE', 'ar-BH', 'ar-DZ', 'ar-EG', 'ar-IQ', 'ar-JO', 'ar-KW', 'ar-LB', 'ar-LY', 'ar-MA', 'ar-OM',
	'ar-QA', 'ar-SY', 'ar-TN', 'ar-YE', 'as-IN', 'az-Cyrl-AZ', 'be-BY', 'bn-BD', 'bs-Cyrl-BA', 'cs-SK',
	'de-AT', 'de-CH', 'de-LU', 'dsb-DE', 'dua-CM', 'dv-MV', 'en-AU', 'en-CA', 'en-IN', 'en-IE', 'en-NZ',
	'en-ZA', 'eo-001', 'es-AR', 'es-BO', 'es-CL', 'es-CO', 'es-CR', 'es-DO', 'es-EC', 'es-GT', 'es-HN',
	'es-NI', 'es-PA', 'es-PE', 'es-PR', 'es-PY', 'es-SV', 'es-US', 'es-UY', 'es-VE', 'et-SE', 'ff-Latn-NG',
	'fi-SE', 'fo-FO', 'fr-BE', 'fr-CH', 'fr-CM', 'fr-LU', 'gsw-FR', 'ha-Latn-NG', 'haw-US', 'hi-Latn-IN',
	'is-LT', 'it-SM', 'iu-Cans-CA', 'ja-Latn-JP', 'jv-Latn-ID', 'kl-GL', 'km-TH', 'kn-Latn-IN', 'ko-Latn-KR',
	'ks-Deva-IN', 'ku-Arab-IQ', 'lb-LU', 'lg-UG', 'ln-CG', 'lo-LA', 'mg-MG', 'mi-NZ', 'ml-TH', 'mr-Latn-IN',
	'ms-Latn-SG', 'nb-SJ', 'ne-NP', 'nl-BE', 'no-NO', 'oc-FR', 'om-ET', 'or-IN', 'pa-Arab-PK', 'pa-IN',
	'qu-EC', 'qu-PE', 'ro-MD', 'rw-RW', 'sd-Arab-PK', 'sd-Deva-IN', 'se-NO', 'si-IN', 'sm-WS', 'sn-Latn-ZW',
	'so-SO', 'sq-MK', 'sr-Latn-RS', 'su-Latn-ID', 'sv-AX', 'sw-TZ', 'syr-SY', 'tg-Cyrl-TJ', 'tk-Latn-TM',
	'tn-BW', 'to-TO', 'tt-Cyrl-RU', 'tzm-Latn-MA', 'ug-Arab-CN', 'ur-IN', 'uz-Cyrl-UZ', 'vi-Latn-VN',
	'wo-SN', 'xh-ZA', 'yo-NG', 'zu-ZA'
)
function Get-LanguageName {
	param (
		[string]$languageTag
	)

	try {
		$culture = [System.Globalization.CultureInfo]::GetCultureInfo($languageTag)
		return $culture.DisplayName
	}
	catch {
		return $languageTag
	}
}
$languageMap = @{}
foreach ($tag in $languageTags) {
	$name = Get-LanguageName -languageTag $tag
	$languageMap[$name] = $tag
}
$sortedLanguageNames = $languageMap.Keys | Sort-Object
foreach ($name in $sortedLanguageNames) {
	$Step1_KeyboardLayoutComboBox.Items.Add($name) | Out-Null
}
$Step1_Form.Controls.Add($Step1_KeyboardLayoutComboBox)

$CheckBox_PCPassword = New-Object System.Windows.Forms.CheckBox
$CheckBox_PCPassword.Location = New-Object System.Drawing.Size($Step1_X_Axis, $Step1_Y_Axis)
$Step1_Y_Axis += $Step1_LocationAdd
$CheckBox_PCPassword.Size = New-Object System.Drawing.Size($Step1_Size_X, $Step1_Size_Y)
$CheckBox_PCPassword.Text = 'PC Password'
$CheckBox_PCPassword.Checked = $false
$Step1_Form.Controls.Add($CheckBox_PCPassword)

$TextBox_PCPassword = New-Object System.Windows.Forms.TextBox
$TextBox_PCPassword.Location = New-Object System.Drawing.Size($Step1_X_Axis, $Step1_Y_Axis)
$Step1_Y_Axis += $Step1_LocationAdd
$TextBox_PCPassword.Size = New-Object System.Drawing.Size($Step1_Size_X, $Step1_Size_Y)
$TextBox_PCPassword.Text = 'Password'
$TextBox_PCPassword.Enabled = $false
$Step1_Form.Controls.Add($TextBox_PCPassword)

$CheckBox_PCAutoLogin = New-Object System.Windows.Forms.CheckBox
$CheckBox_PCAutoLogin.Location = New-Object System.Drawing.Size($Step1_X_Axis, $Step1_Y_Axis)
$Step1_Y_Axis += $Step1_LocationAdd
$CheckBox_PCAutoLogin.Size = New-Object System.Drawing.Size($Step1_Size_X, $Step1_Size_Y)
$CheckBox_PCAutoLogin.Text = 'PC Auto Login'
$CheckBox_PCAutoLogin.Checked = $false
$CheckBox_PCAutoLogin.Enabled = $false
$Step1_Form.Controls.Add($CheckBox_PCAutoLogin)

$CheckBox_RemoteDesktop = New-Object System.Windows.Forms.CheckBox
$CheckBox_RemoteDesktop.Location = New-Object System.Drawing.Size($Step1_X_Axis, $Step1_Y_Axis)
$Step1_Y_Axis += $Step1_LocationAdd
$CheckBox_RemoteDesktop.Size = New-Object System.Drawing.Size($Step1_Size_X, $Step1_Size_Y)
$CheckBox_RemoteDesktop.Text = 'Remote Desktop'
$CheckBox_RemoteDesktop.Checked = $false
$Step1_Form.Controls.Add($CheckBox_RemoteDesktop)

$CheckBox_RemotePowerShell = New-Object System.Windows.Forms.CheckBox
$CheckBox_RemotePowerShell.Location = New-Object System.Drawing.Size($Step1_X_Axis, $Step1_Y_Axis)
$Step1_Y_Axis += $Step1_LocationAdd
$CheckBox_RemotePowerShell.Size = New-Object System.Drawing.Size($Step1_Size_X, $Step1_Size_Y)
$CheckBox_RemotePowerShell.Text = 'Remote PowerShell'
$CheckBox_RemotePowerShell.Checked = $false
$Step1_Form.Controls.Add($CheckBox_RemotePowerShell)

$TextBox_RemotePowerShellIP = New-Object System.Windows.Forms.TextBox
$TextBox_RemotePowerShellIP.Location = New-Object System.Drawing.Size($Step1_X_Axis, $Step1_Y_Axis)
$Step1_Y_Axis += $Step1_LocationAdd
$TextBox_RemotePowerShellIP.Size = New-Object System.Drawing.Size($Step1_Size_X, $Step1_Size_Y)
$TextBox_RemotePowerShellIP.Text = 'IP'
$TextBox_RemotePowerShellIP.Enabled = $false
$Step1_Form.Controls.Add($TextBox_RemotePowerShellIP)

$CheckBox_MozillaFirefox = New-Object System.Windows.Forms.CheckBox
$CheckBox_MozillaFirefox.Location = New-Object System.Drawing.Size($Step1_X_Axis, $Step1_Y_Axis)
$Step1_Y_Axis += $Step1_LocationAdd
$CheckBox_MozillaFirefox.Size = New-Object System.Drawing.Size($Step1_Size_X, $Step1_Size_Y)
$CheckBox_MozillaFirefox.Text = 'Mozilla Firefox'
$CheckBox_MozillaFirefox.Checked = $false
$Step1_Form.Controls.Add($CheckBox_MozillaFirefox)

$CheckBox_GoogleChrome = New-Object System.Windows.Forms.CheckBox
$CheckBox_GoogleChrome.Location = New-Object System.Drawing.Size($Step1_X_Axis, $Step1_Y_Axis)
$Step1_Y_Axis += $Step1_LocationAdd
$CheckBox_GoogleChrome.Size = New-Object System.Drawing.Size($Step1_Size_X, $Step1_Size_Y)
$CheckBox_GoogleChrome.Text = 'Google Chrome'
$CheckBox_GoogleChrome.Checked = $false
$Step1_Form.Controls.Add($CheckBox_GoogleChrome)

$Step1_Form_OK = New-Object System.Windows.Forms.Button
$Step1_Form_OK.Location = New-Object System.Drawing.Size((($Step1_Form.Width) / 3 ), (($Step1_Form.height) - 60))
$Step1_Form_OK.Size = New-Object System.Drawing.Size(57, 20)
$Step1_Form_OK.Text = 'OK'
$Step1_Form_OK.Add_Click({ $Step1_Form.Close() })
$Step1_Form.Controls.Add($Step1_Form_OK)

$Step1_Form_Cancel = New-Object System.Windows.Forms.Button
$Step1_Form_Cancel.Location = New-Object System.Drawing.Size((($Step1_Form.Width) / 2 ), (($Step1_Form.height) - 60))
$Step1_Form_Cancel.Size = New-Object System.Drawing.Size(57, 20)
$Step1_Form_Cancel.Text = 'Cancel'
$Step1_Form_Cancel.Add_Click({ $Step1_Form.Close() })
$Step1_Form.Controls.Add($Step1_Form_Cancel)

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

$Step1_Form_OK.Add_Click{
	$selectedTimeZone = $Step1_KeyboardLayoutComboBoxTimeZone.SelectedItem
	if ($selectedTimeZone) {
		Write-Host "Step1: Time Zone: Setting $selectedTimeZone" -ForegroundColor green -BackgroundColor black
		tzutil /s $selectedTimeZone
	}
	
	$selectedName = $Step1_KeyboardLayoutComboBox.SelectedItem
	if ($selectedName) {
		Write-Host "Step1: Keyboard: Adding $selectedName" -ForegroundColor green -BackgroundColor black
		$selectedTag = $languageMap[$selectedName]
		$currentLanguageList = Get-WinUserLanguageList
		$currentLanguageList.Add($selectedTag)
		Set-WinUserLanguageList -LanguageList $currentLanguageList -Force
	}

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
$Step1_Form.Add_Shown({ $Step1_Form.Activate() })
[void] $Step1_Form.ShowDialog()

Write-Host 'Step1: Windows Updates: Searching' -ForegroundColor green -BackgroundColor black
$updateSession = New-Object -ComObject Microsoft.Update.Session
$updateSearcher = $updateSession.CreateUpdateSearcher()
$updateDownloader = $updateSession.CreateUpdateDownloader()
$updateInstaller = $updateSession.CreateUpdateInstaller()
$searchResult = $updateSearcher.Search('IsInstalled=0')

if ($searchResult.Updates.Count -eq 0) {
	Write-Host 'Step1: Windows Updates: No updates available' -ForegroundColor green -BackgroundColor black
	return
}

Write-Host 'Step1: Windows Updates: Available Updates:' -ForegroundColor green -BackgroundColor black
for ($i = 0; $i -lt $searchResult.Updates.Count; $i++) {
	$update = $searchResult.Updates.Item($i)
	Write-Host "$($i+1). $($update.Title)" -ForegroundColor green -BackgroundColor black
}

Write-Host 'Step1: Windows Updates: Downloading' -ForegroundColor green -BackgroundColor black
$updatesToDownload = New-Object -ComObject Microsoft.Update.UpdateColl
for ($i = 0; $i -lt $searchResult.Updates.Count; $i++) {
	$update = $searchResult.Updates.Item($i)
	$updatesToDownload.Add($update) | Out-Null
}
$updateDownloader.Updates = $updatesToDownload
$downloadResult = $updateDownloader.Download()

if ($downloadResult.ResultCode -ne 2) {
	Write-Host "Step1: Windows Updates: Download failed. Result code: $($downloadResult.ResultCode)" -ForegroundColor green -BackgroundColor black
	return
}

Write-Host 'Step1: Windows Updates: Installing' -ForegroundColor green -BackgroundColor black
$updatesToInstall = New-Object -ComObject Microsoft.Update.UpdateColl
for ($i = 0; $i -lt $searchResult.Updates.Count; $i++) {
	$update = $searchResult.Updates.Item($i)
	if ($update.IsDownloaded) {
		$updatesToInstall.Add($update) | Out-Null
	}
}
$updateInstaller.Updates = $updatesToInstall
$installationResult = $updateInstaller.Install()

if ($installationResult.ResultCode -ne 2) {
	Write-Host "Step1: Windows Updates: Installation failed. Result code: $($installationResult.ResultCode)" -ForegroundColor green -BackgroundColor black
	return
}

$needsReboot = $false
for ($i = 0; $i -lt $updatesToInstall.Count; $i++) {
	if ($updatesToInstall.Item($i).RebootRequired) {
		$needsReboot = $true
		break
	}
}

if ($needsReboot) {
	Write-Host 'Step1: Windows Updates: Restarting' -ForegroundColor green -BackgroundColor black
	Restart-Computer -Force
}

Write-Host 'Step1: Manually Update Windows and Restart PC' -ForegroundColor green -BackgroundColor black
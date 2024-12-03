# Settings: System: Activation
& ([ScriptBlock]::Create(((New-Object System.Net.WebClient).DownloadString('https://get.activated.win/')))) /KMS38

# Settings: System: Multitasking: Snap windows: When I snap a window, suggest what I can snap next to it: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'SnapAssist' -PropertyType DWord -Value 0 -Force

# Settings: System: Multitasking: Snap windows: Show snap layouts when I over over a window's maximize button: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'EnableSnapAssistFlyout' -PropertyType DWord -Value 0 -Force

# Settings: System: For developers: End Task: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' -Name 'TaskbarEndTask' -PropertyType DWord -Value 1 -Force

# Settings: System: For developers: File Explorer: Show file extenstions: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' -Name 'HideFileExt' -PropertyType DWord -Value 0 -Force

# Settings: System: For developers: File Explorer: Show empty drives: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' -Name 'HideDrivesWithNoMedia' -PropertyType DWord -Value 0 -Force

# Settings: Bluetooth & devices: Devices: Device settings: Download over metered connections: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\DeviceSetup' -Name 'CostedNetworkPolicy' -PropertyType DWord -Value 1 -Force

# Settings: Bluetooth & devices: Mouse: Enhance pointer precision: Off
New-ItemProperty -Path 'HKCU:\Control Panel\Mouse' -Name 'MouseSpeed' -PropertyType String -Value 0 -Force
New-ItemProperty -Path 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold1' -PropertyType String -Value 0 -Force
New-ItemProperty -Path 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold2' -PropertyType String -Value 0 -Force

# Settings: Bluetooth & devices: USB: Connection notifications: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Shell\USB')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Shell\USB' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Shell\USB' -Name 'NotifyOnUsbErrors' -PropertyType DWord -Value 1 -Force

# Settings: Personalization: Colors: Choose your mode: Dark
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'SystemUsesLightTheme' -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Colors: Transparency effects: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'EnableTransparency' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Start: Show recently added apps: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Start' -Name 'ShowRecentList' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Start: Show recommended files in Start, recent files in File Explorer, and items in Jump Lists: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_TrackDocs' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Start: Show recommendations for tips, shortcuts, new apps, and more: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_IrisRecommendations' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Start: Show account-related notifications: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_AccountNotifications' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Taskbar: Taskbar items: Search: Hide
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' -Name 'SearchboxTaskbarMode' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Taskbar: Taskbar items: Task view: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowTaskViewButton' -Value 0 -PropertyType DWord -Force

# Settings: Personalization: Taskbar: Taskbar behaviors: Taskbar alignment: Left
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarAl' -PropertyType DWord -Value 0 -Force

# Settings: Accessibility: Keyboard: Use the Print screen key to open screen capture: Off
New-ItemProperty -Path 'HKCU:\Control Panel\Keyboard' -Name 'PrintScreenKeyForSnippingEnabled' -PropertyType DWord -Value 0 -Force

# Settings: Privacy & security: General: Let websites show me locally relevant content by accessing my language list: Off
New-ItemProperty -Path 'HKCU:\Control Panel\International\User Profile' -Name 'HttpAcceptLanguageOptOut' -PropertyType DWord -Value 1 -Force

# Settings: Privacy & security: General: Let Windows improve Start and search results by tracking app launches: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_TrackProgs' -PropertyType DWord -Value 0 -Force

# Settings: Privacy & security: Inking & typing personalization: Custom inking and typing dictionary: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore' -Name 'HarvestContacts' -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Personalization\Settings' -Name 'AcceptedPrivacyPolicy' -PropertyType DWord -Value 0 -Force
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CPSS\Store\InkingAndTypingPersonalization')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CPSS\Store\InkingAndTypingPersonalization' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CPSS\Store\InkingAndTypingPersonalization' -Name 'Value' -PropertyType DWord -Value 0 -Force

# Settings: Privacy & security: Feedback: Feedback fequency: Never
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules' -Name 'NumberOfSIUFInPeriod' -PropertyType DWord -Value 0 -Force

# Settings: Windows Update: Advanced options: Receive updates for other Microsoft products: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\WindowsUpdate\UX\Settings' -Name 'AllowMUUpdateService' -PropertyType DWord -Value 1 -Force

# Settings: Windows Update: Advanced options: Get me up to date: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\WindowsUpdate\UX\Settings' -Name 'IsExpedited' -PropertyType DWord -Value 1 -Force

# Settings: Windows Update: Advanced options: Download updates over metered connections: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\WindowsUpdate\UX\Settings' -Name 'AllowAutoWindowsUpdateDownloadOverMeteredNetwork' -PropertyType DWord -Value 1 -Force

# Settings: Windows Update: Advanced options: Notify me when a restart is required to finish updating: On
New-ItemProperty -Path 'HKLM:\Software\Microsoft\WindowsUpdate\UX\Settings' -Name 'RestartNotificationsAllowed2' -PropertyType DWord -Value 1 -Force

# Folder Options: Open File Explorer to: This PC
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LaunchTo' -PropertyType DWord -Value 1 -Force

# Folder Options: General: Privacy: Show recently used files: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowRecent' -PropertyType DWord -Value 0 -Force

# Folder Options: General: Privacy: Show frequently used folders: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowFrequent' -PropertyType DWord -Value 0 -Force

# Folder Options: General: Privacy: Show files from Office.com: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowCloudFilesInQuickAccess' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Advanced settings: Decrease space between items (compact view): On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'UseCompactMode' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Advanced settings: Hidden files and folders: Show hidden files, folders, and drives
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Hidden' -PropertyType DWord -Value 1 -Force

# Power Plan: Restore default schemes
powercfg.exe /restoredefaultschemes
$PowerPlanUltimate = powercfg.exe -list | Select-String -Pattern 'Ultimate Performance'
$PowerPlanHigh = powercfg.exe -list | Select-String -Pattern 'High performance'
if ($PowerPlanUltimate) {
	$PowerPlanGUID = ($PowerPlanUltimate.Line -split 'GUID: ')[1].Trim().Split(' ')[0]
	# Power Plan: Ultimate Performance
	powercfg.exe /setactive $PowerPlanGUID
}
elseif ($PowerPlanHigh) {
	$PowerPlanGUID = ($PowerPlanHigh.Line -split 'GUID: ')[1].Trim().Split(' ')[0]
	# Power Plan: High performance
	powercfg.exe /setactive $PowerPlanGUID
}
# Power Plan: Turn off display after: 0 Seconds (Never)
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0

# Control Panel: Ease of Access: Ease of Access Center: Make the computer easier to see: Remove background images (when available): On
$RemoveBackgroundImagesBytes = [byte[]](Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask').UserPreferencesMask
$RemoveBackgroundImagesBytes[4] = $RemoveBackgroundImagesBytes[4]-bor 1
New-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -PropertyType Binary -Value $RemoveBackgroundImagesBytes -Force

# Uninstall `Feedback Hub`
Get-AppxPackage 'Microsoft.WindowsFeedbackHub' | Remove-AppxPackage

# Task Manager: Startup apps: Delete: AzureArcSetup
if ($null -ne (Get-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run').GetValue('AzureArcSetup')) {
	Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'AzureArcSetup'
}

# Server Manager: Don't show this message again
New-ItemProperty -Path 'HKLM:\Software\Microsoft\ServerManager' -Name 'DoNotPopWACConsoleAtSMLaunch' -PropertyType DWord -Value 1 -Force

# Add username to autologon
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'DefaultUsername' -Value $env:username -PropertyType String -Force

# Maximum password age (days): Unlimited
net.exe accounts /maxpwage:unlimited

# PasswordComplexity: Off
secedit.exe /export /cfg "$env:TEMP\PasswordComplexity.cfg"
(Get-Content "$env:TEMP\PasswordComplexity.cfg") -replace 'PasswordComplexity = 1', 'PasswordComplexity = 0' | Set-Content "$env:TEMP\PasswordComplexity.cfg"
secedit.exe /configure /db secedit.sdb /cfg "$env:TEMP\PasswordComplexity.cfg" /areas SECURITYPOLICY

# Sound: Communications: Do nothing
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Multimedia\Audio' -Name 'UserDuckingPreference' -PropertyType DWord -Value 3 -Force

# Group Policy: Computer Configuration: Administrative Templates: System: Display Shutdown Event Tracker: Disabled
if (-not (Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\Reliability')) {
	New-Item -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\Reliability' -Force
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows NT\Reliability' -Name 'ShutdownReasonOn' -PropertyType DWord -Value 0 -Force

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Do not allow web search: Enabled
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'DisableWebSearch' -PropertyType DWord -Value 1 -Force

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Don't search the web or display web results in Search: Enabled
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchUseWeb' -PropertyType DWord -Value 0 -Force

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Don't search the web or display web results in Search over metered connections: Enabled
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchUseWebOverMeteredConnections' -PropertyType DWord -Value 0 -Force

# Restore the old Context Menu in Windows 11
if (-not (Test-Path -Path 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32')) {
	New-Item -Path 'HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32' -Force
}
New-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Name "(Default)" -Value "" -Force

# Taskbar tray icons
Get-ChildItem 'HKCU:\Control Panel\NotifyIconSettings' -Recurse | ForEach-Object { New-ItemProperty -Path $_.PSPath -Name 'IsPromoted' -Value 1 -PropertyType DWORD -Force }

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()

$InitialSetup_Form = New-Object System.Windows.Forms.Form -Property @{
	Text            = 'Initial Setup'
	Font            = [Drawing.Font]::new('Tahoma', 11)
	Width           = 350
	Height          = 380
	StartPosition   = 'CenterScreen'
	FormBorderStyle = 'FixedDialog'
	Topmost         = $true
	MaximizeBox     = $false
	MinimizeBox     = $false
	ControlBox      = $false
}

$InitialSetup_ButtonSpacer = 15
$InitialSetup_ButtonWidth = 57
$InitialSetup_TotalButtonWidth = $InitialSetup_ButtonSpacer + $InitialSetup_ButtonWidth + $InitialSetup_ButtonWidth
$InitialSetup_FormCenterX = [math]::Round(($InitialSetup_Form.ClientSize.Width - $InitialSetup_TotalButtonWidth) / 2)
$InitialSetup_ButtonHeight = 20
$InitialSetup_ButtonYLocation = $InitialSetup_Form.Height - 60

$InitialSetup_OK = New-Object System.Windows.Forms.Button -Property @{
	Text      = 'OK'
	Width     = $InitialSetup_ButtonWidth
	Height    = $InitialSetup_ButtonHeight
	Location  = [Drawing.Point]::new($InitialSetup_FormCenterX, $InitialSetup_ButtonYLocation)
	Add_Click = { $InitialSetup_Form.Close() }
}

$InitialSetup_CancelX = $InitialSetup_FormCenterX + $InitialSetup_ButtonWidth + $InitialSetup_ButtonSpacer
$InitialSetup_Cancel = New-Object System.Windows.Forms.Button -Property @{
	Text      = 'Cancel'
	Width     = $InitialSetup_ButtonWidth
	Height    = $InitialSetup_ButtonHeight
	Location  = [Drawing.Point]::new($InitialSetup_CancelX, $InitialSetup_ButtonYLocation)
	Add_Click = { $InitialSetup_Form.Close() }
}

$InitialSetup_LocX = 5
$InitialSetup_LocY = 0
$InitialSetup_SizeX = $InitialSetup_Form.Width - 30
$InitialSetup_SizeY = 26
$InitialSetup__LocAdd = 30

$InitialSetup_TimeZoneSelection = New-Object System.Windows.Forms.ComboBox -Property @{
	Width         = $InitialSetup_SizeX
	Height        = $InitialSetup_SizeY
	Location      = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
	DropDownStyle = 'DropDownList'
}
[void] $InitialSetup_TimeZoneSelection.Items.Add('Select Time Zone')
$InitialSetup_TimeZoneSelection.SelectedIndex = 0
$TimeZones = [TimeZoneInfo]::GetSystemTimeZones() | Sort-Object -Property Id
[void] $TimeZones.ForEach({ $InitialSetup_TimeZoneSelection.Items.Add($_.Id) })

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_KeyboardSelection = New-Object System.Windows.Forms.ComboBox -Property @{
	Width         = $InitialSetup_SizeX
	Height        = $InitialSetup_SizeY
	Location      = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
	DropDownStyle = 'DropDownList'
}
[void] $InitialSetup_KeyboardSelection.Items.Add('Select Keyboard')
$InitialSetup_KeyboardSelection.SelectedIndex = 0
$Keyboard_Tags = @('af-ZA', 'am-ET', 'ar-SA', 'az-Latn-AZ', 'bg-BG', 'bn-IN', 'bs-Latn-BA', 'ca-ES', 'cs-CZ', 'cy-GB', 'da-DK', 'de-DE', 'el-GR', 'en-GB', 'en-US', 'es-ES', 'es-MX', 'et-EE', 'eu-ES', 'fa-IR', 'fi-FI', 'fil-PH', 'fr-CA', 'fr-FR', 'ga-IE', 'gl-ES', 'gu-IN', 'he-IL', 'hi-IN', 'hr-HR', 'hu-HU', 'hy-AM', 'id-ID', 'is-IS', 'it-IT', 'ja-JP', 'ka-GE', 'kk-KZ', 'km-KH', 'kn-IN', 'ko-KR', 'ky-KG', 'lt-LT', 'lv-LV', 'mk-MK', 'ml-IN', 'mn-MN', 'mr-IN', 'ms-MY', 'mt-MT', 'nb-NO', 'nl-NL', 'pl-PL', 'pt-BR', 'pt-PT', 'ro-RO', 'ru-RU', 'si-LK', 'sk-SK', 'sl-SI', 'sq-AL', 'sr-Cyrl-RS', 'sv-SE', 'sw-KE', 'ta-IN', 'te-IN', 'th-TH', 'tr-TR', 'uk-UA', 'ur-PK', 'uz-Latn-UZ', 'vi-VN', 'zh-CN', 'zh-TW')
$Keyboard_Map = @{}
foreach ($Keyboard_Tag in $Keyboard_Tags) {
	try {
		$Keyboard_Map[[Globalization.CultureInfo]::GetCultureInfo($Keyboard_Tag).DisplayName] = $Keyboard_Tag 
	}
	catch {
		$Keyboard_Map[$Keyboard_Tag] = $Keyboard_Tag 
	}
}
$Keyboard_Map.Keys | Sort-Object | ForEach-Object { $InitialSetup_KeyboardSelection.Items.Add($_) | Out-Null }

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_PreComputerName = 'Enter Computer Name'
$InitialSetup_ComputerName = New-Object System.Windows.Forms.TextBox -Property @{
	Text     = $InitialSetup_PreComputerName
	Width    = $InitialSetup_SizeX
	Height   = $InitialSetup_SizeY
	Location = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
}
$InitialSetup_ComputerName.Add_GotFocus{ if ($InitialSetup_ComputerName.Text -eq $InitialSetup_PreComputerName) {
		$InitialSetup_ComputerName.Text = ''
	}
}
$InitialSetup_ComputerName.Add_LostFocus({ if ($InitialSetup_ComputerName.Text -eq '') {
			$InitialSetup_ComputerName.Text = $InitialSetup_PreComputerName
		}
	}
)

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_ComputerPasswordCheckBox = New-Object System.Windows.Forms.CheckBox -Property @{
	Text     = 'Computer Password'
	Width    = $InitialSetup_SizeX
	Height   = $InitialSetup_SizeY
	Location = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
}

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_ComputerPasswordTextBox = New-Object System.Windows.Forms.TextBox -Property @{
	Text     = 'Computer Password'
	Enabled  = $false
	Width    = $InitialSetup_SizeX
	Height   = $InitialSetup_SizeY
	Location = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
}

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_AutoLogonCheckBox = New-Object System.Windows.Forms.CheckBox -Property @{
	Text     = 'Autologon'
	Enabled  = $false
	Width    = $InitialSetup_SizeX
	Height   = $InitialSetup_SizeY
	Location = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
}

$InitialSetup_ComputerPasswordCheckBox.Add_Click(
	{
		$ComputerPasswordEnabled = $InitialSetup_ComputerPasswordCheckBox.Checked
		$InitialSetup_ComputerPasswordTextBox.Enabled = $InitialSetup_AutoLogonCheckBox.Enabled = $ComputerPasswordEnabled
		$InitialSetup_ComputerPasswordTextBox.Text = if ($ComputerPasswordEnabled) {
			'' 
		}
		else {
			'Computer Password'
		}
	}
)

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_RemoteDesktop = New-Object System.Windows.Forms.CheckBox -Property @{
	Text     = 'Remote Desktop'
	Width    = $InitialSetup_SizeX
	Height   = $InitialSetup_SizeY
	Location = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
}

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_RemotePowershell = New-Object System.Windows.Forms.CheckBox -Property @{
	Text     = 'Remote Powershell'
	Width    = $InitialSetup_SizeX
	Height   = $InitialSetup_SizeY
	Location = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
}

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_RemotePowershellIP = New-Object System.Windows.Forms.TextBox -Property @{
	Text     = 'Remote Powershell Trusted IP'
	Enabled  = $false
	Width    = $InitialSetup_SizeX
	Height   = $InitialSetup_SizeY
	Location = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
}

$InitialSetup_RemotePowershell.Add_Click(
	{
		$RemotePowershellEnabled = $InitialSetup_RemotePowershell.Checked
		$InitialSetup_RemotePowershellIP.Enabled = $RemotePowershellEnabled
		$InitialSetup_RemotePowershellIP.Text = if ($RemotePowershellEnabled) {
			''
		}
		else {
			'Remote Powershell Trusted IP'
		}
	}
)

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_MozillaFirefox = New-Object System.Windows.Forms.CheckBox -Property @{
	Text     = 'Mozilla Firefox'
	Width    = $InitialSetup_SizeX
	Height   = $InitialSetup_SizeY
	Location = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
}

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_GoogleChrome = New-Object System.Windows.Forms.CheckBox -Property @{
	Text     = 'Google Chrome'
	Width    = $InitialSetup_SizeX
	Height   = $InitialSetup_SizeY
	Location = [Drawing.Point]::new($InitialSetup_LocX, $InitialSetup_LocY)
}

$InitialSetup_LocY += $InitialSetup__LocAdd

$InitialSetup_OK.Add_Click(
	{
		$InitialSetup_Form.Topmost = $false

		if ($InitialSetup_TimeZoneSelection.SelectedItem -and $InitialSetup_TimeZoneSelection.Text -ne 'Select Time Zone') {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Time Zone: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write($InitialSetup_TimeZoneSelection.SelectedItem); [Console]::ResetColor(); [Console]::WriteLine()
			tzutil.exe /s $InitialSetup_TimeZoneSelection.SelectedItem
		}

		if ($InitialSetup_KeyboardSelection.SelectedItem -and $InitialSetup_KeyboardSelection.Text -ne 'Select Keyboard') {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Keyboard: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write($InitialSetup_KeyboardSelection.SelectedItem); [Console]::ResetColor(); [Console]::WriteLine()
			$LanguageList = Get-WinUserLanguageList
			$LanguageList.Add($Keyboard_Map[$InitialSetup_KeyboardSelection.SelectedItem])
			Set-WinUserLanguageList -LanguageList $LanguageList -Force
		}

		if ($InitialSetup_ComputerName.Text -ne $InitialSetup_PreComputerName) {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Computer name: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write($InitialSetup_ComputerName.Text); [Console]::ResetColor(); [Console]::WriteLine()
			Rename-Computer -NewName $InitialSetup_ComputerName.Text -Force
		}

		if ($InitialSetup_ComputerPasswordCheckBox.Checked -eq $true) {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('PC Password: Adding'); [Console]::ResetColor(); [Console]::WriteLine()
			Set-LocalUser -Name $env:USERNAME -Password (ConvertTo-SecureString $InitialSetup_ComputerPasswordTextBox.Text -AsPlainText -Force)
			New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'DefaultPassword' -Value $InitialSetup_ComputerPasswordTextBox.Text -PropertyType String -Force
		}
		elseif ($InitialSetup_ComputerPasswordCheckBox.Checked -eq $false) {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('PC Password: Removing'); [Console]::ResetColor(); [Console]::WriteLine()
			Set-LocalUser -Name $env:USERNAME -Password (ConvertTo-SecureString '' -AsPlainText -Force)
			New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon' -Value '0' -PropertyType String -Force
		}
	
		if ($InitialSetup_AutoLogonCheckBox.Checked -eq $true) {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Autologon: Enabling'); [Console]::ResetColor(); [Console]::WriteLine()
			New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon' -Value '1' -PropertyType String -Force
		}
		elseif ($InitialSetup_AutoLogonCheckBox.Checked -eq $false) {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Autologon: Disabling'); [Console]::ResetColor(); [Console]::WriteLine()
			New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon' -Value '0' -PropertyType String -Force
		}

		if ($InitialSetup_RemoteDesktop.Checked -eq $true) {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Remote Desktop: Enabling'); [Console]::ResetColor(); [Console]::WriteLine()
			Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0
			Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'
		}
		elseif ($InitialSetup_RemoteDesktop.Checked -eq $false) {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Remote Desktop: Disabling'); [Console]::ResetColor(); [Console]::WriteLine()
			Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 1
			Disable-NetFirewallRule -DisplayGroup 'Remote Desktop'
		}

		if ($InitialSetup_RemotePowershell.Checked -eq $true) {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Remote PowerShell: Enabling'); [Console]::ResetColor(); [Console]::WriteLine()
			Set-NetConnectionProfile -NetworkCategory Private
			Enable-PSRemoting -Force
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Remote PowerShell: Adding IP'); [Console]::ResetColor(); [Console]::WriteLine()
			Set-Item wsman:\localhost\Client\TrustedHosts -Value $InitialSetup_RemotePowershellIP.Text -Force
		}
		elseif ($InitialSetup_RemotePowershell.Checked -eq $false) {
			[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Remote PowerShell: Disabling'); [Console]::ResetColor(); [Console]::WriteLine()
			Disable-PSRemoting -Force
			Remove-Item -Path WSMan:\Localhost\listener\listener* -Recurse
			Clear-Item wsman:\localhost\client\trustedhosts -Force
			Set-NetFirewallRule -DisplayName 'Windows Remote Management (HTTP-In)' -Enabled False | Select-Object -Property DisplayName, Profile, Enabled
			Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system -Name LocalAccountTokenFilterPolicy -Value 0
			Stop-Service WinRM
			Set-Service WinRM -StartupType Manual
		}

		if ($InitialSetup_MozillaFirefox.Checked -eq $true) {
			Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Download.ps1')
		}
	
		if ($InitialSetup_GoogleChrome.Checked -eq $true) {
			Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Chrome/Download.ps1')
		}
	}
)

$InitialSetup_Form.Controls.Add($InitialSetup_OK)
$InitialSetup_Form.Controls.Add($InitialSetup_Cancel)

$InitialSetup_Form.Controls.Add($InitialSetup_TimeZoneSelection)
$InitialSetup_Form.Controls.Add($InitialSetup_KeyboardSelection)
$InitialSetup_Form.Controls.Add($InitialSetup_ComputerName)
$InitialSetup_Form.Controls.Add($InitialSetup_ComputerPasswordCheckBox)
$InitialSetup_Form.Controls.Add($InitialSetup_ComputerPasswordTextBox)
$InitialSetup_Form.Controls.Add($InitialSetup_AutoLogonCheckBox)
$InitialSetup_Form.Controls.Add($InitialSetup_RemoteDesktop)
$InitialSetup_Form.Controls.Add($InitialSetup_RemotePowershell)
$InitialSetup_Form.Controls.Add($InitialSetup_RemotePowershellIP)
$InitialSetup_Form.Controls.Add($InitialSetup_MozillaFirefox)
$InitialSetup_Form.Controls.Add($InitialSetup_GoogleChrome)

[void] $InitialSetup_Form.ShowDialog()
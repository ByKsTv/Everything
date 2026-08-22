Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object System.Windows.Forms.Form -Property @{
	Text            = 'Initial Setup'
	Font            = [Drawing.Font]::new('Tahoma', 11)
	Width           = 350
	Height          = 450
	StartPosition   = 'CenterScreen'
	FormBorderStyle = 'FixedDialog'
	Topmost         = $true
	MaximizeBox     = $false
	MinimizeBox     = $false
	ControlBox      = $false
}

$ButtonWidth = 57
$ButtonSpacer = 15
$ButtonY = $Form.Height - 60
$ButtonX = [math]::Round(($Form.ClientSize.Width - (2 * $ButtonWidth + $ButtonSpacer)) / 2)

$Ok = New-Object System.Windows.Forms.Button -Property @{
	Text         = 'OK'
	DialogResult = [Windows.Forms.DialogResult]::OK
	Width        = $ButtonWidth
	Height       = 20
	Location     = [Drawing.Point]::new($ButtonX, $ButtonY)
	Add_Click    = { $Form.Close() }
}

$Cancel = New-Object System.Windows.Forms.Button -Property @{
	Text      = 'Cancel'
	Width     = $ButtonWidth
	Height    = 20
	Location  = [Drawing.Point]::new($ButtonX + $ButtonWidth + $ButtonSpacer, $ButtonY)
	Add_Click = { $Form.Close() }
}

$LocX = 5
$LocY = 0
$SizeX = $Form.Width - 25
$SizeY = 26
$_LocAdd = 30

$TimeZoneSelection = New-Object System.Windows.Forms.ComboBox -Property @{
	Width         = $SizeX
	Height        = $SizeY
	Location      = [Drawing.Point]::new($LocX, $LocY)
	DropDownStyle = 'DropDownList'
}
[void] $TimeZoneSelection.Items.Add('Select Time Zone')
$TimeZoneSelection.SelectedIndex = 0
$TimeZones = [TimeZoneInfo]::GetSystemTimeZones() | Sort-Object -Property Id
[void] $TimeZones.ForEach({ $TimeZoneSelection.Items.Add($_.Id) })

$LocY += $_LocAdd

$KeyboardSelection = New-Object System.Windows.Forms.ComboBox -Property @{
	Width         = $SizeX
	Height        = $SizeY
	Location      = [Drawing.Point]::new($LocX, $LocY)
	DropDownStyle = 'DropDownList'
}
[void] $KeyboardSelection.Items.Add('Select Keyboard')
$KeyboardSelection.SelectedIndex = 0
$Keyboard_Tags = @('af-ZA', 'am-ET', 'ar-SA', 'az-Latn-AZ', 'bg-BG', 'bn-IN', 'bs-Latn-BA', 'ca-ES', 'cs-CZ', 'cy-GB', 'da-DK', 'de-DE', 'el-GR', 'en-GB', 'en-US', 'es-ES', 'es-MX', 'et-EE', 'eu-ES', 'fa-IR', 'fi-FI', 'fil-PH', 'fr-CA', 'fr-FR', 'ga-IE', 'gl-ES', 'gu-IN', 'he-IL', 'hi-IN', 'hr-HR', 'hu-HU', 'hy-AM', 'id-ID', 'is-IS', 'it-IT', 'ja-JP', 'ka-GE', 'kk-KZ', 'km-KH', 'kn-IN', 'ko-KR', 'ky-KG', 'lt-LT', 'lv-LV', 'mk-MK', 'ml-IN', 'mn-MN', 'mr-IN', 'ms-MY', 'mt-MT', 'nb-NO', 'nl-NL', 'pl-PL', 'pt-BR', 'pt-PT', 'ro-RO', 'ru-RU', 'si-LK', 'sk-SK', 'sl-SI', 'sq-AL', 'sr-Cyrl-RS', 'sv-SE', 'sw-KE', 'ta-IN', 'te-IN', 'th-TH', 'tr-TR', 'uk-UA', 'ur-PK', 'uz-Latn-UZ', 'vi-VN', 'zh-CN', 'zh-TW')
$Keyboard_Map = @{}
foreach ($Keyboard_Tag in $Keyboard_Tags) {
	try {
		$Keyboard_Map[[Globalization.CultureInfo]::GetCultureInfo($Keyboard_Tag).DisplayName] = $Keyboard_Tag
	} catch {
		$Keyboard_Map[$Keyboard_Tag] = $Keyboard_Tag
	}
}
$Keyboard_Map.Keys | Sort-Object | ForEach-Object { $KeyboardSelection.Items.Add($_) | Out-Null }

$LocY += $_LocAdd

$RegionalFormatSelection = New-Object System.Windows.Forms.ComboBox -Property @{
	Width         = $SizeX
	Height        = $SizeY
	Location      = [Drawing.Point]::new($LocX, $LocY)
	DropDownStyle = 'DropDownList'
}
[void] $RegionalFormatSelection.Items.Add('Select Regional Format')
$RegionalFormatSelection.SelectedIndex = 0
$availableCultures = [Globalization.CultureInfo]::GetCultures([Globalization.CultureTypes]::SpecificCultures)
$regionalFormatMapping = $availableCultures | Where-Object {
	$_.Name -match 'en-'
} | Sort-Object -Property 'DisplayName' | ForEach-Object {
	@{ DisplayName = $_.DisplayName.Split('(')[-1].TrimEnd(')'); CultureCode = $_.Name }
}
$RegionalFormatSelection.Items.AddRange($regionalFormatMapping.DisplayName)

$LocY += $_LocAdd

$PreComputerName = 'Enter Computer Name and Username'
$ComputerName = New-Object System.Windows.Forms.TextBox -Property @{
	Text     = $PreComputerName
	Width    = $SizeX
	Height   = $SizeY
	Location = [Drawing.Point]::new($LocX, $LocY)
}
$ComputerName.Add_GotFocus{ if ($ComputerName.Text -eq $PreComputerName) {
		$ComputerName.Text = ''
	}
}
$ComputerName.Add_LostFocus({ if ($ComputerName.Text -eq '') {
			$ComputerName.Text = $PreComputerName
		}
	}
)

$LocY += $_LocAdd

$ComputerPasswordCheckBox = New-Object System.Windows.Forms.CheckBox -Property @{
	Text     = 'Computer Password'
	Width    = $SizeX
	Height   = $SizeY
	Location = [Drawing.Point]::new($LocX, $LocY)
}

$LocY += $_LocAdd

$PreComputerPassword = 'Enter Computer Password'
$ComputerPasswordTextBox = New-Object System.Windows.Forms.TextBox -Property @{
	Text     = $PreComputerPassword
	Enabled  = $false
	Width    = $SizeX
	Height   = $SizeY
	Location = [Drawing.Point]::new($LocX, $LocY)
}
$ComputerPasswordTextBox.Add_GotFocus{ if ($ComputerPasswordTextBox.Text -eq $PreComputerPassword) {
		$ComputerPasswordTextBox.Text = ''
	}
}
$ComputerPasswordTextBox.Add_LostFocus({ if ($ComputerPasswordTextBox.Text -eq '') {
			$ComputerPasswordTextBox.Text = $PreComputerPassword
		}
	}
)

$LocY += $_LocAdd

$AutoLogonCheckBox = New-Object System.Windows.Forms.CheckBox -Property @{
	Text     = 'Autologon'
	Enabled  = $false
	Width    = $SizeX
	Height   = $SizeY
	Location = [Drawing.Point]::new($LocX, $LocY)
}

$ComputerPasswordCheckBox.Add_Click(
	{
		$ComputerPasswordEnabled = $ComputerPasswordCheckBox.Checked
		$ComputerPasswordTextBox.Enabled = $AutoLogonCheckBox.Enabled = $ComputerPasswordEnabled
		$ComputerPasswordTextBox.Text = if ($ComputerPasswordEnabled) {
			''
		} else {
			'Computer Password'
		}
	}
)

$LocY += $_LocAdd

$RemoteDesktop = New-Object System.Windows.Forms.CheckBox -Property @{
	Text     = 'Remote Desktop'
	Width    = $SizeX
	Height   = $SizeY
	Location = [Drawing.Point]::new($LocX, $LocY)
}

$LocY += $_LocAdd

$RemotePowershell = New-Object System.Windows.Forms.CheckBox -Property @{
	Text     = 'Remote Powershell'
	Width    = $SizeX
	Height   = $SizeY
	Location = [Drawing.Point]::new($LocX, $LocY)
}

$LocY += $_LocAdd

$RemotePowershellIP = New-Object System.Windows.Forms.TextBox -Property @{
	Text     = 'Remote Powershell Trusted IP'
	Enabled  = $false
	Width    = $SizeX
	Height   = $SizeY
	Location = [Drawing.Point]::new($LocX, $LocY)
}

$RemotePowershell.Add_Click(
	{
		$RemotePowershellEnabled = $RemotePowershell.Checked
		$RemotePowershellIP.Enabled = $RemotePowershellEnabled
		$RemotePowershellIP.Text = if ($RemotePowershellEnabled) {
			''
		} else {
			'Remote Powershell Trusted IP'
		}
	}
)

$LocY += $_LocAdd

$MozillaFirefox = New-Object System.Windows.Forms.CheckBox -Property @{
	Text     = 'Mozilla Firefox'
	Width    = $SizeX
	Height   = $SizeY
	Location = [Drawing.Point]::new($LocX, $LocY)
}

$LocY += $_LocAdd

$GoogleChrome = New-Object System.Windows.Forms.CheckBox -Property @{
	Text     = 'Google Chrome'
	Width    = $SizeX
	Height   = $SizeY
	Location = [Drawing.Point]::new($LocX, $LocY)
}

$LocY += $_LocAdd

$RustDesk = New-Object System.Windows.Forms.CheckBox -Property @{
	Text     = 'RustDesk'
	Width    = $SizeX
	Height   = $SizeY
	Location = [Drawing.Point]::new($LocX, $LocY)
}

$LocY += $_LocAdd

$Form.Controls.AddRange(@($Ok, $Cancel, $TimeZoneSelection, $KeyboardSelection, $RegionalFormatSelection, $ComputerName, $ComputerPasswordCheckBox, $ComputerPasswordTextBox, $AutoLogonCheckBox, $RemoteDesktop, $RemotePowershell, $RemotePowershellIP, $MozillaFirefox, $GoogleChrome, $RustDesk))

if ($Form.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
	$Form.TopMost = $false
	if ($TimeZoneSelection.SelectedItem -and $TimeZoneSelection.Text -ne 'Select Time Zone') {
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Time Zone: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write($TimeZoneSelection.SelectedItem); [Console]::ResetColor(); [Console]::WriteLine()
		& tzutil.exe /s $TimeZoneSelection.SelectedItem
	}

	if ($KeyboardSelection.SelectedItem -and $KeyboardSelection.Text -ne 'Select Keyboard') {
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Keyboard: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write($KeyboardSelection.SelectedItem); [Console]::ResetColor(); [Console]::WriteLine()
		$LanguageList = Get-WinUserLanguageList
		$LanguageList.Add($Keyboard_Map[$KeyboardSelection.SelectedItem])
		Set-WinUserLanguageList -LanguageList $LanguageList -Force
	}

	if ($RegionalFormatSelection.SelectedItem -and $RegionalFormatSelection.Text -ne 'Select Regional Format') {
		$selectedDisplayName = $RegionalFormatSelection.SelectedItem
		$RegionalFormatSelected = ($regionalFormatMapping | Where-Object { $_.DisplayName -eq $selectedDisplayName }).CultureCode
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Regional Format: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write($RegionalFormatSelected); [Console]::ResetColor(); [Console]::WriteLine()
		Set-Culture -CultureInfo $RegionalFormatSelected
	}

	if ($ComputerName.Text -ne $PreComputerName) {
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Computer name: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write($ComputerName.Text); [Console]::ResetColor(); [Console]::WriteLine()
		Rename-Computer -NewName $ComputerName.Text -Force
		Rename-LocalUser -Name $env:USERNAME -NewName $ComputerName.Text -Force
	}

	if ($ComputerPasswordCheckBox.Checked -eq $true) {
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('PC Password: Adding'); [Console]::ResetColor(); [Console]::WriteLine()
		Set-LocalUser -Name $env:USERNAME -Password (ConvertTo-SecureString $ComputerPasswordTextBox.Text -AsPlainText -Force)
		New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'DefaultPassword' -Value $ComputerPasswordTextBox.Text -PropertyType String -Force
	} elseif ($ComputerPasswordCheckBox.Checked -eq $false) {
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('PC Password: Removing'); [Console]::ResetColor(); [Console]::WriteLine()
		Set-LocalUser -Name $env:username -Password ([securestring]::new())
		New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon' -Value '0' -PropertyType String -Force
	}

	if ($AutoLogonCheckBox.Checked -eq $true) {
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Autologon: Enabling'); [Console]::ResetColor(); [Console]::WriteLine()
		New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon' -Value '1' -PropertyType String -Force
	} elseif ($AutoLogonCheckBox.Checked -eq $false) {
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Autologon: Disabling'); [Console]::ResetColor(); [Console]::WriteLine()
		New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'AutoAdminLogon' -Value '0' -PropertyType String -Force
	}

	if ($RemoteDesktop.Checked -eq $true) {
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Remote Desktop: Enabling'); [Console]::ResetColor(); [Console]::WriteLine()
		New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0 -Force
		Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'
	} elseif ($RemoteDesktop.Checked -eq $false) {
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Remote Desktop: Disabling'); [Console]::ResetColor(); [Console]::WriteLine()
		New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 1 -Force
		Disable-NetFirewallRule -DisplayGroup 'Remote Desktop'
	}

	if ($RemotePowershell.Checked -eq $true) {
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Remote PowerShell: Enabling'); [Console]::ResetColor(); [Console]::WriteLine()
		Set-NetConnectionProfile -NetworkCategory Private
		Enable-PSRemoting -Force
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Remote PowerShell: Adding IP'); [Console]::ResetColor(); [Console]::WriteLine()
		Set-Item 'wsman:\localhost\Client\TrustedHosts' -Value $RemotePowershellIP.Text -Force
	} elseif ($RemotePowershell.Checked -eq $false) {
		[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Remote PowerShell: Disabling'); [Console]::ResetColor(); [Console]::WriteLine()
		Disable-PSRemoting -Force
		Remove-Item -Path 'WSMan:\Localhost\listener\listener*' -Recurse
		Clear-Item 'wsman:\localhost\client\trustedhosts' -Force
		Set-NetFirewallRule -DisplayName 'Windows Remote Management (HTTP-In)' -Enabled False | Select-Object -Property DisplayName, Profile, Enabled
		New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system' -Name 'LocalAccountTokenFilterPolicy' -Value 0 -Force
		Stop-Service 'WinRM'
		Set-Service 'WinRM' -StartupType Manual
	}

	if ($MozillaFirefox.Checked -eq $true) {
		Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/Download.ps1')
	}

	if ($GoogleChrome.Checked -eq $true) {
		Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Google_Chrome/Download.ps1')
	}

	if ($RustDesk.Checked -eq $true) {
		Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/RustDesk/Download.ps1')
	}
}

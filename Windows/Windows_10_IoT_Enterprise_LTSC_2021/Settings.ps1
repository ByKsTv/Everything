Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Pre.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/All_Policies.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Post.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/O&O_ShutUp10++.ps1')

# Settings: Windows Update: Advanced options: Receive updates for other Microsoft products: On
(New-Object -ComObject Microsoft.Update.ServiceManager).AddService2('7971f918-a847-4430-9279-4a52d1efe18d', 7, '')

# Settings: Windows Update: Advanced options: Download updates over metered connections: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\StateVariables' -Name 'AlwaysAllowMeteredNetwork' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Hide empty drives: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideDrivesWithNoMedia' -Value 0 -PropertyType DWord -Force

# [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write("Step2: Windows Packages: Removing Windows Backup app"); [Console]::ResetColor(); [Console]::WriteLine()
# $windowsbackupapp = Get-WindowsPackage -Online | Where-Object { $_.PackageName -eq 'Microsoft-Windows-UserExperience-Desktop-Package~31bf3856ad364e35~amd64~~10.0.19041.4355' }
# if ($windowsbackupapp.PackageState -match 'Installed') {
# 	Remove-WindowsPackage -PackageName 'Microsoft-Windows-UserExperience-Desktop-Package~31bf3856ad364e35~amd64~~10.0.19041.4355' -Online -NoRestart
# }

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Removing Dev Home'); [Console]::ResetColor(); [Console]::WriteLine()
Get-AppxPackage -AllUsers -PackageTypeFilter Bundle -Name '*Windows.DevHome*' | Remove-AppxPackage -AllUsers

# Disable Input language switching notification
if ((Test-Path -Path 'HKCU:\Keyboard Layout\ShowToast') -ne $true) {
	New-Item 'HKCU:\Keyboard Layout\ShowToast' -Force
}
New-ItemProperty -Path 'HKCU:\Keyboard Layout\ShowToast' -Name 'Show' -Value 1 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Settings: Bing Search: Disabling'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'BingSearchEnabled' -Value 0 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Settings: Folder Properties: Customize: Optimize all folders: General items'); [Console]::ResetColor(); [Console]::WriteLine()
$BasePath = 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\Shell'
if (Test-Path -Path $BasePath\Bags) {
	Remove-Item -Path $BasePath\Bags -Recurse -Force
}
if (Test-Path -Path $BasePath\BagMRU) {
	Remove-Item -Path $BasePath\BagMRU -Recurse -Force
}
$Bags = New-Item -Path $BasePath -Name 'Bags' -Force
$AllFolders = New-Item -Path $Bags.PSPath -Name 'AllFolders' -Force
$Shell = New-Item -Path $AllFolders.PSPath -Name 'Shell' -Force
New-ItemProperty -Path $Shell.PSPath -Name 'FolderType' -Value 'NotSpecified' -PropertyType String -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Settings: Settings: Personalization: Start: Choose which folders appears on Start: Settings + Explorer'); [Console]::ResetColor(); [Console]::WriteLine()
$itemsToDisplay = @('explorer', 'settings')
$key = Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*windows.data.unifiedtile.startglobalproperties\Current'
$data = $key.Data[0..19] -Join ','
If ($itemsToDisplay.Length -gt 0) {
	$data += ",203,50,10,$($itemsToDisplay.Length)"
	If ($itemsToDisplay -contains 'explorer') {
		$data += ',5,188,201,168,164,1,36,140,172,3,68,137,133,1,102,160,129,186,203,189,215,168,164,130,1,0'
	}
	If ($itemsToDisplay -contains 'settings') {
		$data += ',5,134,145,204,147,5,36,170,163,1,68,195,132,1,102,159,247,157,177,135,203,209,172,212,1,0'
	}
	If ($itemsToDisplay -contains 'documents') {
		$data += ',5,206,171,211,233,2,36,218,244,3,68,195,138,1,102,130,229,139,177,174,253,253,187,60,0'
	}
	If ($itemsToDisplay -contains 'downloads') {
		$data += ',5,175,230,158,155,14,36,222,147,2,68,213,134,1,102,191,157,135,155,191,143,198,212,55,0'
	}
	If ($itemsToDisplay -contains 'music') {
		$data += ',5,160,140,172,128,11,36,209,254,1,68,178,152,1,102,170,189,208,225,204,234,223,185,21,0'
	}
	If ($itemsToDisplay -contains 'pictures') {
		$data += ',5,160,143,252,193,3,36,138,208,3,68,128,153,1,102,176,181,153,220,205,176,151,222,77,0'
	}
	If ($itemsToDisplay -contains 'videos') {
		$data += ',5,197,203,206,149,4,36,134,251,1,68,244,133,1,102,128,201,206,212,175,217,158,196,181,1,0'
	}
	If ($itemsToDisplay -contains 'network') {
		$data += ',5,196,130,214,243,15,36,141,16,68,174,133,1,102,139,181,211,233,254,210,237,177,148,1,0'
	}
	If ($itemsToDisplay -contains 'personal') {
		$data += ',5,202,224,246,165,7,36,202,242,3,68,232,158,1,102,139,173,143,194,249,160,135,212,188,1,0'
	}
}
$data += ',194,60,1,194,70,1,197,90,1,0'
Set-ItemProperty -Path $key.PSPath -Name 'Data' -Type Binary -Value $data.Split(',')

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Settings: ContentDeliveryManager: Disabling'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'FeatureManagementEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'OemPreInstalledAppsEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'PreInstalledAppsEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'PreInstalledAppsEverEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SlideshowEnabled' -Value 0 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Settings: Settings: System: Tablet: When I sign in: Never use tablet mode'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell' -Name 'SignInMode' -Value 1 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Settings: Control Panel: Ease of Access Center: Make the computer easier to see: Turn off all unnecessary animations (when possible): On'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path 'HKCU:\Control Panel\Desktop\WindowMetrics') -ne $true) {
 New-Item 'HKCU:\Control Panel\Desktop\WindowMetrics' -Force 
}
New-ItemProperty -Path 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Value '0' -PropertyType String -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Settings: File Explorer: Ribbon: Details View and Size all columms to fit'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon' -Name 'MinimizedStateTabletModeOff' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon' -Name 'QatItems' -Value ([byte[]](0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x75, 0x73, 0x74, 0x6f, 0x6d, 0x55, 0x49, 0x20, 0x78, 0x6d, 0x6c, 0x6e, 0x73, 0x3a, 0x73, 0x69, 0x71, 0x3d, 0x22, 0x68, 0x74, 0x74, 0x70, 0x3a, 0x2f, 0x2f, 0x73, 0x63, 0x68, 0x65, 0x6d, 0x61, 0x73, 0x2e, 0x6d, 0x69, 0x63, 0x72, 0x6f, 0x73, 0x6f, 0x66, 0x74, 0x2e, 0x63, 0x6f, 0x6d, 0x2f, 0x77, 0x69, 0x6e, 0x64, 0x6f, 0x77, 0x73, 0x2f, 0x32, 0x30, 0x30, 0x39, 0x2f, 0x72, 0x69, 0x62, 0x62, 0x6f, 0x6e, 0x2f, 0x71, 0x61, 0x74, 0x22, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x72, 0x69, 0x62, 0x62, 0x6f, 0x6e, 0x20, 0x6d, 0x69, 0x6e, 0x69, 0x6d, 0x69, 0x7a, 0x65, 0x64, 0x3d, 0x22, 0x74, 0x72, 0x75, 0x65, 0x22, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x71, 0x61, 0x74, 0x20, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x3d, 0x22, 0x30, 0x22, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x73, 0x68, 0x61, 0x72, 0x65, 0x64, 0x43, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x73, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x36, 0x31, 0x32, 0x38, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x36, 0x31, 0x32, 0x39, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x35, 0x32, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x38, 0x34, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x33, 0x36, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x35, 0x37, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x36, 0x35, 0x37, 0x36, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x74, 0x72, 0x75, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x34, 0x38, 0x35, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x74, 0x72, 0x75, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x73, 0x68, 0x61, 0x72, 0x65, 0x64, 0x43, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x73, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x71, 0x61, 0x74, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x72, 0x69, 0x62, 0x62, 0x6f, 0x6e, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x75, 0x73, 0x74, 0x6f, 0x6d, 0x55, 0x49, 0x3e)) -PropertyType Binary -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Settings: Settings: System: Shared experiences: Share across devices: Off'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP' -Name 'RomeSdkChannelUserAuthzPolicy' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP' -Name 'CdpSessionUserAuthzPolicy' -Value 0 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Settings: Settings: Devices: Typing: Add a space after I choose a text suggestion: Off'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7') -ne $true) {
 New-Item 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnablePredictionSpaceInsertion' -Value 0 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Settings: Settings: Devices: Typing: Add a period after I double-tap the Spacebar: Off'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnableDoubleTapSpace' -Value 0 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Settings: Windows Security: Virus & threat protection: Manage settings: Change notification settings: Recent activity and scan results: Off'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows Defender Security Center\Virus and threat protection') -ne $true) {
 New-Item 'HKLM:\SOFTWARE\Microsoft\Windows Defender Security Center\Virus and threat protection' -Force 
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Defender Security Center\Virus and threat protection' -Name 'SummaryNotificationDisabled' -Value 1 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Settings: Windows Security Notification Icon: Off'); [Console]::ResetColor(); [Console]::WriteLine()
if ($null -ne (Get-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run').GetValue('SecurityHealth')) {
	Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'SecurityHealth'
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Microsoft Edge: Deleting Desktop Shortcut'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path "$env:PUBLIC\Desktop\Microsoft Edge.lnk") -eq $true) {
	Remove-Item -Path "$env:PUBLIC\Desktop\Microsoft Edge.lnk"
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Settings: Ease of Access: Keyboard: Allow the shortcut key to start Filter Keys: Off'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\Keyboard Response' -Name 'Flags' -Value '122' -PropertyType String -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Settings: Ease of Access: Keyboard: Allow the shortcut key to start Toggle Keys: Off'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\ToggleKeys' -Name 'Flags' -Value '58' -PropertyType String -Force

# https://docs.google.com/document/d/1c2-lUJq74wuYK1WrA_bIvgb89dUN0sj8-hO3vqmrau4/edit
# This command forces the kernel timer to constantly poll for interrupts instead of wait for them; dynamic tick was implemented as a power saving feature for laptops but hurts desktop performance
# bcdedit /set disabledynamictick yes

# # Disables the hypervisor which is unneeded on a gaming PC
# bcdedit /set hypervisorlaunchtype off

# # Disable VBS / HVCI
# # https://www.tomshardware.com/how-to/disable-vbs-windows-11
# New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\DeviceGuard' -Name 'EnableVirtualizationBasedSecurity' -Value 0 -PropertyType DWord -Force

# Process scheduling - 22 = Long, variable, 3x foreground boost (36:12)
# New-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\PriorityControl' -Name 'Win32PrioritySeparation' -Value 22 -PropertyType DWord -Force

# https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/DOCS/POSTINSTALL/README.md
# fsutil behavior set DisableDeleteNotify 0
# fsutil behavior set disableLastAccess 1
# fsutil behavior set disable8dot3 1

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Settings: Administrative Shares: Disable'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' -Name 'AutoShareWks' -Value '0' -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Settings: svchost.exe: Group (Decrease Process Number)'); [Console]::ResetColor(); [Console]::WriteLine()
$svchostram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name 'SvcHostSplitThresholdInKB' -Type DWord -Value $svchostram -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Settings: Settings: Devices: Typing: Typing Insights: Disabling'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Input\Settings') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Microsoft\Input\Settings' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Input\Settings' -Name 'InsightsEnabled' -Value 0 -PropertyType DWord -Force

takeown /f 'C:\ProgramData\Microsoft\Windows\SystemData' /r /d y
icacls 'C:\ProgramData\Microsoft\Windows\SystemData' /GRANT Everyone:F, Users:F /t
Remove-Item 'C:\ProgramData\Microsoft\Windows\SystemData' -Force -Recurse

# Hide the "This PC" icon on Desktop
# Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Force -ErrorAction Ignore

# UserFolders -ThreeDObjects Hide 
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag' -Force
}
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
# UserFolders Desktop  Hide 
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag' -Force
}
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
				
# UserFolders Documents  Hide 
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag' -Force
}
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
			
# UserFolders Downloads  Hide 
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag' -Force
}
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
				
# UserFolders Music  Hide  
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag' -Force
}
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
			
# UserFolders Pictures  Hide 
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag' -Force
}
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
# UserFolders Videos  Hide
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag' -Force
}
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag' -Name ThisPCPolicy -PropertyType String -Value Hide -Force

# WindowsInkWorkspace -Hide
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace -Name PenWorkspaceButtonDesiredVisibility -PropertyType DWord -Value 0 -Force
# NotificationAreaIcons -Show
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name EnableAutoTray -PropertyType DWord -Value 0 -Force
# TaskManagerWindow -Expanded
$Taskmgr = Get-Process -Name Taskmgr -ErrorAction Ignore
if ($Taskmgr) {
	$Taskmgr.CloseMainWindow()
}
Start-Process -FilePath Taskmgr.exe
do {
	$Preferences = Get-ItemPropertyValue -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences -ErrorAction Ignore
}
until ($Preferences)
Stop-Process -Name Taskmgr -ErrorAction SilentlyContinue
$Preferences[28] = 0
New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences -PropertyType Binary -Value $Preferences -Force

# PinToStart -UnpinAll
$Script:StartLayout = "$PSScriptRoot\..\StartLayout.xml"
# Unpin all the Start tiles
# Export the current Start layout
Export-StartLayout -Path $Script:StartLayout -UseDesktopApplicationID
[xml]$XML = Get-Content -Path $Script:StartLayout -Encoding UTF8 -Force
$Groups = $XML.LayoutModificationTemplate.DefaultLayoutOverride.StartLayoutCollection.StartLayout.Group
foreach ($Group in $Groups) {
	# Removing all groups inside XML
	$Group.ParentNode.RemoveChild($Group) | Out-Null
}
$XML.Save($Script:StartLayout)
# Temporarily disable changing the Start menu layout
if (-not (Test-Path -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer)) {
	New-Item -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force
}
New-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name LockedStartLayout -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name StartLayoutFile -PropertyType ExpandString -Value $Script:StartLayout -Force
Start-Sleep -Seconds 3
# Restart the Start menu
Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3
# Open the Start menu to load the new layout
(New-Object -ComObject wscript.shell).SendKeys('^{ESC}')
Start-Sleep -Seconds 3
# Enable changing the Start menu layout
Remove-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name LockedStartLayout -Force
Remove-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name StartLayoutFile -Force
Remove-Item -Path $Script:StartLayout -Force
Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3
# Open the Start menu to load the new layout
(New-Object -ComObject wscript.shell).SendKeys('^{ESC}')

# CastToDeviceContext -Hide
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked' -Name '{7AD84985-87B4-4a16-BE58-8B72A5B390F7}' -PropertyType String -Value '' -Force
# ShareContext -Hide
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked' -Name '{E2BF9676-5F8F-435C-97EB-11607A5BEDF7}' -PropertyType String -Value '' -Force
	
# EditWithPaint3DContext -Hide
$Extensions = @('.bmp', '.gif', '.jpe', '.jpeg', '.jpg', '.png', '.tif', '.tiff')
foreach ($Extension in $Extensions) {
	New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\$Extension\Shell\3D Edit" -Name ProgrammaticAccessOnly -PropertyType String -Value '' -Force
}
# ImagesEditContext -Hide
if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\edit)) {
	New-Item -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\edit -Force
}
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\edit -Name ProgrammaticAccessOnly -PropertyType String -Value '' -Force

# IncludeInLibraryContext -Hide
New-ItemProperty -Path 'Registry::HKEY_CLASSES_ROOT\Folder\ShellEx\ContextMenuHandlers\Library Location' -Name '(default)' -PropertyType String -Value '-{3dad6c5d-2167-4cae-9914-f99e41c12cfa}' -Force
# SendToContext -Hide
New-ItemProperty -Path 'Registry::HKEY_CLASSES_ROOT\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo' -Name '(default)' -PropertyType String -Value '-{7BA4C740-9E81-11CF-99D3-00AA004AE837}' -Force
# BitmapImageNewContext -Hide
# add if path exists here
if ((Get-WindowsCapability -Online -Name 'Microsoft.Windows.MSPaint*').State -eq 'Installed') {
	Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.bmp\ShellNew -Force
}
# # RichTextDocumentNewContext -Hide
# if ((Get-WindowsCapability -Online -Name 'Microsoft.Windows.WordPad*').State -eq 'Installed') {
# 	Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.rtf\ShellNew -Force
# }
# CompressedFolderNewContext -Hide
# add if path exists here
Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.zip\CompressedFolder\ShellNew -Force

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Network.ps1')

# [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Hosts: Adding mobile.events.data.microsoft.com'); [Console]::ResetColor(); [Console]::WriteLine()
# $mobileeventsdatamicrosoft = Select-String -Path $env:windir\System32\drivers\etc\hosts -Pattern 'mobile.events.data.microsoft.com'
# if ($null -eq $mobileeventsdatamicrosoft) {
# 	Add-Content -Path $env:windir\System32\drivers\etc\hosts -Value "`n127.0.0.1`tmobile.events.data.microsoft.com" -Force
# }
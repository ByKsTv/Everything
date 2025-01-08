# Uninstall Windows Backup app
Get-WindowsPackage -Online | Where-Object { $_.PackageName -like '*Microsoft-Windows-UserExperience-Desktop-Package~31bf3856ad364e35*' } | ForEach-Object {
	Remove-WindowsPackage -PackageName $_.PackageName -Online -NoRestart -ErrorAction SilentlyContinue
}

# Uninstall Dev Home app
Get-AppxPackage -AllUsers -PackageTypeFilter Bundle -Name '*Windows.DevHome*' | Remove-AppxPackage -AllUsers

# Black Lock Screen Image
takeown.exe /f "$env:ProgramData\Microsoft\Windows\SystemData" /r /d y
icacls.exe "$env:ProgramData\Microsoft\Windows\SystemData" /GRANT Everyone:F, Users:F /t
Remove-Item "$env:ProgramData\Microsoft\Windows\SystemData" -Force -Recurse

# Disable Input language switching notification
if (-not (Test-Path -Path 'HKCU:\Keyboard Layout\ShowToast')) {
	New-Item -Path 'HKCU:\Keyboard Layout\ShowToast' -Force
}
New-ItemProperty -Path 'HKCU:\Keyboard Layout\ShowToast' -Name 'Show' -Value 1 -PropertyType DWord -Force

# Disable Bing Search
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'BingSearchEnabled' -Value 0 -PropertyType DWord -Force

# Folder Properties: Customize: Optimize all folders: General items
$BagMRU_RegPath = 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\Shell'
Remove-Item "$BagMRU_RegPath\Bags", "$BagMRU_RegPath\BagMRU" -Recurse -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path (New-Item (New-Item "$BagMRU_RegPath\Bags\AllFolders" -Force).PSPath -Name Shell -Force).PSPath -Name FolderType -Value 'NotSpecified' -PropertyType String -Force

# Settings: Personalization: Start: Choose which folders appears on Start: Settings + Explorer
$itemsToDisplay = @('explorer', 'settings')
$key = Get-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*windows.data.unifiedtile.startglobalproperties\Current'
$data = $key.Data[0..19] -Join ','
If ($itemsToDisplay.Length -gt 0) {
	$data += ",203,50,10,$($itemsToDisplay.Length)"
	$data += $itemsToDisplay | ForEach-Object {
		switch ($_) {
			'explorer' {
				',5,188,201,168,164,1,36,140,172,3,68,137,133,1,102,160,129,186,203,189,215,168,164,130,1,0'
   }
			'settings' {
				',5,134,145,204,147,5,36,170,163,1,68,195,132,1,102,159,247,157,177,135,203,209,172,212,1,0'
   }
			'documents' {
				',5,206,171,211,233,2,36,218,244,3,68,195,138,1,102,130,229,139,177,174,253,253,187,60,0'
   }
			'downloads' {
				',5,175,230,158,155,14,36,222,147,2,68,213,134,1,102,191,157,135,155,191,143,198,212,55,0'
   }
			'music' {
				',5,160,140,172,128,11,36,209,254,1,68,178,152,1,102,170,189,208,225,204,234,223,185,21,0'
   }
			'pictures' {
				',5,160,143,252,193,3,36,138,208,3,68,128,153,1,102,176,181,153,220,205,176,151,222,77,0'
   }
			'videos' {
				',5,197,203,206,149,4,36,134,251,1,68,244,133,1,102,128,201,206,212,175,217,158,196,181,1,0'
   }
			'network' {
				',5,196,130,214,243,15,36,141,16,68,174,133,1,102,139,181,211,233,254,210,237,177,148,1,0'
   }
			'personal' {
				',5,202,224,246,165,7,36,202,242,3,68,232,158,1,102,139,173,143,194,249,160,135,212,188,1,0'
   }
		}
	}
}
$data += ',194,60,1,194,70,1,197,90,1,0'
Set-ItemProperty -Path $key.PSPath -Name 'Data' -Type Binary -Value $data.Split(',')

# Settings: System: Tablet: When I sign in: Never use tablet mode
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell' -Name 'SignInMode' -Value 1 -PropertyType DWord -Force

# Control Panel: Ease of Access Center: Make the computer easier to see: Turn off all unnecessary animations (when possible): On
New-ItemProperty -Path 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Value '0' -PropertyType String -Force

# Settings: System: Shared experiences: Share across devices: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP' -Name 'RomeSdkChannelUserAuthzPolicy' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP' -Name 'CdpSessionUserAuthzPolicy' -Value 0 -PropertyType DWord -Force

# Settings: Devices: Typing: Add a space after I choose a text suggestion: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnablePredictionSpaceInsertion' -Value 0 -PropertyType DWord -Force

# Settings: Devices: Typing: Add a period after I double-tap the Spacebar: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnableDoubleTapSpace' -Value 0 -PropertyType DWord -Force

# Settings: Windows Security Notification Icon: Off
if ($null -ne (Get-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run').GetValue('SecurityHealth')) {
	Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'SecurityHealth'
}

# Microsoft Edge: Deleting Desktop Shortcut
if ((Test-Path -Path "$env:PUBLIC\Desktop\Microsoft Edge.lnk") -eq $true) {
	Remove-Item -Path "$env:PUBLIC\Desktop\Microsoft Edge.lnk"
}

# Ease of Access: Keyboard: Allow the shortcut key to start Filter Keys: Off
New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\Keyboard Response' -Name 'Flags' -Value '122' -PropertyType String -Force

# Ease of Access: Keyboard: Allow the shortcut key to start Toggle Keys: Off
New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\ToggleKeys' -Name 'Flags' -Value '58' -PropertyType String -Force

# https://docs.google.com/document/d/1c2-lUJq74wuYK1WrA_bIvgb89dUN0sj8-hO3vqmrau4/edit
# This command forces the kernel timer to constantly poll for interrupts instead of wait for them; dynamic tick was implemented as a power saving feature for laptops but hurts desktop performance
# bcdedit /set disabledynamictick yes

# # Disables the hypervisor which is unneeded on a gaming PC
# bcdedit /set hypervisorlaunchtype off

# # Disable VBS / HVCI
# # https://www.tomshardware.com/how-to/disable-vbs-windows-11
# New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\DeviceGuard' -Name 'EnableVirtualizationBasedSecurity' -Value 0 -PropertyType DWord -Force

# https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/DOCS/POSTINSTALL/README.md
# fsutil behavior set DisableDeleteNotify 0
# fsutil behavior set disableLastAccess 1
# fsutil behavior set disable8dot3 1

# Administrative Shares: Disable
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' -Name 'AutoShareWks' -Value '0' -PropertyType DWord -Force

# # svchost.exe: Group (Decrease Process Number)
# $svchostram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
# Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name 'SvcHostSplitThresholdInKB' -Type DWord -Value $svchostram -Force

# UserFolders -ThreeDObjects Hide 
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag' -Force
}
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag')) {
	New-Item -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag' -Name 'ThisPCPolicy' -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag' -Name 'ThisPCPolicy' -PropertyType String -Value Hide -Force

# UserFolders Desktop  Hide 
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag' -Name 'ThisPCPolicy' -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag' -Name 'ThisPCPolicy' -PropertyType String -Value Hide -Force
				
# UserFolders Documents  Hide 
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag' -Name 'ThisPCPolicy' -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag' -Name 'ThisPCPolicy' -PropertyType String -Value Hide -Force
			
# UserFolders Downloads  Hide 
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag' -Name 'ThisPCPolicy' -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag' -Name 'ThisPCPolicy' -PropertyType String -Value Hide -Force
				
# UserFolders Music  Hide  
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag' -Name 'ThisPCPolicy' -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag' -Name 'ThisPCPolicy' -PropertyType String -Value Hide -Force
			
# UserFolders Pictures  Hide 
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag' -Name 'ThisPCPolicy' -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag' -Name 'ThisPCPolicy' -PropertyType String -Value Hide -Force

# UserFolders Videos  Hide
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag' -Name 'ThisPCPolicy' -PropertyType String -Value Hide -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag' -Name 'ThisPCPolicy' -PropertyType String -Value Hide -Force

# Hide the Windows Ink Workspace button on the taskbar
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace' -Name 'PenWorkspaceButtonDesiredVisibility' -PropertyType DWord -Value 0 -Force

# Always show all icons in the notification area
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'EnableAutoTray' -PropertyType DWord -Value 0 -Force

# Start Task Manager in the expanded mode
$Taskmgr = Get-Process -Name Taskmgr -ErrorAction Ignore
if ($Taskmgr) {
	$Taskmgr.CloseMainWindow()
}
Start-Process -FilePath Taskmgr.exe
do {
	$Preferences = Get-ItemPropertyValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\TaskManager' -Name 'Preferences' -ErrorAction Ignore
}
until ($Preferences)
Stop-Process -Name Taskmgr -ErrorAction SilentlyContinue
$Preferences[28] = 0
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\TaskManager' -Name 'Preferences' -PropertyType Binary -Value $Preferences -Force

# Unpin all the Start tiles
$Path = "$env:TEMP\StartLayout.xml"
Export-StartLayout -Path $Path -UseDesktopApplicationID
[xml]$XML = Get-Content $Path
$XML.LayoutModificationTemplate.DefaultLayoutOverride.StartLayoutCollection.StartLayout.Group | ForEach-Object { $_.ParentNode.RemoveChild($_) }
$XML.Save($Path)
New-Item -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Force
New-ItemProperty 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'LockedStartLayout' -Type DWord -Value 1 -Force 
New-ItemProperty 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'StartLayoutFile' -Type ExpandString -Value $Path -Force
Stop-Process -Name 'StartMenuExperienceHost' -Force -ErrorAction SilentlyContinue
(New-Object -ComObject wscript.shell).SendKeys('^{ESC}')
Start-Sleep -Milliseconds 2000
Remove-ItemProperty 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'LockedStartLayout' -Force
Remove-ItemProperty 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'StartLayoutFile' -Force
Remove-Item $Path -Force
Stop-Process -Name 'StartMenuExperienceHost' -Force -ErrorAction SilentlyContinue
(New-Object -ComObject wscript.shell).SendKeys('^{ESC}')

# Hide the "Cast to Device" item from the media files and folders context menu
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked' -Name '{7AD84985-87B4-4a16-BE58-8B72A5B390F7}' -PropertyType String -Value '' -Force

# Hide the "Share" item from the context menu
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked' -Name '{E2BF9676-5F8F-435C-97EB-11607A5BEDF7}' -PropertyType String -Value '' -Force

# Hide the "Include in Library" item from the folders and drives context menu
New-ItemProperty -Path 'Registry::HKEY_CLASSES_ROOT\Folder\ShellEx\ContextMenuHandlers\Library Location' -Name '(default)' -PropertyType String -Value '-{3dad6c5d-2167-4cae-9914-f99e41c12cfa}' -Force

# Hide the "Send to" item from the folders context menu
New-ItemProperty -Path 'Registry::HKEY_CLASSES_ROOT\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo' -Name '(default)' -PropertyType String -Value '-{7BA4C740-9E81-11CF-99D3-00AA004AE837}' -Force

# Hide the "Bitmap image" item from the "New" context menu
Remove-Item -Path 'Registry::HKEY_CLASSES_ROOT\.bmp\ShellNew' -Force -ErrorAction Ignore

# Disable Windows Sandbox
if ((Get-CimInstance -ClassName CIM_Processor).VirtualizationFirmwareEnabled) {
	Disable-WindowsOptionalFeature -FeatureName 'Containers-DisposableClientVM' -Online -NoRestart
}
else {
	try {
		if ((Get-CimInstance -ClassName CIM_ComputerSystem).HypervisorPresent) {
			Disable-WindowsOptionalFeature -FeatureName 'Containers-DisposableClientVM' -Online -NoRestart
		}
	}
	catch [Exception] {
		Write-Error -Message $Localization.EnableHardwareVT -ErrorAction SilentlyContinue
		Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue
	}
}

# Disable Windows Capabilities
$AppsToRemove = @(
	'InternetExplorer',
	'QuickAssist',
	'StepsRecorder',
	'WindowsMediaPlayer',
	'WordPad'
)

foreach ($App in $AppsToRemove) {
	$Capabilities = Get-WindowsCapability -Online | Where-Object {
		$_.State -eq 'Installed' -and
		$_.Name -like "*$App*"
	}

	foreach ($Capability in $Capabilities) {
		Remove-WindowsCapability -Online -Name $Capability.Name
	}
}

$HostsPath = "$env:WINDIR\System32\drivers\etc\hosts"
$Urls = 'mobile.events.data.microsoft.com'
$Urls | ForEach-Object { $Line = '0.0.0.0 ' + $_; if (-not(Select-String -Path $HostsPath -Pattern $Line)) {
		Add-Content -Path $HostsPath -Value $Line
	} }

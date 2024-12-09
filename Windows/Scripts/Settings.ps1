# Power Plan: Restore default schemes
powercfg.exe /restoredefaultschemes
$PowerPlanUltimate = powercfg.exe -list | Select-String -Pattern 'Ultimate Performance'
$PowerPlanHigh = powercfg.exe -list | Select-String -Pattern 'High performance'
if ($PowerPlanUltimate) {
	$PowerPlanGUID = ($PowerPlanUltimate.Line -split 'GUID: ')[1].Trim().Split(' ')[0]
	powercfg.exe /setactive $PowerPlanGUID
}
elseif ($PowerPlanHigh) {
	$PowerPlanGUID = ($PowerPlanHigh.Line -split 'GUID: ')[1].Trim().Split(' ')[0]
	powercfg.exe /setactive $PowerPlanGUID
}

# Disable hibernation
powercfg.exe /HIBERNATE OFF

# Power Plan: Turn off display after: 0 Seconds (Never)
powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0
powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0

# Settings: System: For developers: File Explorer: Show file extenstions: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' -Name 'HideFileExt' -PropertyType DWord -Value 0 -Force

# Settings: System: Multitasking: Snap windows: When I snap a window, suggest what I can snap next to it: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'SnapAssist' -PropertyType DWord -Value 0 -Force

# Folder Options: Open File Explorer to: This PC
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LaunchTo' -PropertyType DWord -Value 1 -Force

# Settings: Personalization: Colors: Transparency effects: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'EnableTransparency' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Colors: Choose your mode: Dark
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'SystemUsesLightTheme' -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Start: Show recommended files in Start, recent files in File Explorer, and items in Jump Lists: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_TrackDocs' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Start: Show account-related notifications: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_AccountNotifications' -PropertyType DWord -Value 0 -Force

# Settings: Personalization: Taskbar: Taskbar items: Search: Hide
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'SearchboxTaskbarMode' -PropertyType DWord -Value 0 -Force

# Settings: Time & language: Typing: Autocorrect misspelled words: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnableAutocorrection' -PropertyType DWord -Value 0 -Force

# Settings: Time & language: Typing: Highlight misspelled words: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnableSpellchecking' -PropertyType DWord -Value 0 -Force

# Settings: Accessibility: Keyboard: Use the Print screen key to open screen capture: Off
New-ItemProperty -Path 'HKCU:\Control Panel\Keyboard' -Name 'PrintScreenKeyForSnippingEnabled' -PropertyType DWord -Value 0 -Force

# Settings: Privacy & security: General: Let Windows improve Start and search results by tracking app launches: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Start_TrackProgs' -PropertyType DWord -Value 0 -Force

# Settings: Privacy & security: General: Let websites show me locally relevant content by accessing my language list: Off
New-ItemProperty -Path 'HKCU:\Control Panel\International\User Profile' -Name 'HttpAcceptLanguageOptOut' -PropertyType DWord -Value 1 -Force

# Settings: Privacy & security: Search permissions: SafeSearch: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings' -Name 'SafeSearchMode' -PropertyType DWord -Value 0 -Force

# Settings: Windows Update: Advanced options: Get me up to date: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'IsExpedited' -PropertyType DWord -Value 1 -Force

# Settings: Windows Update: Advanced options: Notify me when a restart is required to finish updating: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'RestartNotificationsAllowed2' -PropertyType DWord -Value 1 -Force

# Settings: Personalization: Taskbar: Taskbar items: Task view: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowTaskViewButton' -Value 0 -PropertyType DWord -Force

# Folder Options: View: Advanced settings: Hidden files and folders: Show hidden files, folders, and drives
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Hidden' -PropertyType DWord -Value 1 -Force

# Settings: Privacy & security: Search permissions: History: Search history on this device: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings' -Name 'IsDeviceSearchHistoryEnabled' -PropertyType DWord -Value 0 -Force

# Folder Options: General: Privacy: Show recently used files: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowRecent' -PropertyType DWord -Value 0 -Force

# Folder Options: General: Privacy: Show frequently used folders: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowFrequent' -PropertyType DWord -Value 0 -Force

# Add username to autologon
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'DefaultUsername' -Value $env:username -PropertyType String -Force

# Sound: Communications: Do nothing
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Multimedia\Audio' -Name 'UserDuckingPreference' -PropertyType DWord -Value 3 -Force

# Lock Screen: Black image
takeown.exe /f "$env:windir\Web\Screen" /r /d y
icacls.exe "$env:windir\Web\Screen" /GRANT Everyone:F, Users:F /t
$LockScreenImages = @(
	@{file = 'img100.jpg'; width = 3840; height = 2160 },
	@{file = 'img101.jpg'; width = 3840; height = 2400 },
	@{file = 'img101.png'; width = 3840; height = 2400 },
	@{file = 'img102.jpg'; width = 6400; height = 4000 },
	@{file = 'img103.jpg'; width = 3839; height = 2400 },
	@{file = 'img103.png'; width = 3839; height = 2400 },
	@{file = 'img104.jpg'; width = 3840; height = 2400 },
	@{file = 'img105.jpg'; width = 1920; height = 1200 }
)
Add-Type -AssemblyName System.Drawing
foreach ($LockScreenImage in $LockScreenImages) {
	$filePath = "$env:windir\Web\Screen\$($LockScreenImage.file)"
	$bitmap = New-Object System.Drawing.Bitmap $LockScreenImage.width, $LockScreenImage.height
	$graphics = [Drawing.Graphics]::FromImage($bitmap)
	$graphics.FillRectangle([Drawing.Brushes]::Black, 0, 0, $bitmap.Width, $bitmap.Height)
	$graphics.Dispose()
	$bitmap.Save($filePath)
	$bitmap.Dispose()
}

# Settings: Bluetooth & devices: Mouse: Enhance pointer precision: Off
New-ItemProperty -Path 'HKCU:\Control Panel\Mouse' -Name 'MouseSpeed' -PropertyType String -Value 0 -Force
New-ItemProperty -Path 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold1' -PropertyType String -Value 0 -Force
New-ItemProperty -Path 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold2' -PropertyType String -Value 0 -Force

# Maximum password age (days): Unlimited
net.exe accounts /maxpwage:unlimited

# Control Panel: Ease of Access: Ease of Access Center: Make the computer easier to see: Remove background images (when available): On
$RemoveBackgroundImagesBytes = [byte[]](Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask').UserPreferencesMask
$RemoveBackgroundImagesBytes[4] = $RemoveBackgroundImagesBytes[4]-bor 1
New-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -PropertyType Binary -Value $RemoveBackgroundImagesBytes -Force

# Settings: Accessibility: Visual effects: Always show scrollbars: On
New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility' -Name 'DynamicScrollbars' -Value 0 -PropertyType DWord -Force

# FileTransferDialog -Detailed
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager' -Name 'EnthusiastMode' -PropertyType DWord -Value 1 -Force

# JPEGWallpapersQuality -Max
New-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'JPEGImportQuality' -PropertyType DWord -Value 100 -Force

# DiagTrackService -Disable
Get-Service -Name 'DiagTrack' | Stop-Service -Force
Get-Service -Name 'DiagTrack' | Set-Service -StartupType Disabled
Get-NetFirewallRule -Group 'DiagTrack' | Set-NetFirewallRule -Enabled True -Action Block

# ErrorReporting -Disable
Get-Service -Name 'WerSvc' | Stop-Service -Force
Get-Service -Name 'WerSvc' | Set-Service -StartupType Disabled

# MergeConflicts -Show
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideMergeConflicts' -PropertyType DWord -Value 0 -Force

# DismissMSAccount
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows Security Health\State')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows Security Health\State' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows Security Health\State' -Name 'AccountProtection_MicrosoftAccount_Disconnected' -PropertyType DWord -Value 1 -Force

# DismissSmartScreenFilter
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows Security Health\State' -Name 'AppAndBrowser_EdgeSmartScreenOff' -PropertyType DWord -Value 0 -Force

# StickyShift -Disable
New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\StickyKeys' -Name 'Flags' -PropertyType String -Value 506 -Force

# LatestInstalled.NET -Enable
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework' -Name 'OnlyUseLatestCLR' -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework' -Name 'OnlyUseLatestCLR' -PropertyType DWord -Value 1 -Force

# BSoDStopError -Enable
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl' -Name 'DisplayParameters' -PropertyType DWord -Value 1 -Force

# SecondsInSystemClock -Hide
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSecondsInSystemClock' -PropertyType DWord -Value 0 -Force

# RecycleBinDeleteConfirmation -Enable
$ShellState = Get-ItemPropertyValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShellState'
$ShellState[4] = 51
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShellState' -PropertyType Binary -Value $ShellState -Force

# Settings: Accounts: Sign-in options: Automatically save my restartable apps and restart them when I sign back in: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'RestartApps' -PropertyType DWord -Value 0 -Force

# Remote Desktop Connection: Never show pop-up upon ending session
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Terminal Server Client') -ne $true) {
	New-Item 'HKCU:\SOFTWARE\Microsoft\Terminal Server Client' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Terminal Server Client' -Name 'ShowShutdownDialog' -Value 0 -PropertyType DWord -Force

# Settings: Bluetooth & devices: Devices: Device settings: Download over metered connections: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceSetup' -Name 'CostedNetworkPolicy' -PropertyType DWord -Value 1 -Force

# Settings: Bluetooth & devices: AutoPlay: Removeable media: Open folder to view files (File Explorer)
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\StorageOnArrival')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\StorageOnArrival' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\StorageOnArrival' -Name '(default)' -Value 'MSOpenFolder' -PropertyType String -Force
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\StorageOnArrival')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\StorageOnArrival' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\StorageOnArrival' -Name '(default)' -Value 'MSOpenFolder' -PropertyType String -Force

# Settings: Bluetooth & devices: AutoPlay: Memory card: Open folder to view files (File Explorer)
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\CameraAlternate\ShowPicturesOnArrival')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\CameraAlternate\ShowPicturesOnArrival' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\EventHandlersDefaultSelection\CameraAlternate\ShowPicturesOnArrival' -Name '(default)' -Value 'MSOpenFolder' -PropertyType String -Force
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\CameraAlternate\ShowPicturesOnArrival')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\CameraAlternate\ShowPicturesOnArrival' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\UserChosenExecuteHandlers\CameraAlternate\ShowPicturesOnArrival' -Name '(default)' -Value 'MSOpenFolder' -PropertyType String -Force

# Settings: Bluetooth & devices: USB: Connection notifications: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Shell\USB')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Shell\USB' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Shell\USB' -Name 'NotifyOnUsbErrors' -PropertyType DWord -Value 1 -Force

# Settings: Windows Update: Advanced options: Active hours: Off
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'SmartActiveHoursState' -PropertyType DWord -Value 0 -Force

# Settings: System: Display: Graphics settings: Hardware-accelerated GPU scheduling: On
if (Get-CimInstance -ClassName CIM_VideoController | Where-Object -FilterScript { ($_.AdapterDACType -ne 'Internal') -and ($null -ne $_.AdapterDACType) }) {
	if ((Get-CimInstance -ClassName CIM_ComputerSystem).Model -notmatch 'Virtual') {
		$WddmVersion_Min = [Microsoft.Win32.Registry]::GetValue('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\FeatureSetUsage', 'WddmVersion_Min', $null)
		if ($WddmVersion_Min -ge 2700) {
			New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers' -Name HwSchMode -PropertyType DWord -Value 2 -Force
		}
	}
}

# Settings: Personalization: Taskbar: Combine taskbar buttons and hide labels: Always
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarGlomLevel' -PropertyType DWord -Value 0 -Force

# Control Panel: Large Icons
if (-not (Test-Path -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel')) {
	New-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel' -Name 'AllItemsIconView' -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel' -Name 'StartupPage' -PropertyType DWord -Value 1 -Force

# Do not use a different input method for each app window
Set-WinLanguageBarOption

# When I grab a windows's title bar and shake it, don't minimize all other windows
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'DisallowShaking' -PropertyType DWord -Value 1 -Force

# Do not group files and folder in the Downloads folder
Get-ChildItem -Path 'HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\*\Shell' -Recurse | Where-Object -FilterScript { $_.PSChildName -eq '{885A186E-A440-4ADA-812B-DB871B942259}' } | Remove-Item -Force
# https://learn.microsoft.com/en-us/windows/win32/properties/props-system-null
if (-not (Test-Path -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}')) {
	New-Item -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'ColumnList' -PropertyType String -Value 'System.Null' -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'GroupBy' -PropertyType String -Value 'System.Null' -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'LogicalViewMode' -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'Name' -PropertyType String -Value NoName -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'Order' -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'PrimaryProperty' -PropertyType String -Value 'System.ItemNameDisplay' -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'SortByList' -PropertyType String -Value 'prop:System.ItemNameDisplay' -Force

# Do not expand to open folder on navigation pane (default value)
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'NavPaneExpandToCurrentFolder' -PropertyType DWord -Value 0 -Force

# Settings: System: Storage: Storage Sense: Keep Windows running smoothly by automatically cleaning up temporary system and app files: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Name '04' -PropertyType DWord -Value 1 -Force
# Settings: System: Storage: Storage Sense: Automatic User content cleanup: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Name '01' -PropertyType DWord -Value 1 -Force
# Settings: System: Storage: Storage Sense: Run Storage Sense: Every day
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Name '2048' -PropertyType DWord -Value 1 -Force
# Settings: System: Storage: Storage Sense: Delete files in my recycle bin if they have been there for over: 60 days
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Name '256' -PropertyType DWord -Value 60 -Force
# Delete files in my Downloads folder if they haven't been opened for more than: 60 days
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Name '32' -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Name '512' -PropertyType DWord -Value 60 -Force

# Turn off Delivery Optimization
New-ItemProperty -Path 'Registry::HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings' -Name 'DownloadMode' -PropertyType DWord -Value 0 -Force
Delete-DeliveryOptimizationCache -Force

# List of task names to check and disable
$taskNames = @('PcaPatchDbTask', 'Consolidator', 'DmClient', 'DmClientOnScenarioDownload', 'FamilySafetyMonitor', 'FamilySafetyRefreshTask', 'MapsToastTask', 'MapsUpdateTask', 'ProgramDataUpdater', 'MareBackup', 'Microsoft Compatibility Appraiser', 'Microsoft-Windows-DiskDiagnosticDataCollector', 'PcaWallpaperAppDetect', 'Proxy', 'StartupAppTask', 'QueueReporting', 'XblGameSaveTask', 'UsbCeip')
foreach ($taskName in $taskNames) {
	if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
		Get-ScheduledTask -TaskName $taskName | Disable-ScheduledTask
	}
}

# List of capabilities to check and remove
$capabilitiesToRemove = @('WindowsMediaPlayer', 'InternetExplorer', 'WordPad', 'QuickAssist', 'StepsRecorder')
foreach ($capabilityPattern in $capabilitiesToRemove) {
	try {
		$capabilities = Get-WindowsCapability -Online | Where-Object { $_.State -eq 'Installed' -and $_.Name -like "*$capabilityPattern*" }
		if ($capabilities) {
			$capabilities | ForEach-Object { Remove-WindowsCapability -Online -Name $_.Name }
		}
		else {
			Write-Host "No capabilities found for: $capabilityPattern"
		}
	}
 catch {
		Write-Host ('{0}: {1}' -f $capabilityPattern, $_.Exception.Message)
	}
}

# Disable Windows features
$OptionalFeatureToRemove = @('WorkFolders-Client', 'WindowsMediaPlayer')
foreach ($OptionalFeaturePattern in $OptionalFeatureToRemove) {
	try {
		$OptionalFeature = Get-WindowsOptionalFeature -Online | Where-Object { $_.State -eq 'Enabled' -and $_.FeatureName -like "*$OptionalFeaturePattern*" }
		if ($OptionalFeature) {
			$OptionalFeature | ForEach-Object { Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName $_.FeatureName }
		}
		else {
			Write-Host "No Optional Feature found for: $OptionalFeaturePattern"
		}
	}
 catch {
		Write-Host ('{0}: {1}' -f $OptionalFeaturePattern, $_.Exception.Message)
	}
}

# Settings: Windows Update: Get the latest updates as soon as they're available: Off
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'IsContinuousInnovationOptedIn' -PropertyType DWord -Value 0 -Force

# Override for default input method: English
Set-WinDefaultInputMethodOverride -InputTip '0409:00000409'

# Use the latest installed .NET runtime for all apps
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework' -Name 'OnlyUseLatestCLR' -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework' -Name 'OnlyUseLatestCLR' -PropertyType DWord -Value 1 -Force

# Launch folder windows in a separate process
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'SeparateProcess' -PropertyType DWord -Value 1 -Force

# Disable and delete reserved storage after the next update installation
Set-WindowsReservedStorageState -State Disabled

# Disable help lookup via F1
if (-not (Test-Path -Path 'HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64')) {
	New-Item -Path 'HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64' -Name '(default)' -PropertyType String -Value '' -Force

# Enable Num Lock at startup
New-ItemProperty -Path 'Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard' -Name 'InitialKeyboardIndicators' -PropertyType String -Value 2147483650 -Force

# Enable Caps Lock
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout" -Name "Scancode Map" -Force -ErrorAction Ignore

# Use AutoPlay for all media and devices
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers' -Name 'DisableAutoplay' -PropertyType DWord -Value 0 -Force

# Enable thumbnail cache removal
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache' -Name 'Autorun' -PropertyType DWord -Value 3 -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache' -Name 'Autorun' -PropertyType DWord -Value 3 -Force

# Prevent all internal SATA drives from showing up as removable media in the taskbar notification area
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\storahci\Parameters\Device' -Name 'TreatAsInternalPort' -Type MultiString -Value @(0, 1, 2, 3, 4, 5) -Force

# Back up the system registry to %SystemRoot%\System32\config\RegBack folder
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager" -Name 'EnablePeriodicBackup' -Type DWord -Value 1 -Force

# Enable Microsoft Defender Exploit Guard network protection
Set-MpPreference -EnableNetworkProtection Enabled

# Enable detection for potentially unwanted applications and block them
Set-MpPreference -PUAProtection Enabled

# Enable sandboxing for Microsoft Defender
& "$env:SystemRoot\System32\setx.exe" /M MP_FORCE_USE_SANDBOX 1

# Dismiss Microsoft Defender offer in the Windows Security about signing in Microsoft account
if (-not (Test-Path -Path 'HKCU:\Software\Microsoft\Windows Security Health\State')) {
	New-Item -Path 'HKCU:\Software\Microsoft\Windows Security Health\State' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows Security Health\State' -Name 'AccountProtection_MicrosoftAccount_Disconnected' -PropertyType DWord -Value 1 -Force

# Dismiss Microsoft Defender offer in the Windows Security about turning on the SmartScreen filter for Microsoft Edge
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows Security Health\State' -Name 'AppAndBrowser_EdgeSmartScreenOff' -PropertyType DWord -Value 0 -Force

# Enable apps and files checking within Microsoft Defender SmartScreen
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'SmartScreenEnabled' -PropertyType String -Value Warn -Force

# Disable Windows Script Host
if (-not (Test-Path -Path 'HKCU:\Software\Microsoft\Windows Script Host\Settings')) {
	New-Item -Path 'HKCU:\Software\Microsoft\Windows Script Host\Settings' -Force
}
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows Script Host\Settings' -Name 'Enabled' -PropertyType DWord -Value 0 -Force

# Enable Windows Sandbox
if ((Get-CimInstance -ClassName CIM_Processor).VirtualizationFirmwareEnabled) {
	Enable-WindowsOptionalFeature -FeatureName 'Containers-DisposableClientVM' -All -Online -NoRestart
}
else {
	try {
		if ((Get-CimInstance -ClassName CIM_ComputerSystem).HypervisorPresent) {
			Enable-WindowsOptionalFeature -FeatureName 'Containers-DisposableClientVM' -All -Online -NoRestart
		}
	}
	catch [Exception] {
		Write-Error -Message $Localization.EnableHardwareVT -ErrorAction SilentlyContinue
		Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue
	}
}

# Disable DNS-over-HTTPS for IPv4
if (-not (Get-CimInstance -ClassName CIM_ComputerSystem).HypervisorPresent) {
	$InterfaceGuids = @((Get-NetAdapter -Physical).InterfaceGuid)
}
else {
	$InterfaceGuids = @((Get-NetRoute -AddressFamily IPv4 | Where-Object -FilterScript { $_.DestinationPrefix -eq '0.0.0.0/0' } | Get-NetAdapter).InterfaceGuid)
}
if (-not (Get-CimInstance -ClassName CIM_ComputerSystem).HypervisorPresent) {
	Get-NetAdapter -Physical | Get-NetIPInterface -AddressFamily IPv4 | Set-DnsClientServerAddress -ResetServerAddresses
}
else {
	Get-NetRoute | Where-Object -FilterScript { $_.DestinationPrefix -eq '0.0.0.0/0' } | Get-NetAdapter | Set-DnsClientServerAddress -ResetServerAddresses
}
foreach ($InterfaceGuid in $InterfaceGuids) {
	Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\$InterfaceGuid\DohInterfaceSettings\Doh" -Recurse -Force -ErrorAction Ignore
}
Clear-DnsClientCache
Register-DnsClient

# Hide the "Extract all" item from the Windows Installer (.msi) context menu
Remove-Item -Path 'Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract' -Recurse -Force -ErrorAction Ignore

# Hide the "Install" item from the Cabinet (.cab) filenames extensions context menu
Remove-Item -Path 'Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\runas' -Recurse -Force -ErrorAction Ignore

# Hide the "Print" item from the .bat and .cmd context menu
New-ItemProperty -Path 'Registry::HKEY_CLASSES_ROOT\batfile\shell\print' -Name 'ProgrammaticAccessOnly' -PropertyType String -Value '' -Force
New-ItemProperty -Path 'Registry::HKEY_CLASSES_ROOT\cmdfile\shell\print' -Name 'ProgrammaticAccessOnly' -PropertyType String -Value '' -Force

# Hide the "Compressed (zipped) Folder" item from the "New" context menu
Remove-Item -Path 'Registry::HKEY_CLASSES_ROOT\.zip\CompressedFolder\ShellNew' -Force -ErrorAction Ignore

# Enable the "Open", "Print", and "Edit" items if more than 15 files selected
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name 'MultipleInvokePromptMinimum' -PropertyType DWord -Value 300 -Force

# Do not use item check boxes
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'AutoCheckSelect' -PropertyType DWord -Value 0 -Force

# Save screenshots by pressing Win+PrtScr in the Pictures folder
Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name '{B7BEDE81-DF94-4682-A7D8-57A52620B86F}' -Force -ErrorAction SilentlyContinue

# Settings: Update & Security: Troubleshoot: Don't run any troubleshooters
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsMitigation' -Name 'UserPreference' -PropertyType DWord -Value 1 -Force
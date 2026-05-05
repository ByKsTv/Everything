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

# Settings: Accessibility: Keyboard: Use the Print screen key to open screen capture: On
New-ItemProperty -Path 'HKCU:\Control Panel\Keyboard' -Name 'PrintScreenKeyForSnippingEnabled' -PropertyType DWord -Value 1 -Force

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
& takeown.exe /f "$env:windir\Web\Screen" /r /d y
& icacls.exe "$env:windir\Web\Screen" /GRANT Everyone:F, Users:F /t
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
& net.exe accounts /maxpwage:unlimited

# Settings: Accessibility: Visual effects: Always show scrollbars: On
New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility' -Name 'DynamicScrollbars' -Value 0 -PropertyType DWord -Force

# Show the file transfer dialog box in the detailed mode
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager' -Name 'EnthusiastMode' -PropertyType DWord -Value 1 -Force

# Set the quality factor of the JPEG desktop wallpapers to maximum
New-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'JPEGImportQuality' -PropertyType DWord -Value 100 -Force

# Disable the Connected User Experiences and Telemetry (DiagTrack) service, and block connection for the Unified Telemetry Client Outbound Traffic
Get-Service -Name 'DiagTrack' | Stop-Service -Force
Get-Service -Name 'DiagTrack' | Set-Service -StartupType Disabled
Get-NetFirewallRule -Group 'DiagTrack' | Set-NetFirewallRule -Enabled True -Action Block

# Turn off Windows Error Reporting
Get-Service -Name 'WerSvc' | Stop-Service -Force
Get-Service -Name 'WerSvc' | Set-Service -StartupType Disabled

# Folder Options: View: Always show icons, never thumbnails: Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'IconsOnly' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Always show menus: Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'AlwaysShowMenus' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Display file icon on thumbnails: Enabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowTypeOverlay' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Display file size information in folder tips: Enabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'FolderContentsInfoTip' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Display the full path in the title bar: Enabled
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState' -Name 'FullPath' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Hidden files and folders: Show hidden files, folders, and drives
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'Hidden' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Hide empty drives: Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideDrivesWithNoMedia' -Value 0 -PropertyType DWord -Force

# Folder Options: View: Hide extensions for known file types: Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideFileExt' -Value 0 -PropertyType DWord -Force

# Folder Options: View: Hide folder merge conflicts: Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideMergeConflicts' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Hide protected operating system files (Recommended): Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSuperHidden' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Launch folder windows in a separate process: Enabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'SeparateProcess' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Restore previous folder windows at logon: Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'PersistBrowsers' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Show drive letters: Enabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShowDriveLettersFirst' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Show encrypted or compressed NTFS files in color: Enabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowEncryptCompressedColor' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Show pop-up description for folder and desktop items: Enabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowInfoTip' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Show preview handlers in pewview pane: Enabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowPreviewHandlers' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Show status bar: Enabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowStatusBar' -PropertyType DWord -Value 1 -Force

# Folder Options: View: Use check boxes to select items: Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'AutoCheckSelect' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Use Sharing Wizard (Recommended): Enabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'SharingWizardOn' -PropertyType DWord -Value 1 -Force

# Folder Options: View: When typing into list view: Select the typed item in the view
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TypeAhead' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Navigation pane: Always show availability status: Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'NavPaneShowAllCloudStates' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Navigation pane: Expand to open folder: Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'NavPaneExpandToCurrentFolder' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Navigation pane: Show all folders: Disabled
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'NavPaneShowAllFolders' -PropertyType DWord -Value 0 -Force

# Folder Options: View: Navigation pane: Show libraries: Disabled
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}')) {
	New-Item -Path 'HKCU:\SOFTWARE\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}' -Name 'System.IsPinnedToNameSpaceTree' -PropertyType DWord -Value 0 -Force

# Turn off Sticky keys by pressing the Shift key 5 times
New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\StickyKeys' -Name 'Flags' -PropertyType String -Value 506 -Force

# Display Stop error code when BSoD occurs
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl' -Name 'DisplayParameters' -PropertyType DWord -Value 1 -Force

# Hide seconds on the taskbar clock
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSecondsInSystemClock' -PropertyType DWord -Value 0 -Force

# Display the recycle bin files delete confirmation dialog
$ShellState = Get-ItemPropertyValue -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShellState'
$ShellState[4] = 51
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'ShellState' -PropertyType Binary -Value $ShellState -Force

# Settings: Accounts: Sign-in options: Automatically save my restartable apps and restart them when I sign back in: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'RestartApps' -PropertyType DWord -Value 0 -Force

# Remote Desktop Connection: Never show pop-up upon ending session
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Terminal Server Client')) {
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
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarGlomLevel' -PropertyType DWord -Value 0 -Force

# Control Panel: Large Icons
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel' -Name 'AllItemsIconView' -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel' -Name 'StartupPage' -PropertyType DWord -Value 1 -Force

# When I grab a windows's title bar and shake it, don't minimize all other windows
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'DisallowShaking' -PropertyType DWord -Value 1 -Force

# Do not group files and folder in the Downloads folder
Get-ChildItem -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\Shell\Bags\*\Shell' -Recurse -ErrorAction SilentlyContinue | Where-Object -FilterScript {
	$_.PSChildName -eq '{885A186E-A440-4ADA-812B-DB871B942259}'
} | Remove-Item -Force
# https://learn.microsoft.com/en-us/windows/win32/properties/props-system-null
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'ColumnList' -PropertyType String -Value 'System.Null' -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'GroupBy' -PropertyType String -Value 'System.Null' -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'LogicalViewMode' -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'Name' -PropertyType String -Value NoName -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'Order' -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'PrimaryProperty' -PropertyType String -Value 'System.ItemNameDisplay' -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}' -Name 'SortByList' -PropertyType String -Value 'prop:System.ItemNameDisplay' -Force

# Settings: System: Storage: Storage Sense: [Windows 11] Keep Windows running smoothly by automatically cleaning up temporary system and app files / [Windows 10] Delete temporary files that my apps aren't using: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Name '04' -PropertyType DWord -Value 1 -Force
# Settings: System: Storage: Storage Sense: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Name '01' -PropertyType DWord -Value 1 -Force
# Settings: System: Storage: Storage Sense: Run Storage Sense: Every day
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Name '2048' -PropertyType DWord -Value 1 -Force
# Settings: System: Storage: Storage Sense: Delete files in my recycle bin if they have been there for over: 60 Days
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Name '256' -PropertyType DWord -Value 60 -Force
# Delete files in my Downloads folder if they haven't been opened for more than: Never
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Name '32' -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy' -Name '512' -PropertyType DWord -Value 0 -Force

# Turn off Delivery Optimization
New-ItemProperty -Path 'Registry::HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings' -Name 'DownloadMode' -PropertyType DWord -Value 0 -Force
Delete-DeliveryOptimizationCache -Force

# Disable Scheduled Tasks
$TasksToDisable = @(
	'Consolidator',
	'DmClient',
	'DmClientOnScenarioDownload',
	'FamilySafetyMonitor',
	'FamilySafetyRefreshTask',
	'MapsToastTask',
	'MapsUpdateTask',
	'MareBackup',
	'Microsoft Compatibility Appraiser',
	'Microsoft-Windows-DiskDiagnosticDataCollector',
	'PcaPatchDbTask',
	'PcaWallpaperAppDetect',
	'ProgramDataUpdater',
	'Proxy',
	'QueueReporting',
	'StartupAppTask',
	'UsbCeip',
	'WinSAT',
	'XblGameSaveTask'
)

foreach ($Task in $TasksToDisable) {
	if (Get-ScheduledTask -TaskName $Task -ErrorAction SilentlyContinue) {
		Get-ScheduledTask -TaskName $Task | Disable-ScheduledTask
	}
}

# Disable Windows features
$FeaturesToDisable = @(
	'WindowsMediaPlayer',
	'WorkFolders-Client',
	'Recall',
	'MediaPlayback'
)

foreach ($Feature in $FeaturesToDisable) {
	$EnabledFeatures = Get-WindowsOptionalFeature -Online | Where-Object {
		$_.State -eq 'Enabled' -and
		$_.FeatureName -match $Feature
	}

	foreach ($EnabledFeature in $EnabledFeatures) {
		Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName $EnabledFeature.FeatureName
	}
}

# Disable Windows Capabilities
$AppsToRemove = @(
	'Hello.Face',
	'InternetExplorer',
	'MathRecognizer',
	'OpenSSH',
	'QuickAssist',
	'StepsRecorder',
	'Wallpapers',
	'WindowsMediaPlayer',
	'WordPad',
	'Narrator',
	'Print.Management.Console'
)

foreach ($App in $AppsToRemove) {
	$Capabilities = Get-WindowsCapability -Online | Where-Object {
		$_.State -eq 'Installed' -and
		$_.Name -match $App
	}

	foreach ($Capability in $Capabilities) {
		Remove-WindowsCapability -Online -Name $Capability.Name
	}
}

# Add Windows Capabilities
$AppsToInstall = @(
	'Print.Fax.Scan',
	'MSPaint',
	'Notepad',
	'SnippingTool'
)

foreach ($AppInstall in $AppsToInstall) {
	$CapabilitiesInstall = Get-WindowsCapability -Online | Where-Object { $_.State -ne 'Installed' -and $_.Name -match $AppInstall }

	foreach ($CapabilityInstall in $CapabilitiesInstall) {
		Add-WindowsCapability -Online -Name $CapabilityInstall.Name
	}
}

# Settings: Windows Update: Get the latest updates as soon as they're available: Off
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'IsContinuousInnovationOptedIn' -PropertyType DWord -Value 0 -Force

# Override for default input method: English
Set-WinDefaultInputMethodOverride -InputTip '0409:00000409'

# Let me use a different input method for each app window
Set-WinLanguageBarOption -UseLegacySwitchMode

# Use the latest installed .NET runtime for all apps
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework' -Name 'OnlyUseLatestCLR' -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework' -Name 'OnlyUseLatestCLR' -PropertyType DWord -Value 1 -Force

# Disable and delete reserved storage after the next update installation
Set-WindowsReservedStorageState -State Disabled

# Disable help lookup via F1
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64')) {
	New-Item -Path 'HKCU:\SOFTWARE\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64' -Name '(default)' -PropertyType String -Value '' -Force

# Enable Num Lock at startup
New-ItemProperty -Path 'Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard' -Name 'InitialKeyboardIndicators' -PropertyType String -Value 2147483650 -Force

# Use AutoPlay for all media and devices
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers' -Name 'DisableAutoplay' -PropertyType DWord -Value 0 -Force

# Enable thumbnail cache removal
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache' -Name 'Autorun' -PropertyType DWord -Value 3 -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache' -Name 'Autorun' -PropertyType DWord -Value 3 -Force

# Do not back up the system registry to %SystemRoot%\System32\config\RegBack folder
Remove-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager' -Name 'EnablePeriodicBackup' -Force -ErrorAction Ignore

# Disable Microsoft Defender Exploit Guard network protection
Set-MpPreference -EnableNetworkProtection Disabled

# Disable detection for potentially unwanted applications and block them
Set-MpPreference -PUAProtection Disabled

# Settings: Touchpad: Scroll & zoom: Scrolling direction: Down motion scrolls down
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PrecisionTouchPad' -Name 'ScrollDirection' -PropertyType DWord -Value 0 -Force

# Disable sandboxing for Microsoft Defender
& "$env:SystemRoot\System32\setx.exe" /M MP_FORCE_USE_SANDBOX 0

# Dismiss Microsoft Defender offer in the Windows Security about signing in Microsoft account
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows Security Health\State')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows Security Health\State' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows Security Health\State' -Name 'AccountProtection_MicrosoftAccount_Disconnected' -PropertyType DWord -Value 1 -Force

# Dismiss Microsoft Defender offer in the Windows Security about turning on the SmartScreen filter for Microsoft Edge
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows Security Health\State' -Name 'AppAndBrowser_EdgeSmartScreenOff' -PropertyType DWord -Value 0 -Force

# Microsoft Defender: App & browser control: SmartScreen for Microsoft Store apps: Dismiss offer
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows Security Health\State' -Name 'AppAndBrowser_StoreAppsSmartScreenOff' -Value 0 -PropertyType DWord -Force

# Disable apps and files checking within Microsoft Defender SmartScreen
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'SmartScreenEnabled' -PropertyType String -Value 'Off' -Force

# Disable Windows Script Host
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows Script Host\Settings')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows Script Host\Settings' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows Script Host\Settings' -Name 'Enabled' -PropertyType DWord -Value 0 -Force

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
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer' -Name 'MultipleInvokePromptMinimum' -PropertyType DWord -Value 300 -Force

# Settings: Update & Security: Troubleshoot: Don't run any troubleshooters
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\WindowsMitigation')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\WindowsMitigation' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsMitigation' -Name 'UserPreference' -PropertyType DWord -Value 1 -Force

# Settings: Devices: Typing: Typing Insights: Disabling
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Input\Settings')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Input\Settings' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Input\Settings' -Name 'InsightsEnabled' -Value 0 -PropertyType DWord -Force

# Settings: Windows Security: Virus & threat protection: Manage settings: Change notification settings: Recent activity and scan results: Off
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows Defender Security Center\Virus and threat protection' -Name 'SummaryNotificationDisabled' -Value 1 -PropertyType DWord -Force

# On-Screen Keyboard: Options: Use click sound: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Osk' -Name 'ClickSound' -Value 0 -PropertyType DWord -Force

# On-Screen Keyboard: Options: Use Text Prediction: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Osk' -Name 'UseTextPrediction' -Value 0 -PropertyType DWord -Force

# Context menu: Remove 'Rotate right', 'Rotate left'
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.avci\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.avif\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.bmp\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.dds\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.dib\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.gif\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.heic\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.heif\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.hif\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force -ErrorAction SilentlyContinue
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.ico\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jfif\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jpe\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jpeg\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jpg\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jxr\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.png\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.rle\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.tif\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.tiff\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.wdp\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.webp\ShellEx\ContextMenuHandlers\ShellImagePreview' -Force

# Context Menu: Remove 'Set as desktop background'
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.avci\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.avcs\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.avif\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.avifs\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.bmp\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.dib\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.gif\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.heic\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.heics\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.heif\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.heifs\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.hif\Shell\setdesktopwallpaper' -Force -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jfif\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jpe\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jpeg\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.jpg\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.png\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.tif\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.tiff\Shell\setdesktopwallpaper' -Force -Recurse
Remove-Item -Path 'HKLM:\SOFTWARE\Classes\SystemFileAssociations\.wdp\Shell\setdesktopwallpaper' -Force -Recurse

# File Explorer: Ribbon: Details View and Size all columms to fit
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon' -Name 'MinimizedStateTabletModeOff' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon' -Name 'QatItems' -Value ([byte[]](0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x75, 0x73, 0x74, 0x6f, 0x6d, 0x55, 0x49, 0x20, 0x78, 0x6d, 0x6c, 0x6e, 0x73, 0x3a, 0x73, 0x69, 0x71, 0x3d, 0x22, 0x68, 0x74, 0x74, 0x70, 0x3a, 0x2f, 0x2f, 0x73, 0x63, 0x68, 0x65, 0x6d, 0x61, 0x73, 0x2e, 0x6d, 0x69, 0x63, 0x72, 0x6f, 0x73, 0x6f, 0x66, 0x74, 0x2e, 0x63, 0x6f, 0x6d, 0x2f, 0x77, 0x69, 0x6e, 0x64, 0x6f, 0x77, 0x73, 0x2f, 0x32, 0x30, 0x30, 0x39, 0x2f, 0x72, 0x69, 0x62, 0x62, 0x6f, 0x6e, 0x2f, 0x71, 0x61, 0x74, 0x22, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x72, 0x69, 0x62, 0x62, 0x6f, 0x6e, 0x20, 0x6d, 0x69, 0x6e, 0x69, 0x6d, 0x69, 0x7a, 0x65, 0x64, 0x3d, 0x22, 0x74, 0x72, 0x75, 0x65, 0x22, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x71, 0x61, 0x74, 0x20, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x3d, 0x22, 0x30, 0x22, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x73, 0x68, 0x61, 0x72, 0x65, 0x64, 0x43, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x73, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x36, 0x31, 0x32, 0x38, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x36, 0x31, 0x32, 0x39, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x35, 0x32, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x38, 0x34, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x33, 0x36, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x33, 0x35, 0x37, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x36, 0x35, 0x37, 0x36, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x74, 0x72, 0x75, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x20, 0x69, 0x64, 0x51, 0x3d, 0x22, 0x73, 0x69, 0x71, 0x3a, 0x31, 0x32, 0x34, 0x38, 0x35, 0x22, 0x20, 0x76, 0x69, 0x73, 0x69, 0x62, 0x6c, 0x65, 0x3d, 0x22, 0x74, 0x72, 0x75, 0x65, 0x22, 0x20, 0x61, 0x72, 0x67, 0x75, 0x6d, 0x65, 0x6e, 0x74, 0x3d, 0x22, 0x30, 0x22, 0x20, 0x2f, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x73, 0x68, 0x61, 0x72, 0x65, 0x64, 0x43, 0x6f, 0x6e, 0x74, 0x72, 0x6f, 0x6c, 0x73, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x71, 0x61, 0x74, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x72, 0x69, 0x62, 0x62, 0x6f, 0x6e, 0x3e, 0x3c, 0x2f, 0x73, 0x69, 0x71, 0x3a, 0x63, 0x75, 0x73, 0x74, 0x6f, 0x6d, 0x55, 0x49, 0x3e)) -PropertyType Binary -Force

# Performance Options: Advanced: Processor scheduling: Adjust for best performance of: Programs
New-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\PriorityControl' -Name 'Win32PrioritySeparation' -Value 38 -PropertyType DWord -Force

# Enable MSI and High Priority
$PciDevicesPath = 'HKLM:\SYSTEM\CurrentControlSet\Enum\PCI'
Get-ChildItem -Path $PciDevicesPath -ErrorAction SilentlyContinue | Where-Object { $_.PSIsContainer } | ForEach-Object {
	Get-ChildItem -Path $_.PSPath -ErrorAction SilentlyContinue | Where-Object { $_.PSIsContainer } | ForEach-Object {
		$InterruptManagementPath = [IO.Path]::Combine($_.PSPath, 'Device Parameters', 'Interrupt Management')
		$DeviceParametersPath = [IO.Path]::Combine($InterruptManagementPath, 'MessageSignaledInterruptProperties')
		$AffinityPolicyPath = [IO.Path]::Combine($InterruptManagementPath, 'Affinity Policy')

		@($InterruptManagementPath, $DeviceParametersPath, $AffinityPolicyPath) | ForEach-Object {
			if (-not (Test-Path $_)) {
				New-Item -Path $_ -ItemType Directory -Force
			}
		}

		New-ItemProperty -Path $DeviceParametersPath -Name 'MSISupported' -Value 1 -PropertyType DWord -Force
		New-ItemProperty -Path $AffinityPolicyPath -Name 'DevicePriority' -Value 3 -PropertyType DWord -Force
	}
}

# Control Panel: Ease of Access: Ease of Access Center: Always read this section aloud: off
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Ease of Access')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Ease of Access' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Ease of Access' -Name 'selfvoice' -Value 0 -PropertyType DWord -Force

# Control Panel: Ease of Access: Ease of Access Center: Always scan this section: off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Ease of Access' -Name 'selfscan' -Value 0 -PropertyType DWord -Force

# File Explorer: Remove pinned quick access items
Remove-Item -Path "$env:USERPROFILE\Documents" -Recurse -Force
Remove-Item -Path "$env:USERPROFILE\Music" -Recurse -Force
Remove-Item -Path "$env:USERPROFILE\Pictures" -Recurse -Force
Remove-Item -Path "$env:USERPROFILE\Videos" -Recurse -Force
Remove-Item "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations\*" -Force -Recurse
Stop-Process -Name explorer -Force

$HostsPath = "$env:WINDIR\System32\drivers\etc\hosts"
$Urls = 'mobile.events.data.microsoft.com', 'r.bing.comms-appx-web'
$Urls | ForEach-Object {
	$Line = '0.0.0.0 ' + $_
	if (-not (Select-String -Path $HostsPath -Pattern $Line)) {
		Add-Content -Path $HostsPath -Value $Line
	} }

# Open as Notepad (`.nfo` doesn't work)
$NotepadDefaultExts = @('.lua', '.conf', '.json', '.glsl', '.xml', '.md5', '.sfv', '.sha1', '.tth', 'toml')
foreach ($NotepadDefaultExt in $NotepadDefaultExts) {
	New-Item "HKCU:\SOFTWARE\Classes\$NotepadDefaultExt\shell\open\command" -Force | New-ItemProperty -Name '(default)' -Value 'notepad.exe %1' -Force
}

# Narrator: Do not show again
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Narrator' -Name 'ShortcutKeysDialogState' -Value 1 -PropertyType DWord -Force

# Settings: Accessibility: Narrator: Keyboard shortcut for Narrator: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Narrator\NoRoam' -Name 'WinEnterLaunchEnabled' -Value 0 -PropertyType DWord -Force

# Settings: Accessibility: Narrator: Volume: 1
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Narrator\NoRoam' -Name 'SpeechVolume' -Value 1 -PropertyType DWord -Force

# Settings: Accessibility: Narrator: Enable Narrator extenstions: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Narrator\NoRoam' -Name 'ScriptingEnabled' -Value 0 -PropertyType DWord -Force

# Microsoft Store: Settings: App Updates: On
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate' -Name 'AutoDownload' -Value 4 -PropertyType DWord -Force

<#
	Setting:
	GPU Priority

	Description:
	Defines the GPU scheduling priority for the specified multimedia task—in this case, for games.

	Values:
	0–31 (decimal) - Higher values indicate higher GPU scheduling priority.
	Default - Typically 6 for games.
	8 - Gives the game task higher priority access to GPU resources.

	Note:
	This setting affects how the Multimedia Class Scheduler Service (MMCSS) allocates GPU time. Increasing the value can improve responsiveness and performance in games, but excessive values may starve other GPU-using tasks.
#>
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games' -Name 'GPU Priority' -Value 8 -PropertyType DWord -Force

<#
	Setting:
	Priority

	Description:
	Sets the CPU scheduling priority for the specified multimedia task—in this case, games—under the Multimedia Class Scheduler Service (MMCSS).

	Values:
	1–8 (decimal) - Higher numbers give higher CPU scheduling priority.
	Default - Typically 6 for games.
	8 - Maximum priority within MMCSS-managed range.

	Note:
	This influences how much CPU time is given to games compared to other multimedia tasks. Higher values improve responsiveness but may reduce performance of background tasks or services.
#>
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games' -Name 'Priority' -Value 6 -PropertyType DWord -Force

<#
	Setting:
	Scheduling Category

	Description:
	Defines the type of scheduling behavior applied to the task under the Multimedia Class Scheduler Service (MMCSS), influencing how aggressively it receives CPU time.

	Values:
	Low - Lowest priority for background tasks.
	Medium - Balanced CPU access.
	High - Higher CPU priority; suitable for latency-sensitive tasks like games.
	Exclusive - Highest priority; reserves CPU time exclusively (used with caution).

	Note:
	Setting this to "High" ensures games get faster CPU response compared to normal or background tasks. "Exclusive" may impact overall system responsiveness and is generally reserved for critical media tasks.
#>
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games' -Name 'Scheduling Category' -Value 'High' -PropertyType String -Force

<#
	Setting:
	SFIO Priority

	Description:
	Defines the background I/O (Slow File I/O) priority level for the task, affecting how Windows schedules disk operations for that task.

	Values:
	Idle - Lowest disk I/O priority.
	Low - Lower than normal I/O.
	Normal - Default priority for standard tasks.
	High - Elevated disk I/O priority for performance-critical tasks.

	Note:
	Setting this to "High" gives games higher priority access to disk resources, reducing I/O latency during gameplay. Useful for minimizing stutters from background disk activity.
#>
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games' -Name 'SFIO Priority' -Value 'High' -PropertyType String -Force

# Windows search indexer
Stop-Service WSearch -Force -ErrorAction SilentlyContinue
Set-Service WSearch -StartupType Disabled
$base = "$env:ProgramData\Microsoft\Search\Data"
$targets = @(
	(Join-Path -Path $base -ChildPath 'Applications\Windows')  # contains Windows.edb + logs
	(Join-Path -Path $base -ChildPath 'Temp')                  # working/temp files
)
foreach ($t in $targets) {
	if (Test-Path -LiteralPath $t) {
		Remove-Item -LiteralPath $t -Recurse -Force -ErrorAction Stop
	}
}
Get-Process -Name 'SearchApp', 'SearchHost' -ErrorAction SilentlyContinue |
Stop-Process -Force -ErrorAction SilentlyContinue

# Don't promt to save pictures on Snipping Tool
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\TabletPC\Snipping Tool' -Name 'PromptToSave' -Value 0 -PropertyType DWord -Force

# Performance Options -> Visual Effects -> Animate controls and elements inside windows -> Disabled
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name 'VisualFXSetting' -Value 3 -PropertyType DWord -Force

# Performance Options -> Visual Effects -> Animate windows when minimizing and maximizing -> Disabled
New-ItemProperty -Path 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Value 0 -PropertyType String -Force

# Performance Options -> Visual Effects -> Animations in the taskbar -> Disabled
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarAnimations' -Value 0 -PropertyType DWord -Force

# Performance Options -> Visual Effects -> Enable Peek -> Disabled
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\DWM' -Name 'EnableAeroPeek' -Value 0 -PropertyType DWord -Force

# Performance Options -> Visual Effects -> Fade or slide menus into view -> Disabled
# [HKEY_CURRENT_USER\Control Panel\Desktop]
# "UserPreferencesMask"=hex(3):90,12,03,80,91,00,00,00

# Performance Options -> Visual Effects -> Fade or slide ToolTips into view -> Disabled
# [HKEY_CURRENT_USER\Control Panel\Desktop]
# "UserPreferencesMask"=hex(3):90,12,03,80,91,00,00,00

# Performance Options -> Visual Effects -> Fade out menu items after clicking -> Disabled
# [HKEY_CURRENT_USER\Control Panel\Desktop]
# "UserPreferencesMask"=hex(3):90,12,03,80,91,00,00,00

# Performance Options -> Visual Effects -> Save taskbar thumbnail previews -> Disabled
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\DWM' -Name 'AlwaysHibernateThumbnails' -Value 0 -PropertyType DWord -Force

# Performance Options -> Visual Effects -> Show shadows under mouse pointer -> Disabled
# [HKEY_CURRENT_USER\Control Panel\Desktop]
# "UserPreferencesMask"=hex(3):90,12,07,80,91,00,00,00

# Performance Options -> Visual Effects -> Show shadows under windows -> Disabled
# [HKEY_CURRENT_USER\Control Panel\Desktop]
# "UserPreferencesMask"=hex(3):90,12,03,80,91,00,00,00

# Performance Options -> Visual Effects -> Show thumbnails instead of icons -> Disabled
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'IconsOnly' -Value 1 -PropertyType DWord -Force

# Performance Options -> Visual Effects -> Show translucent selection rectangle -> Disabled
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ListviewAlphaSelect' -Value 0 -PropertyType DWord -Force

# Performance Options -> Visual Effects -> Show window contents while dragging -> Enabled
New-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'DragFullWindows' -Value 1 -PropertyType String -Force

# Performance Options -> Visual Effects -> Slide open combo boxes -> Disabled
# [HKEY_CURRENT_USER\Control Panel\Desktop]
# "UserPreferencesMask"=hex(3):90,12,03,80,91,00,00,00

# Performance Options -> Visual Effects -> Smooth edges of screen fonts -> Disabled
New-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'FontSmoothing' -Value 2 -PropertyType String -Force

# Performance Options -> Visual Effects -> Smooth-scroll list boxes -> Disabled
# [HKEY_CURRENT_USER\Control Panel\Desktop]
# "UserPreferencesMask"=hex(3):90,12,03,80,91,00,00,00

# Performance Options -> Visual Effects -> Use drop shadows for icon labels on the desktop -> Disabled
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ListviewShadow' -Value 0 -PropertyType DWord -Force

# Control Panel: Ease of Access: Ease of Access Center: Make the computer easier to see: Remove background images (when available): On
# $RemoveBackgroundImagesBytes = [byte[]](Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask').UserPreferencesMask
# $RemoveBackgroundImagesBytes[4] = $RemoveBackgroundImagesBytes[4]-bor 1
# New-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -PropertyType Binary -Value $RemoveBackgroundImagesBytes -Force

# Control Panel: Ease of Access Center: Make the computer easier to see: Turn off all unnecessary animations (when possible): On
# New-ItemProperty -Path 'HKCU:\Control Panel\Desktop\WindowMetrics' -Name 'MinAnimate' -Value '0' -PropertyType String -Force
New-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'UserPreferencesMask' -Value ([byte[]](0x90, 0x12, 0x03, 0x80, 0x91, 0x00, 0x00, 0x00)) -PropertyType Binary -Force

# Stop CTFMon
# https://www.youtube.com/watch?v=b6wfwG4jecQ
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Input' -Name 'InputServiceEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Input' -Name 'InputServiceEnabledForCCI' -Value 0 -PropertyType DWord -Force
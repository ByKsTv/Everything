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

# Power Plan: Shutdown settings: Disabling Fast Startup
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -Name 'HiberbootEnabled' -PropertyType DWord -Value 0 -Force

# Group Policy: Computer Configuration: Administrative Templates: System: Power Management: Power Throttling Settings: Turn off Power Throttling: Enabled
if (-not (Test-Path -Path 'HKLM:\System\ControlSet001\Control\Power\PowerThrottling')) {
	New-Item -Path 'HKLM:\System\ControlSet001\Control\Power\PowerThrottling' -Force
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Control\Power\PowerThrottling' -Name 'PowerThrottlingOff' -PropertyType DWord -Value 1 -Force

# Settings: System: For developers: File Explorer: Show file extenstions: On
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
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager' -Name 'EnthusiastMode' -PropertyType DWord -Value 1 -Force

# FirstLogonAnimation -Disable
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name 'EnableFirstLogonAnimation' -PropertyType DWord -Value 0 -Force

# JPEGWallpapersQuality -Max
New-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'JPEGImportQuality' -PropertyType DWord -Value 100 -Force

# Win32LongPathLimit -Disable
New-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -PropertyType DWord -Value 1 -Force

# Scheduled Tasks
Get-ScheduledTask -TaskName 'PcaPatchDbTask' | Disable-ScheduledTask
Get-ScheduledTask -TaskName 'Consolidator' | Disable-ScheduledTask
Get-ScheduledTask -TaskName 'DmClient' | Disable-ScheduledTask
Get-ScheduledTask -TaskName 'DmClientOnScenarioDownload' | Disable-ScheduledTask
Get-ScheduledTask -TaskName 'FamilySafetyMonitor' | Disable-ScheduledTask
Get-ScheduledTask -TaskName 'FamilySafetyRefreshTask' | Disable-ScheduledTask
Get-ScheduledTask -TaskName 'MapsToastTask' | Disable-ScheduledTask
Get-ScheduledTask -TaskName 'MapsUpdateTask' | Disable-ScheduledTask
Get-ScheduledTask -TaskName 'MareBackup' | Disable-ScheduledTask
Get-ScheduledTask -TaskName 'Microsoft Compatibility Appraiser' | Disable-ScheduledTask
Get-ScheduledTask -TaskName 'Microsoft-Windows-DiskDiagnosticDataCollector' | Disable-ScheduledTask
Get-ScheduledTask -TaskName 'PcaWallpaperAppDetect' | Disable-ScheduledTask
Get-ScheduledTask -TaskName 'ProgramDataUpdater' | Disable-ScheduledTask
Get-ScheduledTask -TaskName 'Proxy' | Disable-ScheduledTask
Get-ScheduledTask -TaskName 'UsbCeip' | Disable-ScheduledTask
Get-ScheduledTask -TaskName 'XblGameSaveTask' | Disable-ScheduledTask
Get-ScheduledTask -TaskName 'QueueReporting' | Disable-ScheduledTask
Get-ScheduledTask -TaskName 'StartupAppTask' | Disable-ScheduledTask

# DiagTrackService -Disable
Get-Service -Name 'DiagTrack' | Stop-Service -Force
Get-Service -Name 'DiagTrack' | Set-Service -StartupType Disabled
Get-NetFirewallRule -Group 'DiagTrack' | Set-NetFirewallRule -Enabled True -Action Block

Get-Service -Name WerSvc | Stop-Service -Force
Get-Service -Name WerSvc | Set-Service -StartupType Disabled

# MergeConflicts -Show
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'HideMergeConflicts' -PropertyType DWord -Value 0 -Force

# DismissMSAccount
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows Security Health\State' -Name 'AccountProtection_MicrosoftAccount_Disconnected' -PropertyType DWord -Value 1 -Force

# DismissSmartScreenFilter
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows Security Health\State' -Name 'AppAndBrowser_EdgeSmartScreenOff' -PropertyType DWord -Value 0 -Force

# StickyShift -Disable
New-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\StickyKeys' -Name 'Flags' -PropertyType String -Value 506 -Force
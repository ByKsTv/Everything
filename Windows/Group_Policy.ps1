# https://learn.microsoft.com/en-us/windows/privacy/manage-connections-from-windows-operating-system-components-to-microsoft-services-using-mdm
# https://learn.microsoft.com/en-us/windows/privacy/manage-windows-21h2-endpoints

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Network: WLAN Service: WLAN Settings: Allow Windows to automatically connect to suggested open hotspots, to networks shared by contacts, and to hotspots offering paid services: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\WcmSvc\wifinetworkmanager\config') -ne $true) {
    New-Item 'HKLM:\Software\Microsoft\WcmSvc\wifinetworkmanager\config' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\WcmSvc\wifinetworkmanager\config' -Name 'AutoConnectAllowedOEM' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Location and Sensors: Turn off location: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\LocationAndSensors') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\LocationAndSensors' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\LocationAndSensors' -Name 'DisableLocation' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off cloud optimized content: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Name 'DisableCloudOptimizedContent' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off cloud consumer account state content: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Name 'DisableConsumerAccountStateContent' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Cloud Content: Do not show Windows tips: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Name 'DisableSoftLanding' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off Microsoft consumer experiences: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsConsumerFeatures' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Configure Windows spotlight on lock screen: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'ConfigureWindowsSpotlight' -Value 2 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off Spotlight collection on Desktop: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableSpotlightCollectionOnDesktop' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Do not use diagnostic data for tailored experiences: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableTailoredExperiencesWithDiagnosticData' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Do not suggest third-party content in Windows spotlight: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableThirdPartySuggestions' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off all Windows spotlight features: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsSpotlightFeatures' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off Windows Spotlight on Action Center: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsSpotlightOnActionCenter' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off Windows Spotlight on Settings: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsSpotlightOnSettings' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off the Windows Welcome Experience: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsSpotlightWindowsWelcomeExperience' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Control Panel: Allow Online Tips: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) {
    New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'AllowOnlineTips' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Control Panel: Regional and Language Options: Handwriting personalization: Turn off automatic learning: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\InputPersonalization') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\InputPersonalization' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\InputPersonalization' -Name 'RestrictImplicitInkCollection' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\InputPersonalization' -Name 'RestrictImplicitTextCollection' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Start Menu and Taskbar: Do not keep history of recently opened documents: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) {
    New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoRecentDocsHistory' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Start Menu and Taskbar: Notifications: Turn off notifications network usage: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'NoCloudApplicationNotification' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: App-V: CEIP: Microsoft Customer Experience Improvement Program (CEIP): Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\AppV\CEIP') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\AppV\CEIP' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\AppV\CEIP' -Name 'CEIPEnable' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Device Installation: Do not send a Windows error report when a generic driver is installed on a device: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings' -Force 
}
if ((Test-Path -Path 'HKLM:\System\DriverDatabase\Policies\Settings') -ne $true) {
    New-Item 'HKLM:\System\DriverDatabase\Policies\Settings' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings' -Name 'DisableSendGenericDriverNotFoundToWER' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\System\DriverDatabase\Policies\Settings' -Name 'DisableSendGenericDriverNotFoundToWER' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Device Installation: Prevent Windows from sending an error report when a device driver requests additional woftware during installation: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings' -Force 
}
if ((Test-Path -Path 'HKLM:\System\DriverDatabase\Policies\Settings') -ne $true) {
    New-Item 'HKLM:\System\DriverDatabase\Policies\Settings' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\DeviceInstall\Settings' -Name 'DisableSendRequestAdditionalSoftwareToWER' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\System\DriverDatabase\Policies\Settings' -Name 'DisableSendRequestAdditionalSoftwareToWER' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off handwriting recognition error reporting: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\HandwritingErrorReports' -Name 'PreventHandwritingErrorReports' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Windows Customer Experience Improvement Program: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\SQMClient\Windows') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\SQMClient\Windows' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\SQMClient\Windows' -Name 'CEIPEnable' -Value 0 -PropertyType DWord -Force

Write-Host "Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Help and Support Center 'Did you know?' content: Enabled" -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc' -Name 'Headlines' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Help and Support Center Microsoft Knowledge Base search: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\HelpSvc' -Name 'MicrosoftKBSearch' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Windows Error Reporting: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting' -Force 
}
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting' -Name 'DoReport' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'Disabled' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Search Companion content file updates: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\SearchCompanion') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\SearchCompanion' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\SearchCompanion' -Name 'DisableContentFileUpdates' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Internet File Association service: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) {
    New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoInternetOpenWith' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off access to the Store: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Explorer') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Explorer' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Explorer' -Name 'NoUseStoreOpenWith' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Internet download for Web publishing and online ordering wizards: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) {
    New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoWebServices' -Value 1 -PropertyType DWord -Force

Write-Host "Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off the 'Order Prints' picture task: Enabled" -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) {
    New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoOnlinePrintsWizard' -Value 1 -PropertyType DWord -Force

Write-Host "Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off the 'Publish to Web' task for files and folders: Enabled" -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) {
    New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoPublishingWizard' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off the Windows Messenger Customer Experience Improvement Program: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Messenger\Client') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Messenger\Client' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Messenger\Client' -Name 'CEIP' -Value 2 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off handwriting personalization data sharing: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\TabletPC') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\TabletPC' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\TabletPC' -Name 'PreventHandwritingDataSharing' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: OS Policies: Allow Clipboard History: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\System') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\System' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'AllowClipboardHistory' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: OS Policies: Allow Clipboard synchronization across devices: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\System') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\System' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'AllowCrossDeviceClipboard' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: OS Policies: Allow publishing of User Activites: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\System') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\System' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'PublishUserActivities' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: OS Policies: Allow upload of User Activites: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\System') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\System' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'UploadUserActivities' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: OS Policies: Enabled Activity Feed: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\System') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\System' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\System' -Name 'EnableActivityFeed' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: System: User Profiles: Turn off the advertising ID: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\AdvertisingInfo') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AdvertisingInfo' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\AdvertisingInfo' -Name 'DisabledByGroupPolicy' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Remove Program Compatibility Property Page: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'DisablePropPage' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Turn off Application Compatibility Engine: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'DisableEngine' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Turn off Application Telemetry: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'AITEnable' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Turn off Inventory Collector: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'DisableInventory' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Turn off Program Compatibility Assistant: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'DisablePCA' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Turn off Steps Recorder: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'DisableUAR' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Turn off SwitchBack Compatibility Engine: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\AppCompat' -Name 'SbEnable' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Data Collection and Preview Builds: Allow device name to be sent in Windows diagnostic data: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Name 'AllowDeviceNameInTelemetry' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Data Collection and Preview Builds: Configure collection of browsing data for Desktop Analytics: Do not allow sending intranet or internet history' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection') -ne $true) {
    New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'MicrosoftEdgeDataOptIn' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Data Collection and Preview Builds: Disable OneSettings Downloads: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Name 'DisableOneSettingsDownloads' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Data Collection and Preview Builds: Do not show feedback notifications: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\DataCollection' -Name 'DoNotShowFeedbackNotifications' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Siuf\Rules' -Name 'NumberOfSIUFInPeriod' -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path 'HKCU:\Software\Microsoft\Siuf\Rules' -Name 'PeriodInNanoSeconds' -PropertyType DWord -Value 0 -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Edge UI: Disable help tips: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\EdgeUI') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\EdgeUI' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\EdgeUI' -Name 'DisableHelpSticker' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Maps: Turn off Automatic Download nad Update of Map Data: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Maps') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Maps' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Maps' -Name 'AutoDownloadAndUpdateMapData' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Maps: Turn off unsolicited network  traffic on the Offline Maps settings page: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Maps') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Maps' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Maps' -Name 'AllowUntriggeredNetworkTrafficOnSettingsPage' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Online Assistance: Turn off Active Help: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Assistance\Client\1.0') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Assistance\Client\1.0' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Assistance\Client\1.0' -Name 'NoActiveHelp' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow Cloud Search: Disable Cloud Search' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCloudSearch' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow Cortana: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortana' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow Cortana above lock screen: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortanaAboveLock' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow Cortana Page in OOBE on an AAD account: Disable Cortana Page in AAD' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortanaInAADPathOOBE' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow search highlights: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'EnableDynamicContentInWSB' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow search and Cortana to use location: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'AllowSearchToUseLocation' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Do not allow web search: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'DisableWebSearch' -Value 1 -PropertyType DWord -Force

Write-Host "Computer Configuration: Administrative Templates: Windows Components: Search: Don't search the web or display web results in Search: Enabled" -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchUseWeb' -Value 0 -PropertyType DWord -Force

Write-Host "Computer Configuration: Administrative Templates: Windows Components: Search: Don't search the web or disable web results in Search over metered connections: Enabled" -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchUseWebOverMeteredConnections' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Set the SafeSearch setting for Search: Off' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchSafeSearch' -Value 3 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Set what information is shared in Search: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Force 
}
Remove-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchPrivacy' -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Text Input: Improve inking and typing recognition: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput') -ne $true) {
    New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput' -Name 'AllowLinguisticDataCollection' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Calendar: Turn off Windows Calendar: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Windows') -ne $true) {
    New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Windows' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Windows' -Name 'TurnOffWinCal' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Error Reporting: Configure Error Reporting: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\DW') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\DW' -Force 
}
Remove-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\DW' -Name 'DWReporteeName' -Force
Remove-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\PCHealth\ErrorReporting\DW' -Name 'DWFileTreeRoot' -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Error Reporting: Automatically send memory dumps for OS-generated error reports: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'AutoApproveOSDumps' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Error Reporting: Send data when on connected to a restricted/costed network: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'BypassNetworkCostThrottling' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Error Reporting: Send additional data when on battery power: Disabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'BypassPowerThrottling' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Error Reporting: Do not send additional data: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'DontSendAdditionalData' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Mobility Center: Turn off Windows Mobility Center: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\MobilityCenter') -ne $true) {
    New-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\MobilityCenter' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\MobilityCenter' -Name 'NoMobilityCenter' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Messenger: Do not automatically start Windows Messenger initially: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Messenger\Client') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Messenger\Client' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Messenger\Client' -Name 'PreventAutoRun' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Messenger: Do not allow Windows Messenger to be run: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Messenger\Client') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Messenger\Client' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Messenger\Client' -Name 'PreventRun' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Microsoft Defender Antivirus: MAPS: Send file samples when further analysis is required: Never send' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows Defender\Spynet' -Name 'SubmitSamplesConsent' -Value 2 -PropertyType DWord -Force

Write-Host 'Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Game Recording and Broadcasing: Disable' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKLM:\Software\Policies\Microsoft\Windows\GameDVR') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Microsoft\Windows\GameDVR' -Force 
}
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Windows\GameDVR' -Name 'AllowGameDVR' -Value 0 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Windows Components: Windows Copilot: Turn off Windows Copilot: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot' -Name 'TurnOffWindowsCopilot' -Value 1 -PropertyType DWord -Force

Write-Host 'Group Policy: User Configuration: Administrative Templates: Start Menu and Taskbar: Remove the Meet Now icon: Enabled' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'HideSCAMeetNow' -Value 1 -PropertyType DWord -Force
# Sort by Path - Computer
# Group Policy: Computer Configuration: Administrative Templates: Control Panel: Allow Online Tips: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'AllowOnlineTips' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Control Panel: Personalization: Prevent enabling lock screen camera: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Personalization' -Name 'NoLockScreenCamera' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Control Panel: Regional and Language Options: Allow users to enable online speech recognition services: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\InputPersonalization' -Name 'AllowInputPersonalization' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Control Panel: Regional and Language Options: Handwriting personalization: Turn off automatic learning: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\InputPersonalization' -Name 'RestrictImplicitInkCollection' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\InputPersonalization' -Name 'RestrictImplicitTextCollection' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Network: QoS Packet Scheduler: Limit reservable bandwidth: Enabled: 0%
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Psched' -Name 'NonBestEffortLimit' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Start Menu and Taskbar: Do not keep history of recently opened documents: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoRecentDocsHistory' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Start Menu and Taskbar: Remove "Recently added" list from Start Menu: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'HideRecentlyAddedApps' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Start Menu and Taskbar: Notifications: Turn off notifications network usage: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'NoCloudApplicationNotification' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: System: Display Shutdown Event Tracker: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows NT\Reliability' -Name 'ShutdownReasonOn' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: System: App-V: CEIP: Microsoft Customer Experience Improvement Program (CEIP): Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\AppV\CEIP' -Name 'CEIPEnable' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: System: Device Installation: Do not send a Windows error report when a generic driver is installed on a device: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Settings' -Name 'DisableSendGenericDriverNotFoundToWER' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'System\DriverDatabase\Policies\Settings' -Name 'DisableSendGenericDriverNotFoundToWER' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: System: Device Installation: Prevent Windows from sending an error report when a device driver requests additional woftware during installation: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Settings' -Name 'DisableSendRequestAdditionalSoftwareToWER' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'System\DriverDatabase\Policies\Settings' -Name 'DisableSendRequestAdditionalSoftwareToWER' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: System: Group Policy: Phone-PC linking on this device: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\System' -Name 'EnableMmx' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off access to the Store: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'NoUseStoreOpenWith' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Help and Support Center 'Did you know?' content: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\PCHealth\HelpSvc' -Name 'Headlines' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Help and Support Center Microsoft Knowledge Base search: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\PCHealth\HelpSvc' -Name 'MicrosoftKBSearch' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Internet download for Web publishing and online ordering wizards: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoWebServices' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Internet File Association service: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoInternetOpenWith' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Search Companion content file updates: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\SearchCompanion' -Name 'DisableContentFileUpdates' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off the 'Order Prints' picture task: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoOnlinePrintsWizard' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off the 'Publish to Web' task for files and folders: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoPublishingWizard' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Windows Customer Experience Improvement Program: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\SQMClient\Windows' -Name 'CEIPEnable' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off Windows Error Reporting: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting' -Name 'DoReport' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off the Windows Messenger Customer Experience Improvement Program: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Messenger\Client' -Name 'CEIP' -Type DWORD -Value 2

# Group Policy: Computer Configuration: Administrative Templates: System: OS Policies: Allow Clipboard History: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\System' -Name 'AllowClipboardHistory' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: System: OS Policies: Allow Clipboard synchronization across devices: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\System' -Name 'AllowCrossDeviceClipboard' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: System: OS Policies: Allow publishing of User Activites: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\System' -Name 'PublishUserActivities' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: System: OS Policies: Enabled Activity Feed: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\System' -Name 'EnableActivityFeed' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: System: OS Policies: Allow Upload of User Activities: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\System' -Name 'UploadUserActivities' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: System: Remote Assistance: Configure Solicited Remote Assistance: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name 'fAllowToGetHelp' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: System: User Profiles: Turn off the advertising ID: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo' -Name 'DisabledByGroupPolicy' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Remove Program Compatibility Property Page: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\AppCompat' -Name 'DisablePropPage' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Turn off Application Compatibility Engine: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\AppCompat' -Name 'DisableEngine' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Turn off Application Telemetry: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\AppCompat' -Name 'AITEnable' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Turn off Inventory Collector: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\AppCompat' -Name 'DisableInventory' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Turn off Program Compatibility Assistant: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\AppCompat' -Name 'DisablePCA' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Turn off Steps Recorder: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\AppCompat' -Name 'DisableUAR' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Application Compatibility: Turn off SwitchBack Compatibility Engine: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\AppCompat' -Name 'SbEnable' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Biometrics: Allow the use of biometrics: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Biometrics' -Name 'Enabled' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Cloud Content: Do not show Windows tips: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableSoftLanding' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off cloud consumer account state content: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableConsumerAccountStateContent' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off cloud optimized content: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableCloudOptimizedContent' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off Microsoft consumer experiences: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsConsumerFeatures' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Credential User Interface: Do not display the password reveal button: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\CredUI' -Name 'DisablePasswordReveal' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Data Collection and Preview Builds: Allow device name to be sent in Windows diagnostic data: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name 'AllowDeviceNameInTelemetry' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Data Collection and Preview Builds: Allow Diagnostic Data: Enabled: Diagnostic data off (not recommended)
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name 'AllowTelemetry' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Data Collection and Preview Builds: Allow Telemetry: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'AllowTelemetry' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Data Collection and Preview Builds: Allow Telemetry: 0 - Security [Enterprise Only]
Set-Policy -Scope Computer -Path 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'MaxTelemetryAllowed' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Data Collection and Preview Builds: Disable OneSettings Downloads: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name 'DisableOneSettingsDownloads' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Data Collection and Preview Builds: Do not show feedback notifications: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name 'DoNotShowFeedbackNotifications' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Data Collection and Preview Builds: Limit Diagnostic Log Collection: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name 'LimitDiagnosticLogCollection' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Delivery Optimization: Download Mode: Enabled: HTTP only (0)
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization' -Name 'DODownloadMode' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Edge UI: Disable help tips: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\EdgeUI' -Name 'DisableHelpSticker' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: File Explorer: Do not show the 'new application installed' notification: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'NoNewAppAlert' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Location and Sensors: Turn off location: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors' -Name 'DisableLocation' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Location and Sensors: Turn off location scripting: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors' -Name 'DisableLocationScripting' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Location and Sensors: Turn off sensors: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors' -Name 'DisableSensors' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Location and Sensors: Windows Location Provider: Turn off Windows Location Provider: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors' -Name 'DisableWindowsLocationProvider' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Maps: Turn off Automatic Download and Update of Map Data: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Maps' -Name 'AutoDownloadAndUpdateMapData' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Maps: Turn off unsolicited network  traffic on the Offline Maps settings page: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Maps' -Name 'AllowUntriggeredNetworkTrafficOnSettingsPage' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Messaging: Allow Message Service Cloud Sync: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Messaging' -Name 'AllowMessageSync' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Microsoft Defender Antivirus: MAPS: Join Microsoft MAPS: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows Defender\Spynet' -Name 'SpyNetReporting' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Microsoft Defender Antivirus: MAPS: Send file samples when further analysis is required: Never send
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows Defender\Spynet' -Name 'SubmitSamplesConsent' -Type DWORD -Value 2

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: OneDrive: Prevent the usage of OneDrive for file storage: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\OneDrive' -Name 'DisableFileSyncNGSC' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Online Assistance: Turn off Active Help: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Assistance\Client\1.0' -Name 'NoActiveHelp' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Software Protection Platform: Turn off KMS Client Online AVS Validation: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform' -Name 'NoGenTicket' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Speech: Allow Automatic Update of Speech Data: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Speech' -Name 'AllowSpeechModelUpdate' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Text Input: Improve inking and typing recognition: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\TextInput' -Name 'AllowLinguisticDataCollection' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Calendar: Turn off Windows Calendar: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Windows' -Name 'TurnOffWinCal' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Defender SmartScreen: Microsoft Edge: Configure Windows Defender SmartScreen: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'SmartScreenEnabled' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Error Reporting: Automatically send memory dumps for OS-generated error reports: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'AutoApproveOSDumps' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Error Reporting: Disable Windows Error Reporting: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'Disabled' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Error Reporting: Do not send additional data: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'DontSendAdditionalData' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Error Reporting: Send additional data when on battery power: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'BypassPowerThrottling' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Error Reporting: Send data when on connected to a restricted/costed network: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting' -Name 'BypassNetworkCostThrottling' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Media Digitial Rights Management: Prevent Windows Media DRM Internet Access: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\WMDRM' -Name 'DisableOnline' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Messenger: Do not automatically start Windows Messenger initially: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Messenger\Client' -Name 'PreventAutoRun' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Messenger: Do not allow Windows Messenger to be run: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Messenger\Client' -Name 'PreventRun' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Mobility Center: Turn off Windows Mobility Center: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\MobilityCenter' -Name 'NoMobilityCenter' -Type DWORD -Value 1

# Sort by Path - User
# Group Policy: User Configuration: Administrative Templates: Start Menu and Taskbar: Remove the Meet Now icon: Enabled
Set-Policy -Scope User -Path 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'HideSCAMeetNow' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'HideSCAMeetNow' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Windows Components: Attachment Manager: Do not preserve zone information in file attachments: Enabled
Set-Policy -Scope User -Path 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments' -Name 'SaveZoneInformation' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Configure Windows spotlight on lock screen: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'ConfigureWindowsSpotlight' -Type DWORD -Value 2

# Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off Spotlight collection on Desktop: Enabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableSpotlightCollectionOnDesktop' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Do not use diagnostic data for tailored experiences: Enabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableTailoredExperiencesWithDiagnosticData' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Do not suggest third-party content in Windows spotlight: Enabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableThirdPartySuggestions' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off Windows Spotlight on Action Center: Enabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsSpotlightOnActionCenter' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off all Windows spotlight features: Enabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsSpotlightFeatures' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off Windows Spotlight on Settings: Enabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsSpotlightOnSettings' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Windows Components: Cloud Content: Turn off the Windows Welcome Experience: Enabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsSpotlightWindowsWelcomeExperience' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Windows Components: File Explorer: Turn off display of recent search entries in the File Explorer search box: Enabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'DisableSearchBoxSuggestions' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Windows Components: Remote Desktop Services: Remote Desktop Connection Client: Allow .rdp files from unkown publishers: Enabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Name 'AllowUnsignedFiles' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Windows Components: Windows Copilot: Turn off Windows Copilot: Enabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot' -Name 'TurnOffWindowsCopilot' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Windows Components: Windows Defender SmartScreen: Microsoft Edge: Configure Windows Defender SmartScreen: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'SmartScreenEnabled' -Type DWORD -Value 0

# To Sort
# Firefox
# https://mozilla.github.io/policy-templates/
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableDefaultBrowserAgent' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Mozilla\Firefox' -Name 'BackgroundAppUpdate' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Mozilla\Firefox' -Name 'NoDefaultBookmarks' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableTelemetry' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableFeedbackCommands' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableFirefoxStudies' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisablePocket' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableProfileRefresh' -Type DWORD -Value 1

# Chrome
# Computer Configuration: Administrative Templates: Google: Google Chrome: Enable showing full-tab promotional content: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Google\Chrome' -Name 'PromotionalTabsEnabled' -Type DWORD -Value 0

# Computer Configuration: Administrative Templates: Google: Google Chrome: Privacy Sanndbox policies: Choose whether the Privacy Sandbox ad measurement setting can be disabled: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Google\Chrome' -Name 'PrivacySandboxAdMeasurementEnabled' -Type DWORD -Value 0

# Computer Configuration: Administrative Templates: Google: Google Chrome: Privacy Sanndbox policies: Choose whether the Privacy Sandbox Ad topics setting can be disabled: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Google\Chrome' -Name 'PrivacySandboxAdTopicsEnabled' -Type DWORD -Value 0

# Computer Configuration: Administrative Templates: Google: Google Chrome: Privacy Sanndbox policies: Choose whether the Privacy Sandbox prompt can be shown to your users: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Google\Chrome' -Name 'PrivacySandboxPromptEnabled' -Type DWORD -Value 0

# Computer Configuration: Administrative Templates: Google: Google Chrome: Privacy Sanndbox policies: Choose whether the Privacy SandboxSite-suggested ads setting can be disabled: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Google\Chrome' -Name 'PrivacySandboxSiteEnabledAdsEnabled' -Type DWORD -Value 0

# Adobe
# Computer Configuration: Administrative Templates: Adobe Acrobat DC: Preferences: General: Disable automatic updates: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown' -Name 'bUpdater' -Type DWORD -Value 0
        
# Computer Configuration: Administrative Templates: Adobe Acrobat DC: Preferences: General: Show messages when I launch Acrobat: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cIPM' -Name 'bShowMsgAtLaunch' -Type DWORD -Value 0
        
# Computer Configuration: Administrative Templates: Adobe Acrobat DC: Preferences: General: Turn off user participation in the feedback program: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown' -Name 'bUsageMeasurement' -Type DWORD -Value 0

# Computer Configuration: Administrative Templates: Adobe Acrobat DC: Preferences: Startup: Protected View: For all files
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown' -Name 'iProtectedView' -Type DWORD -Value 2

# Adobe Acrobat: Turn off the generative AI features
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown' -Name 'bEnableGentech' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off handwriting recognition error reporting: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports' -Name 'PreventHandwritingErrorReports' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: System: Internet Communication Management: Internet Communication settings: Turn off handwriting personalization data sharing: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\TabletPC' -Name 'PreventHandwritingDataSharing' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Data Collection and Preview Builds: Configure collection of browsing data for Desktop Analytics: Do not allow sending intranet or internet history
Set-Policy -Scope Computer -Path 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'MicrosoftEdgeDataOptIn' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: File Explorer: Turn off Windows Libraries features that rely on indexed file data: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'DisableIndexedLibraryExperience' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Do not allow web search: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'DisableWebSearch' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Don't search the web or display web results in Search: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchUseWeb' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Don't search the web or display web results in Search over metered connections: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchUseWebOverMeteredConnections' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow Cloud Search: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCloudSearch' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow Cortana above lock screen: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortanaAboveLock' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow search and Cortana to use location: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowSearchToUseLocation' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow search highlights: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'EnableDynamicContentInWSB' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow Cortana: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortana' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow Cortana Page in OOBE on an AAD account: Disable Cortana Page in AAD
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortanaInAADPathOOBE' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Set the SafeSearch setting for Search: Off
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchSafeSearch' -Type DWORD -Value 3

# BingSearch -Disable
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Windows\WindowsAI' -Name 'DisableAIDataAnalysis' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Game Recording and Broadcasing: Disable
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\GameDVR' -Name 'AllowGameDVR' -Type DWORD -Value 0

# Settings: Settings: Personalization: Lock screen: Show lock screen background pictures on the sign-in screen: Off
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\System' -Name 'DisableLogonBackgroundImage' -Type DWORD -Value 0

# AdminApprovalMode -Never
Set-Policy -Scope Computer -Path 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'ConsentPromptBehaviorAdmin' -Type DWORD -Value 0
# MappedDrivesAppElevatedAccess -Enable
Set-Policy -Scope Computer -Path 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableLinkedConnections' -Type DWORD -Value 1
# PreventEdgeShortcutCreation -Channels Stable, Beta, Dev, Canary
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\EdgeUpdate' -Name 'CreateDesktopShortcut{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\EdgeUpdate' -Name 'CreateDesktopShortcut{2CD8A007-E189-409D-A2C8-9AF4EF3C72AA}' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\EdgeUpdate' -Name 'CreateDesktopShortcut{0D50BFEC-CD6A-4F9A-964C-C7416E3ACB10}' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\EdgeUpdate' -Name 'CreateDesktopShortcut{65C35B14-6C1D-4122-AC46-7148CC9D6497}' -Type DWORD -Value 0
# Unknown
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'AddressBarMicrosoftSearchInBingProviderEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'AlternateErrorPagesEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'AutofillAddressEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'AutofillCreditCardEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'ConfigureDoNotTrack' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'EdgeShoppingAssistantEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'HubsSidebarEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'LocalProvidersEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'MetricsReportingEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'NetworkPredictionOptions' -Type DWORD -Value 2
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'PasswordManagerEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'PaymentMethodQueryEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'PersonalizationReportingEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'ResolveNavigationErrorsUseWebService' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'SearchSuggestEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'SendSiteInfoToImproveServices' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'SiteSafetyServicesEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'TyposquattingCheckerEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'UserFeedbackAllowed' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'WebWidgetAllowed' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\MRT' -Name 'DontReportInfectionInformation' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main' -Name 'AllowPrelaunch' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader' -Name 'AllowTabPreloading' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\Windows Feeds' -Name 'EnableFeeds' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\WindowsAI' -Name 'DisableAIDataAnalysis' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot' -Name 'TurnOffWindowsCopilot' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\MRT' -Name 'DontReportInfectionInformation' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main' -Name 'AllowPrelaunch' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader' -Name 'AllowTabPreloading' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'AddressBarMicrosoftSearchInBingProviderEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'AlternateErrorPagesEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'AutofillAddressEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'AutofillCreditCardEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'ConfigureDoNotTrack' -Type DWORD -Value 1
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'EdgeShoppingAssistantEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'HubsSidebarEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'LocalProvidersEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'MetricsReportingEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'NetworkPredictionOptions' -Type DWORD -Value 2
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'PasswordManagerEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'PaymentMethodQueryEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'PersonalizationReportingEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'ResolveNavigationErrorsUseWebService' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'SearchSuggestEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'SendSiteInfoToImproveServices' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'SiteSafetyServicesEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'TyposquattingCheckerEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'UserFeedbackAllowed' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'WebWidgetAllowed' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Network: WLAN Service: WLAN Settings: Allow Windows to automatically connect to suggested open hotspots, to networks shared by contacts, and to hotspots offering paid services: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config' -Name 'AutoConnectAllowedOEM' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: System: Power Management: Power Throttling Settings: Turn off Power Throttling: Enabled
Set-Policy -Scope Computer -Path 'System\CurrentControlSet\Control\Power\PowerThrottling' -Name 'PowerThrottlingOff' -Type DWORD -Value 1
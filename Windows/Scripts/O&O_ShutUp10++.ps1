# O&O ShutUp10++: Current User: Microsoft Edge (legacy version): Disable page prediction: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FlipAhead')) {
	New-Item -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FlipAhead' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FlipAhead' -Name 'FPEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Microsoft Edge (legacy version): Disable tracking in the web: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main')) {
	New-Item -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main' -Name 'DoNotTrack' -Value 1 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Microsoft Edge (legacy version): Disable search and website suggestions: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main' -Name 'ShowSearchSuggestionsGlobal' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Microsoft Edge (legacy version): Disable form suggestions: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main' -Name 'Use FormSuggest' -Value 'no' -PropertyType String -Force

# O&O ShutUp10++: Current User: Microsoft Edge (legacy version): Do not optimize web search results on the task bar for screen reader: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main' -Name 'OptimizeWindowsSearchResultsForScreenReaders' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Microsoft Edge (legacy version): Disable SmartScreen Filter: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter')) {
	New-Item -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter' -Name 'EnabledV9' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Microsoft Edge (legacy version): Disable sites saving protected media licenses on my device: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Privacy')) {
	New-Item -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Privacy' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Privacy' -Name 'EnableEncryptedMediaExtensions' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Microsoft Edge (legacy version): Disable Cortana in Microsoft Edge: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI')) {
	New-Item -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI' -Name 'EnableCortana' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Microsoft Edge (legacy version): Disable showing search history: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI\ShowSearchHistory')) {
	New-Item -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI\ShowSearchHistory' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Classes\Local Settings\SOFTWARE\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI\ShowSearchHistory' -Name '(default)' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Activity History and Clipboard: Disable storage of clipboard history: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Clipboard' -Name 'EnableClipboardHistory' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Privacy: Disable transmission of typing information: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\input\TIPC' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Cortana (Personal Assistant): Disable input Personalization: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\InputPersonalization' -Name 'RestrictImplicitTextCollection' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\InputPersonalization' -Name 'RestrictImplicitInkCollection' -Value 1 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore' -Name 'HarvestContacts' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Personalization\Settings' -Name 'AcceptedPrivacyPolicy' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Miscellaneous: Disable feedback reminders: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules' -Name 'NumberOfSIUFInPeriod' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Miscellaneous: Disable Windows Media Player Diagnostics: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\MediaPlayer\Preferences' -Name 'UsageTracking' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Miscellaneous: Disable feedback reminders: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules' -Name 'PeriodInNanoSeconds' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to use voice activation: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps' -Name 'AgentActivationEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to use voice activation when device is locked: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps' -Name 'AgentActivationOnLockScreenEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: App Privacy: Disable the standard app for the headset button: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps' -Name 'AgentActivationLastUsed' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Privacy: Disable text suggestions when typing on the software keyboard: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\TabletTip\1.7' -Name 'EnableTextPrediction' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Privacy: Disable and reset Advertising ID and info: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Privacy: Disable sending URLs from apps to Windows Store: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost' -Name 'EnableWebContentEvaluation' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: App Privacy: Prohibit apps from running in the background: Off
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications' -Name 'GlobalUserDisabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to movements: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to diagnostics information: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to calendar: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to unpaired devices: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync' -Name 'Value' -Value 'Deny' -PropertyType String -Force
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to messages: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to the file system: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to contacts: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to documents: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to downloads folder: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to email: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to eye tracking: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable the ability for apps to take screenshots: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable the ability for desktop apps to take screenshots: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic\NonPackaged')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic\NonPackaged' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic\NonPackaged' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable the ability for apps to take screenshots without borders: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable the ability for desktop apps to take screenshots without margins: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder\NonPackaged')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder\NonPackaged' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder\NonPackaged' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to device location: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to device microphone: Off
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone' -Name 'Value' -Value 'Allow' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to music libraries: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to phone calls: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to call history: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to images: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to radios: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to user account information: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to tasks: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to notifications: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to videos: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Current User: App Privacy: Disable app access to camera: Off
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam' -Name 'Value' -Value 'Allow' -PropertyType String -Force

# O&O ShutUp10++: Current User: Privacy: Disable tips, tricks, and suggestions when using Windows: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338389Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Lock Screen: Disable Windows Spotlight: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'RotatingLockScreenEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Lock Screen: Disable fun facts, tips, tricks, and more on your lock screen: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'RotatingLockScreenOverlayEnabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338387Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Miscellaneous: Disable automatic installation of recommended Windows Store Apps: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SilentInstalledAppsEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Miscellaneous: Disable tips, tricks, and suggestions while using Windows: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SoftLandingEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Windows Explorer: Disable occassionally showing app suggestions in Start menu: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SystemPaneSuggestionsEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Privacy: Disable suggestions in the timeline: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-353698Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Privacy: Disable suggestions in Start: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338388Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Privacy: Disable showing suggested content in the Settings app: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-338393Enabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-353694Enabled' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name 'SubscribedContent-353696Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Windows Update: Disable Windows Update via peer-to-peer: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization' -Name 'SystemSettingsDownloadMode' -Value 0 -PropertyType DWord -Force
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config' -Name 'DODownloadMode' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Taskbar: Disable widgets in Windows Explorer: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'TaskbarDa' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Windows Copilot: Disable the Copilot button from the taskbar: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowCopilotButton' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Windows Explorer: Disable ads in Windows Explorer/OneDrive: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'ShowSyncProviderNotifications' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Taskbar: Disable People icon in the taskbar: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People' -Name 'PeopleBand' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Taskbar: Disable news and interests in the taskbar: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds' -Name 'ShellFeedsTaskbarViewMode' -Value 2 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Mobile Devices: Disable Phone Link app: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Mobility' -Name 'PhoneLinkEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Mobile Devices: Disable showing suggestions for using mobile devices with Windows: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Mobility' -Name 'OptedIn' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Mobile Devices: Disable access to mobile devices: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Mobility' -Name 'CrossDeviceEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Lock Screen: Disable notifications on lock screen: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings' -Name 'NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: User Behavior: Disable the user of diagnostic data for a tailor-made user experience: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy' -Name 'TailoredExperiencesWithDiagnosticDataEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Privacy: Disable app notifications: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PushNotifications' -Name 'ToastEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Search: Disable search with AI in search box: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings' -Name 'IsDynamicSearchBoxEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Synchronization of Windows Settings: Disable synchronization of all settings: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync' -Name 'SyncPolicy' -Value 5 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Synchronization of Windows Settings: Disable synchronization of accessibility settings: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Synchronization of Windows Settings: Disable synchronization of browser settings: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Synchronization of Windows Settings: Disable synchronization of credentials (passwords): On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Synchronization of Windows Settings: Disable synchronization of language settings: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Synchronization of Windows Settings: Disable synchronization of design settings: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Synchronization of Windows Settings: Disable synchronization of advanced Windows settings: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows' -Name 'Enabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Privacy: Disable the possibility of suggesting to finish the setup of the device: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement' -Name 'ScoobeSystemSettingEnabled' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Cortana (Personal Assistant): Disable and reset Cortana: On
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search')) {
	New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Windows Search' -Name 'CortanaConsent' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Windows Explorer: Disable OneDrive access to network before login: On
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\OneDrive')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\OneDrive' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\OneDrive' -Name 'PreventNetworkTrafficPreUserSignIn' -Value 1 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Privacy: Disable advertisements via Bluetooth: On
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Bluetooth')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Bluetooth' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Bluetooth' -Name 'AllowAdvertising' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Microsoft Edge (legacy version): Disable automatic completion of web addresses in address bar: On
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Browser')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Browser' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Browser' -Name 'AllowAddressBarDropdown' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Windows Update: Disable Windows dynamic configuration and update rollouts: On
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\System')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\System' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\System' -Name 'AllowExperimentation' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Cortana (Personal Assistant): Disable download and updates of speech recognition and speech synthesis models: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Speech_OneCore\Preferences' -Name 'ModelDownloadAllowed' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to motion: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\activity' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to diagnostics information: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to calendar: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to unpaired devices: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync' -Name 'Value' -Value 'Deny' -PropertyType String -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to messages: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to the file system: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to contacts: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to documents: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to downloads folder: On
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\downloadsFolder' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to email: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to eye tracking: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\gazeInput' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable the ability for apps to take screenshots: On
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureProgrammatic' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable the ability for apps to take screenshots without borders: On
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\graphicsCaptureWithoutBorder' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to device microphone: Off
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone' -Name 'Value' -Value 'Allow' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to music libraries: On
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\musicLibrary' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to phone calls: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to call history: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to images: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to radios: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to user account information: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to tasks: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to notifications: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to videos: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary' -Name 'Value' -Value 'Deny' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: App Privacy: Disable app access to camera: Off
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam' -Name 'Value' -Value 'Allow' -PropertyType String -Force

# O&O ShutUp10++: Local Machine: Windows Update: Disable automatic downloading manufacturers' apps and icons for devices: Off
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata' -Name 'PreventDeviceMetadataFromNetwork' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Windows Update: Disable automatic app updates through Windows Update: Off
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate' -Name 'AutoDownload' -Value 4 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Privacy: Disable Windows Error Reporting: On
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting' -Name 'Disabled' -Value 1 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Privacy: Disable Windows Error Reporting: On
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\Windows Error Reporting' -Name 'Disabled' -Value 1 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Location Services: Disable Windows Geolocation Service: On
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\lfsvc\Service\Configuration' -Name 'Status' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}' -Name 'SensorPermissionState' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Privacy: Disable the Windows Customer Experience Improvement Program
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\SQMClient\Windows' -Name 'CEIPEnable' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: User Behavior: Disable application telemetry
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CPSS\Store\AllowTelemetry')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CPSS\Store\AllowTelemetry' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CPSS\Store\AllowTelemetry' -Name 'Value' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack' -Name 'DiagTrackAuthorization' -Value 1101 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\TraceManager' -Name 'MiniTraceSlotEnabled' -Value 0 -PropertyType DWord -Force
# DiagnosticDataLevel -Minimal
New-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack' -Name 'ShowedToastAtLevel' -PropertyType DWord -Value 1 -Force

# O&O ShutUp10++: Local Machine: Security: Disable telemetry: On
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\DiagTrack' -Name 'Start' -Value 4 -PropertyType DWord -Force
if (-not (Test-Path -Path 'HKLM:\System\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener')) {
	New-Item -Path 'HKLM:\System\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener' -Force
}
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener' -Name 'Start' -Value 0 -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\dmwappushservice' -Name 'Start' -Value 4 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Miscellaneous: Disable installation of PC Health Check: On
if (-not (Test-Path -Path 'HKLM:\SOFTWARE\Microsoft\PCHC')) {
	New-Item -Path 'HKLM:\SOFTWARE\Microsoft\PCHC' -Force
}
New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\PCHC' -Name 'PreviousUninstall' -Value 1 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Miscellaneous: Disable Network Connectivity Status indicator: On
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\NlaSvc\Parameters\Internet' -Name 'EnableActiveProbing' -Value 0 -PropertyType DWord -Force

# O&O ShutUp10++: Local Machine: Windows Update: Disable automatic Windows Updates: Off
New-ItemProperty -Path 'HKLM:\System\ControlSet001\Services\wuauserv' -Name 'Start' -Value 3 -PropertyType DWord -Force

# O&O ShutUp10++: Current User: Search: Disable extenstion of Windows search with Bing: On
# New-ItemProperty -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'DisableSearchBoxSuggestions' -Value 1 -PropertyType DWord -Force
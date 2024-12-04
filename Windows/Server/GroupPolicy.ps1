Get-ChildItem -Path "$env:TEMP\Computer.txt", "$env:TEMP\User.txt" -Force -ErrorAction Ignore | Remove-Item -Force -ErrorAction Ignore

$LGPO_DDL = 'https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/LGPO.zip'
$LGPO_Filename = [IO.Path]::GetFileName(([URI]$LGPO_DDL).AbsolutePath)
$LGPO_SavePath = [IO.Path]::Combine($env:TEMP, $LGPO_Filename)
(New-Object System.Net.WebClient).DownloadFile($LGPO_DDL, $LGPO_SavePath)

Expand-Archive -Path $LGPO_SavePath -DestinationPath $env:TEMP -Force

Move-Item -Path "$env:TEMP\LGPO_30\LGPO.exe" -Destination $env:TEMP -Force

Remove-Item -Path "$env:TEMP\LGPO_30", "$env:TEMP\LGPO.zip" -Recurse -Force

function Set-Policy {
	[CmdletBinding()]
	param
	(
		[Parameter(
			Mandatory = $true,
			Position = 1
		)]
		[string]
		[ValidateSet('Computer', 'User')]
		$Scope,

		[Parameter(
			Mandatory = $true,
			Position = 2
		)]
		[string]
		$Path,

		[Parameter(
			Mandatory = $true,
			Position = 3
		)]
		[string]
		$Name,

		[Parameter(
			Mandatory = $true,
			Position = 4
		)]
		[ValidateSet('DWORD', 'SZ', 'EXSZ', 'CLEAR')]
		[string]
		$Type,

		[Parameter(
			Mandatory = $false,
			Position = 5
		)]
		$Value
	)

	switch ($Type) {
		'CLEAR' {
			$Policy = @"
$Scope
$($Path)
$($Name)
$($Type)`n
"@
		}
		default {
			$Policy = @"
$Scope
$($Path)
$($Name)
$($Type):$($Value)`n
"@
		}
	}

	if ($Scope -eq 'Computer') {
		$Path = "$env:TEMP\Computer.txt"
	}
	else {
		$Path = "$env:TEMP\User.txt"
	}

	Add-Content -Path $Path -Value $Policy -Encoding Default -Force
}

# Group Policy: Computer Configuration: Administrative Templates: System: Display Shutdown Event Tracker: Disabled
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows NT\Reliability' -Name 'ShutdownReasonOn' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Do not allow web search: Enabled
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\Windows Search' -Name 'DisableWebSearch' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Don't search the web or display web results in Search: Enabled
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchUseWeb' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Don't search the web or display web results in Search over metered connections: Enabled
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchUseWebOverMeteredConnections' -Type DWORD -Value 0

# # Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow Cloud Search: Disabled
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCloudSearch' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow Cortana above lock screen: Disabled
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortanaAboveLock' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow search and Cortana to use location: Disabled
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\Windows Search' -Name 'AllowSearchToUseLocation' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Search: Allow search highlights: Disabled
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\Windows Search' -Name 'EnableDynamicContentInWSB' -Type DWORD -Value 0

# 
Set-Policy -Scope Computer -Path 'Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection' -Name 'AllowTelemetry' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'HideSCAMeetNow' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Biometrics' -Name 'Enabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'AddressBarMicrosoftSearchInBingProviderEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'AlternateErrorPagesEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'AutofillAddressEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'AutofillCreditCardEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'ConfigureDoNotTrack' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'EdgeShoppingAssistantEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'HubsSidebarEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'LocalProvidersEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'MetricsReportingEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'NetworkPredictionOptions' -Type DWORD -Value 2
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'PasswordManagerEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'PaymentMethodQueryEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'PersonalizationReportingEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'ResolveNavigationErrorsUseWebService' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'SearchSuggestEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'SendSiteInfoToImproveServices' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'SiteSafetyServicesEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'SmartScreenEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'TyposquattingCheckerEnabled' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'UserFeedbackAllowed' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Edge' -Name 'WebWidgetAllowed' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\InputPersonalization' -Name 'AllowInputPersonalization' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\MRT' -Name 'DontReportInfectionInformation' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\MicrosoftEdge\Main' -Name 'AllowPrelaunch' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\MicrosoftEdge\TabPreloader' -Name 'AllowTabPreloading' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Speech' -Name 'AllowSpeechModelUpdate' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\WMDRM' -Name 'DisableOnline' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows Defender\Spynet' -Name 'SpyNetReporting' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows Defender\Spynet' -Name 'SubmitSamplesConsent' -Type DWORD -Value 2
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform' -Name 'NoGenTicket' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows NT\Terminal Services' -Name 'fAllowToGetHelp' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\AppCompat' -Name 'AITEnable' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\AppCompat' -Name 'DisableInventory' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\AppCompat' -Name 'DisableUAR' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\CredUI' -Name 'DisablePasswordReveal' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\DataCollection' -Name 'AllowTelemetry' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\DataCollection' -Name 'DisableOneSettingsDownloads' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\DataCollection' -Name 'DoNotShowFeedbackNotifications' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\DataCollection' -Name 'LimitDiagnosticLogCollection' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\DeliveryOptimization' -Name 'DODownloadMode' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\HandwritingErrorReports' -Name 'PreventHandwritingErrorReports' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\LocationAndSensors' -Name 'DisableLocation' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\LocationAndSensors' -Name 'DisableLocationScripting' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\LocationAndSensors' -Name 'DisableSensors' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\LocationAndSensors' -Name 'DisableWindowsLocationProvider' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\Maps' -Name 'AllowUntriggeredNetworkTrafficOnSettingsPage' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\Maps' -Name 'AutoDownloadAndUpdateMapData' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\Messaging' -Name 'AllowMessageSync' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\OneDrive' -Name 'DisableFileSyncNGSC' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\Personalization' -Name 'NoLockScreenCamera' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\System' -Name 'AllowClipboardHistory' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\System' -Name 'AllowCrossDeviceClipboard' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\System' -Name 'EnableActivityFeed' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\System' -Name 'EnableMmx' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\System' -Name 'PublishUserActivities' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\System' -Name 'UploadUserActivities' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\TabletPC' -Name 'PreventHandwritingDataSharing' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\Windows Feeds' -Name 'EnableFeeds' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\WindowsAI' -Name 'DisableAIDataAnalysis' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\WindowsCopilot' -Name 'TurnOffWindowsCopilot' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\WindowsUpdate' -Name 'DeferUpdatePeriod' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\WindowsUpdate' -Name 'DeferUpgrade' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\WindowsUpdate' -Name 'DeferUpgradePeriod' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Update: Manage updates offered from Windows: Do not include drivers with Windows Updates: Not configured
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\WindowsUpdate' -Name 'ExcludeWUDriversInQualityUpdate' -Type CLEAR

# Group Policy: Computer Configuration: Administrative Templates: Windows Components: Windows Update: Manage end user experience: Configure Automatic Updates: Not configured
Set-Policy -Scope Computer -Path 'Software\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'NoAutoUpdate' -Type CLEAR

Set-Policy -Scope Computer -Path 'Software\Software\Policies\Microsoft\MRT' -Name 'DontReportInfectionInformation' -Type DWORD -Value 1
Set-Policy -Scope Computer -Path 'Software\Software\Policies\Microsoft\MicrosoftEdge\Main' -Name 'AllowPrelaunch' -Type DWORD -Value 0
Set-Policy -Scope Computer -Path 'Software\Software\Policies\Microsoft\MicrosoftEdge\TabPreloader' -Name 'AllowTabPreloading' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'HideSCAMeetNow' -Type DWORD -Value 1
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
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'SmartScreenEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'TyposquattingCheckerEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'UserFeedbackAllowed' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'WebWidgetAllowed' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'DisableSearchBoxSuggestions' -Type DWORD -Value 1
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Windows\WindowsAI' -Name 'DisableAIDataAnalysis' -Type DWORD -Value 1
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot' -Name 'TurnOffWindowsCopilot' -Type DWORD -Value 1

if ((Test-Path -Path "$env:TEMP\Computer.txt") -or (Test-Path -Path "$env:TEMP\User.txt")) {
	if (Test-Path -Path "$env:TEMP\Computer.txt") {
		& "$env:TEMP\LGPO.exe" /t "$env:TEMP\Computer.txt"
	}
	if (Test-Path -Path "$env:TEMP\User.txt") {
		& "$env:TEMP\LGPO.exe" /t "$env:TEMP\User.txt"
	}

	gpupdate /force
}

Get-ChildItem -Path "$env:TEMP\Computer.txt", "$env:TEMP\User.txt" -Force -ErrorAction Ignore | Remove-Item -Force -ErrorAction Ignore
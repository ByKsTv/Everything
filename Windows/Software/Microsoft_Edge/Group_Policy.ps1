# Group Policy: Computer Configuration: Administrative Templates: Microsoft: Edge: Allow personalization of ads, Microsoft Edge, search, news and other Microsoft services by sending browsing history, favorites and collections, usage and other browsing data to Microsoft: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'PersonalizationReportingEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'PersonalizationReportingEnabled' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft: Edge: Allow suggestions from local providers: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'LocalProvidersEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'LocalProvidersEnabled' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft: Edge: Allow user feedback: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'UserFeedbackAllowed' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'UserFeedbackAllowed' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft: Edge: Allow users to configure Site safety services (obsolete): Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'SiteSafetyServicesEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'SiteSafetyServicesEnabled' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft: Edge: Allow websites to query for available payment methods: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'PaymentMethodQueryEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'PaymentMethodQueryEnabled' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft: Edge: Configure Do Not Track: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'ConfigureDoNotTrack' -Type DWORD -Value 1
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'ConfigureDoNotTrack' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Microsoft: Edge: Enable AutoFill for addresses: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'AutofillAddressEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'AutofillAddressEnabled' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft: Edge: Enable AutoFill for payment instruments: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'AutofillCreditCardEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'AutofillCreditCardEnabled' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft: Edge: Enable Microsoft Search in Bing suggestions in the address bar: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'AddressBarMicrosoftSearchInBingProviderEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'AddressBarMicrosoftSearchInBingProviderEnabled' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft: Edge: Enable network prediction: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'NetworkPredictionOptions' -Type DWORD -Value 2
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'NetworkPredictionOptions' -Type DWORD -Value 2

# Group Policy: Computer Configuration: Administrative Templates: Microsoft: Edge: Enable resolution of navigation errors using a web service: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'ResolveNavigationErrorsUseWebService' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'ResolveNavigationErrorsUseWebService' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft: Edge: Enable search suggestions: Disalbed
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'SearchSuggestEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'SearchSuggestEnabled' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft: Edge: Enable the Search bar (deprecated): Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'WebWidgetAllowed' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'WebWidgetAllowed' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft: Edge: Enable usage and crash-related data reporting (obsolete): Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'MetricsReportingEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'MetricsReportingEnabled' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft: Edge: Send site information to improve Microsoft services (obsolete): Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'SendSiteInfoToImproveServices' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'SendSiteInfoToImproveServices' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft: Edge: Shopping in Microsoft Edge Enabled: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'EdgeShoppingAssistantEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'EdgeShoppingAssistantEnabled' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft: Edge: Show Hubs Sidebar: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'HubsSidebarEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'HubsSidebarEnabled' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft: Edge: Suggest similar pages when a webpage can't be found: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'AlternateErrorPagesEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'AlternateErrorPagesEnabled' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft Edge Update: Applications: Microsoft Edge: Create Desktop Shortcut upon install: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\EdgeUpdate' -Name 'CreateDesktopShortcut{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft Edge Update: Applications: Microsoft Edge Beta: Create Desktop shortcut upon install: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\EdgeUpdate' -Name 'CreateDesktopShortcut{2CD8A007-E189-409D-A2C8-9AF4EF3C72AA}' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft Edge Update: Applications: Microsoft Edge Canary: Create Desktop shortcut upon install: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\EdgeUpdate' -Name 'CreateDesktopShortcut{65C35B14-6C1D-4122-AC46-7148CC9D6497}' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft Edge Update: Applications: Microsoft Edge Dev: Create Desktop shortcut upon install: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\EdgeUpdate' -Name 'CreateDesktopShortcut{0D50BFEC-CD6A-4F9A-964C-C7416E3ACB10}' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft Edge: Website Typo Protection settings: Configure Edge Website Typo Protection: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'TyposquattingCheckerEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'TyposquattingCheckerEnabled' -Type DWORD -Value 0

# Group Policy: Computer Configuration: Administrative Templates: Microsoft: Edge: Password manager and protection: Enable saving passwords to the password manager: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'PasswordManagerEnabled' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Edge' -Name 'PasswordManagerEnabled' -Type DWORD -Value 0

# Allow Microsoft Edge to pre-launch at Windows startup, when the system is idle, and each time Microsoft Edge is closed: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main' -Name 'AllowPrelaunch' -Type DWORD -Value 0

# Allow Microsoft Edge to start and load the Start and New Tab page at Windows startup and each time Microsoft Edge is closed: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader' -Name 'AllowTabPreloading' -Type DWORD -Value 0

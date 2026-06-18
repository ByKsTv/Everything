# Group Policy: Computer Configuration: Administrative Templates: Mozilla: Firefox: Background updater: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Mozilla\Firefox' -Name 'BackgroundAppUpdate' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Mozilla: Firefox: Disable Feedback Commands: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableFeedbackCommands' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Mozilla: Firefox: Disable Firefox Studies: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableFirefoxStudies' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Mozilla: Firefox: Disable Pocket: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisablePocket' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Mozilla: Firefox: Disable Profile Refresh: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableProfileRefresh' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Mozilla: Firefox: Disable Telemetry: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableTelemetry' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Mozilla: Firefox: Disable the default browser agent: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Mozilla\Firefox' -Name 'DisableDefaultBrowserAgent' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Mozilla: Firefox: No Default Bookmarks: Enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Mozilla\Firefox' -Name 'NoDefaultBookmarks' -Type DWORD -Value 1

# Group Policy: Computer Configuration: Administrative Templates: Mozilla: Firefox: Generative AI: Enabled: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Mozilla\Firefox\GenerativeAI' -Name 'Enabled' -Type DWORD -Value 0
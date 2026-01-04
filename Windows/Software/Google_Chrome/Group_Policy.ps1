# Computer Configuration: Administrative Templates: Google: Google Chrome: Enable Bookmark Bar: Enabled
Set-Policy -Scope Computer -Path 'Software\Policies\Google\Chrome' -Name 'BookmarkBarEnabled' -Type DWORD -Value 1

# Computer Configuration: Administrative Templates: Google: Google Chrome: Show the apps shortcut in the bookmark bar: Disabled
Set-Policy -Scope Computer -Path 'Software\Policies\Google\Chrome' -Name 'ShowAppsShortcutInBookmarkBar' -Type DWORD -Value 0

# Computer Configuration: Administrative Templates: Google: Google Chrome: Enable showing full-tab promotional content: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Google\Chrome' -Name 'PromotionalTabsEnabled' -Type DWORD -Value 0

# Computer Configuration: Administrative Templates: Google: Google Chrome: Privacy Sanndbox policies: Choose whether the Privacy Sandbox ad measurement setting can be disabled: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Google\Chrome' -Name 'PrivacySandboxAdMeasurementEnabled' -Type DWORD -Value 0

# Computer Configuration: Administrative Templates: Google: Google Chrome: Privacy Sanndbox policies: Choose whether the Privacy Sandbox Ad topics setting can be disabled: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Google\Chrome' -Name 'PrivacySandboxAdTopicsEnabled' -Type DWORD -Value 0

# Computer Configuration: Administrative Templates: Google: Google Chrome: Privacy Sanndbox policies: Choose whether the Privacy Sandbox prompt can be shown to your users: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Google\Chrome' -Name 'PrivacySandboxPromptEnabled' -Type DWORD -Value 0

# Computer Configuration: Administrative Templates: Google: Google Chrome: Privacy Sanndbox policies: Choose whether the Privacy Sandbox Site-suggested ads setting can be disabled: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Google\Chrome' -Name 'PrivacySandboxSiteEnabledAdsEnabled' -Type DWORD -Value 0

# Computer Configuration: Administrative Templates: Google: Google Chrome: Extensions: Control Manifest v2 extension availability: Manifest v2 is enabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Google\Chrome' -Name 'ExtensionManifestV2Availability' -Type DWORD -Value 2

# Computer Configuration: Administrative Templates: Google: Google Chrome: 
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Google\Chrome' -Name 'AIModeSettings' -Type DWORD -Value 1

# Computer Configuration: Administrative Templates: Google: Google Chrome: 
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Google\Chrome' -Name 'GenAiDefaultSettings' -Type DWORD -Value 2
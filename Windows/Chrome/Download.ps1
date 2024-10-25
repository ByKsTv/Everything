[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome: Downloading group policy'); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile('https://dl.google.com/dl/edgedl/chrome/policy/policy_templates.zip', "$env:TEMP\policy_templates_chrome.zip")

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome: Extracting group policy'); [Console]::ResetColor(); [Console]::WriteLine()
Expand-Archive -Path "$env:TEMP\policy_templates_chrome.zip" -DestinationPath "$env:TEMP\policy_templates_chrome" -ErrorAction SilentlyContinue

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome: Importing group policy'); [Console]::ResetColor(); [Console]::WriteLine()
Move-Item -Path "$env:TEMP\policy_templates_chrome\windows\admx\chrome.admx" -Destination "$env:windir\PolicyDefinitions" -ErrorAction SilentlyContinue
Move-Item -Path "$env:TEMP\policy_templates_chrome\windows\admx\google.admx" -Destination "$env:windir\PolicyDefinitions" -ErrorAction SilentlyContinue
Move-Item -Path "$env:TEMP\policy_templates_chrome\windows\admx\en-US\chrome.adml" -Destination "$env:windir\PolicyDefinitions\en-US" -ErrorAction SilentlyContinue
Move-Item -Path "$env:TEMP\policy_templates_chrome\windows\admx\en-US\google.adml" -Destination "$env:windir\PolicyDefinitions\en-US" -ErrorAction SilentlyContinue

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome: Computer Configuration: Administrative Templates: Google: Google Chrome: Enable showing full-tab promotional content: Disabled'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -LiteralPath 'HKLM:\Software\Policies\Google\Chrome') -ne $true) {
    New-Item 'HKLM:\Software\Policies\Google\Chrome' -Force
}
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Google\Chrome' -Name 'PromotionalTabsEnabled' -Value 0 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome: Computer Configuration: Administrative Templates: Google: Google Chrome: Privacy Sanndbox policies: Choose whether the Privacy Sandbox ad measurement setting can be disabled: Disabled'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Google\Chrome' -Name 'PrivacySandboxAdMeasurementEnabled' -Value 0 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome: Computer Configuration: Administrative Templates: Google: Google Chrome: Privacy Sanndbox policies: Choose whether the Privacy Sandbox Ad topics setting can be disabled: Disabled'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Google\Chrome' -Name 'PrivacySandboxAdTopicsEnabled' -Value 0 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome: Computer Configuration: Administrative Templates: Google: Google Chrome: Privacy Sanndbox policies: Choose whether the Privacy Sandbox prompt can be shown to your users: Disabled'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Google\Chrome' -Name 'PrivacySandboxPromptEnabled' -Value 0 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome: Computer Configuration: Administrative Templates: Google: Google Chrome: Privacy Sanndbox policies: Choose whether the Privacy SandboxSite-suggested ads setting can be disabled: Disabled'); [Console]::ResetColor(); [Console]::WriteLine()
New-ItemProperty -LiteralPath 'HKLM:\Software\Policies\Google\Chrome' -Name 'PrivacySandboxSiteEnabledAdsEnabled' -Value 0 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile('https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi', "$env:TEMP\googlechromestandaloneenterprise64.msi")

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $env:TEMP\googlechromestandaloneenterprise64.msi -ArgumentList '/quiet' -Wait

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome: Opening default apps on Windows Settings'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process 'ms-settings:defaultapps'

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome: Waiting for user to set up default browser'); [Console]::ResetColor(); [Console]::WriteLine()
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show('Set up Google Chrome as Default Browser.

Press OK after Finished.' , 'Default Browser Notification' , 0, 64)
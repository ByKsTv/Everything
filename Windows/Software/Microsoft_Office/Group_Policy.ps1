# https://www.microsoft.com/en-us/download/details.aspx?id=49030

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: First Run: Disable First Run Movie: Enabled
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Firstrun' -Name 'disablemovie' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: First Run: Disable Office First Run on application boot: Enabled
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Firstrun' -Name 'BootedRTM' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Language Preferences: Other: Turn off Coming Soon: Enabled
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Common\General' -Name 'disablecomingsoon' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Miscellaneous: Show LinkedIn features in Office applications: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common' -Name 'LinkedIn' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Miscellaneous: Disable the Office Start screen for all Office applications: Enabled
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Common\General' -Name 'disableboottoofficestart' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Miscellaneous: Show OneDrive Sign In: Disabled
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Common\General' -Name 'skydrivesigninoption' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Miscellaneous: Suppress recommended settings dialog: Enabled
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Common\General' -Name 'optindisable' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow the use of connected experiences in Office: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy' -Name 'DisconnectedState' -Type DWORD -Value 2

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Disable Opt-in Wizard on first run: Enabled
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Common\General' -Name 'shownfirstrunoptin' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow Microsoft to follow up on feedback submitted by users: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Feedback' -Name 'IncludeEmail' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Enable Customer Experience Improvement Program: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common' -Name 'QMEnable' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow the use of connected experiences in Office that analyze content: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy' -Name 'UserContentDisabled' -Type DWORD -Value 2

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow the use of connected experiences in Office that download online content: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy' -Name 'DownloadContentDisabled' -Type DWORD -Value 2

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow the use of additional optional connected experiences in Office: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy' -Name 'ControllerConnectedServicesEnabled' -Type DWORD -Value 2

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow users to include screenshots and attachments when they submit feedback to Microsoft: Disabled
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Common\Feedback' -Name 'includescreenshot' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow users to submit feedback to Microsoft: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Feedback' -Name 'Enabled' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow users to receive and respond to in-product surveys from Microsoft: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Feedback' -Name 'SurveyEnabled' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Configure the level of client software diagnostic data sent by Office to Microsoft: Enabled: Neither
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\Common\ClientTelemetry' -Name 'SendTelemetry' -Type DWORD -Value 3

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Send personal information: Disabled
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Common' -Name 'sendcustomerdata' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Automatically receive small updates to improve reliability: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common' -Name 'UpdateReliabilityData' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Security Settings: Turn off error reporting for files that fail file validation: Enabled
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Common\Security\FileValidation' -Name 'disablereporting' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Telemetry Dashboard: Turn on telemetry data collection: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\OSM' -Name 'Enablelogging' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Telemetry Dashboard: Turn on privacy settings in Office Telemetry Agent: Enabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\OSM' -Name 'EnableFileObfuscation' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Telemetry Dashboard: Turn on data uploading for Office Telemetry Agent: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\OSM' -Name 'EnableUpload' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Telemetry Dashboard: Office applications to exclude from Office Telemetry Agent reporting: All
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\OSM\PreventedApplications' -Name 'accesssolution' -Type DWORD -Value 1
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\OSM\PreventedApplications' -Name 'olksolution' -Type DWORD -Value 1
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\OSM\PreventedApplications' -Name 'onenotesolution' -Type DWORD -Value 1
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\OSM\PreventedApplications' -Name 'pptsolution' -Type DWORD -Value 1
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\OSM\PreventedApplications' -Name 'projectsolution' -Type DWORD -Value 1
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\OSM\PreventedApplications' -Name 'publishersolution' -Type DWORD -Value 1
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\OSM\PreventedApplications' -Name 'visiosolution' -Type DWORD -Value 1
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\OSM\PreventedApplications' -Name 'wdsolution' -Type DWORD -Value 1
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\OSM\PreventedApplications' -Name 'xlsolution' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Telemetry Dashboard: Office sulotions to exclude from Office Telemetry Agent reporting: All
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\OSM\PreventedSolutiontypes' -Name 'agave' -Type DWORD -Value 1
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\OSM\PreventedSolutiontypes' -Name 'appaddins' -Type DWORD -Value 1
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\OSM\PreventedSolutiontypes' -Name 'comaddins' -Type DWORD -Value 1
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\OSM\PreventedSolutiontypes' -Name 'documentfiles' -Type DWORD -Value 1
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\OSM\PreventedSolutiontypes' -Name 'templatefiles' -Type DWORD -Value 1

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Tools | Options | General | Service Options...: Online Content: Online content options: Do not allow Office to connect to the Internet
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Common\Internet' -Name 'useonlinecontent' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Tools | Options | General | Service Options...: Online Content: Service Level Options: Office services only
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Common\Internet' -Name 'serviceleveloptions' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Tools | Options | General | Spelling: Proofing Data Collection: Improve Proofing Tools: Disabled
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Common\PTWatson' -Name 'PTWOptIn' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Outlook 2016: Outlook Options: Other: Advanced: Enable mail logging (troubleshooting): Disabled
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Outlook\Options\Mail' -Name 'EnableLogging' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Skype for Business 2016: Microsoft Lync Feature Policies: Disable automatic upload of sign-in failure logs: Enabled
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Lync' -Name 'disableautomaticsendtracing' -Type DWORD -Value 1

# TODO
Set-Policy -Scope User -Path 'SOFTWARE\Microsoft\Office\16.0\Common\MailSettings' -Name 'InlineTextPrediction' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'SOFTWARE\Microsoft\Office\Common\ClientTelemetry' -Name 'DisableTelemetry' -Type DWORD -Value 1
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Word\Options' -Name 'EnableLogging' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Common\General' -Name 'ShownFileFmtPrompt' -Type DWORD -Value 0
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Common' -Name 'disableboottoofficestart' -Type DWORD -Value 1
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Common\Internet' -Name 'disableboottoofficestart' -Type DWORD -Value 1
Set-Policy -Scope User -Path 'Software\Policies\Microsoft\Office\16.0\Common\PTWatson' -Name 'disableboottoofficestart' -Type DWORD -Value 1
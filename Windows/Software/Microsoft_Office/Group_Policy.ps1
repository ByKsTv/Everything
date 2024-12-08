# https://www.microsoft.com/en-us/download/details.aspx?id=49030

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Miscellaneous: Show LinkedIn features in Office applications: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common' -Name 'LinkedIn' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow Microsoft to follow up on feedback submitted by users?: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Feedback' -Name 'IncludeEmail' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow the use of additional optional connected experiences in Office: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy' -Name 'ControllerConnectedServicesEnabled' -Type DWORD -Value 2

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow the use of connected experiences in Office: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy' -Name 'DisconnectedState' -Type DWORD -Value 2

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow the use of connected experiences in Office that analyze content: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy' -Name 'UserContentDisabled' -Type DWORD -Value 2

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow the use of connected experiences in Office that download online content: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy' -Name 'DownloadContentDisabled' -Type DWORD -Value 2

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow users to receive and respond to in-product surveys from Microsoft: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Feedback' -Name 'SurveyEnabled' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow users to submit feedback to Microsoft: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Feedback' -Name 'Enabled' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Automatically receive small updates to improve reliability: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common' -Name 'UpdateReliabilityData' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Enable Customer Experience Improvement Program: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common' -Name 'QMEnable' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Configure the level of client software diagnostic data sent by Office to Microsoft: Enabled: Neither
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\Common\ClientTelemetry' -Name 'SendTelemetry' -Type DWORD -Value 3

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Telemetry Dashboard: Turn on data uploading for Office Telemetry Agent: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\OSM' -Name 'EnableUpload' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Telemetry Dashboard: Turn on telemetry data collection: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\OSM' -Name 'Enablelogging' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Telemetry Dashboard: Turn on privacy settings in Office Telemetry Agent: Enabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\OSM' -Name 'EnableFileObfuscation' -Type DWORD -Value 1

# Doesn't exist
Set-Policy -Scope User -Path 'SOFTWARE\Microsoft\Office\16.0\Common\MailSettings' -Name 'InlineTextPrediction' -Type DWORD -Value 0

# Disable telemetry for Microsoft Office
Set-Policy -Scope User -Path 'SOFTWARE\Microsoft\Office\Common\ClientTelemetry' -Name 'DisableTelemetry' -Type DWORD -Value 1
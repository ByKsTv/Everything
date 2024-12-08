# https://www.microsoft.com/en-us/download/details.aspx?id=49030

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Miscellaneous: Show LinkedIn features in Office applications: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common' -Name 'LinkedIn' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow Microsoft to follow up on feedback submitted by users?: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Feedback' -Name 'IncludeEmail' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow users to receive and respond to in-product surveys from Microsoft: Disabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Feedback' -Name 'SurveyEnabled' -Type DWORD -Value 0

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Telemetry Dashboard: Turn on privacy settings in Office Telemetry Agent: Enabled
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\OSM' -Name 'EnableFileObfuscation' -Type DWORD -Value 1

# Doesn't exist
Set-Policy -Scope User -Path 'SOFTWARE\Microsoft\Office\16.0\Common\MailSettings' -Name 'InlineTextPrediction' -Type DWORD -Value 0
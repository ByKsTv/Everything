# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow the use of connected experiences in Office: Not configured
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy' -Name 'DisconnectedState' -Type CLEAR

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow the use of connected experiences in Office that analyze content: Not configured
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy' -Name 'UserContentDisabled' -Type CLEAR

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow the use of connected experiences in Office that download online content: Not configured
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy' -Name 'DownloadContentDisabled' -Type CLEAR

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Privacy: Trust Center: Allow the use of additional optional connected experiences in Office: Not configured
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Privacy' -Name 'ControllerConnectedServicesEnabled' -Type CLEAR

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Tools | Options | General | Service Options...: Online Content: Online content options: Not configured
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Internet' -Name 'useonlinecontent' -Type CLEAR

# Group Policy: User Configuration: Administrative Templates: Microsoft Office 2016: Tools | Options | General | Service Options...: Online Content: Service Level Options: Not configured
Set-Policy -Scope User -Path 'SOFTWARE\Policies\Microsoft\Office\16.0\Common\Internet' -Name 'serviceleveloptions' -Type CLEAR
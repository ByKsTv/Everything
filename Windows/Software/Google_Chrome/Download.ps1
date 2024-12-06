[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile('https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi', "$env:TEMP\googlechromestandaloneenterprise64.msi")

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $env:TEMP\googlechromestandaloneenterprise64.msi -ArgumentList '/quiet' -Wait

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome: Opening default apps on Windows Settings'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process 'ms-settings:defaultapps'

Add-Type -AssemblyName System.Windows.Forms
$Popup_Usermanual = New-Object System.Windows.Forms.Form -Property @{TopMost = $true; ShowInTaskbar = $false; Opacity = 0 }
$Popup_Text = "Please set 'Google Chrome' as default web browser"
[System.Windows.Forms.MessageBox]::Show($Popup_Usermanual, $Popup_Text, '', 'OK')
$Popup_Usermanual.Dispose()
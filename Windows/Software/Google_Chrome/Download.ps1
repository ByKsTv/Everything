Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Google_Chrome/Group_Policy_Templates.ps1')

$Chrome_DDL = 'https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi'
$Chrome_Filename = [IO.Path]::GetFileName(([URI]$Chrome_DDL).AbsolutePath)
$Chrome_SavePath = [IO.Path]::Combine($env:TEMP, $Chrome_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Google Chrome'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Chrome_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Chrome_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($Chrome_DDL, $Chrome_SavePath)

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $Chrome_SavePath -ArgumentList "/quiet /norestart /l*v `"$($env:TEMP)\GoogleChrome.MsiInstall.log`""

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome: Opening default apps on Windows Settings'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process 'ms-settings:defaultapps'

Add-Type -AssemblyName System.Windows.Forms
$Popup_Usermanual = New-Object System.Windows.Forms.Form -Property @{TopMost = $true; ShowInTaskbar = $false; Opacity = 0 }
$Popup_Text = "Please set 'Google Chrome' as default web browser"
[System.Windows.Forms.MessageBox]::Show($Popup_Usermanual, $Popup_Text, '', 'OK')
$Popup_Usermanual.Dispose()
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Google_Chrome/Group_Policy_Templates.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Pre.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Google_Chrome/Group_Policy.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Post.ps1')

$Chrome_MSI_DDL = 'https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi'
$Chrome_MSI_FileName = [IO.Path]::GetFileName(([URI]$Chrome_MSI_DDL).AbsolutePath)
$Chrome_MSI_SavePath = [IO.Path]::Combine($env:TEMP, $Chrome_MSI_FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Chrome_MSI_FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Chrome_MSI_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Chrome_MSI_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($Chrome_MSI_DDL, $Chrome_MSI_SavePath)

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/7-Zip/Download.ps1')
$Chrome_MSI_Dir = [IO.Path]::Combine([IO.Path]::GetDirectoryName($Chrome_MSI_SavePath), [IO.Path]::GetFileNameWithoutExtension($Chrome_MSI_SavePath))
$Chrome_MSI_Dir_SavePath = [IO.Path]::Combine($env:TEMP, $Chrome_MSI_Dir)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Chrome_MSI_FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Chrome_MSI_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Chrome_MSI_Dir_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
& 7z.exe x $Chrome_MSI_SavePath -o"$Chrome_MSI_Dir_SavePath" -y

$Chrome_Installer_SavePath = (Get-ChildItem -Path $Chrome_MSI_Dir_SavePath -Recurse -Filter '*GoogleChromeInstaller*' | Select-Object -First 1).FullName
$Chrome_Installer_FileName = [IO.Path]::GetFileName(([URI]$Chrome_Installer_SavePath).AbsolutePath)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Chrome_Installer_FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Chrome_Installer_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Chrome_MSI_Dir_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
& 7z.exe x $Chrome_Installer_SavePath -o"$Chrome_MSI_Dir_SavePath" -y

$Chrome_7Zip_SavePath = (Get-ChildItem -Path $Chrome_MSI_Dir_SavePath -Recurse -Filter '*.7z*' | Select-Object -First 1).FullName
$Chrome_7Zip_FileName = [IO.Path]::GetFileName(([URI]$Chrome_7Zip_SavePath).AbsolutePath)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Chrome_7Zip_FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Chrome_7Zip_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Chrome_MSI_Dir_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
& 7z.exe x $Chrome_7Zip_SavePath -o"$Chrome_MSI_Dir_SavePath" -y

$Chrome_Installer_SavePath = (Get-ChildItem -Path $Chrome_MSI_Dir_SavePath -Recurse -Filter '*chrome_installer*' | Select-Object -First 1).FullName
$Chrome_Installer_FileName = [IO.Path]::GetFileName(([URI]$Chrome_Installer_SavePath).AbsolutePath)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Chrome_Installer_FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Chrome_Installer_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process -FilePath $Chrome_Installer_SavePath # Do not add `-Wait`

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome: Opening default apps on Windows Settings'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process 'ms-settings:defaultapps'

Add-Type -AssemblyName System.Windows.Forms
$Popup_Usermanual = New-Object System.Windows.Forms.Form -Property @{ TopMost = $true }
$Popup_Text = "Please set 'Google Chrome' as default web browser"
[Windows.Forms.MessageBox]::Show($Popup_Usermanual, $Popup_Text, '', 'OK') | Out-Null

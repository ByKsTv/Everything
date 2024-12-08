Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Google_Chrome/Group_Policy_Templates.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Pre.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Google_Chrome/Group_Policy.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Post.ps1')

$apiUrl = 'https://api.github.com/repos/microsoft/winget-pkgs/contents/manifests/g/Google/Chrome/EXE'
$response = Invoke-RestMethod -Uri $apiUrl
$versions = $response | Where-Object { $_.type -eq 'dir' -and $_.name -match '^\d+\.\d+\.\d+\.\d+$' } | Select-Object -ExpandProperty name
$latestVersion = ($versions | ForEach-Object { [Version]$_ } | Sort-Object -Descending | Select-Object -First 1).ToString()
$yamlContent = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/microsoft/winget-pkgs/master/manifests/g/Google/Chrome/EXE/$latestVersion/Google.Chrome.EXE.installer.yaml" -UseBasicParsing | Select-Object -ExpandProperty Content
$null = $yamlContent -split "`n" -join "`n" -match '(?ms)-\s*Architecture:\s*x64.*?Scope:\s*machine.*?InstallerUrl:\s*(http.*?)(?:\s*InstallerSha256:|$).*?InstallerSwitches:\s*Custom:\s*(.*?)$'
$installURL = $Matches[1].Trim()
$switchesURL = if ($Matches[2]) {
    $Matches[2].Trim() 
}
else {
    'None' 
}

$Chrome_Filename = [IO.Path]::GetFileName(([URI]$installURL).AbsolutePath)
$Chrome_SavePath = [IO.Path]::Combine($env:TEMP, $Chrome_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Google Chrome'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$installURL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Chrome_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($installURL, $Chrome_SavePath)

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Google Chrome'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Chrome_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$switchesURL'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $Chrome_SavePath -ArgumentList $switchesURL

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome: Opening default apps on Windows Settings'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process 'ms-settings:defaultapps'

Add-Type -AssemblyName System.Windows.Forms
$Popup_Usermanual = New-Object System.Windows.Forms.Form -Property @{TopMost = $true; ShowInTaskbar = $false; Opacity = 0 }
$Popup_Text = "Please set 'Google Chrome' as default web browser"
[System.Windows.Forms.MessageBox]::Show($Popup_Usermanual, $Popup_Text, '', 'OK')
$Popup_Usermanual.Dispose()
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Key.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Windows_11_IoT_Enterprise_LTSC_2024/Settings.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Settings_Windows11.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Settings.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/O&O_ShutUp10++.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Pre.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/All_Policies.ps1')
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Post.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Network.ps1')

UsoClient.exe StartInteractiveScan

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Initial_Setup.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/Arkenfox.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Microsoft_Visual_C++_Redistributable/Download.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/DirectX_End_User_Runtimes/Download.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/.NET/Download.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Mozilla_Firefox/Extensions.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Google_Chrome/Extensions.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Microsoft_Edge/Uninstall.ps1')

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Software_Selection.ps1')

Add-Type -AssemblyName System.Windows.Forms
$Popup_Usermanual = New-Object System.Windows.Forms.Form -Property @{
    TopMost = $true
}
$Popup_Text = "Pin 'File Explorer' to taskbar"
[Windows.Forms.MessageBox]::Show($Popup_Usermanual, $Popup_Text, '', 'OK') | Out-Null
$Popup_Usermanual.Dispose()

Start-Process -FilePath 'ms-settings:windowsupdate'

$Popup_Usermanual = New-Object System.Windows.Forms.Form -Property @{
    TopMost = $true
}
$Popup_Text = "Wait for Windows Updates.
1. Click on 'Advanced options'
2. Click on 'Optional updates'
3. Select all
4. Click on 'Download & install'"
[Windows.Forms.MessageBox]::Show($Popup_Usermanual, $Popup_Text, '', 'OK') | Out-Null
$Popup_Usermanual.Dispose()

$Popup_Usermanual = New-Object System.Windows.Forms.Form -Property @{
    TopMost = $true
}
$Popup_Text = 'Please restart PC after installing all Windows Updates'
[Windows.Forms.MessageBox]::Show($Popup_Usermanual, $Popup_Text, '', 'OK') | Out-Null
$Popup_Usermanual.Dispose()

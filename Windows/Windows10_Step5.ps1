Add-Type -AssemblyName System.Windows.Forms
Unregister-ScheduledTask -TaskName Windows10_Step5 -Confirm:$false
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Arkenfox.ps1 | Invoke-Expression
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Windows10_Step5_Settings.ps1 | Invoke-Expression
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Windows10_Step5_Network.ps1 | Invoke-Expression
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Extensions.ps1 | Invoke-Expression
$MPVAnswer = [System.Windows.Forms.MessageBox]::Show('Install mpv?' , 'mpv' , 4, 32)
if ($MPVAnswer -eq 'Yes') {
	Write-Host 'mpv > Install' -ForegroundColor green -BackgroundColor black
	Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/mpv/Download_Install_AutoUpdate.ps1 | Invoke-Expression
}
$EdgeUninstallAnswer = [System.Windows.Forms.MessageBox]::Show('Uninstall Edge?' , 'Uninstall Edge' , 4, 32)
if ($EdgeUninstallAnswer -eq 'Yes') {
	Write-Host 'Microsoft Edge > Uninstall' -ForegroundColor green -BackgroundColor black
	#Invoke-RestMethod https://raw.githubusercontent.com/ChrisTitusTech/winutil/main/edgeremoval.ps1 | Invoke-Expression
	Invoke-RestMethod https://raw.githubusercontent.com/ChrisTitusTech/winutil/d0bde83333730a4536497451af747daba11e5039/edgeremoval.ps1 | Invoke-Expression
}
Write-Host 'Restart' -ForegroundColor cyan -BackgroundColor black
shutdown /r /t 00
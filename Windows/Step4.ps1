Unregister-ScheduledTask -TaskName Step4 -Confirm:$false
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Arkenfox.ps1 | Invoke-Expression
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Step4_Settings.ps1 | Invoke-Expression
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Step4_Network.ps1 | Invoke-Expression
Invoke-RestMethod https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Extensions.ps1 | Invoke-Expression
Add-Type -AssemblyName System.Windows.Forms
$EdgeUninstallAnswer = [System.Windows.Forms.MessageBox]::Show('Uninstall Edge?' , 'Edge' , 4, 32)
if ($EdgeUninstallAnswer -eq 'Yes') {
    Write-Host 'Microsoft Edge > Uninstall' -ForegroundColor green -BackgroundColor black
    #Invoke-RestMethod https://raw.githubusercontent.com/ChrisTitusTech/winutil/main/edgeremoval.ps1 | Invoke-Expression
    Invoke-RestMethod https://raw.githubusercontent.com/ChrisTitusTech/winutil/d0bde83333730a4536497451af747daba11e5039/edgeremoval.ps1 | Invoke-Expression
}
Write-Host 'Restart' -ForegroundColor cyan -BackgroundColor black
shutdown /r /t 00
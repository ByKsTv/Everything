Write-Host 'Discord: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x64', "$env:TEMP\DiscordSetup.exe")

Write-Host 'Discord: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\DiscordSetup.exe -ArgumentList '/S' -Wait

Write-Host 'Discord: Waiting for Desktop shortcut' -ForegroundColor green -BackgroundColor black
while (($null -eq (Test-Path -Path "C:\Users\$env:USERNAME\Desktop\Discord.lnk") -eq $false)) {
}

Write-Host 'Discord: Deleting Desktop Shortcut' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path "C:\Users\$env:USERNAME\Desktop\Discord.lnk") -eq $true) {
    Remove-Item -Path ("C:\Users\$env:USERNAME\Desktop\Discord.lnk")
}

Write-Host 'Discord: Disabling Startup' -ForegroundColor green -BackgroundColor black
Remove-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run' -Name Discord -Force
Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name Discord -Force
Remove-Item -Path "$env:ProgramData\SquirrelMachineInstalls\Discord.exe" -Force
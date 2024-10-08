Write-Host 'Discord: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x64', "$env:TEMP\DiscordSetup.exe")

Write-Host 'Discord: Installing' -ForegroundColor green -BackgroundColor black
Start-Process -FilePath $env:TEMP\DiscordSetup.exe -ArgumentList '/S' -Wait

Write-Host 'Discord: Waiting for Discord Updater to Open' -ForegroundColor green -BackgroundColor black
while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'Discord Updater' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}

Write-Host 'Discord: Waiting for Discord Updater to Close' -ForegroundColor green -BackgroundColor black
while (($true -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'Discord Updater' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}

Write-Host 'Discord: Deleting Desktop Shortcut' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path "$($env:USERPROFILE)\Desktop\Discord.lnk") -eq $true) {
    Remove-Item -Path "$($env:USERPROFILE)\Desktop\Discord.lnk"
}

Write-Host 'Discord: Disabling Startup' -ForegroundColor green -BackgroundColor black
Remove-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run' -Name Discord -Force
Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name Discord -Force
Remove-Item -Path "$env:ProgramData\SquirrelMachineInstalls\Discord.exe" -Force
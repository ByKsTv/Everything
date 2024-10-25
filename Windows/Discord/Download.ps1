[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Discord: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile('https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x64', "$env:TEMP\DiscordSetup.exe")

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Discord: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process -FilePath $env:TEMP\DiscordSetup.exe -ArgumentList '/S' -Wait

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Discord: Waiting for Discord Updater to Open'); [Console]::ResetColor(); [Console]::WriteLine()
while (($null -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'Discord Updater' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Discord: Waiting for Discord Updater to Close'); [Console]::ResetColor(); [Console]::WriteLine()
while (($true -eq (Get-Process | Where-Object { $_.mainWindowTitle -match 'Discord Updater' } -ErrorAction SilentlyContinue))) {
    Start-Sleep -Milliseconds 1000
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Discord: Deleting Desktop Shortcut'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path "$($env:USERPROFILE)\Desktop\Discord.lnk") -eq $true) {
    Remove-Item -Path "$($env:USERPROFILE)\Desktop\Discord.lnk"
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Discord: Disabling Startup'); [Console]::ResetColor(); [Console]::WriteLine()
Remove-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run' -Name Discord -Force
Remove-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name Discord -Force
Remove-Item -Path "$env:ProgramData\SquirrelMachineInstalls\Discord.exe" -Force
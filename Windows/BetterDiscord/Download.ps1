Write-Host 'BetterDiscord: Closing Discord' -ForegroundColor green -BackgroundColor black
Get-Process Discord -ea 0 | ForEach-Object { $_.CloseMainWindow() | Out-Null }
Start-Sleep 1
Get-Process Discord -ea 0 | Stop-Process -Force

Write-Host 'BetterDiscord: Checking for folders' -ForegroundColor green -BackgroundColor black
if (!(Test-Path -Path $env:APPDATA\BetterDiscord)) {
    New-Item -Path $env:APPDATA\BetterDiscord -Value BetterDiscord -ItemType Directory
}
if (!(Test-Path -Path $env:APPDATA\BetterDiscord\plugins)) {
    New-Item -Path $env:APPDATA\BetterDiscord\plugins -Value plugins -ItemType Directory
}
if (!(Test-Path -Path $env:APPDATA\BetterDiscord\themes)) {
    New-Item -Path $env:APPDATA\BetterDiscord\themes -Value themes -ItemType Directory
}
if (!(Test-Path -Path "$env:APPDATA\BetterDiscord\data")) {
    New-Item -Path "$env:APPDATA\BetterDiscord\data" -Value 'data' -ItemType Directory
}
if (!(Test-Path -Path "$env:APPDATA\BetterDiscord\data\stable")) {
    New-Item -Path "$env:APPDATA\BetterDiscord\data\stable" -Value 'stable' -ItemType Directory
}

Write-Host 'BetterDiscord: Adding Theme: amoled-cord.css' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LuckFire/amoled-cord/main/clients/amoled-cord.theme.css', "$env:APPDATA\BetterDiscord\themes\amoled-cord.theme.css")

Write-Host 'BetterDiscord: Adding DoNotTrack.plugin.js' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/rauenzi/BetterDiscordAddons/master/Plugins/DoNotTrack/DoNotTrack.plugin.js', "$env:APPDATA\BetterDiscord\plugins\DoNotTrack.plugin.js")

Write-Host 'BetterDiscord: Adding 0PluginLibrary.plugin.js (DoNotTrack)' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/rauenzi/BDPluginLibrary/master/release/0PluginLibrary.plugin.js', "$env:APPDATA\BetterDiscord\plugins\0PluginLibrary.plugin.js")

Write-Host 'BetterDiscord: Adding PluginRepo.plugin.js' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/PluginRepo/PluginRepo.plugin.js', "$env:APPDATA\BetterDiscord\plugins\PluginRepo.plugin.js")

Write-Host 'BetterDiscord: Adding 0BDFDB.plugin.js (PluginRepo)' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Library/0BDFDB.plugin.js', "$env:APPDATA\BetterDiscord\plugins\0BDFDB.plugin.js")

Write-Host 'BetterDiscord: Adding CallTimeCounter.plugin.js' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/QWERTxD/BetterDiscordPlugins/main/CallTimeCounter/CallTimeCounter.plugin.js', "$env:APPDATA\BetterDiscord\plugins\CallTimeCounter.plugin.js")

Write-Host 'BetterDiscord: Adding BetterRoleColors.plugin.js' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/rauenzi/BetterDiscordAddons/master/Plugins/BetterRoleColors/BetterRoleColors.plugin.js', "$env:APPDATA\BetterDiscord\plugins\BetterRoleColors.plugin.js")

Write-Host 'BetterDiscord: Adding ThemeRepo.plugin.js' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/ThemeRepo/ThemeRepo.plugin.js', "$env:APPDATA\BetterDiscord\plugins\ThemeRepo.plugin.js")

Write-Host 'BetterDiscord: Enabling All Plugins' -ForegroundColor green -BackgroundColor black
New-Item -Path "$env:APPDATA\BetterDiscord\data\stable\plugins.json" -ItemType File -Value '{
    "DoNotTrack": true,
    "ZeresPluginLibrary": true,
    "PluginRepo": true,
    "BDFDB": true,
    "CallTimeCounter": true,
    "BetterRoleColors": true,
    "ThemeRepo": true
}' -Force

Write-Host 'BetterDiscord: Enabling All Themes' -ForegroundColor green -BackgroundColor black
New-Item -Path "$env:APPDATA\BetterDiscord\data\stable\themes.json" -ItemType File -Value '{
    "AMOLED-Cord": true
}' -Force

Write-Host 'BetterDiscord: Getting latest release' -ForegroundColor green -BackgroundColor black
$BetterDiscordURL = ((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/BetterDiscord/BetterDiscord/releases/latest').assets | Where-Object name -Like '*betterdiscord*' ).browser_download_url

Write-Host 'BetterDiscord: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile("$BetterDiscordURL", "$env:APPDATA\BetterDiscord\data\betterdiscord.asar")

Write-Host 'BetterDiscord: Installing' -ForegroundColor green -BackgroundColor black
$DiscordAppDirs = Get-Item -Path "$env:LOCALAPPDATA\Discord\app*\modules\discord_desktop*\discord_desktop*\"
foreach ($DiscordAppDir in $DiscordAppDirs) {
    $DiscordIndex = "$DiscordAppDir\index.js"
    $DiscordIndexContent = @"
require("$env:APPDATA\BetterDiscord\data\betterdiscord.asar");
module.exports = require("./core.asar");
"@
    New-Item -Path $DiscordIndex -ItemType File -Value $DiscordIndexContent -Force
    (Get-Content $DiscordIndex).Replace('\', '\\') | Set-Content $DiscordIndex -Force
}
$BetterDiscord = 'BetterDiscord Updater'
$BetterDiscord_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $BetterDiscord }
if (!($BetterDiscord_Exists)) {
    Write-Host "BetterDiscord: Task Scheduler: Adding $BetterDiscord" -ForegroundColor green -BackgroundColor black
    $BetterDiscord_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $BetterDiscord_Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/BetterDiscord/Download.ps1')"
    $BetterDiscord_Trigger = New-ScheduledTaskTrigger -AtLogOn
    $BetterDiscord_Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
    $BetterDiscord_Parameters = @{
        TaskName  = $BetterDiscord
        Principal = $BetterDiscord_Principal
        Action    = $BetterDiscord_Action
        Trigger   = $BetterDiscord_Trigger
        Settings  = $BetterDiscord_Settings
    }
    Register-ScheduledTask @BetterDiscord_Parameters -Force
}

Write-Host 'BetterDiscord: Checking if Discord is Installed' -ForegroundColor green -BackgroundColor black
if ((Test-Path -Path $env:LOCALAPPDATA\Discord)) {
    Write-Host 'BetterDiscord: Discord is Installed' -ForegroundColor green -BackgroundColor black
    
    Write-Host 'BetterDiscord: Checking if BetterDiscord is Installed' -ForegroundColor green -BackgroundColor black
    $DiscordAppDir = Get-Item -Path "$env:LOCALAPPDATA\Discord\app*\modules\discord_desktop*\discord_desktop*\" | Sort-Object -Descending | Select-Object -First 1
    $DiscordIndex = "$DiscordAppDir\index.js"
    $DiscordIndexExists = Select-String -Path $DiscordIndex -Pattern 'betterdiscord'

    if ($null -ne $DiscordIndexExists) {
        Write-Host 'BetterDiscord: BetterDiscord is already Installed' -ForegroundColor green -BackgroundColor black
    }
    
    else {
        Write-Host 'BetterDiscord: BetterDiscord is not Installed' -ForegroundColor green -BackgroundColor black
        Write-Host 'BetterDiscord: Installing' -ForegroundColor green -BackgroundColor black

        Write-Host 'BetterDiscord: Closing Discord' -ForegroundColor green -BackgroundColor black
        Get-Process Discord -ea 0 | ForEach-Object { $_.CloseMainWindow() | Out-Null }
        Start-Sleep 1
        Get-Process Discord -ea 0 | Stop-Process -Force

        Write-Host 'BetterDiscord: Checking if first time installation of BetterDiscord' -ForegroundColor green -BackgroundColor black
        if (!(Test-Path -Path $env:APPDATA\BetterDiscord)) {
            Write-Host 'BetterDiscord: First time installation of BetterDiscord' -ForegroundColor green -BackgroundColor black

            Write-Host 'BetterDiscord: Checking for folders' -ForegroundColor green -BackgroundColor black
            if (!(Test-Path -Path $env:APPDATA\BetterDiscord)) {
                Write-Host 'BetterDiscord: Creating BetterDiscord folder' -ForegroundColor green -BackgroundColor black
                New-Item -Path $env:APPDATA\BetterDiscord -Value BetterDiscord -ItemType Directory
            }
            if (!(Test-Path -Path $env:APPDATA\BetterDiscord\plugins)) {
                Write-Host 'BetterDiscord: Creating plugins folder' -ForegroundColor green -BackgroundColor black
                New-Item -Path $env:APPDATA\BetterDiscord\plugins -Value plugins -ItemType Directory
            }
            if (!(Test-Path -Path $env:APPDATA\BetterDiscord\themes)) {
                Write-Host 'BetterDiscord: Creating themes folder' -ForegroundColor green -BackgroundColor black
                New-Item -Path $env:APPDATA\BetterDiscord\themes -Value themes -ItemType Directory
            }
            if (!(Test-Path -Path "$env:APPDATA\BetterDiscord\data")) {
                Write-Host 'BetterDiscord: Creating data folder' -ForegroundColor green -BackgroundColor black
                New-Item -Path "$env:APPDATA\BetterDiscord\data" -Value 'data' -ItemType Directory
            }
            if (!(Test-Path -Path "$env:APPDATA\BetterDiscord\data\stable")) {
                Write-Host 'BetterDiscord: Creating stable folder' -ForegroundColor green -BackgroundColor black
                New-Item -Path "$env:APPDATA\BetterDiscord\data\stable" -Value 'stable' -ItemType Directory
            }

            Write-Host 'BetterDiscord: Adding Theme: AMOLED-Cord' -ForegroundColor green -BackgroundColor black
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LuckFire/amoled-cord/main/clients/amoled-cord.theme.css', "$env:APPDATA\BetterDiscord\themes\amoled-cord.theme.css")

            Write-Host 'BetterDiscord: Adding Plugin: DoNotTrack' -ForegroundColor green -BackgroundColor black
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/rauenzi/BetterDiscordAddons/master/Plugins/DoNotTrack/DoNotTrack.plugin.js', "$env:APPDATA\BetterDiscord\plugins\DoNotTrack.plugin.js")

            Write-Host 'BetterDiscord: Adding Plugin: 0PluginLibrary' -ForegroundColor green -BackgroundColor black
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/rauenzi/BDPluginLibrary/master/release/0PluginLibrary.plugin.js', "$env:APPDATA\BetterDiscord\plugins\0PluginLibrary.plugin.js")

            Write-Host 'BetterDiscord: Adding Plugin: PluginRepo' -ForegroundColor green -BackgroundColor black
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/PluginRepo/PluginRepo.plugin.js', "$env:APPDATA\BetterDiscord\plugins\PluginRepo.plugin.js")

            Write-Host 'BetterDiscord: Adding Plugin: 0BDFDB' -ForegroundColor green -BackgroundColor black
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Library/0BDFDB.plugin.js', "$env:APPDATA\BetterDiscord\plugins\0BDFDB.plugin.js")

            Write-Host 'BetterDiscord: Adding Plugin: CallTimeCounter' -ForegroundColor green -BackgroundColor black
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/QWERTxD/BetterDiscordPlugins/main/CallTimeCounter/CallTimeCounter.plugin.js', "$env:APPDATA\BetterDiscord\plugins\CallTimeCounter.plugin.js")

            Write-Host 'BetterDiscord: Adding Plugin: BetterRoleColors' -ForegroundColor green -BackgroundColor black
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/rauenzi/BetterDiscordAddons/master/Plugins/BetterRoleColors/BetterRoleColors.plugin.js', "$env:APPDATA\BetterDiscord\plugins\BetterRoleColors.plugin.js")

            Write-Host 'BetterDiscord: Adding Plugin: ThemeRepo' -ForegroundColor green -BackgroundColor black
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/ThemeRepo/ThemeRepo.plugin.js', "$env:APPDATA\BetterDiscord\plugins\ThemeRepo.plugin.js")

            Write-Host 'BetterDiscord: Adding Plugin: YABDP4Nitro' -ForegroundColor green -BackgroundColor black
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/riolubruh/YABDP4Nitro/main/YABDP4Nitro.plugin.js', "$env:APPDATA\BetterDiscord\plugins\YABDP4Nitro.plugin.js")

            Write-Host 'BetterDiscord: Adding Plugin: RemoveChatButtons' -ForegroundColor green -BackgroundColor black
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/BleedingBD/plugin-RemoveChatButtons/main/RemoveChatButtons.plugin.js', "$env:APPDATA\BetterDiscord\plugins\RemoveChatButtons.plugin.js")

            Write-Host 'BetterDiscord: Adding Plugin: removeTrackingURL' -ForegroundColor green -BackgroundColor black
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/wotanut/DiscordStuff/main/plugins/dist/removeTrackingURL.plugin.js', "$env:APPDATA\BetterDiscord\plugins\removeTrackingURL.plugin.js")

            Write-Host 'BetterDiscord: Adding Plugin: UncompressedImages' -ForegroundColor green -BackgroundColor black
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Knewest/uncompressed-discord-images/main/UncompressedImages.plugin.js', "$env:APPDATA\BetterDiscord\plugins\UncompressedImages.plugin.js")

            Write-Host 'BetterDiscord: Enabling All Plugins' -ForegroundColor green -BackgroundColor black
            New-Item -Path "$env:APPDATA\BetterDiscord\data\stable\plugins.json" -ItemType File -Value '{
    "DoNotTrack": true,
    "ZeresPluginLibrary": true,
    "PluginRepo": true,
    "BDFDB": true,
    "CallTimeCounter": true,
    "BetterRoleColors": true,
    "ThemeRepo": true,
    "YABDP4Nitro": true,
    "RemoveChatButtons": true,
    "removeTrackingURL": true,
    "Uncompressed Images": true
}' -Force

            Write-Host 'BetterDiscord: Enabling AMOLED-Cord Theme' -ForegroundColor green -BackgroundColor black
            New-Item -Path "$env:APPDATA\BetterDiscord\data\stable\themes.json" -ItemType File -Value '{
    "AMOLED-Cord": true
}' -Force
        }
        
        Write-Host 'BetterDiscord: Getting latest release' -ForegroundColor green -BackgroundColor black
        $BetterDiscordURL = ((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/BetterDiscord/BetterDiscord/releases/latest').assets | Where-Object name -Like '*betterdiscord*' ).browser_download_url

        Write-Host 'BetterDiscord: Downloading' -ForegroundColor green -BackgroundColor black
        (New-Object System.Net.WebClient).DownloadFile("$BetterDiscordURL", "$env:APPDATA\BetterDiscord\data\betterdiscord.asar")

        Write-Host 'BetterDiscord: Installing' -ForegroundColor green -BackgroundColor black
        New-Item -Path $DiscordIndex -ItemType File -Value @"
require("$env:APPDATA\BetterDiscord\data\betterdiscord.asar");
module.exports = require("./core.asar");
"@ -Force
        (Get-Content $DiscordIndex).Replace('\', '\\') | Set-Content $DiscordIndex -Force
    }
}

Write-Host 'BetterDiscord: Updating BetterDiscord, Themes and Plugins' -ForegroundColor green -BackgroundColor black
Write-Host 'BetterDiscord: Getting latest release' -ForegroundColor green -BackgroundColor black
$BetterDiscordURL = ((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/BetterDiscord/BetterDiscord/releases/latest').assets | Where-Object name -Like '*betterdiscord*' ).browser_download_url

Write-Host 'BetterDiscord: Downloading' -ForegroundColor green -BackgroundColor black
(New-Object System.Net.WebClient).DownloadFile("$BetterDiscordURL", "$env:APPDATA\BetterDiscord\data\betterdiscord.asar")

if ((Test-Path -Path "$env:APPDATA\BetterDiscord\themes\amoled-cord.theme.css")) {
    Write-Host 'BetterDiscord: Updating Theme: AMOLED-Cord' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LuckFire/amoled-cord/main/clients/amoled-cord.theme.css', "$env:APPDATA\BetterDiscord\themes\amoled-cord.theme.css")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\DoNotTrack.plugin.js")) {
    Write-Host 'BetterDiscord: Updating Plugin: DoNotTrack' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/rauenzi/BetterDiscordAddons/master/Plugins/DoNotTrack/DoNotTrack.plugin.js', "$env:APPDATA\BetterDiscord\plugins\DoNotTrack.plugin.js")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\0PluginLibrary.plugin.js")) {
    Write-Host 'BetterDiscord: Updating Plugin: 0PluginLibrary' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/rauenzi/BDPluginLibrary/master/release/0PluginLibrary.plugin.js', "$env:APPDATA\BetterDiscord\plugins\0PluginLibrary.plugin.js")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\PluginRepo.plugin.js")) {
    Write-Host 'BetterDiscord: Updating Plugin: PluginRepo' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/PluginRepo/PluginRepo.plugin.js', "$env:APPDATA\BetterDiscord\plugins\PluginRepo.plugin.js")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\0BDFDB.plugin.js")) {
    Write-Host 'BetterDiscord: Updating Plugin: 0BDFDB' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Library/0BDFDB.plugin.js', "$env:APPDATA\BetterDiscord\plugins\0BDFDB.plugin.js")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\CallTimeCounter.plugin.js")) {
    Write-Host 'BetterDiscord: Updating Plugin: CallTimeCounter' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/QWERTxD/BetterDiscordPlugins/main/CallTimeCounter/CallTimeCounter.plugin.js', "$env:APPDATA\BetterDiscord\plugins\CallTimeCounter.plugin.js")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\BetterRoleColors.plugin.js")) {
    Write-Host 'BetterDiscord: Updating Plugin: BetterRoleColors' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/rauenzi/BetterDiscordAddons/master/Plugins/BetterRoleColors/BetterRoleColors.plugin.js', "$env:APPDATA\BetterDiscord\plugins\BetterRoleColors.plugin.js")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\ThemeRepo.plugin.js")) {
    Write-Host 'BetterDiscord: Updating Plugin: ThemeRepo' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/ThemeRepo/ThemeRepo.plugin.js', "$env:APPDATA\BetterDiscord\plugins\ThemeRepo.plugin.js")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\YABDP4Nitro.plugin.js")) {
    Write-Host 'BetterDiscord: Updating Plugin: YABDP4Nitro' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/riolubruh/YABDP4Nitro/main/YABDP4Nitro.plugin.js', "$env:APPDATA\BetterDiscord\plugins\YABDP4Nitro.plugin.js")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\RemoveChatButtons.plugin.js")) {
    Write-Host 'BetterDiscord: Updating Plugin: RemoveChatButtons' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/BleedingBD/plugin-RemoveChatButtons/main/RemoveChatButtons.plugin.js', "$env:APPDATA\BetterDiscord\plugins\RemoveChatButtons.plugin.js")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\removeTrackingURL.plugin.js")) {
    Write-Host 'BetterDiscord: Updating Plugin: removeTrackingURL' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/wotanut/DiscordStuff/main/plugins/dist/removeTrackingURL.plugin.js', "$env:APPDATA\BetterDiscord\plugins\removeTrackingURL.plugin.js")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\UncompressedImages.plugin.js")) {
    Write-Host 'BetterDiscord: Updating Plugin: UncompressedImages' -ForegroundColor green -BackgroundColor black
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Knewest/uncompressed-discord-images/main/UncompressedImages.plugin.js', "$env:APPDATA\BetterDiscord\plugins\UncompressedImages.plugin.js")
}
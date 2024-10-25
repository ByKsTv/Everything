$BetterDiscord = 'BetterDiscord Updater'
$BetterDiscord_Exists = Get-ScheduledTask | Where-Object { $_.TaskName -like $BetterDiscord }
if (!($BetterDiscord_Exists)) {
    Write-Host "BetterDiscord: Task Scheduler: Adding $BetterDiscord" -ForegroundColor green -BackgroundColor black
    $BetterDiscord_Principal = New-ScheduledTaskPrincipal -UserId "$env:computername\$env:USERNAME" -RunLevel Highest
    $BetterDiscord_Action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "/C start /MIN powershell -WindowStyle Minimized Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/BetterDiscord/Download.ps1')"
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

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Checking if Discord is Installed'); [Console]::ResetColor(); [Console]::WriteLine()
if (!(Test-Path -Path $env:LOCALAPPDATA\Discord)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Discord is not Installed'); [Console]::ResetColor(); [Console]::WriteLine()
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Discord: Initiating'); [Console]::ResetColor(); [Console]::WriteLine()
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Discord/Download.ps1')
}
if ((Test-Path -Path $env:LOCALAPPDATA\Discord)) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Discord is already Installed'); [Console]::ResetColor(); [Console]::WriteLine()
    
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Checking if BetterDiscord is Installed'); [Console]::ResetColor(); [Console]::WriteLine()
    $DiscordAppDir = Get-Item -Path "$env:LOCALAPPDATA\Discord\app*\modules\discord_desktop*\discord_desktop*\" | Sort-Object -Descending | Select-Object -First 1
    $DiscordIndex = "$DiscordAppDir\index.js"
    $DiscordIndexExists = Select-String -Path $DiscordIndex -Pattern 'betterdiscord'

    if ($null -ne $DiscordIndexExists) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: BetterDiscord is already Installed'); [Console]::ResetColor(); [Console]::WriteLine()
    }
    
    else {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: BetterDiscord is not Installed'); [Console]::ResetColor(); [Console]::WriteLine()
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Installing'); [Console]::ResetColor(); [Console]::WriteLine()

        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Closing Discord'); [Console]::ResetColor(); [Console]::WriteLine()
        Get-Process Discord -ea 0 | ForEach-Object { $_.CloseMainWindow() | Out-Null }
        Start-Sleep 1
        Get-Process Discord -ea 0 | Stop-Process -Force

        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Checking if first time installation of BetterDiscord'); [Console]::ResetColor(); [Console]::WriteLine()
        if (!(Test-Path -Path $env:APPDATA\BetterDiscord)) {
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: First time installation of BetterDiscord'); [Console]::ResetColor(); [Console]::WriteLine()

            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Checking for folders'); [Console]::ResetColor(); [Console]::WriteLine()
            if (!(Test-Path -Path $env:APPDATA\BetterDiscord)) {
                [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Creating BetterDiscord folder'); [Console]::ResetColor(); [Console]::WriteLine()
                New-Item -Path $env:APPDATA\BetterDiscord -ItemType Directory -Force
            }
            if (!(Test-Path -Path $env:APPDATA\BetterDiscord\plugins)) {
                [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Creating plugins folder'); [Console]::ResetColor(); [Console]::WriteLine()
                New-Item -Path $env:APPDATA\BetterDiscord\plugins -ItemType Directory -Force
            }
            if (!(Test-Path -Path $env:APPDATA\BetterDiscord\themes)) {
                [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Creating themes folder'); [Console]::ResetColor(); [Console]::WriteLine()
                New-Item -Path $env:APPDATA\BetterDiscord\themes -ItemType Directory -Force
            }
            if (!(Test-Path -Path "$env:APPDATA\BetterDiscord\data")) {
                [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Creating data folder'); [Console]::ResetColor(); [Console]::WriteLine()
                New-Item -Path "$env:APPDATA\BetterDiscord\data" -ItemType Directory -Force
            }
            if (!(Test-Path -Path "$env:APPDATA\BetterDiscord\data\stable")) {
                [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Creating stable folder'); [Console]::ResetColor(); [Console]::WriteLine()
                New-Item -Path "$env:APPDATA\BetterDiscord\data\stable" -ItemType Directory -Force
            }

            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Adding Theme: AMOLED-Cord'); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LuckFire/amoled-cord/main/clients/amoled-cord.theme.css', "$env:APPDATA\BetterDiscord\themes\amoled-cord.theme.css")

            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Adding Plugin: DoNotTrack'); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/rauenzi/BetterDiscordAddons/master/Plugins/DoNotTrack/DoNotTrack.plugin.js', "$env:APPDATA\BetterDiscord\plugins\DoNotTrack.plugin.js")

            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Adding Plugin: 0PluginLibrary'); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/rauenzi/BDPluginLibrary/master/release/0PluginLibrary.plugin.js', "$env:APPDATA\BetterDiscord\plugins\0PluginLibrary.plugin.js")

            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Adding Plugin: PluginRepo'); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/PluginRepo/PluginRepo.plugin.js', "$env:APPDATA\BetterDiscord\plugins\PluginRepo.plugin.js")

            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Adding Plugin: 0BDFDB'); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Library/0BDFDB.plugin.js', "$env:APPDATA\BetterDiscord\plugins\0BDFDB.plugin.js")

            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Adding Plugin: CallTimeCounter'); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/QWERTxD/BetterDiscordPlugins/main/CallTimeCounter/CallTimeCounter.plugin.js', "$env:APPDATA\BetterDiscord\plugins\CallTimeCounter.plugin.js")

            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Adding Plugin: ThemeRepo'); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/ThemeRepo/ThemeRepo.plugin.js', "$env:APPDATA\BetterDiscord\plugins\ThemeRepo.plugin.js")

            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Adding Plugin: YABDP4Nitro'); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/riolubruh/YABDP4Nitro/main/YABDP4Nitro.plugin.js', "$env:APPDATA\BetterDiscord\plugins\YABDP4Nitro.plugin.js")

            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Adding Plugin: RemoveChatButtons'); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/BleedingBD/plugin-RemoveChatButtons/main/RemoveChatButtons.plugin.js', "$env:APPDATA\BetterDiscord\plugins\RemoveChatButtons.plugin.js")

            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Adding Plugin: removeTrackingURL'); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/wotanut/DiscordStuff/main/plugins/dist/removeTrackingURL.plugin.js', "$env:APPDATA\BetterDiscord\plugins\removeTrackingURL.plugin.js")

            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Adding Plugin: UncompressedImages'); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Knewest/uncompressed-discord-images/main/UncompressedImages.plugin.js', "$env:APPDATA\BetterDiscord\plugins\UncompressedImages.plugin.js")

            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Enabling All Plugins'); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/BetterDiscord/plugins.json', "$env:APPDATA\BetterDiscord\data\stable\plugins.json")
            
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Enabling AMOLED-Cord Theme'); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/BetterDiscord/themes.json', "$env:APPDATA\BetterDiscord\data\stable\themes.json")
        }
        
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Downloading'); [Console]::ResetColor(); [Console]::WriteLine()
        (New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/BetterDiscord/BetterDiscord/releases/latest').assets | Where-Object name -Like '*betterdiscord*').browser_download_url, "$env:APPDATA\BetterDiscord\data\betterdiscord.asar")

        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Installing'); [Console]::ResetColor(); [Console]::WriteLine()
        New-Item -Path $DiscordIndex -ItemType File -Value @"
require("$env:APPDATA\BetterDiscord\data\betterdiscord.asar");
module.exports = require("./core.asar");
"@ -Force
        (Get-Content $DiscordIndex).Replace('\', '\\') | Set-Content $DiscordIndex -Force
    }
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Updating BetterDiscord, Themes and Plugins'); [Console]::ResetColor(); [Console]::WriteLine()
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Updating'); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile(((Invoke-RestMethod -Method GET -Uri 'https://api.github.com/repos/BetterDiscord/BetterDiscord/releases/latest').assets | Where-Object name -Like '*betterdiscord*').browser_download_url, "$env:APPDATA\BetterDiscord\data\betterdiscord.asar")

if ((Test-Path -Path "$env:APPDATA\BetterDiscord\themes\amoled-cord.theme.css")) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Updating Theme: AMOLED-Cord'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/LuckFire/amoled-cord/main/clients/amoled-cord.theme.css', "$env:APPDATA\BetterDiscord\themes\amoled-cord.theme.css")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\DoNotTrack.plugin.js")) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Updating Plugin: DoNotTrack'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/rauenzi/BetterDiscordAddons/master/Plugins/DoNotTrack/DoNotTrack.plugin.js', "$env:APPDATA\BetterDiscord\plugins\DoNotTrack.plugin.js")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\0PluginLibrary.plugin.js")) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Updating Plugin: 0PluginLibrary'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/rauenzi/BDPluginLibrary/master/release/0PluginLibrary.plugin.js', "$env:APPDATA\BetterDiscord\plugins\0PluginLibrary.plugin.js")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\PluginRepo.plugin.js")) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Updating Plugin: PluginRepo'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/PluginRepo/PluginRepo.plugin.js', "$env:APPDATA\BetterDiscord\plugins\PluginRepo.plugin.js")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\0BDFDB.plugin.js")) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Updating Plugin: 0BDFDB'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Library/0BDFDB.plugin.js', "$env:APPDATA\BetterDiscord\plugins\0BDFDB.plugin.js")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\CallTimeCounter.plugin.js")) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Updating Plugin: CallTimeCounter'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/QWERTxD/BetterDiscordPlugins/main/CallTimeCounter/CallTimeCounter.plugin.js', "$env:APPDATA\BetterDiscord\plugins\CallTimeCounter.plugin.js")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\ThemeRepo.plugin.js")) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Updating Plugin: ThemeRepo'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mwittrien/BetterDiscordAddons/master/Plugins/ThemeRepo/ThemeRepo.plugin.js', "$env:APPDATA\BetterDiscord\plugins\ThemeRepo.plugin.js")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\YABDP4Nitro.plugin.js")) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Updating Plugin: YABDP4Nitro'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/riolubruh/YABDP4Nitro/main/YABDP4Nitro.plugin.js', "$env:APPDATA\BetterDiscord\plugins\YABDP4Nitro.plugin.js")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\RemoveChatButtons.plugin.js")) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Updating Plugin: RemoveChatButtons'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/BleedingBD/plugin-RemoveChatButtons/main/RemoveChatButtons.plugin.js', "$env:APPDATA\BetterDiscord\plugins\RemoveChatButtons.plugin.js")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\removeTrackingURL.plugin.js")) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Updating Plugin: removeTrackingURL'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/wotanut/DiscordStuff/main/plugins/dist/removeTrackingURL.plugin.js', "$env:APPDATA\BetterDiscord\plugins\removeTrackingURL.plugin.js")
}
if ((Test-Path -Path "$env:APPDATA\BetterDiscord\plugins\UncompressedImages.plugin.js")) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('BetterDiscord: Updating Plugin: UncompressedImages'); [Console]::ResetColor(); [Console]::WriteLine()
    (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Knewest/uncompressed-discord-images/main/UncompressedImages.plugin.js', "$env:APPDATA\BetterDiscord\plugins\UncompressedImages.plugin.js")
}
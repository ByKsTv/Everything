$Settings = @'
{
    "ftue-shown-prod": "true",
    "is-first-launch-done": "true",
    "addons-settings": "{\"updateFrequency\":0,\"maxSimultaneousDownloads\":20,\"reservedBackupSpaceMB\":10,\"downloadTimeoutInSecs\":1200}",
    "general-settings": "{\"runOnStartup\":false,\"closeCurseForgeAction\":1,\"dateFormat\":null,\"gpuHardwareAcceleration\":true}",
    "privacy-settings": "{\"isPrivacyOptimizePerformance\":false,\"isPrivacyCustomize\":false,\"enableDiscordRichPresence\":false}",
    "advanced-settings": "{\"fileScanJobsCount\":2,\"logLevel\":6}"
}
'@
$LocalCFG = [IO.Path]::Combine($env:APPDATA, 'CurseForge', 'storage.json')
New-Item -Path $LocalCFG -ItemType File -Value $Settings -Force

$DDL = 'https://curseforge.overwolf.com/downloads/curseforge-latest-win64.exe'
$FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
$SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'CurseForge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)
                
$Argument = '/S /ALLUSERS'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'CurseForge'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $SavePath -ArgumentList $Argument
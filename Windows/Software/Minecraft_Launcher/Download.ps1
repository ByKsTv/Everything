$Minecraft_DDL = 'https://launcher.mojang.com/download/MinecraftInstaller.msi'
$Minecraft_Filename = [IO.Path]::GetFileName(([URI]$Minecraft_DDL).AbsolutePath)
$Minecraft_SavePath = [IO.Path]::Combine($env:TEMP, $Minecraft_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Minecraft Launcher'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Minecraft_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Minecraft_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($Minecraft_DDL, $Minecraft_SavePath)

$Minecraft_Argument = '/q'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Minecraft Launcher'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Minecraft_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Minecraft_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $Minecraft_SavePath -ArgumentList $Minecraft_Argument
$GitHub = Invoke-RestMethod -Uri 'https://api.github.com/repos/Orbmu2k/nvidiaProfileInspector/releases/latest'
$GitHub_Version = $($GitHub).name
$GitHub_FileName = $($GitHub).assets.name
$GitHub_DDL = $($GitHub).assets.browser_download_url

$SavePath = [IO.Path]::Combine($env:TEMP, $GitHub_FileName)

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$GitHub_FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' version '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$GitHub_Version'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$GitHub_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($GitHub_DDL, $SavePath)

$ExtractPath = Join-Path -Path (Split-Path $SavePath -Parent) -ChildPath ([IO.Path]::GetFileNameWithoutExtension($SavePath))
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ExtractPath'"); [Console]::ResetColor(); [Console]::WriteLine()
Expand-Archive -Path $SavePath -DestinationPath $ExtractPath -Force

$FileName = 'nvidiaProfileInspector.exe'
$FilePath = Get-ChildItem -Path $ExtractPath -Filter $FileName | Select-Object -ExpandProperty FullName

$Settings_DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/nvidiaProfileInspector/Settings.xml'
$Settings_Extension = '.nip'
$Settings_FileName = [IO.Path]::GetFileNameWithoutExtension($Settings_DDL) + $Settings_Extension
$Settings_FilePath = [IO.Path]::Combine($ExtractPath, $Settings_FileName)

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Settings_FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Settings_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Settings_FilePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($Settings_DDL, $Settings_FilePath)

$Argument = '-silent'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Running '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FilePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Settings_FilePath $Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process -FilePath $FilePath -ArgumentList $Settings_FilePath, $Argument -Wait
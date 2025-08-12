$DDL = 'https://dl.google.com/android/repository/usb_driver_r13-windows.zip'
$FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
$SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'USB Driver'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

$Dir_SavePath = [IO.Path]::Combine((Split-Path $SavePath -Parent), [IO.Path]::GetFileNameWithoutExtension($SavePath))
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'USB Driver'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Dir_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
Expand-Archive -Path $SavePath -DestinationPath $Dir_SavePath -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'USB Driver'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Dir_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
pnputil.exe /add-driver "$Dir_SavePath\*.inf" /subdirs /install
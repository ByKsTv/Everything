$USB_Driver_DDL = 'https://dl.google.com/android/repository/usb_driver_r13-windows.zip'
$USB_Driver_Filename = [IO.Path]::GetFileName(([URI]$USB_Driver_DDL).AbsolutePath)
$USB_Driver_SavePath = [IO.Path]::Combine($env:TEMP, $USB_Driver_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'USB Driver'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$USB_Driver_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$USB_Driver_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($USB_Driver_DDL, $USB_Driver_SavePath)

$USB_Driver_Dir_SavePath = $USB_Driver_SavePath.TrimEnd('.zip')
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'USB Driver'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$USB_Driver_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$USB_Driver_Dir_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
Expand-Archive -Path $USB_Driver_SavePath -DestinationPath $USB_Driver_Dir_SavePath -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'USB Driver'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$USB_Driver_Dir_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
pnputil.exe /add-driver "$USB_Driver_Dir_SavePath\*.inf" /subdirs /install
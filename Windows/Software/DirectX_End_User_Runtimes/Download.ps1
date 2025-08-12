$DDL = Invoke-WebRequest -UseBasicParsing -Uri 'https://www.microsoft.com/en-us/download/details.aspx?id=8109' | Select-Object -ExpandProperty 'Links' | Where-Object { $_.outerHTML -match 'exe' } | Select-Object -ExpandProperty 'href'
$FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
$SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'DirectX End-User Runtimes (June 2010)'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

$Destination = [IO.Path]::Combine([IO.Path]::GetDirectoryName($SavePath), [IO.Path]::GetFileNameWithoutExtension($SavePath))
$Argument = "/Q /T:$Destination"
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'DirectX End-User Runtimes (June 2010)'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Destination'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $SavePath -ArgumentList $Argument -Wait

$Destination = [IO.Path]::Combine($Destination, 'DXSETUP.exe')
$Argument = '/silent'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'DirectX End-User Runtimes (June 2010)'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Destination'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $Destination -ArgumentList $Argument
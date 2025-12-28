# https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170
$DDL = 'https://aka.ms/vc14/vc_redist.x64.exe'
$FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
$SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Visual C++ Redistributable'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

$Description = ([Diagnostics.FileVersionInfo]::GetVersionInfo($SavePath)).FileDescription
$Argument = '/install /quiet /norestart'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Description'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $SavePath -ArgumentList $Argument -Wait
$VC_redist_DDL = 'https://aka.ms/vs/17/release/VC_redist.x64.exe'
$VC_redist_Filename = [IO.Path]::GetFileName(([URI]$VC_redist_DDL).AbsolutePath)
$VC_redist_SavePath = [IO.Path]::Combine($env:TEMP, $VC_redist_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Visual C++ Redistributable'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VC_redist_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VC_redist_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($VC_redist_DDL, $VC_redist_SavePath)

$VC_redist_Description = ([Diagnostics.FileVersionInfo]::GetVersionInfo($VC_redist_SavePath)).FileDescription
$VC_redist_exe_Argument = '/install /quiet /norestart'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VC_redist_Description'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VC_redist_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VC_redist_exe_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $VC_redist_SavePath -ArgumentList $VC_redist_exe_Argument
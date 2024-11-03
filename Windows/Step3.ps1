[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Task Scheduler: Removing current step'); [Console]::ResetColor(); [Console]::WriteLine()
Unregister-ScheduledTask -TaskName Step3 -Confirm:$false

$DirectX_DDL = ((Invoke-WebRequest -UseBasicParsing -Uri 'https://www.microsoft.com/en-us/download/details.aspx?id=8109').Links | Where-Object { $_.outerHTML -Match 'directx_Jun2010_redist.exe' } ).href
$DirectX_Filename = [IO.Path]::GetFileName(([URI]$DirectX_DDL).AbsolutePath)
$DirectX_SavePath = [IO.Path]::Combine($env:TEMP, $DirectX_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'DirectX End-User Runtimes (June 2010)'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DirectX_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DirectX_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DirectX_DDL, $DirectX_SavePath)

$DirectX_Destination = [IO.Path]::Combine($env:TEMP, 'directx_Jun2010_redist')
$DirectX_Argument = "/Q /T:$DirectX_Destination"
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'DirectX End-User Runtimes (June 2010)'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DirectX_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DirectX_Destination'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $DirectX_SavePath -ArgumentList $DirectX_Argument -Wait

$DirectX_exe_Destination = [IO.Path]::Combine($DirectX_Destination, 'DXSETUP.exe')
$DirectX_exe_Argument = '/silent'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'DirectX End-User Runtimes (June 2010)'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DirectX_exe_Destination'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DirectX_exe_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $DirectX_exe_Destination -ArgumentList $DirectX_exe_Argument

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('.NET: Initiating'); [Console]::ResetColor(); [Console]::WriteLine()
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/.NET/Download.ps1')

$VC_redist_DDL = 'https://aka.ms/vs/17/release/VC_redist.x64.exe'
$VC_redist_Filename = [IO.Path]::GetFileName(([URI]$VC_redist_DDL).AbsolutePath)
$VC_redist_SavePath = [IO.Path]::Combine($env:TEMP, $VC_redist_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Microsoft Visual C++ Redistributable'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VC_redist_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VC_redist_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($VC_redist_DDL, $VC_redist_SavePath)

$VC_redist_Description = ([System.Diagnostics.FileVersionInfo]::GetVersionInfo($VC_redist_SavePath)).FileDescription
$VC_redist_exe_Argument = '/install /quiet /norestart'
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VC_redist_Description'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VC_redist_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$VC_redist_exe_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $VC_redist_SavePath -ArgumentList $VC_redist_exe_Argument

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Mozilla Firefox Extensions: Initiating'); [Console]::ResetColor(); [Console]::WriteLine()
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Firefox/Extensions.ps1')

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Google Chrome Extensions: Initiating'); [Console]::ResetColor(); [Console]::WriteLine()
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Chrome/Extensions.ps1')

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Software Selection: Initiating'); [Console]::ResetColor(); [Console]::WriteLine()
Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software_Selection.ps1')
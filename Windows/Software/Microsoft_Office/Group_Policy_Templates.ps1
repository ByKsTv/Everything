$DDL = ([regex]::Matches((Invoke-WebRequest -UseBasicParsing 'https://www.microsoft.com/en-us/download/details.aspx?id=49030').Content, 'https?://\S+?\.exe').Value | Where-Object { $_ -match 'x64' })
$FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
$SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Administrative Template files (ADMX/ADML) for Microsoft Office'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

$Destination = [IO.Path]::Combine([IO.Path]::GetDirectoryName($SavePath), [IO.Path]::GetFileNameWithoutExtension($SavePath))
$Argument = "/quiet /extract:$Destination"
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Administrative Template files (ADMX/ADML) for Microsoft Office'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Destination'"); [Console]::ResetColor(); [Console]::WriteLine()
Start-Process $SavePath -ArgumentList $Argument -Wait

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Administrative Template files (ADMX/ADML) for Microsoft Office'"); [Console]::ResetColor(); [Console]::WriteLine()
Copy-Item "$Destination\admx\*.admx" "$env:windir\PolicyDefinitions" -Force
Copy-Item "$Destination\admx\en-us\*.adml" "$env:windir\PolicyDefinitions\en-US" -Force

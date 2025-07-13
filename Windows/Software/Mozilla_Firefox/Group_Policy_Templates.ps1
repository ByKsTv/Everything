$DDL = Invoke-RestMethod -Uri 'https://api.github.com/repos/mozilla/policy-templates/releases/latest' | Select-Object -ExpandProperty 'assets' | Where-Object { $_.name -match 'policy_templates' } | Select-Object -ExpandProperty 'browser_download_url'
$FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
$SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

$ExtractPath = Join-Path -Path (Split-Path $SavePath -Parent) -ChildPath ([IO.Path]::GetFileNameWithoutExtension($SavePath))
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ExtractPath'"); [Console]::ResetColor(); [Console]::WriteLine()
Expand-Archive -Path $SavePath -DestinationPath $ExtractPath -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Mozilla Firefox Policy Templates'"); [Console]::ResetColor(); [Console]::WriteLine()
Copy-Item "$ExtractPath\windows\*.admx" "$env:windir\PolicyDefinitions" -Force
Copy-Item "$ExtractPath\windows\en-US\*.adml" "$env:windir\PolicyDefinitions\en-US" -Force
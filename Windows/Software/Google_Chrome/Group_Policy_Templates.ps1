$GoogleChrome_PolicyTemplates_DDL = 'https://dl.google.com/dl/edgedl/chrome/policy/policy_templates.zip'
$GoogleChrome_PolicyTemplates_Filename = [IO.Path]::GetFileName(([URI]$GoogleChrome_PolicyTemplates_DDL).AbsolutePath)
$GoogleChrome_PolicyTemplates_SavePath = [IO.Path]::Combine($env:TEMP, $GoogleChrome_PolicyTemplates_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$GoogleChrome_PolicyTemplates_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$GoogleChrome_PolicyTemplates_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$GoogleChrome_PolicyTemplates_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($GoogleChrome_PolicyTemplates_DDL, $GoogleChrome_PolicyTemplates_SavePath)
        
$GoogleChrome_PolicyTemplates_Dir = $GoogleChrome_PolicyTemplates_SavePath.TrimEnd('.zip')
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$GoogleChrome_PolicyTemplates_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$GoogleChrome_PolicyTemplates_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$GoogleChrome_PolicyTemplates_Dir'"); [Console]::ResetColor(); [Console]::WriteLine()
Expand-Archive -Path $GoogleChrome_PolicyTemplates_SavePath -DestinationPath $GoogleChrome_PolicyTemplates_Dir -Force
        
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Google Chrome Policy Templates'"); [Console]::ResetColor(); [Console]::WriteLine()
Copy-Item "$GoogleChrome_PolicyTemplates_Dir\windows\admx\*.admx" "$env:windir\PolicyDefinitions" -Force
Copy-Item "$GoogleChrome_PolicyTemplates_Dir\windows\admx\en-US\*.adml" "$env:windir\PolicyDefinitions\en-US" -Force
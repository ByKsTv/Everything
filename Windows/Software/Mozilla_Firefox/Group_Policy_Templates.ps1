$Firefox_PolicyTemplates_DDL = ((Invoke-RestMethod -Uri 'https://api.github.com/repos/mozilla/policy-templates/releases/latest').assets | Where-Object name -Like 'policy_templates*').browser_download_url
$Firefox_PolicyTemplates_Filename = [IO.Path]::GetFileName(([URI]$Firefox_PolicyTemplates_DDL).AbsolutePath)
$Firefox_PolicyTemplates_SavePath = [IO.Path]::Combine($env:TEMP, $Firefox_PolicyTemplates_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_PolicyTemplates_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_PolicyTemplates_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_PolicyTemplates_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($Firefox_PolicyTemplates_DDL, $Firefox_PolicyTemplates_SavePath)

$Firefox_PolicyTemplates_Dir = $Firefox_PolicyTemplates_SavePath.TrimEnd('.zip')
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_PolicyTemplates_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_PolicyTemplates_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Firefox_PolicyTemplates_Dir'"); [Console]::ResetColor(); [Console]::WriteLine()
Expand-Archive -Path $Firefox_PolicyTemplates_SavePath -DestinationPath $Firefox_PolicyTemplates_Dir -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Mozilla Firefox Policy Templates'"); [Console]::ResetColor(); [Console]::WriteLine()
Copy-Item "$Firefox_PolicyTemplates_Dir\windows\*.admx" "$env:windir\PolicyDefinitions" -Force
Copy-Item "$Firefox_PolicyTemplates_Dir\windows\en-US\*.adml" "$env:windir\PolicyDefinitions\en-US" -Force
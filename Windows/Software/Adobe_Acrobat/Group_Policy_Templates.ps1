# https://www.adobe.com/devnet-docs/acrobatetk/tools/PrefRef/Windows/index.html
# https://www.adobe.com/devnet-docs/acrobatetk/tools/PrefRef/Windows/FeatureLockDown.html#idkeyname_1_13262
$DDL = 'https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/misc/AcrobatADMTemplate.zip'
$FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
$SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)
        
$ExtractPath = [IO.Path]::Combine([IO.Path]::GetDirectoryName($SavePath), [IO.Path]::GetFileNameWithoutExtension($SavePath))
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ExtractPath'"); [Console]::ResetColor(); [Console]::WriteLine()
Expand-Archive -Path $SavePath -DestinationPath $ExtractPath -Force
        
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Adobe Acrobat Policy Templates'"); [Console]::ResetColor(); [Console]::WriteLine()
Copy-Item "$ExtractPath\*.admx" "$env:windir\PolicyDefinitions" -Force
Copy-Item "$ExtractPath\*.adm" "$env:windir\PolicyDefinitions" -Force
Copy-Item "$ExtractPath\en-US\*.adml" "$env:windir\PolicyDefinitions\en-US" -Force
# https://www.adobe.com/devnet-docs/acrobatetk/tools/PrefRef/Windows/index.html
# https://www.adobe.com/devnet-docs/acrobatetk/tools/PrefRef/Windows/FeatureLockDown.html#idkeyname_1_13262
$AdobeAcrobat_PolicyTemplates_DDL = 'https://ardownload2.adobe.com/pub/adobe/acrobat/win/AcrobatDC/misc/AcrobatADMTemplate.zip'
$AdobeAcrobat_PolicyTemplates_Filename = [IO.Path]::GetFileName(([URI]$AdobeAcrobat_PolicyTemplates_DDL).AbsolutePath)
$AdobeAcrobat_PolicyTemplates_SavePath = [IO.Path]::Combine($env:TEMP, $AdobeAcrobat_PolicyTemplates_Filename)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AdobeAcrobat_PolicyTemplates_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AdobeAcrobat_PolicyTemplates_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AdobeAcrobat_PolicyTemplates_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($AdobeAcrobat_PolicyTemplates_DDL, $AdobeAcrobat_PolicyTemplates_SavePath)
        
$AdobeAcrobat_PolicyTemplates_Dir = $AdobeAcrobat_PolicyTemplates_SavePath.TrimEnd('.zip')
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AdobeAcrobat_PolicyTemplates_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AdobeAcrobat_PolicyTemplates_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$AdobeAcrobat_PolicyTemplates_Dir'"); [Console]::ResetColor(); [Console]::WriteLine()
Expand-Archive -Path $AdobeAcrobat_PolicyTemplates_SavePath -DestinationPath $AdobeAcrobat_PolicyTemplates_Dir -Force
        
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Adobe Acrobat Policy Templates'"); [Console]::ResetColor(); [Console]::WriteLine()
Copy-Item "$AdobeAcrobat_PolicyTemplates_Dir\*.admx" "$env:windir\PolicyDefinitions" -Force
Copy-Item "$AdobeAcrobat_PolicyTemplates_Dir\*.adm" "$env:windir\PolicyDefinitions" -Force
Copy-Item "$AdobeAcrobat_PolicyTemplates_Dir\en-US\*.adml" "$env:windir\PolicyDefinitions\en-US" -Force
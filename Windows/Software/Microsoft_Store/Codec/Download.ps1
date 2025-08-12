# https://www.codecguide.com/media_foundation_codecs.htm
$DDL1 = 'https://www.dropbox.com/scl/fi/q4rjngx9q70stpo8gqlws/Media_Foundation_Codecs.zip?rlkey=206stwfy6mkem0t2aqcypeua6&st=ukqg635a&dl=0'
$DDL = $DDL1.Replace('www.dropbox.com', 'dl.dropboxusercontent.com').Replace('dl=0', 'dl=1')
$FileName = [IO.Path]::GetFileName(([URI]$DDL).AbsolutePath)
$SavePath = [IO.Path]::Combine($env:TEMP, $FileName)
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
(New-Object System.Net.WebClient).DownloadFile($DDL, $SavePath)

Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/7-Zip/Download.ps1')

$ExtractPath = [IO.Path]::Combine([IO.Path]::GetDirectoryName($SavePath), [IO.Path]::GetFileNameWithoutExtension($SavePath))
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ExtractPath'"); [Console]::ResetColor(); [Console]::WriteLine()
& 7z.exe x $SavePath -o"$ExtractPath" -y

Get-ChildItem -Path $ExtractPath -Recurse -Include '*.appx', '*.appxbundle' | ForEach-Object {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$_'"); [Console]::ResetColor(); [Console]::WriteLine()
    Add-AppxPackage $_.FullName -ErrorAction SilentlyContinue
}

if (-not (Get-AppxPackage -Name 'Microsoft.WindowsStore')) {
    Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Microsoft_Store/Download.ps1')
}
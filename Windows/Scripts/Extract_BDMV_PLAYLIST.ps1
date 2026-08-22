param(
    [Parameter(Mandatory)]
    [string]$BDMV_Playlist_Path,

    [Parameter(Mandatory)]
    [int]$Start_With_Episode_Number
)

$BDMV_Playlist_Path = $BDMV_Playlist_Path.Trim().Trim([char]'"')

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Selected folder '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BDMV_Playlist_Path'"); [Console]::ResetColor(); [Console]::WriteLine()

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Starts from episode '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Start_With_Episode_Number'"); [Console]::ResetColor(); [Console]::WriteLine()

$mplsFiles = Get-ChildItem -LiteralPath $BDMV_Playlist_Path -Recurse -Include '*.mpls'
if ($mplsFiles.Count -eq 0) {
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('No playlist files found in '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BDMV_Playlist_Path'"); [Console]::ResetColor(); [Console]::WriteLine()
    exit
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Found '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$($mplsFiles.Count)'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' playlist files in '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$BDMV_Playlist_Path'"); [Console]::ResetColor(); [Console]::WriteLine()
$processed = $false
foreach ($mplsFile in $mplsFiles) {
    if ($processed) {
        break
    }

    $mplsFilePath = $mplsFile.FullName

    $TaskName = 'Mediainfo Updater'
    if (-not (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue)) {
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/MediaInfo/Download.ps1')
    }

    $mediaInfoOutput = & MediaInfo.exe --Output=JSON "$mplsFilePath"
    if (-not $mediaInfoOutput) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('No output from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'MediaInfo'"); [Console]::WriteLine()
        continue
    }

    try {
        $mediaInfoJson = $mediaInfoOutput | ConvertFrom-Json
        $filteredResults = @()
        foreach ($track in $mediaInfoJson.media.track) {
            if ($track.'@type' -eq 'Video' -and [int]$track.Duration -gt 600) {
                $filteredResults += $track
            }
        }

        $FileNames = @()
        foreach ($result in $filteredResults) {
            if ($result.extra -and $result.extra.source) {
                $FileNames += $result.extra.source
            }
        }

        foreach ($FileName in $FileNames) {
            $filePath = [IO.Path]::GetFullPath([IO.Path]::Combine([IO.Path]::GetDirectoryName($mplsFile.FullName), $FileName))
            $parentFolderPath = (Get-Item -Path ([IO.Path]::GetDirectoryName($filePath))).Parent.FullName
            $streamFolderPath = [IO.Path]::Combine($parentFolderPath, 'STREAM')

            if (-not (Test-Path -Path $streamFolderPath)) {
                [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('STEAM folder not found in '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$streamFolderPath'"); [Console]::WriteLine()
                continue
            }

            $streamFile = Get-ChildItem -Path $streamFolderPath -Filter $FileName
            if ($streamFile) {
                $fileExtension = $streamFile.Extension
                $newFileName = '{0:D3}{1}' -f $Start_With_Episode_Number, $fileExtension
                $newFilePath = [IO.Path]::Combine($streamFolderPath, $newFileName)
                [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Renaming '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$($streamFile.FullName)'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$newFileName'"); [Console]::ResetColor(); [Console]::WriteLine()
                Rename-Item -Path $streamFile.FullName -NewName $newFileName -Force

                $mainFolderPath = (Get-Item -Path $streamFolderPath).Parent.Parent.Parent.Parent.FullName
                [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Moving '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$newFileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$mainFolderPath'"); [Console]::ResetColor(); [Console]::WriteLine()
                Move-Item -Path $newFilePath -Destination ([IO.Path]::Combine($mainFolderPath, $newFileName)) -Force

                $Start_With_Episode_Number++
                $processed = $true
            } else {
                [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Files not found in '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ResetColor(); [Console]::WriteLine()
            }
        }
    } catch {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Failed to convert MediaInfo output to JSON or process the results for file '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$($mplsFile.FullName)'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' Output '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$mediaInfoOutput'"); [Console]::ResetColor(); [Console]::WriteLine()

        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Error '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$_'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' Output '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$mediaInfoOutput'"); [Console]::ResetColor(); [Console]::WriteLine()
    }
}

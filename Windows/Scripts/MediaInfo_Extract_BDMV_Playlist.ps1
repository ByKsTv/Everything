$startNumber = 1 # One above the existing one
$mplsDirectory = 'Path_to_BDMV\PLAYLIST'

# Verify the directory exists
if (-not (Test-Path -Path $mplsDirectory)) {
    Write-Output "The specified directory does not exist: $mplsDirectory"
    exit
}


Write-Output "Searching for .mpls files in directory: $mplsDirectory"

# Get all .mpls files in the specified directory and subdirectories
$mplsFiles = Get-ChildItem -Path $mplsDirectory -Recurse -Include *.mpls

# Check if any .mpls files were found
if ($mplsFiles.Count -eq 0) {
    Write-Output "No .mpls files found in the specified directory: $mplsDirectory"
    exit
}

Write-Output "Found $($mplsFiles.Count) .mpls files in the directory: $mplsDirectory"

$processed = $false

foreach ($mplsFile in $mplsFiles) {
    if ($processed) {
        break
    }

    Write-Output "Processing file: $($mplsFile.FullName)"

    # Remove the \\?\ prefix for MediaInfo processing
    $mplsFilePath = $mplsFile.FullName

    # Run MediaInfo with JSON output and capture the output
    $mediaInfoOutput = & MediaInfo.exe --Output=JSON "$mplsFilePath"

    # Check if the output is empty or invalid
    if (-not $mediaInfoOutput) {
        Write-Output "No output from MediaInfo for file $($mplsFile.FullName). Please check the file path and MediaInfo executable path."
        continue
    }

    try {
        # Convert the MediaInfo output to JSON
        $mediaInfoJson = $mediaInfoOutput | ConvertFrom-Json

        # Filter results and search for entries with @type as Video and Duration more than 600
        $filteredResults = @()
        foreach ($track in $mediaInfoJson.media.track) {
            if ($track.'@type' -eq 'Video' -and [int]$track.Duration -gt 600) {
                $filteredResults += $track
            }
        }

        # Initialize an array to hold the file names
        $fileNames = @()

        # Extract the name of the file from each filtered result
        foreach ($result in $filteredResults) {
            if ($result.extra -and $result.extra.source) {
                $fileNames += $result.extra.source
            }
        }

        # Output the file names
        $fileNames | ForEach-Object { Write-Output $_ }

        # Navigate to the STREAM folder based on the file paths
        foreach ($fileName in $fileNames) {
            $filePath = [IO.Path]::GetFullPath((Join-Path -Path (Split-Path -Path $mplsFile.FullName -Parent) -ChildPath $fileName))
            $parentFolderPath = (Get-Item -Path (Split-Path -Path $filePath -Parent)).Parent.FullName
            $streamFolderPath = Join-Path -Path $parentFolderPath -ChildPath 'STREAM'

            if (-not (Test-Path -Path $streamFolderPath)) {
                Write-Output "STREAM folder not found: $streamFolderPath"
                continue
            }

            Write-Output "STREAM folder found: $streamFolderPath"

            # Get the file in the STREAM folder
            $streamFile = Get-ChildItem -Path $streamFolderPath -Filter $fileName

            if ($streamFile) {
                $fileExtension = $streamFile.Extension
                $newFileName = '{0:D3}{1}' -f $startNumber, $fileExtension
                $newFilePath = Join-Path -Path $streamFolderPath -ChildPath $newFileName

                Write-Output "Renaming file from $($streamFile.FullName) to $newFilePath"

                # Rename the file
                Rename-Item -Path $streamFile.FullName -NewName $newFileName -Force
                Write-Output "Renamed file to $newFilePath"

                # Move the file to the main folder four levels up
                $mainFolderPath = (Get-Item -Path $streamFolderPath).Parent.Parent.Parent.Parent.FullName
                Move-Item -Path $newFilePath -Destination (Join-Path -Path $mainFolderPath -ChildPath $newFileName) -Force
                Write-Output "Moved file $newFileName to $mainFolderPath"

                # Increment the start number for the next file
                $startNumber++
                $processed = $true
            }
            else {
                Write-Output "File not found in STREAM folder: $fileName"
            }
        }
    }
    catch {
        Write-Output "Failed to convert MediaInfo output to JSON or process the results for file $($mplsFile.FullName). Output: $mediaInfoOutput"
        Write-Output "Error: $_"
    }
}

Write-Output 'Processing completed.'

Add-Type -AssemblyName System.Windows.Forms
[Windows.Forms.Application]::EnableVisualStyles()

$BDMV_PLAYLIST_FileDialog = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    FileName        = 'Select PLAYLIST Folder'
    CheckFileExists = $false
    ValidateNames   = $false
}
$BDMV_PLAYLIST_Form = New-Object System.Windows.Forms.Form -Property @{ 
    TopMost       = $true
    ShowInTaskbar = $false
    Opacity       = 0 
}
$BDMV_PLAYLIST_Form.Show()
$BDMV_PLAYLIST_OK = $BDMV_PLAYLIST_FileDialog.ShowDialog($BDMV_PLAYLIST_Form)
$BDMV_PLAYLIST_Form.Dispose()

if ($BDMV_PLAYLIST_OK -eq [Windows.Forms.DialogResult]::OK) {
    $BDMV_PLAYLIST_FolderSelected = [IO.Path]::GetDirectoryName($BDMV_PLAYLIST_FileDialog.FileName)

    Write-Output "Selected Folder: $BDMV_PLAYLIST_FolderSelected"

    $BDMV_Episode_Form = New-Object System.Windows.Forms.Form -Property @{
        Text            = 'Select Episode'
        Font            = [Drawing.Font]::new('Tahoma', 11)
        Width           = 300
        Height          = 120
        StartPosition   = 'CenterScreen'
        FormBorderStyle = 'FixedDialog'
        Topmost         = $true
        MaximizeBox     = $false
        MinimizeBox     = $false
        ControlBox      = $false
    }
    
    $BDMV_Episode_Form_ButtonSpacer = 15
    $BDMV_Episode_Form_ButtonWidth = 57
    $BDMV_Episode_Form_TotalButtonWidth = $BDMV_Episode_Form_ButtonSpacer + $BDMV_Episode_Form_ButtonWidth + $BDMV_Episode_Form_ButtonWidth
    $BDMV_Episode_FormCenterX = [math]::Round(($BDMV_Episode_Form.ClientSize.Width - $BDMV_Episode_Form_TotalButtonWidth) / 2)
    $BDMV_Episode_Form_ButtonHeight = 20
    $BDMV_Episode_Form_ButtonYLocation = $BDMV_Episode_Form.Height - 60
    
    $BDMV_Episode_OK_Click = $false
    $BDMV_Episode_Form_OK = New-Object System.Windows.Forms.Button -Property @{
        Text      = 'OK'
        Width     = $BDMV_Episode_Form_ButtonWidth
        Height    = $BDMV_Episode_Form_ButtonHeight
        Location  = [Drawing.Point]::new($BDMV_Episode_FormCenterX, $BDMV_Episode_Form_ButtonYLocation)
        Add_Click = ({ $BDMV_Episode_Form.Close()
                $global:BDMV_Episode_OK_Click = $true })
    }

    $BDMV_Episode_Form_CancelX = $BDMV_Episode_FormCenterX + $BDMV_Episode_Form_ButtonWidth + $BDMV_Episode_Form_ButtonSpacer
    $BDMV_Episode_Form_Cancel = New-Object System.Windows.Forms.Button -Property @{
        Text      = 'Cancel'
        Width     = $BDMV_Episode_Form_ButtonWidth
        Height    = $BDMV_Episode_Form_ButtonHeight
        Location  = [Drawing.Point]::new($BDMV_Episode_Form_CancelX, $BDMV_Episode_Form_ButtonYLocation)
        Add_Click = ({ $BDMV_Episode_Form.Close() })
    }
        
    $BDMV_Episode_Form_LocX = 5
    $BDMV_Episode_Form_LocY = 0
    $BDMV_Episode_Form_SizeX = $BDMV_Episode_Form.Width - 25
    $BDMV_Episode_Form_SizeY = 26
    $BDMV_Episode_Form__LocAdd = 30
        
    $BDMV_Episode_Form_Label = New-Object System.Windows.Forms.Label -Property @{
        Text     = 'Starts from episode:'
        AutoSize = $true
        Width    = $BDMV_Episode_Form_SizeX
        Height   = $BDMV_Episode_Form_SizeY
        Location = [Drawing.Point]::new($BDMV_Episode_Form_LocX, $BDMV_Episode_Form_LocY)
    }
    
    $BDMV_Episode_Form_LocY += $BDMV_Episode_Form__LocAdd
    
    $BDMV_Episode_Form_TextBox = New-Object System.Windows.Forms.TextBox -Property @{
        Width    = $BDMV_Episode_Form_SizeX
        Height   = $BDMV_Episode_Form_SizeY
        Location = [Drawing.Point]::new($BDMV_Episode_Form_LocX, $BDMV_Episode_Form_LocY)
    }
    
    $BDMV_Episode_Form.Controls.Add($BDMV_Episode_Form_OK)
    $BDMV_Episode_Form.Controls.Add($BDMV_Episode_Form_Cancel)
    
    $BDMV_Episode_Form.Controls.Add($BDMV_Episode_Form_Label)
    $BDMV_Episode_Form.Controls.Add($BDMV_Episode_Form_TextBox)

    [void] $BDMV_Episode_Form.ShowDialog()

    if ($true -eq $BDMV_Episode_OK_Click) {
        
        $BDMV_Episode_Form.Topmost = $false

        $ChosenNumber = $BDMV_Episode_Form_TextBox.Text

        $ChosenNumber = [int]$ChosenNumber
        Write-Output "Starts from episode: $ChosenNumber"

        Write-Output "Searching for .mpls files in directory: $BDMV_PLAYLIST_FolderSelected"

        # Get all .mpls files in the specified directory and subdirectories
        $mplsFiles = Get-ChildItem -Path $BDMV_PLAYLIST_FolderSelected -Recurse -Include *.mpls

        # Check if any .mpls files were found
        if ($mplsFiles.Count -eq 0) {
            Write-Output "No .mpls files found in the specified directory: $BDMV_PLAYLIST_FolderSelected"
            exit
        }

        Write-Output "Found $($mplsFiles.Count) .mpls files in the directory: $BDMV_PLAYLIST_FolderSelected"

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
                        $newFileName = '{0:D3}{1}' -f $ChosenNumber, $fileExtension
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
                        $ChosenNumber++
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
    }
}
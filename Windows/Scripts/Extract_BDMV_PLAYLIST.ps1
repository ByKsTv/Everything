Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object System.Windows.Forms.Form -Property @{
    TopMost       = $true
    StartPosition = 'CenterScreen'
}

$FileDialog = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    FileName        = 'Select PLAYLIST Folder'
    Title           = 'Extract BDMV Playlist'
    Filter          = 'Folders|*.'
    CheckFileExists = $false
}

if ($FileDialog.ShowDialog($Form) -eq [Windows.Forms.DialogResult]::OK) {
    $SelectedFolder = [IO.Path]::GetDirectoryName($FileDialog.FileName)
    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Selected folder '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SelectedFolder'"); [Console]::ResetColor(); [Console]::WriteLine()

    $Form = New-Object System.Windows.Forms.Form -Property @{
        Text            = 'Starts From Episode'
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

    $ButtonWidth = 57
    $ButtonSpacer = 15
    $ButtonY = $Form.Height - 60
    $ButtonX = [math]::Round(($Form.ClientSize.Width - (2 * $ButtonWidth + $ButtonSpacer)) / 2)

    $Ok = New-Object System.Windows.Forms.Button -Property @{
        Text         = 'OK'
        DialogResult = [Windows.Forms.DialogResult]::OK
        Width        = $ButtonWidth
        Height       = 20
        Location     = [Drawing.Point]::new($ButtonX, $ButtonY)
        Add_Click    = { $Form.Close() }
    }

    $Cancel = New-Object System.Windows.Forms.Button -Property @{
        Text      = 'Cancel'
        Width     = $ButtonWidth
        Height    = 20
        Location  = [Drawing.Point]::new($ButtonX + $ButtonWidth + $ButtonSpacer, $ButtonY)
        Add_Click = { $Form.Close() }
    }

    $LocX = 5
    $LocY = 0
    $SizeX = $Form.Width - 25
    $SizeY = 26
    $_LocAdd = 30
        
    $Label = New-Object System.Windows.Forms.Label -Property @{
        Text     = 'Starts From Episode:'
        AutoSize = $true
        Width    = $SizeX
        Height   = $SizeY
        Location = [Drawing.Point]::new($LocX, $LocY)
    }
    
    $LocY += $_LocAdd
    
    $TextBox = New-Object System.Windows.Forms.TextBox -Property @{
        Width    = $SizeX
        Height   = $SizeY
        Location = [Drawing.Point]::new($LocX, $LocY)
    }
    $Form.Add_Shown({ $TextBox.Focus() })

    $Form.Controls.AddRange(@($Ok, $Cancel, $Label, $TextBox))
    if ($Form.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
        $ChosenNumber = [int]$TextBox.Text
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Starts from episode '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$ChosenNumber'"); [Console]::ResetColor(); [Console]::WriteLine()

        $mplsFiles = Get-ChildItem -Path $SelectedFolder -Recurse -Include '*.mpls'
        if ($mplsFiles.Count -eq 0) {
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('No playlist files found in '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SelectedFolder'"); [Console]::ResetColor(); [Console]::WriteLine()
            exit
        }

        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Found '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$($mplsFiles.Count)'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' playlist files in '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$SelectedFolder'"); [Console]::ResetColor(); [Console]::WriteLine()
        $processed = $false
        foreach ($mplsFile in $mplsFiles) {
            if ($processed) {
                break
            }

            $mplsFilePath = $mplsFile.FullName

            Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/MediaInfo/Download.ps1')
            
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
                        $newFileName = '{0:D3}{1}' -f $ChosenNumber, $fileExtension
                        $newFilePath = [IO.Path]::Combine($streamFolderPath, $newFileName)
                        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Renaming '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$($streamFile.FullName)'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$newFileName'"); [Console]::ResetColor(); [Console]::WriteLine()
                        Rename-Item -Path $streamFile.FullName -NewName $newFileName -Force

                        $mainFolderPath = (Get-Item -Path $streamFolderPath).Parent.Parent.Parent.Parent.FullName
                        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Moving '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$newFileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$mainFolderPath'"); [Console]::ResetColor(); [Console]::WriteLine()
                        Move-Item -Path $newFilePath -Destination ([IO.Path]::Combine($mainFolderPath, $newFileName)) -Force

                        $ChosenNumber++
                        $processed = $true
                    }
                    else {
                        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Files not found in '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$FileName'"); [Console]::ResetColor(); [Console]::WriteLine()
                    }
                }
            }
            catch {
                [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Failed to convert MediaInfo output to JSON or process the results for file '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$($mplsFile.FullName)'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' Output '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$mediaInfoOutput'"); [Console]::ResetColor(); [Console]::WriteLine()

                [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Error '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$_'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' Output '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$mediaInfoOutput'"); [Console]::ResetColor(); [Console]::WriteLine()
            }
        }
    }
}
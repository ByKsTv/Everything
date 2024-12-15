Add-Type -AssemblyName System.Windows.Forms
[Windows.Forms.Application]::EnableVisualStyles()

$Subtitles_Sorting_Form = New-Object System.Windows.Forms.Form -Property @{
    TopMost = $true
}
$Subtitles_Sorting_OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    FileName        = 'Select Folder'
    Filter          = 'Folders|*.'
    CheckFileExists = $false
}

if ($Subtitles_Sorting_OpenFileDialog.ShowDialog($Subtitles_Sorting_Form) -eq [Windows.Forms.DialogResult]::OK) {
    $Subtitles_Sorting_Dir = [IO.Path]::GetDirectoryName($Subtitles_Sorting_OpenFileDialog.FileName)

    $Subtitles_Sorting_FontsDir = [IO.Path]::Combine($Subtitles_Sorting_Dir, 'Fonts')
    $Subtitles_Sorting_SubsDir = [IO.Path]::Combine($Subtitles_Sorting_Dir, 'Subs')

    if (-not (Test-Path $Subtitles_Sorting_FontsDir)) {
        New-Item -ItemType Directory -Path $Subtitles_Sorting_FontsDir -Force | Out-Null
    }

    $Subtitles_Sorting_FontsExt = @('.otf', '.ttf', '.woff', '.woff2', '.eot', '.ttc')

    Get-ChildItem -Path $Subtitles_Sorting_Dir -Recurse -File | ForEach-Object {
        if ($Subtitles_Sorting_FontsExt -contains $_.Extension.ToLower()) {
            $source_file = $_.FullName
            $destination_file = Join-Path $Subtitles_Sorting_FontsDir $_.Name

            Write-Host "Copying: $source_file to $destination_file"
            Copy-Item -Path $source_file -Destination $destination_file -Force
        }
    }

    $Subtitles_Sorting_VideoFiles = Get-ChildItem -Path $Subtitles_Sorting_Dir -File | Where-Object { $_.Extension -in @('.mkv', '.m2ts') } | Sort-Object Name

    Write-Host 'Video files:'
    foreach ($Subtitles_Sorting_VideoFile in $Subtitles_Sorting_VideoFiles) {
        Write-Host $Subtitles_Sorting_VideoFile.Name
    }

    Get-ChildItem -Path $Subtitles_Sorting_SubsDir -Recurse -Directory | ForEach-Object {
        $subdir = $_
        $eng_subs = Get-ChildItem -Path $subdir.FullName -File | Where-Object { $_.Name -like '*eng*' -and $_.Extension -in @('.srt', '.sub', '.idx', '.ass', '.sup') }

        if (-not $eng_subs) {
            Write-Host "No 'eng' subtitle found. Searching for 'und' subtitle files in $($subdir.FullName)."
            $eng_subs = Get-ChildItem -Path $subdir.FullName -File | Where-Object { $_.Name -like '*und*' -and $_.Extension -in @('.srt', '.sub', '.idx', '.ass', '.sup') }
        }

        if ($eng_subs) {
            $largest_sub = $eng_subs | Sort-Object Length -Descending | Select-Object -First 1

            $video_file = $Subtitles_Sorting_VideoFiles | Select-Object -First 1
            if ($video_file) {
                $new_subtitle_name = [IO.Path]::GetFileNameWithoutExtension($video_file.Name) + '.eng' + $largest_sub.Extension
                $new_subtitle_path = Join-Path $Subtitles_Sorting_SubsDir $new_subtitle_name

                Write-Host "Renaming $($largest_sub.FullName) to $new_subtitle_path"
                Move-Item -Path $largest_sub.FullName -Destination $new_subtitle_path -Force

                $Subtitles_Sorting_VideoFiles = $Subtitles_Sorting_VideoFiles | Where-Object { $_.FullName -ne $video_file.FullName }
            }
        }
    }
}

$Subtitles_Sorting_Form.Dispose()
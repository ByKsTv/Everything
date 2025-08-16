Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object System.Windows.Forms.Form -Property @{
    TopMost       = $true
    StartPosition = 'CenterScreen'
}

$FolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
    Description         = 'Select the TV Show folder'
    ShowNewFolderButton = $false
}

if ($FolderDialog.ShowDialog($Form) -eq [Windows.Forms.DialogResult]::OK) {
    $TVShow_Path = $FolderDialog.SelectedPath
    $Fonts_Path = [IO.Path]::Combine($TVShow_Path, 'Fonts')
    $Subs_Path = [IO.Path]::Combine($TVShow_Path, 'Subs')

    if (-not (Test-Path $Fonts_Path)) {
        New-Item -ItemType Directory -Path $Fonts_Path | Out-Null
    }

    $Fonts_Extensions = '.otf', '.ttf', '.woff', '.woff2', '.eot', '.ttc'
    Get-ChildItem -Path $Subs_Path -Recurse -File | ForEach-Object {
        if ($Fonts_Extensions -contains $_.Extension.ToLower()) {
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Copying '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$($_.FullName)'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$([IO.Path]::Combine($Fonts_Path, $_.Name))'"); [Console]::ResetColor(); [Console]::WriteLine()
            Copy-Item -LiteralPath $_.FullName -Destination ([IO.Path]::Combine($Fonts_Path, $_.Name)) -ErrorAction SilentlyContinue
        }
    }

    $Video_Files = Get-ChildItem $TVShow_Path -File | Where-Object { $_.Extension -in '.mkv', '.m2ts' } | Sort-Object Name
    Get-ChildItem $Subs_Path -Directory -Recurse | Sort-Object Name | ForEach-Object {
        $ENG_Subs = Get-ChildItem -LiteralPath $_.FullName -File | Where-Object { $_.Name -match 'eng' -and $_.Extension -in '.srt', '.sub', '.idx', '.ass', '.sup' }
        if (-not $ENG_Subs) {
            $ENG_Subs = Get-ChildItem -LiteralPath $_.FullName -File | Where-Object { $_.Name -match 'und' -and $_.Extension -in '.srt', '.sub', '.idx', '.ass', '.sup' }
        }
        if ($ENG_Subs) {
            $largest_sub = $ENG_Subs | Sort-Object Length -Descending | Select-Object -First 1
            $new_subtitle_name = ($Video_Files[0].BaseName) + '.eng' + $largest_sub.Extension
            $old_subtitle_path = $largest_sub.FullName
            $new_subtitle_path = [IO.Path]::Combine($Subs_Path, $new_subtitle_name)
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Moving '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$old_subtitle_path'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$new_subtitle_path'"); [Console]::ResetColor(); [Console]::WriteLine()
            Move-Item -LiteralPath $old_subtitle_path $new_subtitle_path
            $Video_Files = $Video_Files | Select-Object -Skip 1
        }
    }
}
param(
    [Parameter(Mandatory)]
    [string]$TVShow_Path
)

$TVShow_Path = $TVShow_Path.Trim().Trim([char]'"')

$Fonts_Path = [IO.Path]::Combine($TVShow_Path, 'Fonts')
$Subs_Path = [IO.Path]::Combine($TVShow_Path, 'Subs')

if (-not (Test-Path -LiteralPath $Fonts_Path -PathType Container)) {
    $null = New-Item -ItemType Directory -Path $Fonts_Path
}

if (Test-Path -LiteralPath $Subs_Path -PathType Container) {
    $Font_Files = Get-ChildItem -LiteralPath $Subs_Path -Recurse -File | Where-Object {
        $_.Extension -match '^\.(otf|ttf|woff2?|eot|ttc)$'
    }

    foreach ($Font_File in $Font_Files) {
        $Font_Destination = [IO.Path]::Combine($Fonts_Path, $Font_File.Name)
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Copying '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$($Font_File.FullName)'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Font_Destination'"); [Console]::ResetColor(); [Console]::WriteLine()
        Copy-Item -LiteralPath $Font_File.FullName -Destination $Font_Destination -ErrorAction SilentlyContinue
    }

    $Video_Files = @(Get-ChildItem -LiteralPath $TVShow_Path -File | Where-Object {
            $_.Extension -match '^\.(mkv|m2ts)$'
        } | Sort-Object Name)

    $Subtitle_Directories = @(Get-ChildItem -LiteralPath $Subs_Path -Directory -Recurse | Sort-Object Name)
    $Video_Index = 0

    foreach ($Subtitle_Directory in $Subtitle_Directories) {
        if ($Video_Index -ge $Video_Files.Count) {
            break
        }

        $ENG_Subs = @(Get-ChildItem -LiteralPath $Subtitle_Directory.FullName -File | Where-Object {
                $_.Name -match 'eng' -and $_.Extension -match '^\.(srt|sub|idx|ass|sup)$'
            })

        if ($ENG_Subs.Count -eq 0) {
            $ENG_Subs = @(Get-ChildItem -LiteralPath $Subtitle_Directory.FullName -File | Where-Object {
                    $_.Name -match 'und' -and $_.Extension -match '^\.(srt|sub|idx|ass|sup)$'
                })
        }

        if ($ENG_Subs.Count -gt 0) {
            $Largest_Sub = $ENG_Subs | Sort-Object Length -Descending | Select-Object -First 1
            $New_Subtitle_Path = [IO.Path]::Combine($Subs_Path, "$($Video_Files[$Video_Index].BaseName).eng$($Largest_Sub.Extension)")
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Moving '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$($Largest_Sub.FullName)'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$New_Subtitle_Path'"); [Console]::ResetColor(); [Console]::WriteLine()
            Move-Item -LiteralPath $Largest_Sub.FullName -Destination $New_Subtitle_Path
            $Video_Index++
        }
    }
}

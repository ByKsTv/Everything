
Add-Type -AssemblyName System.Windows.Forms

# Check FFmpeg is installed
if (-not (Get-Command ffmpeg.exe -ErrorAction SilentlyContinue)) {
    Write-Host 'ERROR: ffmpeg.exe was not found.' -ForegroundColor Red
    exit
}

# Choose folder containing videos
$FolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
$FolderDialog.Description = 'Choose folder containing video files'

if ($FolderDialog.ShowDialog() -ne 'OK') {
    exit
}

$FolderPath = $FolderDialog.SelectedPath

# Find video files and sort by filename
$Extensions = @('.mp4', '.mkv', '.mov', '.avi', '.m4v', '.ts', '.webm')

$Videos = @(
    Get-ChildItem -LiteralPath $FolderPath -File |
        Where-Object { $_.Extension.ToLowerInvariant() -in $Extensions } |
        Sort-Object Name
)

if ($Videos.Count -lt 2) {
    Write-Host 'ERROR: At least two video files are required.' -ForegroundColor Red
    exit
}

# Choose output location
$SaveDialog = New-Object System.Windows.Forms.SaveFileDialog
$SaveDialog.Title = 'Choose output location'
$SaveDialog.Filter = 'Matroska Video (*.mkv)|*.mkv'
$SaveDialog.InitialDirectory = $FolderPath
$SaveDialog.FileName = ((Split-Path $FolderPath -Leaf) + '.combined.mkv')

if ($SaveDialog.ShowDialog() -ne 'OK') {
    exit
}

$SavePath = $SaveDialog.FileName

# Prevent overwriting an input video
if ($Videos.FullName -contains $SavePath) {
    Write-Host 'ERROR: Output file cannot be one of the input files.' -ForegroundColor Red
    exit
}

# Create temporary FFmpeg concat list
$ListPath = Join-Path $env:TEMP ('ffconcat_' + [guid]::NewGuid().ToString('N') + '.txt')

try {
    $Lines = @(
        foreach ($Video in $Videos) {
            $EscapedPath = $Video.FullName.Replace('\', '/').Replace("'", "'\''")
            "file '$EscapedPath'"
        }
    )

    # Write UTF-8 without BOM
    [System.IO.File]::WriteAllLines(
        $ListPath,
        [string[]]$Lines,
        (New-Object System.Text.UTF8Encoding($false))
    )

    Write-Host ''
    Write-Host 'Starting FFmpeg' -ForegroundColor Green
    Write-Host "Source folder: $FolderPath" -ForegroundColor Yellow
    Write-Host "Output file: $SavePath" -ForegroundColor Yellow
    Write-Host "Videos found: $($Videos.Count)" -ForegroundColor Cyan
    Write-Host ''

    foreach ($Video in $Videos) {
        Write-Host " + $($Video.Name)" -ForegroundColor Gray
    }

    Write-Host ''
    Write-Host 'Merging videos...' -ForegroundColor Green

    # Combine all videos sequentially
    & ffmpeg.exe -hide_banner -y -f concat -safe 0 -i $ListPath -map 0 -c copy $SavePath

    if ($LASTEXITCODE -eq 0) {
        Write-Host ''
        Write-Host 'SUCCESS! Videos merged.' -ForegroundColor Green
        Write-Host "Output: $SavePath" -ForegroundColor Yellow
    } else {
        Write-Host ''
        Write-Host 'ERROR: FFmpeg failed to merge the videos.' -ForegroundColor Red
    }
} finally {
    # Delete temporary list
    if (Test-Path -LiteralPath $ListPath) {
        Remove-Item -LiteralPath $ListPath -Force
    }
}

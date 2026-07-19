# input and output files
Set-Location 'path'
$InputFile = 'output.mp4'
$OutputFile = 'output2.mp4'

# Target size in MB
$TargetMB = 179

# Safety margin so the file stays under the limit
$TargetMB = $TargetMB - 2

# Audio bitrate in kbps
$AudioBitrateKbps = 128

# Get duration in seconds
$Duration = ffprobe -v error `
    -show_entries format=duration `
    -of default=noprint_wrappers=1:nokey=1 `
    "$InputFile"

$Duration = [double]$Duration

if ($Duration -le 0) {
    Write-Error 'Could not detect video duration.'
    exit 1
}

# Convert target size to kilobits
# MB -> bytes -> bits -> kilobits
$TargetKilobits = $TargetMB * 1024 * 1024 * 8 / 1000

# Total bitrate needed
$TotalBitrateKbps = $TargetKilobits / $Duration

# Video bitrate = total bitrate - audio bitrate
$VideoBitrateKbps = [math]::Floor($TotalBitrateKbps - $AudioBitrateKbps)

if ($VideoBitrateKbps -lt 100) {
    Write-Error "Video is too long for 179 MB with $AudioBitrateKbps kbps audio."
    exit 1
}

Write-Host "Duration: $Duration seconds"
Write-Host "Target video bitrate: $VideoBitrateKbps kbps"
Write-Host "Audio bitrate: $AudioBitrateKbps kbps"

# First pass
ffmpeg -y -i "$InputFile" `
    -c:v libx264 `
    -b:v "${VideoBitrateKbps}k" `
    -pass 1 `
    -an `
    -f null NUL

# Second pass
ffmpeg -y -i "$InputFile" `
    -c:v libx264 `
    -b:v "${VideoBitrateKbps}k" `
    -pass 2 `
    -c:a aac `
    -b:a "${AudioBitrateKbps}k" `
    -movflags +faststart `
    "$OutputFile"

# Clean up ffmpeg pass files
Remove-Item 'ffmpeg2pass-0.log' -ErrorAction SilentlyContinue
Remove-Item 'ffmpeg2pass-0.log.mbtree' -ErrorAction SilentlyContinue

Write-Host "Done: $OutputFile"
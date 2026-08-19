[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$InputFile,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$OutputFile,

    [Parameter(Mandatory)]
    [ValidateRange(1, 100000)]
    [double]$TargetSizeMB,

    [ValidateRange(0, 10000)]
    [double]$SafetyMarginMB = 2,

    [ValidateRange(8, 512)]
    [int]$AudioBitrateKbps = 128
)

$InputFile = $InputFile.Trim().Trim([char]'"')
$OutputFile = $OutputFile.Trim().Trim([char]'"')

if ($SafetyMarginMB -ge $TargetSizeMB) {
    throw 'SafetyMarginMB must be smaller than TargetSizeMB.'
}

foreach ($ExecutableName in 'ffmpeg', 'ffprobe') {
    if ($null -eq (Get-Command -Name $ExecutableName -ErrorAction SilentlyContinue)) {
        throw "'$ExecutableName' was not found in PATH."
    }
}

try {
    $ResolvedInputPath = (Resolve-Path -LiteralPath $InputFile -ErrorAction Stop).Path
}
catch {
    throw "Input file '$InputFile' was not found."
}

$ResolvedOutputPath = [System.IO.Path]::GetFullPath($OutputFile)
$OutputDirectory = Split-Path -Path $ResolvedOutputPath -Parent

if (-not (Test-Path -LiteralPath $OutputDirectory -PathType Container)) {
    throw "Output directory '$OutputDirectory' does not exist."
}

if ($ResolvedInputPath -eq $ResolvedOutputPath) {
    throw 'InputFile and OutputFile must be different files.'
}

$ProbeArguments = @(
    '-v', 'error'
    '-show_entries', 'format=duration:stream=codec_type'
    '-of', 'json'
    $ResolvedInputPath
)

$ProbeOutput = & ffprobe @ProbeArguments
$ProbeExitCode = $LASTEXITCODE

if ($ProbeExitCode -ne 0) {
    throw "ffprobe failed with exit code $ProbeExitCode."
}

try {
    $ProbeData = ($ProbeOutput -join [Environment]::NewLine) |
    ConvertFrom-Json -ErrorAction Stop
}
catch {
    throw "Could not parse ffprobe output: $($_.Exception.Message)"
}

try {
    $DurationSeconds = [double]::Parse(
        [string]$ProbeData.format.duration,
        [System.Globalization.CultureInfo]::InvariantCulture
    )
}
catch {
    throw 'Could not determine the video duration.'
}

if ($DurationSeconds -le 0) {
    throw 'Video duration must be greater than zero.'
}

$HasAudio = $ProbeData.streams.codec_type -contains 'audio'

if ($HasAudio) {
    $EffectiveAudioBitrateKbps = $AudioBitrateKbps
}
else {
    $EffectiveAudioBitrateKbps = 0
}

# Upload limits expressed as MB normally use decimal megabytes.
$BytesPerMegabyte = 1000000

$UsableTargetSizeMB = $TargetSizeMB - $SafetyMarginMB
$TargetKilobits = $UsableTargetSizeMB * $BytesPerMegabyte * 8 / 1000
$TotalBitrateKbps = $TargetKilobits / $DurationSeconds

$VideoBitrateKbps = [math]::Floor(
    $TotalBitrateKbps - $EffectiveAudioBitrateKbps
)

if ($VideoBitrateKbps -lt 100) {
    throw @"
The target size is too small for this video.

Duration: $([math]::Round($DurationSeconds, 2)) seconds
Target size: $TargetSizeMB MB
Audio bitrate: $EffectiveAudioBitrateKbps kbps
Calculated video bitrate: $VideoBitrateKbps kbps
"@
}

$PassLogBase = Join-Path `
    -Path ([System.IO.Path]::GetTempPath()) `
    -ChildPath "ffmpeg2pass-$([guid]::NewGuid().ToString('N'))"

Write-Host "Duration: $([math]::Round($DurationSeconds, 2)) seconds"
Write-Host "Target file size: $TargetSizeMB MB"
Write-Host "Usable target size: $UsableTargetSizeMB MB"
Write-Host "Video bitrate: $VideoBitrateKbps kbps"
Write-Host "Audio bitrate: $EffectiveAudioBitrateKbps kbps"

$FirstPassArguments = @(
    '-y'
    '-i', $ResolvedInputPath
    '-map', '0:v:0'
    '-c:v', 'libx264'
    '-b:v', "${VideoBitrateKbps}k"
    '-pass', '1'
    '-passlogfile', $PassLogBase
    '-an'
    '-f', 'null'
    '-'
)

$SecondPassArguments = @(
    '-y'
    '-i', $ResolvedInputPath
    '-map', '0:v:0'
    '-c:v', 'libx264'
    '-b:v', "${VideoBitrateKbps}k"
    '-pass', '2'
    '-passlogfile', $PassLogBase
)

if ($HasAudio) {
    $SecondPassArguments += @(
        '-map', '0:a:0'
        '-c:a', 'aac'
        '-b:a', "${AudioBitrateKbps}k"
    )
}

$SecondPassArguments += @(
    '-movflags', '+faststart'
    $ResolvedOutputPath
)

try {
    Write-Host 'Running first pass...'

    & ffmpeg @FirstPassArguments

    if ($LASTEXITCODE -ne 0) {
        throw "FFmpeg first pass failed with exit code $LASTEXITCODE."
    }

    Write-Host 'Running second pass...'

    & ffmpeg @SecondPassArguments

    if ($LASTEXITCODE -ne 0) {
        throw "FFmpeg second pass failed with exit code $LASTEXITCODE."
    }
}
finally {
    Remove-Item -Path "$PassLogBase*" -Force -ErrorAction SilentlyContinue
}

$OutputItem = Get-Item -LiteralPath $ResolvedOutputPath -ErrorAction Stop
$OutputSizeMB = $OutputItem.Length / $BytesPerMegabyte

Write-Host ''
Write-Host "Done: $ResolvedOutputPath"
Write-Host "Final size: $([math]::Round($OutputSizeMB, 2)) MB"

if ($OutputSizeMB -gt $TargetSizeMB) {
    Write-Warning (
        "The output exceeds the $TargetSizeMB MB target. " +
        'Increase SafetyMarginMB and encode again.'
    )
}
$LinkPath = ''
$TargetPath = ''

# Check that the network folder exists
if (-not (Test-Path $TargetPath)) {
    Write-Error "Target network path does not exist: $TargetPath"
    exit 1
}

# Check if the local link path already exists
if (Test-Path $LinkPath) {
    Write-Error "Link path already exists: $LinkPath"
    exit 1
}

# Create parent folder if needed
$Parent = Split-Path $LinkPath -Parent
if (-not (Test-Path $Parent)) {
    New-Item -ItemType Directory -Path $Parent -Force | Out-Null
}

# Create the directory symlink
New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath

Write-Host 'Symlink created:'
Write-Host "$LinkPath -> $TargetPath"

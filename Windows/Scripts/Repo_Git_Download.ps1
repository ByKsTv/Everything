param(
    [Parameter(Mandatory)]
    [string]$RepoUrl
)

$DownloadsDir = Join-Path $HOME 'Downloads'

# Extract repository name from URL
$RepoName = [IO.Path]::GetFileName(([uri]$RepoUrl).AbsolutePath.TrimEnd('/')) -replace '\.git$', ''

$RepoPath = Join-Path $DownloadsDir $RepoName
$ZipPath = Join-Path $DownloadsDir "${RepoName}-with-git.zip"

# Remove previous files
Remove-Item $RepoPath, $ZipPath -Recurse -Force -ErrorAction SilentlyContinue

Push-Location $DownloadsDir

try {
    # Clone repository
    git clone $RepoUrl
    if ($LASTEXITCODE -ne 0) {
        throw 'Git clone failed.'
    }

    # Create ZIP (including .git directory)
    tar.exe -a -c -f $ZipPath $RepoName
    if ($LASTEXITCODE -ne 0) {
        throw 'ZIP creation failed.'
    }
} finally {
    # Clean up cloned repository
    Remove-Item $RepoPath -Recurse -Force -ErrorAction SilentlyContinue
    Pop-Location
}

param(
    [Parameter(Mandatory = $true)]
    [string]$ExePath,
    [string]$OutputPath
)

$ExePath = $ExePath.Trim().Trim([char]'"')
$OutputPath = $OutputPath.Trim().Trim([char]'"')

# If no output path specified, use the same name as the exe but with .ico extension
if (-not $OutputPath) {
    $OutputPath = [System.IO.Path]::ChangeExtension($ExePath, '.ico')
}

# Extract and save the icon
[System.Drawing.Icon]::ExtractAssociatedIcon($ExePath).ToBitmap().Save($OutputPath)

Write-Host "Icon extracted to: $OutputPath"

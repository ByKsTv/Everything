param(
    [Parameter(Mandatory)]
    [string]$FileName
)

$FileName = $FileName.Trim().Trim([char]'"')

$Base64Content = [Convert]::ToBase64String((Get-Content $FileName -Encoding Byte))

Write-Output "Selected File: $FileName"
Write-Output "Base64 Content: $Base64Content"

$Base64Content | Clip
Add-Type -AssemblyName System.Windows.Forms

$FileDialog = New-Object System.Windows.Forms.OpenFileDialog
$FileDialog.Filter = 'All Files (*.*)|*.*'

$form = New-Object System.Windows.Forms.Form
$form.TopMost = $true

if ($FileDialog.ShowDialog($form) -eq 'OK') {
    $FileName = $FileDialog.FileName
    $Base64Content = [Convert]::ToBase64String((Get-Content $FileName -Encoding Byte))

    Write-Output "Selected File: $FileName"
    Write-Output "Base64 Content: $Base64Content"

    $Base64Content | Clip
}
Add-Type -AssemblyName System.Windows.Forms
[Windows.Forms.Application]::EnableVisualStyles()

$ExtractBase64_Form = New-Object System.Windows.Forms.Form -Property @{
    TopMost = $true
}
$ExtractBase64_OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    FileName        = 'Select file'
    Filter          = 'All Files (*.*)|*.*'
    CheckFileExists = $false
}

if ($ExtractBase64_OpenFileDialog.ShowDialog($ExtractBase64_Form) -eq [Windows.Forms.DialogResult]::OK) {
    $FileName = $ExtractBase64_OpenFileDialog.FileName
    $Base64Content = [Convert]::ToBase64String((Get-Content $FileName -Encoding Byte))

    Write-Output "Selected File: $FileName"
    Write-Output "Base64 Content: $Base64Content"

    $Base64Content | Clip
}

$ExtractBase64_Form.Dispose()
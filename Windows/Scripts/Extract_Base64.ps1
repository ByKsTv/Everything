Add-Type -AssemblyName System.Windows.Forms
[Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object System.Windows.Forms.Form -Property @{
    TopMost       = $true
    StartPosition = 'CenterScreen'
}

$FileDialog = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    FileName        = 'Select file'
    Title           = 'Extract Base64'
    Filter          = 'All Files (*.*)|*.*'
    CheckFileExists = $false
}

if ($FileDialog.ShowDialog($Form) -eq [Windows.Forms.DialogResult]::OK) {
    $FileName = $FileDialog.FileName
    $Base64Content = [Convert]::ToBase64String((Get-Content $FileName -Encoding Byte))

    Write-Output "Selected File: $FileName"
    Write-Output "Base64 Content: $Base64Content"

    $Base64Content | Clip
}
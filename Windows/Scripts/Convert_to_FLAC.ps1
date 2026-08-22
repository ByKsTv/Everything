Add-Type -AssemblyName System.Windows.Forms
[Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object System.Windows.Forms.Form -Property @{
    TopMost       = $true
    StartPosition = 'CenterScreen'
}

$FileDialog = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    FileName        = 'Select file'
    Title           = 'Convert to FLAC'
    Filter          = 'All Files (*.*)|*.*'
    CheckFileExists = $true
}

if ($FileDialog.ShowDialog($Form) -eq [Windows.Forms.DialogResult]::OK) {
    $SelectedFile = $FileDialog.FileName

    $InputFileName = [IO.Path]::GetFileNameWithoutExtension($SelectedFile)
    $InputDirectory = [IO.Path]::GetDirectoryName($SelectedFile)
    $OutputFile = [IO.Path]::Combine($InputDirectory, "$InputFileName.flac")

    $FFmpegCommand = "ffmpeg -i `"$SelectedFile`" -c:v copy -c:a flac `"$OutputFile`""
    Write-Host "Running command: $FFmpegCommand"
    & ffmpeg -i "$SelectedFile" -c:v copy -c:a flac "$OutputFile"

    Write-Host "Conversion complete: $OutputFile"
}

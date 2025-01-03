Add-Type -AssemblyName System.Windows.Forms
[Windows.Forms.Application]::EnableVisualStyles()

$FFmpegForm = New-Object System.Windows.Forms.Form -Property @{
    TopMost = $true
}
$FFmpegOpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog -Property @{
    FileName        = 'Select file'
    Filter          = 'All Files (*.*)|*.*'
    CheckFileExists = $true
}

if ($FFmpegOpenFileDialog.ShowDialog($FFmpegForm) -eq [Windows.Forms.DialogResult]::OK) {
    $SelectedFile = $FFmpegOpenFileDialog.FileName

    $InputFileName = [IO.Path]::GetFileNameWithoutExtension($SelectedFile)
    $InputDirectory = [IO.Path]::GetDirectoryName($SelectedFile)
    $OutputFile = Join-Path -Path $InputDirectory -ChildPath ("$InputFileName.flac")

    $FFmpegCommand = "ffmpeg -i `"$SelectedFile`" -c:v copy -c:a flac `"$OutputFile`""
    Write-Host "Running command: $FFmpegCommand"
    & ffmpeg -i "$SelectedFile" -c:v copy -c:a flac "$OutputFile"

    Write-Host "Conversion complete: $OutputFile"
}

$FFmpegForm.Dispose()
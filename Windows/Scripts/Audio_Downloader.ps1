Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object System.Windows.Forms.Form -Property @{
    Text          = 'Audio Downloader'
    Size          = [Drawing.Size]::new(400, 300)
    StartPosition = 'CenterScreen'
    TopMost       = $true
}

$UrlLabel = New-Object System.Windows.Forms.Label -Property @{
    Text     = 'URL:'
    Location = [Drawing.Point]::new(10, 20)
    Size     = [Drawing.Size]::new(100, 20)
}

$UrlBox = New-Object System.Windows.Forms.TextBox -Property @{
    Location = [Drawing.Point]::new(120, 20)
    Size     = [Drawing.Size]::new(240, 20)
}

$FormatLabel = New-Object System.Windows.Forms.Label -Property @{
    Text     = 'Audio Format:'
    Location = [Drawing.Point]::new(10, 60)
    Size     = [Drawing.Size]::new(100, 20)
}

$FormatBox = New-Object System.Windows.Forms.ComboBox -Property @{
    Location      = [Drawing.Point]::new(120, 60)
    Size          = [Drawing.Size]::new(150, 20)
    DropDownStyle = 'DropDownList'
}
$FormatBox.Items.AddRange(@(
        'Default (Best by yt-dlp)',
        'mp3', 'aac', 'm4a', 'opus', 'vorbis', 'wav', 'flac', 'alac'
    ))
$FormatBox.SelectedIndex = 0

$FolderLabel = New-Object System.Windows.Forms.Label -Property @{
    Text     = 'Save to folder:'
    Location = [Drawing.Point]::new(10, 100)
    Size     = [Drawing.Size]::new(100, 20)
}

$FolderPathBox = New-Object System.Windows.Forms.TextBox -Property @{
    Location = [Drawing.Point]::new(120, 100)
    Size     = [Drawing.Size]::new(170, 20)
}

$FolderButton = New-Object System.Windows.Forms.Button -Property @{
    Text     = 'Browse...'
    Location = [Drawing.Point]::new(300, 98)
    Size     = [Drawing.Size]::new(60, 22)
}
$FolderButton.Add_Click({
        $FolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
        if ($FolderDialog.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
            $FolderPathBox.Text = $FolderDialog.SelectedPath
        }
    })

$DownloadButton = New-Object System.Windows.Forms.Button -Property @{
    Text         = 'Download'
    Location     = [Drawing.Point]::new(150, 150)
    DialogResult = [System.Windows.Forms.DialogResult]::OK
}

$Form.AcceptButton = $DownloadButton

$Form.Controls.AddRange(@(
        $UrlLabel,
        $UrlBox,
        $FormatLabel,
        $FormatBox,
        $FolderLabel,
        $FolderPathBox,
        $FolderButton,
        $DownloadButton
    ))

if ($Form.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
    $Url = $UrlBox.Text
    $Format = $FormatBox.SelectedItem
    $OutputDir = $FolderPathBox.Text

    if (-not $Url -or -not $OutputDir) {
        [System.Windows.Forms.MessageBox]::Show('Please fill in all required fields.', 'Missing Info', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }

    $OutputTemplate = [IO.Path]::Combine($OutputDir, '%(title)s.%(ext)s')

    $Arguments = @(
        '--extract-audio',
        '--audio-quality', '0',
        '--output', "`"$OutputTemplate`""
    )

    if ($Format -ne 'Default (Best by yt-dlp)') {
        $Arguments += '--audio-format'
        $Arguments += $Format
    }

    $Arguments += "`"$Url`""

    Start-Process -FilePath 'yt-dlp' -ArgumentList $Arguments -Wait
}

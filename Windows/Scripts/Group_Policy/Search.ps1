Add-Type -AssemblyName System.Windows.Forms
$form = New-Object System.Windows.Forms.Form
$form.Text = "Search File Content"
$form.TopMost = $true
$form.StartPosition = "CenterScreen"
$form.Width = 400
$form.Height = 150

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Width = 350
$textBox.Top = 20
$textBox.Left = 20

$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = "OK"
$okButton.Top = 60
$okButton.Left = 100
$okButton.Width = 80
$okButton.Add_Click({
    $form.Tag = $textBox.Text
    $form.Close()
})

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "Cancel"
$cancelButton.Top = 60
$cancelButton.Left = 200
$cancelButton.Width = 80
$cancelButton.Add_Click({
    $form.Tag = $null
    $form.Close()
})

$form.Controls.Add($textBox)
$form.Controls.Add($okButton)
$form.Controls.Add($cancelButton)
$form.ShowDialog()

$SearchText = $form.Tag
if (![string]::IsNullOrWhiteSpace($SearchText)) {
    $SearchText = "*$SearchText*"
    $Files = Get-ChildItem -Path "$env:windir\PolicyDefinitions" -Recurse -File
    foreach ($File in $Files) {
        try {
            if ((Get-Content $File.FullName -ErrorAction Stop) -like $SearchText) {
                Write-Host "Found '$SearchText' in: $($File.FullName)" -ForegroundColor Green
            }
        } catch {
            Write-Host "Error reading: $($File.FullName)" -ForegroundColor Red
        }
    }
}
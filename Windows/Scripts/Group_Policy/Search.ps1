Add-Type -AssemblyName System.Windows.Forms
[Windows.Forms.Application]::EnableVisualStyles()

$SearchPolicy_Form = New-Object System.Windows.Forms.Form -Property @{
	Text            = 'Search Policy'
	Font            = [Drawing.Font]::new('Tahoma', 11)
	Width           = 200
	Height          = 90
	StartPosition   = 'CenterScreen'
	FormBorderStyle = 'FixedDialog'
	Topmost         = $true
	MaximizeBox     = $false
	MinimizeBox     = $false
	ControlBox      = $false
}

$SearchPolicy_ButtonSpacer = 15
$SearchPolicy_ButtonWidth = 57
$SearchPolicy_TotalButtonWidth = $SearchPolicy_ButtonSpacer + $SearchPolicy_ButtonWidth + $SearchPolicy_ButtonWidth
$SearchPolicy_FormCenterX = [math]::Round(($SearchPolicy_Form.ClientSize.Width - $SearchPolicy_TotalButtonWidth) / 2)
$SearchPolicy_ButtonHeight = 20
$SearchPolicy_ButtonYLocation = $SearchPolicy_Form.Height - 60

$SearchPolicy_OK = New-Object System.Windows.Forms.Button -Property @{
	Text      = 'OK'
	Width     = $SearchPolicy_ButtonWidth
	Height    = $SearchPolicy_ButtonHeight
	Location  = [Drawing.Point]::new($SearchPolicy_FormCenterX, $SearchPolicy_ButtonYLocation)
	Add_Click = { $SearchPolicy_Form.Close() }
}

$SearchPolicy_CancelX = $SearchPolicy_FormCenterX + $SearchPolicy_ButtonWidth + $SearchPolicy_ButtonSpacer
$SearchPolicy_Cancel = New-Object System.Windows.Forms.Button -Property @{
	Text      = 'Cancel'
	Width     = $SearchPolicy_ButtonWidth
	Height    = $SearchPolicy_ButtonHeight
	Location  = [Drawing.Point]::new($SearchPolicy_CancelX, $SearchPolicy_ButtonYLocation)
	Add_Click = { $SearchPolicy_Form.Close() }
}

$SearchPolicy_LocX = 5
$SearchPolicy_LocY = 0
$SearchPolicy_SizeX = $SearchPolicy_Form.Width - 25
$SearchPolicy_SizeY = 26

$SearchPolicy_TextBox = New-Object System.Windows.Forms.TextBox -Property @{
	Width         = $SearchPolicy_SizeX
	Height        = $SearchPolicy_SizeY
	Location      = [Drawing.Point]::new($SearchPolicy_LocX, $SearchPolicy_LocY)
}

$SearchPolicy_Form.Controls.Add($SearchPolicy_OK)
$SearchPolicy_Form.Controls.Add($SearchPolicy_Cancel)

$SearchPolicy_Form.Controls.Add($SearchPolicy_TextBox)

[void] $SearchPolicy_Form.ShowDialog()

$SearchPolicy_UserDefined = $SearchPolicy_TextBox.Text
if ($SearchPolicy_UserDefined) {
    $SearchPolicy_UserDefined = "*$SearchPolicy_UserDefined*"
    $SearchPolicy_Dir = Get-ChildItem -Path "$env:windir\PolicyDefinitions" -Recurse -File
    foreach ($SearchPolicy_File in $SearchPolicy_Dir) {
        try {
            if ((Get-Content $SearchPolicy_File.FullName -ErrorAction Stop) -like $SearchPolicy_UserDefined) {
                Write-Host "Found '$SearchPolicy_UserDefined' in: $($SearchPolicy_File.FullName)" -ForegroundColor Green
            }
        }
        catch {
            Write-Host "Error reading: $($SearchPolicy_File.FullName)" -ForegroundColor Red
        }
    }
}
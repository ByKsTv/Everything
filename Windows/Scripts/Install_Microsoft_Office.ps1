$OfficeSelection_GraveSoft = (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/gravesoft/gravesoft.dev/main/docs/office_c2r_links.md' -UseBasicParsing).Content

$OfficeSelection_Scrubber_Regex = '\[\*\*download Office Scrubber\*\*\]\((.*?)\)'
$OfficeSelection_Scrubber_Match = [regex]::Match($OfficeSelection_GraveSoft, $OfficeSelection_Scrubber_Regex)
$OfficeSelection_Scrubber_DDL = $OfficeSelection_Scrubber_Match.Groups[1].Value

# Parse languages from the HTML content
$OfficeSelection_LanguagePattern = '## (.+?)\s*\[([^\]]+)\]'
$OfficeSelection_LanguageMatches = [regex]::Matches($OfficeSelection_GraveSoft, $OfficeSelection_LanguagePattern)
$OfficeSelection_LanguageSections = @{}

for ($i = 0; $i -lt $OfficeSelection_LanguageMatches.Count; $i++) {
    $match = $OfficeSelection_LanguageMatches[$i]
    $languageName = $match.Groups[1].Value.Trim()
    $languageCode = $match.Groups[2].Value.Trim()
    $startIndex = $match.Index + $match.Length
    if ($i + 1 -lt $OfficeSelection_LanguageMatches.Count) {
        $endIndex = $OfficeSelection_LanguageMatches[$i + 1].Index
    }
    else {
        $endIndex = $OfficeSelection_GraveSoft.Length
    }
    $languageContent = $OfficeSelection_GraveSoft.Substring($startIndex, $endIndex - $startIndex)
    $OfficeSelection_LanguageSections[$languageName] = @{
        Code    = $languageCode
        Content = $languageContent
    }
}

# Process each language to extract tabs and products
foreach ($language in $OfficeSelection_LanguageSections.Keys) {
    $content = $OfficeSelection_LanguageSections[$language]['Content']
    # Extract content inside <Tabs> ... </Tabs>
    $tabsPattern = '<Tabs>(.*?)</Tabs>'
    $tabsMatch = [regex]::Match($content, $tabsPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    if ($tabsMatch.Success) {
        $tabsContent = $tabsMatch.Groups[1].Value
        # Extract each TabItem
        $tabPattern = '<TabItem value="([^"]+)" label="([^"]+)"(?: default)?>\s*(.*?)</TabItem>'
        $tabMatches = [regex]::Matches($tabsContent, $tabPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
        $tabs = @()
        foreach ($tabMatch in $tabMatches) {
            $tabValue = $tabMatch.Groups[1].Value
            $tabLabel = $tabMatch.Groups[2].Value
            $tabContent = $tabMatch.Groups[3].Value
            # Parse the table data
            $lines = $tabContent -split "`n"
            $tableStartIndex = -1
            for ($i = 0; $i -lt $lines.Length; $i++) {
                if ($lines[$i] -match '^\| Product ID \|') {
                    $tableStartIndex = $i
                    break
                }
            }
            if ($tableStartIndex -ne -1) {
                # Assume the next line is separator line
                $dataStartIndex = $tableStartIndex + 2
                $products = @()
                for ($j = $dataStartIndex; $j -lt $lines.Length; $j++) {
                    $line = $lines[$j].Trim()
                    if ($line -match '^\|') {
                        $columns = $line -split '\|'
                        # Ensure there are enough columns
                        if ($columns.Length -ge 4) {
                            $productId = $columns[1].Trim(' *')
                            $includedApps = $columns[2].Trim()
                            $onlineX64Link = $columns[3].Trim()
                            # Extract link from [Link](url)
                            $onlineLinkMatch = [regex]::Match($onlineX64Link, '\[.*?\]\((.*?)\)')
                            if ($onlineLinkMatch.Success) {
                                $linkUrl = $onlineLinkMatch.Groups[1].Value
                            }
                            else {
                                $linkUrl = ''
                            }

                            $products += @{
                                ProductID     = $productId
                                IncludedApps  = $includedApps
                                OnlineX64Link = $linkUrl
                            }
                        }
                    }
                    else {
                        # Break if the line does not start with '|'
                        break
                    }
                }
                $tabs += @{
                    Value    = $tabValue
                    Label    = $tabLabel
                    Products = $products
                }
            }
        }
        $OfficeSelection_LanguageSections[$language]['Tabs'] = $tabs
    }
}

# Create the form
$OfficeSelection_Form = New-Object System.Windows.Forms.Form
$OfficeSelection_Form.Text = 'Office Selection'
$OfficeSelection_Form.Font = New-Object System.Drawing.Font('Tahoma', 11)
$OfficeSelection_Form.Size = New-Object System.Drawing.Size(800, 500)
$OfficeSelection_Form.StartPosition = 'CenterScreen'
$OfficeSelection_Form.Topmost = $true
$OfficeSelection_Form.MaximizeBox = $false
$OfficeSelection_Form.MinimizeBox = $false
$OfficeSelection_Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

# Add 3 additional checkboxes below the TabControl
$OfficeSelection_ActivateOffice = New-Object System.Windows.Forms.CheckBox
$OfficeSelection_ActivateOffice.Text = 'Activate Office'
$OfficeSelection_ActivateOffice.Location = New-Object System.Drawing.Point(5, 330)
$OfficeSelection_ActivateOffice.Size = New-Object System.Drawing.Size(300, 20)
$OfficeSelection_ActivateOffice.Checked = $true
$OfficeSelection_Form.Controls.Add($OfficeSelection_ActivateOffice)

$OfficeSelection_DisableTelemetry = New-Object System.Windows.Forms.CheckBox
$OfficeSelection_DisableTelemetry.Text = 'Disable Telemetry'
$OfficeSelection_DisableTelemetry.Checked = $true
$OfficeSelection_DisableTelemetry.Location = New-Object System.Drawing.Point(5, 350)
$OfficeSelection_DisableTelemetry.Size = New-Object System.Drawing.Size(300, 20)
$OfficeSelection_Form.Controls.Add($OfficeSelection_DisableTelemetry)

$OfficeSelection_EnableTelemetry = New-Object System.Windows.Forms.CheckBox
$OfficeSelection_EnableTelemetry.Text = 'Enable Telemetry'
$OfficeSelection_EnableTelemetry.Enabled = $false
$OfficeSelection_EnableTelemetry.Location = New-Object System.Drawing.Point(5, 370)
$OfficeSelection_EnableTelemetry.Size = New-Object System.Drawing.Size(300, 20)
$OfficeSelection_Form.Controls.Add($OfficeSelection_EnableTelemetry)

$OfficeSelection_DisableTelemetry.add_CheckedChanged({
        $OfficeSelection_EnableTelemetry.Enabled = -not $OfficeSelection_DisableTelemetry.Checked
        $OfficeSelection_EnableTelemetry.Checked = $false
    })

$OfficeSelection_EnableTelemetry.add_CheckedChanged({
        $OfficeSelection_DisableTelemetry.Enabled = -not $OfficeSelection_EnableTelemetry.Checked
        $OfficeSelection_DisableTelemetry.Checked = $false
    })

$OfficeSelection_Scrubber = New-Object System.Windows.Forms.CheckBox
$OfficeSelection_Scrubber.Text = 'Office Scrubber (Uninstall Office)'
$OfficeSelection_Scrubber.Location = New-Object System.Drawing.Point(5, 390)
$OfficeSelection_Scrubber.Size = New-Object System.Drawing.Size(300, 20)
$OfficeSelection_Form.Controls.Add($OfficeSelection_Scrubber)

$OfficeSelection_LanguageSelector = New-Object System.Windows.Forms.ComboBox
$OfficeSelection_LanguageSelector.Location = New-Object System.Drawing.Point(5, 0)
$OfficeSelection_LanguageSelector.Width = 200
$OfficeSelection_LanguageSelector.DropDownStyle = 'DropDownList'

# Add languages to the combobox, sorted alphabetically
foreach ($language in ($OfficeSelection_LanguageSections.Keys | Sort-Object)) {
    $null = $OfficeSelection_LanguageSelector.Items.Add($language)
}

# Set default language to English
$defaultLanguageIndex = $OfficeSelection_LanguageSelector.Items.IndexOf('English')
if ($defaultLanguageIndex -ge 0) {
    $OfficeSelection_LanguageSelector.SelectedIndex = $defaultLanguageIndex
}

# Create a TabControl
$OfficeSelection_Tabs = New-Object System.Windows.Forms.TabControl
$OfficeSelection_Tabs.Location = New-Object System.Drawing.Point(5, 30)
# Initial size; will adjust later
$OfficeSelection_Tabs.Size = New-Object System.Drawing.Size(300, 300)
$OfficeSelection_Form.Controls.Add($OfficeSelection_Tabs)

# Function to populate tabs based on selected language
$populateTabs = {
    $selectedLanguage = $OfficeSelection_LanguageSelector.SelectedItem
    # Clear existing tabs
    $OfficeSelection_Tabs.TabPages.Clear()

    # Get the tabs for the selected language
    $tabs = $OfficeSelection_LanguageSections[$selectedLanguage]['Tabs']

    # Create a Graphics object for measuring text
    $graphics = $OfficeSelection_Tabs.CreateGraphics()
    $totalTabWidth = 0

    foreach ($tab in $tabs) {
        $tabPage = New-Object System.Windows.Forms.TabPage
        $tabPage.Text = $tab['Label']

        # Measure the width of the tab text
        $size = $graphics.MeasureString($tabPage.Text, $OfficeSelection_Tabs.Font)
        $totalTabWidth += [int]$size.Width + 3  # Add extra space for padding and margins

        # Create a Panel to hold the checkboxes
        $panel = New-Object System.Windows.Forms.Panel
        $panel.AutoScroll = $true
        $panel.Dock = 'Fill'

        # Create a Tooltip object
        $tooltip = New-Object System.Windows.Forms.ToolTip

        # Positioning variables
        $yPosition = 0

        # For each product, create a checkbox
        foreach ($product in $tab['Products']) {
            $checkbox = New-Object System.Windows.Forms.CheckBox
            $checkbox.Text = $product['ProductID']
            $checkbox.Location = New-Object System.Drawing.Point(5, $yPosition)
            $checkbox.AutoSize = $true

            # Set tooltip with Included Apps
            $tooltip.SetToolTip($checkbox, $product['IncludedApps'])

            $panel.Controls.Add($checkbox)
            $yPosition += 20
        }

        $tabPage.Controls.Add($panel)
        $OfficeSelection_Tabs.TabPages.Add($tabPage)
    }

    # Dispose of the Graphics object
    $graphics.Dispose()

    # Get the screen working area width
    $screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Width

    # Calculate the new width for the TabControl
    $newTabControlWidth = $totalTabWidth + 20  # Additional padding

    # Ensure the TabControl does not exceed the screen width
    if ($newTabControlWidth + 40 -lt $screenWidth) {
        $OfficeSelection_Tabs.Width = $newTabControlWidth
        $OfficeSelection_Form.Width = $OfficeSelection_Tabs.Width + 40  # Adjust form width accordingly
    }
    else {
        $OfficeSelection_Tabs.Width = $screenWidth - 40
        $OfficeSelection_Form.Width = $screenWidth
    }
}

# Populate tabs for default language
$populateTabs.Invoke()


# Event handler for language selection
$OfficeSelection_LanguageSelector.add_SelectedIndexChanged({
        $populateTabs.Invoke()
    })

# Event handler to clear checkboxes in other tabs when switching tabs
$OfficeSelection_Tabs.add_SelectedIndexChanged({
        # When the tab is changed, clear the checkboxes in all tabs except the selected one
        $selectedTab = $OfficeSelection_Tabs.SelectedTab
        foreach ($tabPage in $OfficeSelection_Tabs.TabPages) {
            if ($tabPage -ne $selectedTab) {
                # Clear checkboxes in this tab
                foreach ($control in $tabPage.Controls[0].Controls) {
                    if ($control -is [System.Windows.Forms.CheckBox]) {
                        $control.Checked = $false
                    }
                }
            }
        }
    })

# OK Button
$OfficeSelection_OK = New-Object System.Windows.Forms.Button
$OfficeSelection_OK.Text = 'OK'
$OfficeSelection_OK.Location = New-Object System.Drawing.Size((($OfficeSelection_Form.Width) / 3 ), (($OfficeSelection_Form.height) - 65))
$OfficeSelection_OK.Size = New-Object System.Drawing.Size(57, 20)
$OfficeSelection_OK.Add_Click({
        $OfficeSelection_Form.Topmost = $false

        if ($OfficeSelection_Scrubber.Checked) {
            $OfficeSelection_Scrubber_Filename = [IO.Path]::GetFileName(([URI]$OfficeSelection_Scrubber_DDL).AbsolutePath)
            $OfficeSelection_Scrubber_SavePath = [IO.Path]::Combine($env:TEMP, $OfficeSelection_Scrubber_Filename)
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$OfficeSelection_Scrubber_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$OfficeSelection_Scrubber_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$OfficeSelection_Scrubber_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile($OfficeSelection_Scrubber_DDL, $OfficeSelection_Scrubber_SavePath)

            $OfficeSelection_Scrubber_Dir = $OfficeSelection_Scrubber_SavePath.TrimEnd('.zip')
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$OfficeSelection_Scrubber_Filename'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$OfficeSelection_Scrubber_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$OfficeSelection_Scrubber_Dir'"); [Console]::ResetColor(); [Console]::WriteLine()
            Expand-Archive -Path $OfficeSelection_Scrubber_SavePath -DestinationPath $OfficeSelection_Scrubber_Dir -Force

            $OfficeSelection_Scrubber_CMD = [IO.Path]::Combine($OfficeSelection_Scrubber_Dir, 'OfficeScrubber.cmd')
            $OfficeSelection_Scrubber_Argument = '/A'
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Uninstalling '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Office'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$OfficeSelection_Scrubber_CMD'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$OfficeSelection_Scrubber_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
            Start-Process $OfficeSelection_Scrubber_CMD -ArgumentList $OfficeSelection_Scrubber_Argument -Wait
        }

        # Collect selected products from the active tab only
        $selectedProducts = @()
        $tabPage = $OfficeSelection_Tabs.SelectedTab
        foreach ($control in $tabPage.Controls[0].Controls) {
            if ($control -is [System.Windows.Forms.CheckBox] -and $control.Checked) {
                $productID = $control.Text
                # Find the product in languageSections
                $selectedLanguage = $OfficeSelection_LanguageSelector.SelectedItem
                $product = ($OfficeSelection_LanguageSections[$selectedLanguage]['Tabs'] | Where-Object { $_['Label'] -eq $tabPage.Text }).Products | Where-Object { $_['ProductID'] -eq $productID }
                if ($product) {
                    $selectedProducts += $product
                }
            }
        }
        # Extract Online x64 Links for selected products
        foreach ($product in $selectedProducts) {
            $Office_Selected_ID = $($product['ProductID'])
            $Office_Selected_ID_URL = $($product['OnlineX64Link'])
            $Office_Selected_ID_Includes = $($product['IncludedApps'])

            $Office_Selected_SavePath = [IO.Path]::Combine($env:TEMP, "$Office_Selected_ID.exe")

            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Office_Selected_ID'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' which includes '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Office_Selected_ID_Includes'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Office_Selected_ID_URL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Office_Selected_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile($Office_Selected_ID_URL, $Office_Selected_SavePath)
            
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Installing '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Office_Selected_ID'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' which includes '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Office_Selected_ID_Includes'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Office_Selected_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            Start-Process $Office_Selected_SavePath -Wait
        }

        if ($OfficeSelection_ActivateOffice.Checked) {
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Office: Activating'); [Console]::ResetColor(); [Console]::WriteLine()
            & ([ScriptBlock]::Create(((New-Object Net.WebClient).DownloadString('https://get.activated.win/')))) /Ohook
        }

        if ($OfficeSelection_DisableTelemetry.Checked) {
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Office: Disable Telemetry'); [Console]::ResetColor(); [Console]::WriteLine()
            Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/abbodi1406/WHD/master/scripts/OC2R_DisableTelemetry.ps1')
        }

        if ($OfficeSelection_EnableTelemetry.Checked) {
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Office: Enable Telemetry'); [Console]::ResetColor(); [Console]::WriteLine()
            Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/abbodi1406/WHD/master/scripts/OC2R_RevertTelemetry.ps1')
        }

        $OfficeSelection_Form.Close()
    })

# Cancel Button
$OfficeSelection_Cancel = New-Object System.Windows.Forms.Button
$OfficeSelection_Cancel.Text = 'Cancel'
$OfficeSelection_Cancel.Location = New-Object System.Drawing.Size((($OfficeSelection_Form.Width) / 2 ), (($OfficeSelection_Form.height) - 65))
$OfficeSelection_Cancel.Size = New-Object System.Drawing.Size(57, 20)
$OfficeSelection_Cancel.Add_Click({
        $OfficeSelection_Form.Close()
    })

$OfficeSelection_Form.Controls.Add($OfficeSelection_LanguageSelector)
$OfficeSelection_Form.Controls.Add($OfficeSelection_OK)
$OfficeSelection_Form.Controls.Add($OfficeSelection_Cancel)

# Show the form
[void]$OfficeSelection_Form.ShowDialog()
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()

$GraveSoft = (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/gravesoft/gravesoft.dev/main/docs/office_c2r_links.md' -UseBasicParsing).Content

$Scrubber_Regex = '\[Download Office Scrubber\]\((.*?)\)'
$Scrubber_Match = [regex]::Match($GraveSoft, $Scrubber_Regex)
$Scrubber_DDL = $Scrubber_Match.Groups[1].Value

$Language_Regex = '## (.+?)\s*\[([^\]]+)\]'
$Language_Match = [regex]::Matches($GraveSoft, $Language_Regex)
$Language_Sections = @{}
for ($i = 0; $i -lt $Language_Match.Count; $i++) {
    $match = $Language_Match[$i]
    $languageName = $match.Groups[1].Value.Trim()
    $languageCode = $match.Groups[2].Value.Trim()
    $startIndex = $match.Index + $match.Length
    if ($i + 1 -lt $Language_Match.Count) {
        $endIndex = $Language_Match[$i + 1].Index
    }
    else {
        $endIndex = $GraveSoft.Length
    }
    $languageContent = $GraveSoft.Substring($startIndex, $endIndex - $startIndex)
    $Language_Sections[$languageName] = @{
        Code    = $languageCode
        Content = $languageContent
    }
}

# Process each language to extract tabs and products
foreach ($language in $Language_Sections.Keys) {
    $content = $Language_Sections[$language]['Content']
    # Extract content inside <Tabs> ... </Tabs>
    $tabsPattern = '<Tabs>(.*?)</Tabs>'
    $tabsMatch = [regex]::Match($content, $tabsPattern, [Text.RegularExpressions.RegexOptions]::Singleline)
    if ($tabsMatch.Success) {
        $tabsContent = $tabsMatch.Groups[1].Value
        # Extract each TabItem
        $tabPattern = '<TabItem value="([^"]+)" label="([^"]+)"(?: default)?>\s*(.*?)</TabItem>'
        $tabMatches = [regex]::Matches($tabsContent, $tabPattern, [Text.RegularExpressions.RegexOptions]::Singleline)
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
        $Language_Sections[$language]['Tabs'] = $tabs
    }
}

$Form = New-Object System.Windows.Forms.Form -Property @{
    Text            = 'Office Selection'
    Font            = [Drawing.Font]::new('Tahoma', 11)
    Height          = 500
    StartPosition   = 'CenterScreen'
    FormBorderStyle = 'FixedDialog'
    Topmost         = $true
    MaximizeBox     = $false
    MinimizeBox     = $false
    ControlBox      = $false
}

$Activate = New-Object System.Windows.Forms.CheckBox -Property @{
    Text     = 'Activate Office'
    Width    = 300
    Height   = 20
    Location = [Drawing.Point]::new(5, 330)
    Checked  = $true
}

$DisableTelemetry = New-Object System.Windows.Forms.CheckBox -Property @{
    Text     = 'Disable Telemetry'
    Width    = 300
    Height   = 20
    Location = [Drawing.Point]::new(5, 350)
    Checked  = $true
}

$Scrubber = New-Object System.Windows.Forms.CheckBox -Property @{
    Text     = 'Office Scrubber (Uninstall Office)'
    Width    = 300
    Height   = 20
    Checked  = $true
    Location = [Drawing.Point]::new(5, 370)
}

$Language_Selection = New-Object System.Windows.Forms.ComboBox -Property @{
    Width         = 200
    Height        = 20
    Location      = [Drawing.Point]::new(5, 0)
    DropDownStyle = 'DropDownList'
}

$Form.Controls.AddRange(@($Activate, $DisableTelemetry, $Scrubber))

# Add languages to the combobox, sorted alphabetically
foreach ($language in ($Language_Sections.Keys | Sort-Object)) {
    $Language_Selection.Items.Add($language) | Out-Null
}

# Set default language to English
$defaultLanguageIndex = $Language_Selection.Items.IndexOf('English')
if ($defaultLanguageIndex -ge 0) {
    $Language_Selection.SelectedIndex = $defaultLanguageIndex
}

# Create a TabControl
$OfficeSelection_Tabs = New-Object System.Windows.Forms.TabControl -Property @{
    # Initial size; will adjust later
    Width    = 300
    Height   = 300
    Location = [Drawing.Point]::new(5, 30)
}
$Form.Controls.Add($OfficeSelection_Tabs)

# Function to populate tabs based on selected language
$populateTabs = {
    $selectedLanguage = $Language_Selection.SelectedItem
    # Clear existing tabs
    $OfficeSelection_Tabs.TabPages.Clear()

    # Get the tabs for the selected language
    $tabs = $Language_Sections[$selectedLanguage]['Tabs']

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
    $screenWidth = [Windows.Forms.Screen]::PrimaryScreen.WorkingArea.Width

    # Calculate the new width for the TabControl
    $newTabControlWidth = $totalTabWidth + 20  # Additional padding

    # Ensure the TabControl does not exceed the screen width
    if ($newTabControlWidth + 40 -lt $screenWidth) {
        $OfficeSelection_Tabs.Width = $newTabControlWidth
        $Form.Width = $OfficeSelection_Tabs.Width + 40  # Adjust form width accordingly
    }
    else {
        $OfficeSelection_Tabs.Width = $screenWidth - 40
        $Form.Width = $screenWidth
    }
}

# Populate tabs for default language
$populateTabs.Invoke()


# Event handler for language selection
$Language_Selection.add_SelectedIndexChanged({
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
                    if ($control -is [Windows.Forms.CheckBox]) {
                        $control.Checked = $false
                    }
                }
            }
        }
    })


$ButtonWidth = 57
$ButtonSpacer = 15
$ButtonY = $Form.Height - 60
$ButtonX = [math]::Round(($Form.ClientSize.Width - (2 * $ButtonWidth + $ButtonSpacer)) / 2)

$Ok = New-Object System.Windows.Forms.Button -Property @{
    Text         = 'OK'
    DialogResult = [Windows.Forms.DialogResult]::OK
    Width        = $ButtonWidth
    Height       = 20
    Location     = [Drawing.Point]::new($ButtonX, $ButtonY)
    Add_Click    = { $Form.Close() }
}

$Cancel = New-Object System.Windows.Forms.Button -Property @{
    Text      = 'Cancel'
    Width     = $ButtonWidth
    Height    = 20
    Location  = [Drawing.Point]::new($ButtonX + $ButtonWidth + $ButtonSpacer, $ButtonY)
    Add_Click = { $Form.Close() }
}

$Form.Controls.AddRange(@($Language_Selection, $Ok, $Cancel))
if ($Form.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
    if ($Scrubber.Checked) {
        if (-not (Test-Path -Path 'HKCU:\Software\Microsoft\Windows Script Host\Settings')) {
            New-Item -Path 'HKCU:\Software\Microsoft\Windows Script Host\Settings' -Force
        }
        New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows Script Host\Settings' -Name 'Enabled' -PropertyType DWord -Value 1 -Force

        # If URL is not working
        $Scrubber_Exists = Invoke-WebRequest -Uri $Scrubber_DDL -Method Head -ErrorAction SilentlyContinue
        if ($null -eq $Scrubber_Exists) {
            $Scrubber_DDL = 'https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Microsoft_Office/OfficeScrubberAIO.cmd'
            $Scrubber_FileName = [IO.Path]::GetFileName(([URI]$Scrubber_DDL).AbsolutePath)
            $Scrubber_CMD = [IO.Path]::Combine($env:TEMP, $Scrubber_FileName)
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Scrubber_FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Scrubber_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Scrubber_CMD'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile($Scrubber_DDL, $Scrubber_CMD)
        }
        # If URL is working
        else {
            $Scrubber_FileName = [IO.Path]::GetFileName(([URI]$Scrubber_DDL).AbsolutePath)
            $Scrubber_SavePath = [IO.Path]::Combine($env:TEMP, $Scrubber_FileName)
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Downloading '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Scrubber_FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Scrubber_DDL'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Scrubber_SavePath'"); [Console]::ResetColor(); [Console]::WriteLine()
            (New-Object System.Net.WebClient).DownloadFile($Scrubber_DDL, $Scrubber_SavePath)

            $Scrubber_Dir = [IO.Path]::Combine([IO.Path]::GetDirectoryName($Scrubber_SavePath), [IO.Path]::GetFileNameWithoutExtension($Scrubber_SavePath))
            [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Extracting '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Scrubber_FileName'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' from '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Scrubber_SavePath'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' to '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Scrubber_Dir'"); [Console]::ResetColor(); [Console]::WriteLine()
            Expand-Archive -Path $Scrubber_SavePath -DestinationPath $Scrubber_Dir -Force

            $Scrubber_CMD = [IO.Path]::Combine($Scrubber_Dir, 'OfficeScrubber.cmd')
        }
        $Scrubber_Argument = '/P /C /A /M1 /M2 /M4 /M5 /M6'
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Uninstalling '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'Office'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' using '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Scrubber_CMD'"); [Console]::ForegroundColor = 'Green'; [Console]::Write(' with '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write("'$Scrubber_Argument'"); [Console]::ResetColor(); [Console]::WriteLine()
        Start-Process $Scrubber_CMD -ArgumentList $Scrubber_Argument -Wait

        New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows Script Host\Settings' -Name 'Enabled' -PropertyType DWord -Value 0 -Force
    }

    # Collect selected products from the active tab only
    $selectedProducts = @()
    $tabPage = $OfficeSelection_Tabs.SelectedTab
    foreach ($control in $tabPage.Controls[0].Controls) {
        if ($control -is [Windows.Forms.CheckBox] -and $control.Checked) {
            $productID = $control.Text
            # Find the product in languageSections
            $selectedLanguage = $Language_Selection.SelectedItem
            $product = ($Language_Sections[$selectedLanguage]['Tabs'] | Where-Object { $_['Label'] -eq $tabPage.Text }).Products | Where-Object { $_['ProductID'] -eq $productID }
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

    if ($Activate.Checked) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Office: Activating'); [Console]::ResetColor(); [Console]::WriteLine()
        & ([ScriptBlock]::Create(((New-Object Net.WebClient).DownloadString('https://get.activated.win/')))) /Ohook
    }

    if ($DisableTelemetry.Checked) {
        [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Office: Disable Telemetry'); [Console]::ResetColor(); [Console]::WriteLine()

        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Pre.ps1')
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Software/Microsoft_Office/Group_Policy.ps1')
        Invoke-Expression (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ByKsTv/Everything/main/Windows/Scripts/Group_Policy/Post.ps1')
    }
}
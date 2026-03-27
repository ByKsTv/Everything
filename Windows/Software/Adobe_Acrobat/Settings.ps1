# Adobe Acrobat Pro: User Configuration: Administrative Templates: Adobe Acrobat DC: Preferences: General: Display splash screen at launch: Disabled
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals')) {
    New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals' -Name 'bDisplayAboutDialog' -Value 0 -PropertyType DWord -Force

# Adobe Acrobat Pro: Preferences: Catalog: Enable Logging: Off
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Catalog\cOptions')) {
    New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Catalog\cOptions' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Catalog\cOptions' -Name 'bCreateLog' -Value 0 -PropertyType DWord -Force

# Adobe Acrobat Pro: Preferences: Page Display: Zoom: Fit Visible
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals')) {
    New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals' -Name 'iDefaultZoomType' -Value '4' -PropertyType String -Force

# Adobe Acrobat Pro: General: Show me messages when I launch Adobe Acrobat: Disable
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\IPM')) {
    New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\IPM' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\IPM' -Name 'bShowMsgAtLaunch' -Value 0 -PropertyType DWord -Force

# Adobe Acrobat Pro: Edit: Prefrences: Security (Enhanced): Protected View: All Files
if (-not (Test-Path -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\TrustManager')) {
    New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\TrustManager' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\TrustManager' -Name 'iProtectedView' -Value 2 -PropertyType DWord -Force
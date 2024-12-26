# Computer Configuration: Administrative Templates: Adobe Acrobat DC: Preferences: General: Disable automatic updates: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown' -Name 'bUpdater' -Type DWORD -Value 0
        
# Computer Configuration: Administrative Templates: Adobe Acrobat DC: Preferences: General: Show messages when I launch Acrobat: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cIPM' -Name 'bShowMsgAtLaunch' -Type DWORD -Value 0
        
# Computer Configuration: Administrative Templates: Adobe Acrobat DC: Preferences: General: Turn off user participation in the feedback program: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown' -Name 'bUsageMeasurement' -Type DWORD -Value 0

# Computer Configuration: Administrative Templates: Adobe Acrobat DC: Preferences: Startup: Protected View: For all files
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown' -Name 'iProtectedView' -Type DWORD -Value 2

# Doesnt exist
# Adobe Acrobat: Turn off the generative AI features
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown' -Name 'bEnableGentech' -Type DWORD -Value 0

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adobe Acrobat Pro: User Configuration: Administrative Templates: Adobe Acrobat DC: Preferences: General: Display splash screen at launch: Disabled'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals' -Name 'bDisplayAboutDialog' -Value 0 -PropertyType DWord -Force
        
[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adobe Acrobat Pro: Preferences: Catalog: Enable Logging: Off'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Catalog\cOptions') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Catalog\cOptions' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Catalog\cOptions' -Name 'bCreateLog' -Value 0 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adobe Acrobat Pro: Preferences: Page Display: Zoom: Fit Visible'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\Originals' -Name 'iDefaultZoomType' -Value '4' -PropertyType String -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adobe Acrobat Pro: General: Show me messages when I launch Adobe Acrobat: Disable'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\IPM') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\IPM' -Force
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\IPM' -Name 'bShowMsgAtLaunch' -Value 0 -PropertyType DWord -Force

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Adobe Acrobat Pro: Edit: Prefrences: Security (Enhanced): Protected View: All Files'); [Console]::ResetColor(); [Console]::WriteLine()
if ((Test-Path -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\TrustManager') -ne $true) {
    New-Item 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\TrustManager' -Force 
}
New-ItemProperty -Path 'HKCU:\SOFTWARE\Adobe\Adobe Acrobat\DC\TrustManager' -Name 'iProtectedView' -Value 2 -PropertyType DWord -Force
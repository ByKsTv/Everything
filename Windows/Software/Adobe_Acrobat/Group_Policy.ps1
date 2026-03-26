# Computer Configuration: Administrative Templates: Adobe Acrobat DC: Preferences: General: Disable automatic updates: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown' -Name 'bUpdater' -Type DWORD -Value 0
        
# Computer Configuration: Administrative Templates: Adobe Acrobat DC: Preferences: General: Show messages when I launch Acrobat: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cIPM' -Name 'bShowMsgAtLaunch' -Type DWORD -Value 0
        
# Computer Configuration: Administrative Templates: Adobe Acrobat DC: Preferences: General: Turn off user participation in the feedback program: Disabled
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown' -Name 'bUsageMeasurement' -Type DWORD -Value 0

# Computer Configuration: Administrative Templates: Adobe Acrobat DC: Preferences: Startup: Protected View: For all files
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown' -Name 'iProtectedView' -Type DWORD -Value 2

# https://www.adobe.com/devnet-docs/acrobatetk/tools/PrefRef/Windows/FeatureLockDown.html#idkeyname_1_10559
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown' -Name 'bToggleFTE' -Type DWORD -Value 1

# Doesnt exist
# Adobe Acrobat: Turn off the generative AI features
Set-Policy -Scope Computer -Path 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown' -Name 'bEnableGentech' -Type DWORD -Value 0
while ($true) {
    $devices = & adb.exe devices 2>$null | Out-String

    if ($devices -match '(?m)^.+\s+device\s*$') {
        break
    }

    [Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Status: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write('Waiting for a connected device...'); [Console]::ResetColor(); [Console]::WriteLine()
    Start-Sleep -Seconds 2
}

[Console]::BackgroundColor = 'Black'; [Console]::ForegroundColor = 'Green'; [Console]::Write('Status: '); [Console]::ForegroundColor = 'Yellow'; [Console]::Write('Device connected'); [Console]::ResetColor(); [Console]::WriteLine()


Add-Type -AssemblyName System.Windows.Forms
[Windows.Forms.Application]::EnableVisualStyles()

$Form = New-Object System.Windows.Forms.Form -Property @{
    Text            = 'Set Device Name'
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

$ButtonSpacer = 15
$ButtonWidth = 57
$TotalButtonWidth = $ButtonSpacer + $ButtonWidth + $ButtonWidth
$FormCenterX = [math]::Round(($Form.ClientSize.Width - $TotalButtonWidth) / 2)
$ButtonHeight = 20
$ButtonYLocation = $Form.Height - 60

$OK = New-Object System.Windows.Forms.Button -Property @{
    Text      = 'OK'
    Width     = $ButtonWidth
    Height    = $ButtonHeight
    Location  = [Drawing.Point]::new($FormCenterX, $ButtonYLocation)
    Add_Click = ({ $Form.Close() })
}

$CancelX = $FormCenterX + $ButtonWidth + $ButtonSpacer
$Cancel = New-Object System.Windows.Forms.Button -Property @{
    Text      = 'Cancel'
    Width     = $ButtonWidth
    Height    = $ButtonHeight
    Location  = [Drawing.Point]::new($CancelX, $ButtonYLocation)
    Add_Click = ({ $Form.Close() })
}

$LocX = 5
$LocY = 0
$SizeX = $Form.Width - 25
$SizeY = 26

$TextBox = New-Object System.Windows.Forms.TextBox -Property @{
    Text     = 'Brand-Model'
    Width    = $SizeX
    Height   = $SizeY
    Location = [Drawing.Point]::new($LocX, $LocY)
}

$Form.Controls.Add($OK)
$Form.Controls.Add($Cancel)

$Form.Controls.Add($TextBox)

[void] $Form.ShowDialog()

$deviceName = $TextBox.Text

$settings = @(
    [PSCustomObject]@{
        Name  = 'Settings -> Display and sound -> Display -> Backlight -> 100'
        Table = 'system'
        Key   = 'screen_brightness'
        Value = '255'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Network Internet -> Scanning always available -> Off'
        Table = 'global'
        Key   = 'wifi_scan_always_enabled'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Privacy -> Location -> Location status -> Off'
        Table = 'secure'
        Key   = 'location_mode'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Privacy -> Microphone -> Microphone access on your remote -> Off'
        Table = 'global'
        Key   = 'receive_explicit_user_interaction_audio_enabled'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Privacy -> Usage & diagnostics -> Off'
        Table = 'global'
        Key   = 'multi_cb'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Privacy -> Security -> Scan apps with Play Protect -> Off'
        Table = 'global'
        Key   = 'package_verifier_user_consent'
        Value = '-1'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Privacy -> Security -> Improve harmful app detection -> Off'
        Table = 'global'
        Key   = 'upload_apk_enable'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> System -> Power & Energy -> Shut-Off Timer -> When inactive -> Never'
        Table = 'secure'
        Key   = 'sleep_timeout'
        Value = '-1'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> System -> Power & Energy -> Shut-Off Timer -> When watching -> Never'
        Table = 'secure'
        Key   = 'attentive_timeout'
        Value = '-1'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> System -> Power & Energy -> Shut-Off Timer -> Countdown from now -> Never'
        Table = 'global'
        Key   = 'power_sleep_timer'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> System -> Power & Energy -> Shut-Off Timer -> Countdown from now -> Never'
        Table = 'global'
        Key   = 'REMIND_TIME'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> System -> Power & Energy -> Shut-Off Timer -> Countdown from now -> Never'
        Table = 'global'
        Key   = 'tv_timer_sleep_timer_entry_values'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> System -> Power & Energy -> Scheduled power on/off -> Power on time type -> Off'
        Table = 'global'
        Key   = 'tv_timer_power_on_time_type_entry_values'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> System -> Power & Energy -> Scheduled power on/off -> Power off time type -> Off'
        Table = 'global'
        Key   = 'tv_timer_power_off_time_type_entry_values'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> System -> Power & Energy -> Scheduled power on/off -> Power off after turning on -> Off'
        Table = 'global'
        Key   = 'power_switch_off_timer'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> System -> About -> Device name'
        Table = 'secure'
        Key   = 'bluetooth_name'
        Value = $deviceName
    }

    [PSCustomObject]@{
        Name  = 'Settings -> System -> About -> Device name'
        Table = 'global'
        Key   = 'device_name'
        Value = $deviceName
    }

    [PSCustomObject]@{
        Name  = 'Settings -> System -> Date & Time -> Automatic date & time -> use network provided time'
        Table = 'global'
        Key   = 'auto_time'
        Value = '1'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> System -> Date & Time -> Use 24-hour format -> On'
        Table = 'system'
        Key   = 'time_12_24'
        Value = '24'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> System -> Language -> English (United States)'
        Table = 'system'
        Key   = 'system_locales'
        Value = 'en-US'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Developer options -> Window animation scale -> Animation off'
        Table = 'global'
        Key   = 'window_animation_scale'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Developer options -> Transition animation scale -> Animation off'
        Table = 'global'
        Key   = 'transition_animation_scale'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Developer options -> Animator duration scale -> Animation off'
        Table = 'global'
        Key   = 'animator_duration_scale'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> System -> System sounds -> Off'
        Table = 'system'
        Key   = 'sound_effects_enabled'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Stay awake while plugged into power'
        Table = 'global'
        Key   = 'stay_on_while_plugged_in'
        Value = '7'
        # 1 = stay awake while on AC charger
        # 2 = stay awake while on USB power
        # 4 = stay awake while wireless charging
        # 7 = 1 + 2 + 4, so stay awake for all power types
    }

    [PSCustomObject]@{
        Name  = 'Do not turn the screen off for a very long time'
        Table = 'system'
        Key   = 'screen_off_timeout'
        Value = '2147483647' # ms
    }

    [PSCustomObject]@{
        Name  = 'Disable the Android screensaver / Daydream / ambient mode'
        Table = 'secure'
        Key   = 'screensaver_enabled'
        Value = '0'
    }
)

foreach ($setting in $settings) {
    $table = $setting.Table
    $key = $setting.Key
    $value = $setting.Value

    $old = & adb.exe shell settings get $table $key
    $old = "$old".Trim()

    if ($old -match '^(null)?$') {
        $oldDisplay = '<created>'
    } else {
        $oldDisplay = $old
    }

    & adb.exe shell settings put $table $key $value

    $new = & adb.exe shell settings get $table $key
    $new = "$new".Trim()

    Write-Host "$($setting.Name) ($table $key): $oldDisplay -> $new"
}

$PKG = 'dev.vodik7.tvquickactions'

$PackageCheck = adb shell "pm list packages $PKG"

if ($PackageCheck -match "package:$([regex]::Escape($PKG))") {

    # Accessibility service / secure settings
    adb shell "pm grant $PKG android.permission.WRITE_SECURE_SETTINGS 2>/dev/null || true"

    # Display over other apps
    adb shell "pm grant $PKG android.permission.SYSTEM_ALERT_WINDOW 2>/dev/null || true"
    adb shell "cmd appops set --user 0 $PKG SYSTEM_ALERT_WINDOW allow || appops set --user 0 $PKG android:system_alert_window allow"

    # Usage access
    adb shell "pm grant $PKG android.permission.PACKAGE_USAGE_STATS 2>/dev/null || true"
    adb shell "cmd appops set --user 0 $PKG GET_USAGE_STATS allow || appops set --user 0 $PKG android:get_usage_stats allow"

    # Disable Energy optimization / battery optimization
    $Whitelist = adb shell 'cmd deviceidle whitelist' 2>$null
    $IsWhitelisted = $Whitelist | Select-String -SimpleMatch $PKG

    if (-not $IsWhitelisted) {
        adb shell "cmd deviceidle whitelist +$PKG"
    } else {
        Write-Host "Already whitelisted: $PKG"
    }

    adb shell "am set-inactive $PKG false"
    adb shell "am set-standby-bucket $PKG active"
    adb shell "cmd appops set --user 0 $PKG RUN_IN_BACKGROUND allow || true"
    adb shell "cmd appops set --user 0 $PKG RUN_ANY_IN_BACKGROUND allow || true"
    adb shell "cmd appops set --user 0 $PKG START_FOREGROUND allow || true"
} else {
    Write-Host "Package not found: $PKG"
}

# List of packages to uninstall
$Packages = @(
    'com.android.adservices.api', # Android AdServices. Introduced in Android 13 privacy sandbox beta components disabled on default. https://source.android.com/docs/core/ota/modular-system/adservices
    'com.android.federatedcompute.services', # FederatedCompute. Another component of OnDevicePersonalization. But this app learns things about users. Introduced in Android 14(`com.google.android.federatedcompute` Introduced in Android 13). https://source.android.com/docs/core/ota/modular-system/ondevicepersonalization
    'com.android.hotwordenrollment.okgoogle', # "OK Google" detection service.
    'com.android.hotwordenrollment.xgoogle', # "OK Google" detection service.
    'com.android.nearby.halfsheet', # Useless frameworks to Wi-Fi connections, USB tethering, auto, usage. Every version has random code and the app is not running in the background.
    'com.android.ondevicepersonalization.services', # OnDevicePersonalization. Another thing to AdServices privacy sandbox. Introduced in Android 13. https://source.android.com/docs/core/ota/modular-system/ondevicepersonalization
    'com.android.providers.settings.auto_generated_rro_product__', # Useless overlay to Backup google. Backup works without it.
    'com.google.android.apps.tv.dreamx', # Ambient Mode. Running wallpapers from this app like a slideshow. https://play.google.com/store/apps/details?id=com.google.android.apps.tv.dreamx&hl=en&gl=US
    'com.google.android.feedback', # This is the package that sends crash-report feedback to the Play Store? The crash pop-up still happens with this disabled. Doesn't seem to run on its own. Has permission to access system logs and package usage stats. Only connects to 4 Google domains. App developers likely have to go through the Play Store to access any sent data. https://beta.pithus.org/report/7041823ff880c207ed2ddacdc92e5ed803b1eb105e4483696d2152bea44903aa
    'com.google.android.onetimeinitializer', # Provides first time setup, safe to remove.
    'com.google.android.play.games', # Google Play Games (https://play.google.com/store/apps/details?id=com.google.android.play.games)
    'com.google.android.youtube.tv', # YouTube app. https://play.google.com/store/apps/details?id=com.google.android.youtube.tv&hl=en_US
    'com.google.android.youtube.tvmusic', # YouTube Music https://play.google.com/store/apps/details?id=com.google.android.youtube.tvmusic&hl=en&gl=US
    'com.android.health.connect.backuprestore', # Backups data from Health Connect app.
    'com.android.healthconnect.controller', # Health Connect. Manage the health and fitness data on your phone, and control which apps can access it.
    'com.netflix.ninja', # Netflix
    'ru.haier.evo', # evo tv
    'com.haier.apps.evoSmart', # (Russian named app which translates to "Local Apps", when opening the app we see a list of apps which we can download inside of it)
    'com.mediatek.tv.oneworld.tvcenter', # Live TV. I guess it's for scanning channels.
    'com.mediatek.wwtv.mediaplayer', # MultiMediaPlayer. I guess it's not needed because there are better apps.
    'com.haier.emanual9603', # E-Manual.
    'com.haier.launcher.haiermatrix' # Haier TV+. Seems like a wrapper app that opens other haier apps which are already installed.
    # To restore you can use `adb shell cmd package install-existing com.google.android.tv.remote.service`
)

foreach ($package in $Packages) {
    $exists = adb shell pm list packages $package | ForEach-Object {
        $_.Trim()
    } | Where-Object {
        $_ -eq "package:$package"
    }

    if ($exists) {
        Write-Host "Package found. Uninstalling: $package" -ForegroundColor Yellow

        $result = adb shell pm uninstall --user 0 $package 2>&1

        if ($result -match 'Success') {
            Write-Host "Uninstalled successfully: $package" -ForegroundColor Green
        } else {
            Write-Host "Failed to uninstall: $package" -ForegroundColor Red
            Write-Host $result
        }
    } else {
        Write-Host "Package not found, skipping: $package" -ForegroundColor DarkGray
    }
}

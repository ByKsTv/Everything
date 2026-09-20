# Android TV setup over ADB

# 1. Wait for a device
Write-Host 'Waiting for a device...' -ForegroundColor Yellow
adb wait-for-device

# 2. Select the device (only asks when several are connected)
$serials = @(adb devices | Where-Object { $_ -match '\tdevice\s*$' } | ForEach-Object { ($_ -split '\s+')[0] })
$serial = $serials[0]
if ($serials.Count -gt 1) {
    $serial = $serials | Out-GridView -Title 'Select a device' -OutputMode Single
}
if (-not $serial) {
    return
}
Write-Host "Using device: $serial" -ForegroundColor Green

# 3. Ask for the device name (spaces are fine)
Add-Type -AssemblyName Microsoft.VisualBasic
$deviceName = [Microsoft.VisualBasic.Interaction]::InputBox('Enter the TV name:', 'Set Device Name', 'Brand-Model').Trim()
if (-not $deviceName) {
    return
}

# 4. Apply settings (every adb command from here on targets the selected device)
$env:ANDROID_SERIAL = $serial

$powerInfo = adb shell dumpsys power | Out-String
if ($powerInfo -match '(?:mScreenBrightnessSettingMaximum|mMaximumScreenBrightnessSetting)=(\d+)') {
    $maxBrightness = $Matches[1]
} else {
    Write-Warning 'Max brightness not found, using 255'
    $maxBrightness = '255'
}

$settings = @(
    @{ Name = 'Display -> Backlight -> Maximum'; Table = 'system'; Key = 'screen_brightness'; Value = $maxBrightness }
    @{ Name = 'Network -> Scanning always available -> Off'; Table = 'global'; Key = 'wifi_scan_always_enabled'; Value = '0' }
    @{ Name = 'Privacy -> Location -> Off'; Table = 'secure'; Key = 'location_mode'; Value = '0' }
    @{ Name = 'Privacy -> Microphone access on your remote -> Off'; Table = 'global'; Key = 'receive_explicit_user_interaction_audio_enabled'; Value = '0' }
    @{ Name = 'Privacy -> Usage & diagnostics -> Off'; Table = 'global'; Key = 'multi_cb'; Value = '0' }
    @{ Name = 'Privacy -> Security -> Scan apps with Play Protect -> Off'; Table = 'global'; Key = 'package_verifier_user_consent'; Value = '-1' }
    @{ Name = 'Privacy -> Security -> Improve harmful app detection -> Off'; Table = 'global'; Key = 'upload_apk_enable'; Value = '0' }
    @{ Name = 'Power -> Shut-off timer -> When inactive -> Never'; Table = 'secure'; Key = 'sleep_timeout'; Value = '-1' }
    @{ Name = 'Power -> Shut-off timer -> When watching -> Never'; Table = 'secure'; Key = 'attentive_timeout'; Value = '-1' }
    @{ Name = 'Power -> Shut-off timer -> Countdown -> Never'; Table = 'global'; Key = 'power_sleep_timer'; Value = '0' }
    @{ Name = 'Power -> Shut-off timer -> Countdown -> Never'; Table = 'global'; Key = 'REMIND_TIME'; Value = '0' }
    @{ Name = 'Power -> Shut-off timer -> Countdown -> Never'; Table = 'global'; Key = 'tv_timer_sleep_timer_entry_values'; Value = '0' }
    @{ Name = 'Power -> Scheduled power on -> Off'; Table = 'global'; Key = 'tv_timer_power_on_time_type_entry_values'; Value = '0' }
    @{ Name = 'Power -> Scheduled power off -> Off'; Table = 'global'; Key = 'tv_timer_power_off_time_type_entry_values'; Value = '0' }
    @{ Name = 'Power -> Power off after turning on -> Off'; Table = 'global'; Key = 'power_switch_off_timer'; Value = '0' }
    @{ Name = 'About -> Device name (Bluetooth)'; Table = 'secure'; Key = 'bluetooth_name'; Value = $deviceName }
    @{ Name = 'About -> Device name'; Table = 'global'; Key = 'device_name'; Value = $deviceName }
    @{ Name = 'Date & Time -> Automatic date & time -> Network'; Table = 'global'; Key = 'auto_time'; Value = '1' }
    @{ Name = 'Date & Time -> 24-hour format -> On'; Table = 'system'; Key = 'time_12_24'; Value = '24' }
    @{ Name = 'Language -> English (United States)'; Table = 'system'; Key = 'system_locales'; Value = 'en-US' }
    @{ Name = 'Developer -> Window animation scale -> Off'; Table = 'global'; Key = 'window_animation_scale'; Value = '0' }
    @{ Name = 'Developer -> Transition animation scale -> Off'; Table = 'global'; Key = 'transition_animation_scale'; Value = '0' }
    @{ Name = 'Developer -> Animator duration scale -> Off'; Table = 'global'; Key = 'animator_duration_scale'; Value = '0' }
    @{ Name = 'System sounds -> Off'; Table = 'system'; Key = 'sound_effects_enabled'; Value = '0' }
    @{ Name = 'Stay awake while plugged in (1 AC + 2 USB + 4 wireless)'; Table = 'global'; Key = 'stay_on_while_plugged_in'; Value = '7' }
    @{ Name = 'Screen off timeout -> Never (ms)'; Table = 'system'; Key = 'screen_off_timeout'; Value = '2147483647' }
    @{ Name = 'Screensaver / ambient mode -> Off'; Table = 'secure'; Key = 'screensaver_enabled'; Value = '0' }
)

foreach ($setting in $settings) {
    $table = $setting.Table
    $key = $setting.Key
    $value = $setting.Value -replace "'", "'\''"   # the TV's shell gets the value in single quotes, so spaces survive

    $oldValue = adb shell settings get $table $key
    adb shell "settings put $table $key '$value'"
    $newValue = adb shell settings get $table $key

    $message = "$($setting.Name) ($table $key): $oldValue -> $newValue"
    if ($newValue -eq $setting.Value) {
        Write-Host "[OK] $message" -ForegroundColor Green
    } else {
        Write-Host "[FAILED] $message" -ForegroundColor Red
    }
}

# 5. Uninstall unwanted packages (restore with: adb shell cmd package install-existing <package>)
$installedPackages = (adb shell pm list packages) -replace '^package:|\s+$', ''
$appsToUninstall = @(
    @{ Name = 'AdServices (Privacy Sandbox, Android 13+)'; Package = 'com.android.adservices.api' }
    @{ Name = 'FederatedCompute, learns from user data (Android 14+)'; Package = 'com.android.federatedcompute.services' }
    @{ Name = '"OK Google" detection'; Package = 'com.android.hotwordenrollment.okgoogle' }
    @{ Name = '"OK Google" detection'; Package = 'com.android.hotwordenrollment.xgoogle' }
    @{ Name = 'Nearby pop-ups (Wi-Fi, tethering), useless on a TV'; Package = 'com.android.nearby.halfsheet' }
    @{ Name = 'OnDevicePersonalization (Privacy Sandbox)'; Package = 'com.android.ondevicepersonalization.services' }
    @{ Name = 'Useless settings overlay, backup works without it'; Package = 'com.android.providers.settings.auto_generated_rro_product__' }
    @{ Name = 'Ambient Mode slideshow'; Package = 'com.google.android.apps.tv.dreamx' }
    @{ Name = 'Sends crash reports to the Play Store'; Package = 'com.google.android.feedback' }
    @{ Name = 'First-time setup, safe to remove'; Package = 'com.google.android.onetimeinitializer' }
    @{ Name = 'Google Play Games'; Package = 'com.google.android.play.games' }
    @{ Name = 'YouTube'; Package = 'com.google.android.youtube.tv' }
    @{ Name = 'YouTube Music'; Package = 'com.google.android.youtube.tvmusic' }
    @{ Name = 'Health Connect backup'; Package = 'com.android.health.connect.backuprestore' }
    @{ Name = 'Health Connect'; Package = 'com.android.healthconnect.controller' }
    @{ Name = 'Netflix'; Package = 'com.netflix.ninja' }
    @{ Name = 'evo tv'; Package = 'ru.haier.evo' }
    @{ Name = '"Local Apps" (Russian), in-app app store'; Package = 'com.haier.apps.evoSmart' }
    @{ Name = 'Live TV, used for scanning channels'; Package = 'com.mediatek.tv.oneworld.tvcenter' }
    @{ Name = 'MultiMediaPlayer, better apps exist'; Package = 'com.mediatek.wwtv.mediaplayer' }
    @{ Name = 'E-Manual'; Package = 'com.haier.emanual9603' }
    @{ Name = 'Haier TV+, wrapper that opens other Haier apps'; Package = 'com.haier.launcher.haiermatrix' }
    @{ Name = 'Prime Video'; Package = 'com.amazon.amazonvideo.livingroom' }
    @{ Name = 'PatchWall, suspected spyware'; Package = 'com.mitv.tvhome.atv' }
    @{ Name = 'Mi Channel, same as PatchWall'; Package = 'com.mitv.tvhome.michannel' }
    @{ Name = 'Mi TV Plus'; Package = 'com.mitv.tvhome.mitvplus' }
    @{ Name = 'Analytics with a lot of random resources'; Package = 'com.miui.tv.analytics' }
    # @{ Name = 'Xiaomi update service'; Package = 'com.xiaomi.mitv.updateservice' }
    # @{ Name = 'Mi TV OEM tab'; Package = 'com.mitv.tvhome.oemtab' }
)

foreach ($app in $appsToUninstall) {
    if ($installedPackages -notcontains $app.Package) {
        Write-Host "[SKIPPED] $($app.Name): $($app.Package) is not installed" -ForegroundColor DarkGray
        continue
    }

    $result = adb shell pm uninstall --user 0 $app.Package

    if ($result -match 'Success') {
        Write-Host "[OK] Uninstalled $($app.Name) ($($app.Package))" -ForegroundColor Green
    } else {
        Write-Host "[FAILED] $($app.Name) ($($app.Package)): $result" -ForegroundColor Red
    }
}

# 6. Grant every runtime permission and special app access that each installed app requests
$installedPackages = (adb shell pm list packages) -replace '^package:|\s+$', ''   # read again, the uninstalled apps are gone

# Permission the app must declare -> app-op to allow (Settings -> Apps -> Special app access)
$specialAccess = @{
    SYSTEM_ALERT_WINDOW      = 'SYSTEM_ALERT_WINDOW'       # Display over other apps
    PACKAGE_USAGE_STATS      = 'GET_USAGE_STATS'           # Usage data access
    WRITE_SETTINGS           = 'WRITE_SETTINGS'            # Modify system settings
    MANAGE_EXTERNAL_STORAGE  = 'MANAGE_EXTERNAL_STORAGE'   # All files access
    REQUEST_INSTALL_PACKAGES = 'REQUEST_INSTALL_PACKAGES'  # Install unknown apps
    SCHEDULE_EXACT_ALARM     = 'SCHEDULE_EXACT_ALARM'      # Alarms & reminders
    USE_FULL_SCREEN_INTENT   = 'USE_FULL_SCREEN_INTENT'    # Full screen notifications
    MANAGE_MEDIA             = 'MANAGE_MEDIA'              # Media management apps
}

# Apps that get battery optimization turned off even though they do not declare
# REQUEST_IGNORE_BATTERY_OPTIMIZATIONS (they open the battery settings screen instead).
# Apps that do declare it are handled automatically, so only add the others here.
# Value: package name, e.g. 'dev.vodik7.tvquickactions' (TV Quick Actions)
$batteryUnrestricted = @(
    'dev.vodik7.tvquickactions'
)

foreach ($pkg in $installedPackages) {
    $dump = (adb shell dumpsys package $pkg) -join "`n"
    $commands = @()

    # Runtime permissions the app declares, that are not granted yet and not locked by the system
    foreach ($m in [regex]::Matches($dump, '(?m)^\s+([\w.]+): granted=false, flags=\[([^\]]*)\]')) {
        if ($m.Groups[2].Value -notmatch 'SYSTEM_FIXED|POLICY_FIXED') {
            $commands += , @('pm', 'grant', $pkg, $m.Groups[1].Value)
        }
    }

    # Special app access the app declares
    foreach ($permission in $specialAccess.Keys) {
        if ($dump -match "android\.permission\.$permission\b") {
            $commands += , @('appops', 'set', '--user', '0', $pkg, $specialAccess[$permission], 'allow')
        }
    }
    if ($dump -match 'android\.permission\.WRITE_SECURE_SETTINGS: granted=false') {
        $commands += , @('pm', 'grant', $pkg, 'android.permission.WRITE_SECURE_SETTINGS')
    }

    # Battery optimization off, only for apps that ask for it
    if ($dump -match 'android\.permission\.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS' -or $batteryUnrestricted -contains $pkg) {
        $commands += , @('cmd', 'deviceidle', 'whitelist', "+$pkg")
        $commands += , @('am', 'set-inactive', $pkg, 'false')
        $commands += , @('am', 'set-standby-bucket', $pkg, 'active')
        foreach ($op in 'RUN_IN_BACKGROUND', 'RUN_ANY_IN_BACKGROUND', 'START_FOREGROUND') {
            $commands += , @('appops', 'set', '--user', '0', $pkg, $op, 'allow')
        }
    }

    foreach ($command in $commands) {
        $output = "$(adb shell @command 2>&1)"
        $message = $command -join ' '
        if ($LASTEXITCODE -eq 0 -and $output -notmatch 'Exception|Error|Unknown|Failure|not requested') {
            Write-Host "[OK] $message" -ForegroundColor Green
        } else {
            Write-Host "[FAILED] $message : $output" -ForegroundColor Red
        }
    }
}

# 7. Turn on accessibility services (Settings -> Accessibility)
# Value: 'package/class' of the service, as printed by:
#   adb shell settings get secure enabled_accessibility_services
$accessibilityServices = @(
    'dev.vodik7.tvquickactions/dev.vodik7.tvquickactions.KeyAccessibilityService'   # TV Quick Actions
)

foreach ($service in $accessibilityServices) {
    $enabled = adb shell settings get secure enabled_accessibility_services
    if ($enabled -eq 'null') {
        $enabled = ''
    }
    if ($enabled -notlike "*$service*") {
        $enabled = (@($enabled -split ':' | Where-Object { $_ }) + $service) -join ':'
        adb shell "settings put secure enabled_accessibility_services '$enabled'"
    }
    adb shell settings put secure accessibility_enabled 1

    $result = adb shell settings get secure enabled_accessibility_services
    if ($result -like "*$service*") {
        Write-Host "[OK] Accessibility: $service" -ForegroundColor Green
    } else {
        Write-Host "[FAILED] Accessibility: $service : $result" -ForegroundColor Red
    }
}

# 8. Clean up
Remove-Item Env:ANDROID_SERIAL
Write-Host 'Done.' -ForegroundColor Green

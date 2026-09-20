# Android Smartphone setup over ADB

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

# 3. Apply settings (every adb command from here on targets the selected device)
$env:ANDROID_SERIAL = $serial

$settings = @(
    @{ Name = 'Phone -> Call settings -> Record calls -> Show notification after recording -> Off'; Table = 'system'; Key = 'record_calls_notification_on_off'; Value = '0' }
    # @{ Name = 'Phone -> Call settings -> Record calls -> Auto record calls -> On'; Table = 'system'; Key = 'record_calls_automatically_on_off'; Value = '1' }
    @{ Name = 'Play Store -> Play Protect -> Scan apps with Play Protect -> Off'; Table = 'global'; Key = 'package_verifier_user_consent'; Value = '-1' }
    @{ Name = 'Settings -> Connections -> Wi-Fi -> Intelligent Wi-Fi -> Switch to mobile data -> Off'; Table = 'global'; Key = 'wifi_watchdog_poor_network_test_enabled'; Value = '0' }
    @{ Name = 'Settings -> Connections -> Wi-Fi -> Intelligent Wi-Fi -> Switch to better Wi-Fi networks -> Off'; Table = 'global'; Key = 'sem_wifi_switch_to_better_wifi_enabled'; Value = '0' }
    @{ Name = 'Settings -> Connections -> Wi-Fi -> Intelligent Wi-Fi -> Turn Wi-Fi on/off automatically -> Off'; Table = 'global'; Key = 'sem_auto_wifi_control_enabled'; Value = '0' }
    @{ Name = 'Settings -> Connections -> Wi-Fi -> Intelligent Wi-Fi -> Show network quality info -> Off'; Table = 'global'; Key = 'sem_wifi_network_rating_scorer_enabled'; Value = '0' }
    @{ Name = 'Settings -> Connections -> Wi-Fi Calling -> On'; Table = 'system'; Key = 'wifi_call_enable1'; Value = '1' }
    @{ Name = 'Settings -> Connections -> Wi-Fi Calling -> Calling Preference -> Wi-Fi preferred'; Table = 'system'; Key = 'wifi_call_preferred1'; Value = '1' }
    @{ Name = 'Settings -> Connections -> Bluetooth -> Off'; Table = 'global'; Key = 'bluetooth_on'; Value = '0' }
    @{ Name = 'Settings -> Connections -> Bluetooth -> Advanced settings -> Music Share -> Off'; Table = 'secure'; Key = 'bluetooth_cast_mode'; Value = '0' }
    @{ Name = 'Settings -> Connections -> Airplane mode -> Off'; Table = 'global'; Key = 'airplane_mode_on'; Value = '0' }
    @{ Name = 'Settings -> Connections -> Mobile networks -> Data roaming -> Off'; Table = 'global'; Key = 'data_roaming'; Value = '0' }
    @{ Name = 'Settings -> Connections -> Mobile networks -> VoLTE calls -> On'; Table = 'system'; Key = 'voicecall_type'; Value = '0' }
    @{ Name = 'Settings -> Connections -> Data usage -> Mobile data -> On'; Table = 'global'; Key = 'mobile_data'; Value = '1' }
    @{ Name = 'Settings -> Connections -> More connection settings -> Private DNS -> Off'; Table = 'global'; Key = 'private_dns_mode'; Value = 'off' }
    @{ Name = 'Settings -> Modes and Routines -> Settings -> Show routines on Lock screen -> Off'; Table = 'system'; Key = 'add_info_com_samsung_android_app_routines#dashboard'; Value = '0' }
    @{ Name = 'Settings -> Sounds and vibration -> Sounds'; Table = 'global'; Key = 'mode_ringer'; Value = '2' }
    @{ Name = 'Settings -> Sounds and vibration -> Vibrate while ringing'; Table = 'system'; Key = 'vibrate_when_ringing'; Value = '1' }
    @{ Name = 'Settings -> Sounds and vibration -> System sounds -> Touch interactions -> Off'; Table = 'system'; Key = 'sound_effects_enabled'; Value = '0' }
    @{ Name = 'Settings -> Sounds and vibration -> System sounds -> Dialing keypad -> Off'; Table = 'system'; Key = 'dtmf_tone'; Value = '0' }
    @{ Name = 'Settings -> Sounds and vibration -> System sounds -> Samsung Keyboard -> Off'; Table = 'system'; Key = 'sip_key_feedback_sound'; Value = '0' }
    @{ Name = 'Settings -> Sounds and vibration -> System sounds -> Charging -> On'; Table = 'secure'; Key = 'charging_sounds_enabled'; Value = '1' }
    @{ Name = 'Settings -> Sounds and vibration -> System sounds -> Screen lock/unlock -> On'; Table = 'system'; Key = 'lockscreen_sounds_enabled'; Value = '1' }
    @{ Name = 'Settings -> Sounds and vibration -> Volume -> Use Volume keys for media -> On'; Table = 'system'; Key = 'adjust_media_volume_only'; Value = '1' }
    @{ Name = 'Settings -> Sounds and vibration -> Volume -> Media volume limit -> Off'; Table = 'system'; Key = 'volumelimit_on'; Value = '0' }
    @{ Name = 'Settings -> Sounds and vibration -> System vibration -> Touch interactions -> Off'; Table = 'system'; Key = 'haptic_feedback_enabled'; Value = '0' }
    @{ Name = 'Settings -> Sounds and vibration -> System vibration -> Dialing keypad -> Off'; Table = 'system'; Key = 'dialing_keypad_vibrate'; Value = '0' }
    @{ Name = 'Settings -> Sounds and vibration -> System vibration -> Samsung Keyboard -> Off'; Table = 'system'; Key = 'sip_key_feedback_vibration'; Value = '0' }
    @{ Name = 'Settings -> Sounds and vibration -> System vibration -> Charging -> Off'; Table = 'secure'; Key = 'charging_vibration_enabled'; Value = '0' }
    @{ Name = 'Settings -> Sounds and vibration -> System vibration -> Navigation gestures -> Off'; Table = 'system'; Key = 'navigation_gestures_vibrate'; Value = '0' }
    @{ Name = 'Settings -> Notifications -> Lock screen notifications -> On'; Table = 'secure'; Key = 'lock_screen_show_notifications'; Value = '1' }
    @{ Name = 'Settings -> Notifications -> Lock screen notifications -> Show content'; Table = 'secure'; Key = 'lock_screen_allow_private_notifications'; Value = '1' }
    @{ Name = 'Settings -> Notifications -> Lock screen notifications -> Show content when unlocked -> On'; Table = 'secure'; Key = 'lock_screen_allow_private_notifications_when_unsecure'; Value = '1' }
    @{ Name = 'Settings -> Notifications -> Lock screen notifications -> Notifications to show -> Alert and silent notifications'; Table = 'secure'; Key = 'lock_screen_show_silent_notifications'; Value = '1' }
    @{ Name = 'Settings -> Notifications -> Notification pop-up style -> Detailed'; Table = 'system'; Key = 'edge_lighting'; Value = '0' }
    @{ Name = 'Settings -> Notifications -> Advanced settings -> Show notification icons -> All notifications'; Table = 'system'; Key = 'simple_status_bar'; Value = '0' }
    @{ Name = 'Settings -> Notifications -> Advanced settings -> Show battery percentage -> On'; Table = 'system'; Key = 'display_battery_percentage'; Value = '1' }
    @{ Name = 'Settings -> Notifications -> Advanced settings -> Notification history -> Off'; Table = 'secure'; Key = 'notification_history_enabled'; Value = '0' }
    @{ Name = 'Settings -> Notifications -> Advanced settings -> Floating notifications -> Off'; Table = 'secure'; Key = 'notification_bubbles'; Value = '0' }
    @{ Name = 'Settings -> Notifications -> Advanced settings -> Show snooze button -> Off'; Table = 'secure'; Key = 'show_notification_snooze'; Value = '0' }
    @{ Name = 'Settings -> Notifications -> Advanced settings -> Notification reminders -> Off'; Table = 'system'; Key = 'notification_reminder_selectable'; Value = '0' }
    @{ Name = 'Settings -> Notifications -> Advanced settings -> App icon badges -> Off'; Table = 'secure'; Key = 'notification_badging'; Value = '0' }
    @{ Name = 'Settings -> Display -> Dark mode settings -> Turn on as scheduled -> Off'; Table = 'system'; Key = 'display_night_theme_scheduled'; Value = '0' }
    @{ Name = 'Settings -> Display -> Brightness -> Max'; Table = 'system'; Key = 'screen_brightness'; Value = '255' }
    @{ Name = 'Settings -> Display -> Adaptive brightness -> Off'; Table = 'system'; Key = 'screen_brightness_mode'; Value = '0' }
    @{ Name = 'Settings -> Display -> Eye comfort shield -> Off'; Table = 'system'; Key = 'blue_light_filter'; Value = '0' }
    @{ Name = 'Settings -> Display -> Accidental touch protection -> Off'; Table = 'system'; Key = 'screen_off_pocket'; Value = '0' }
    @{ Name = 'Settings -> Display -> Touch sensitivity -> Off'; Table = 'system'; Key = 'auto_adjust_touch'; Value = '0' }
    @{ Name = 'Settings -> Display -> Show charging information -> Off'; Table = 'system'; Key = 'charging_info_always'; Value = '0' }
    @{ Name = 'Settings -> Display -> Screen saver -> None'; Table = 'secure'; Key = 'screensaver_enabled'; Value = '0' }
    @{ Name = 'Settings -> Wallpaper and style -> Dim wallpaper when Dark mode is on -> Off'; Table = 'system'; Key = 'display_night_theme_wallpaper'; Value = '0' }
    @{ Name = 'Settings -> Lock screen -> Touch and hold to edit -> Off'; Table = 'system'; Key = 'lock_editor_support_touch_hold'; Value = '0' }
    @{ Name = 'Settings -> Lock screen -> Always On Display -> Off'; Table = 'system'; Key = 'aod_mode'; Value = '0' }
    @{ Name = 'Settings -> Lock screen -> Roaming clock -> Off'; Table = 'system'; Key = 'dualclock_menu_settings'; Value = '0' }
    @{ Name = 'Settings -> Advanced features -> Motions and gestures -> Life to wake -> Off'; Table = 'system'; Key = 'lift_to_wake'; Value = '0' }
    @{ Name = 'Settings -> Advanced features -> Screenshots -> Screenshot format -> PNG'; Table = 'global'; Key = 'smart_capture_screenshot_format'; Value = 'PNG' }
    @{ Name = 'Settings -> Advanced features -> Visibility enhancments -> Remove animations -> On'; Table = 'global'; Key = 'remove_animations'; Value = '1' }
    @{ Name = 'Settings -> Location -> Location services -> Wi-Fi scanning -> On'; Table = 'global'; Key = 'wifi_scan_always_enabled'; Value = '1' }
    @{ Name = 'Settings -> Location -> Location services -> Bluetooth scanning -> On'; Table = 'global'; Key = 'ble_scan_always_enabled'; Value = '1' }
    @{ Name = 'Settings -> Developer options -> Disable adb authorization timeout -> On'; Table = 'global'; Key = 'adb_allowed_connection_time'; Value = '0' }
    @{ Name = 'Settings -> Developer options -> Mobile data always active -> On'; Table = 'global'; Key = 'mobile_data_always_on'; Value = '1' }
    @{ Name = 'Settings -> Developer options -> Network download rate limit -> No limit'; Table = 'global'; Key = 'ingress_rate_limit_bytes_per_second'; Value = '-1' }
    @{ Name = 'Settings -> Developer options -> Window animation scale -> Animation off'; Table = 'global'; Key = 'window_animation_scale'; Value = '0' }
    @{ Name = 'Settings -> Developer options -> Transition animation scale -> Animation off'; Table = 'global'; Key = 'transition_animation_scale'; Value = '0' }
    @{ Name = 'Settings -> Developer options -> Animator duration scale -> Animation off'; Table = 'global'; Key = 'animator_duration_scale'; Value = '0' }
    @{ Name = 'Settings -> Developer options -> Force full GNSS measurements -> On'; Table = 'global'; Key = 'enable_gnss_raw_meas_full_tracking'; Value = '1' }
    @{ Name = 'Settings -> Battery and device care -> Memory -> RAM Plus -> Off'; Table = 'global'; Key = 'ram_expand_size'; Value = '0' }
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

# 4. Uninstall unwanted packages (restore with: adb shell cmd package install-existing <package>)
$installedPackages = (adb shell pm list packages) -replace '^package:|\s+$', ''
$appsToUninstall = @(
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

# 5. Grant every runtime permission and special app access that each installed app requests
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
    # 'dev.vodik7.tvquickactions'
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

# 6. Turn on accessibility services (Settings -> Accessibility)
# Value: 'package/class' of the service, as printed by:
#   adb shell settings get secure enabled_accessibility_services
$accessibilityServices = @(
    # 'dev.vodik7.tvquickactions/dev.vodik7.tvquickactions.KeyAccessibilityService'   # TV Quick Actions
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

# 7. Clean up
Remove-Item Env:ANDROID_SERIAL
Write-Host 'Done.' -ForegroundColor Green

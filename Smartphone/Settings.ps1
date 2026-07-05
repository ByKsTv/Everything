$settings = @(
    [PSCustomObject]@{
        Name  = 'Phone -> Call settings -> Record calls -> Show notification after recording -> Off'
        Table = 'system'
        Key   = 'record_calls_notification_on_off'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Phone -> Call settings -> Record calls -> Auto record calls -> On'
        Table = 'system'
        Key   = 'record_calls_automatically_on_off'
        Value = '1'
    }

    [PSCustomObject]@{
        Name  = 'Play Store -> Play Protect -> Scan apps with Play Protect -> Off'
        Table = 'global'
        Key   = 'package_verifier_user_consent'
        Value = '-1'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Connections -> Wi-Fi -> Intelligent Wi-Fi -> Switch to mobile data -> Off'
        Table = 'global'
        Key   = 'wifi_watchdog_poor_network_test_enabled'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Connections -> Wi-Fi -> Intelligent Wi-Fi -> Switch to better Wi-Fi networks -> Off'
        Table = 'global'
        Key   = 'sem_wifi_switch_to_better_wifi_enabled'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Connections -> Wi-Fi -> Intelligent Wi-Fi -> Turn Wi-Fi on/off automatically -> Off'
        Table = 'global'
        Key   = 'sem_auto_wifi_control_enabled'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Connections -> Wi-Fi -> Intelligent Wi-Fi -> Show network quality info -> Off'
        Table = 'global'
        Key   = 'sem_wifi_network_rating_scorer_enabled'
        Value = '0'
    }

    # Settings -> Connections -> Wi-Fi -> Intelligent Wi-Fi -> Detect suspicious networks -> Off

    [PSCustomObject]@{
        Name  = 'Settings -> Connections -> Wi-Fi Calling -> On'
        Table = 'system'
        Key   = 'wifi_call_enable1'
        Value = '1'
    }
 
    [PSCustomObject]@{
        Name  = 'Settings -> Connections -> Wi-Fi Calling -> Calling Preference -> Wi-Fi preferred'
        Table = 'system'
        Key   = 'wifi_call_preferred1'
        Value = '1'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Connections -> Bluetooth -> Off'
        Table = 'global'
        Key   = 'bluetooth_on'
        Value = '0'
    }
 
    [PSCustomObject]@{
        Name  = 'Settings -> Connections -> Bluetooth -> Advanced settings -> Music Share -> Off'
        Table = 'secure'
        Key   = 'bluetooth_cast_mode'
        Value = '0'
    }

    # Settings -> Connections -> Bluetooth -> Advanced settings -> Ringtone sync -> On

    # Settings -> Connections -> NFC and contactless payments -> Off

    [PSCustomObject]@{
        Name  = 'Settings -> Connections -> Airplane mode -> Off'
        Table = 'global'
        Key   = 'airplane_mode_on'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Connections -> Mobile networks -> Data roaming -> Off'
        Table = 'global'
        Key   = 'data_roaming'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Connections -> Mobile networks -> VoLTE calls -> On'
        Table = 'system'
        Key   = 'voicecall_type'
        Value = '0'
    }

    # Settings -> Connections -> Mobile networks -> Network mode -> LTE/3G/2G (auto connect)

    # Settings -> Connections -> Mobile networks -> Network operators -> Select automatically -> On

    # Settings -> Connections -> Data usage -> Data saver -> Off

    [PSCustomObject]@{
        Name  = 'Settings -> Connections -> Data usage -> Mobile data -> On'
        Table = 'global'
        Key   = 'mobile_data'
        Value = '1'
    }

    # Settings -> Connections -> Data usage -> Billing cycle and data warning -> Start billing cycle on -> 1st day of each month

    # Settings -> Connections -> Data usage -> Billing cycle and data warning -> Set data warning -> Off

    # Settings -> Connections -> Data usage -> Billing cycle and data warning -> Set data limit -> Off

    # Settings -> Connections -> Mobile Hotspot and Tethering -> Mobile Hotspot -> Off

    # Settings -> Connections -> Mobile Hotspot and Tethering -> Bluetooth tethering -> Off

    [PSCustomObject]@{
        Name  = 'Settings -> Connections -> More connection settings -> Private DNS -> Off'
        Table = 'global'
        Key   = 'private_dns_mode'
        Value = 'off'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Display -> Dark'
        Table = 'secure'
        Key   = 'ui_night_mode'
        Value = '2'
    }
    [PSCustomObject]@{
        Name  = 'Settings -> Display -> Dark'
        Table = 'system'
        Key   = 'display_night_theme'
        Value = '1'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Display -> Dark mode settings -> Turn on as scheduled -> Off'
        Table = 'system'
        Key   = 'display_night_theme_scheduled'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Display -> Brightness -> Max'
        Table = 'system'
        Key   = 'screen_brightness'
        Value = '255'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Display -> Adaptive brightness -> Off'
        Table = 'system'
        Key   = 'screen_brightness_mode'
        Value = '0'
    }
    
    [PSCustomObject]@{
        Name  = 'Settings -> Location -> Location services -> Wi-Fi scanning -> On'
        Table = 'global'
        Key   = 'wifi_scan_always_enabled'
        Value = '1'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Location -> Location services -> Bluetooth scanning -> On'
        Table = 'global'
        Key   = 'ble_scan_always_enabled'
        Value = '1'
    }

    # Settings -> Developer options -> Wi-Fi scan throttling -> On

    [PSCustomObject]@{
        Name  = 'Settings -> Developer options -> Mobile data always active -> Off'
        Table = 'global'
        Key   = 'mobile_data_always_on'
        Value = '0'
    }

    [PSCustomObject]@{
        Name  = 'Settings -> Developer options -> Network download rate limit -> No limit'
        Table = 'global'
        Key   = 'ingress_rate_limit_bytes_per_second'
        Value = '-1'
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
        Name  = 'Settings -> Developer options -> Force full GNSS measurements -> On'
        Table = 'global'
        Key   = 'enable_gnss_raw_meas_full_tracking'
        Value = '1'
    }


















    # old
    [PSCustomObject]@{
        Name  = 'Turn on Wi-Fi automatically'
        Table = 'global'
        Key   = 'wifi_wakeup_enabled'
        Value = '0' # Off
    }
    [PSCustomObject]@{
        Name  = 'Notify for public networks'
        Table = 'global'
        Key   = 'wifi_networks_available_notification_on'
        Value = '0' # Off
    }
    [PSCustomObject]@{
        Name  = 'Ambient display'
        Table = 'secure'
        Key   = 'doze_enabled'
        Value = '1' # On
    }
    [PSCustomObject]@{
        Name  = 'Tap to wake'
        Table = 'secure'
        Key   = 'double_tap_to_wake'
        Value = '1' # On
    }
    [PSCustomObject]@{
        Name  = 'Use Battery Manager'
        Table = 'global'
        Key   = 'app_auto_restriction_enabled'
        Value = '0' # Off
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
    }
    else {
        $oldDisplay = $old
    }

    & adb.exe shell settings put $table $key $value

    $new = & adb.exe shell settings get $table $key
    $new = "$new".Trim()

    Write-Host "$($setting.Name) ($table $key): $oldDisplay -> $new"
}
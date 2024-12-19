local TIME_THRESHOLD = 1

local function browser_switch(_, remaining_time)
    if remaining_time and remaining_time <= TIME_THRESHOLD and mp.get_property("path", ""):match("^https?://") and
        mp.get_property_number('playlist-count') == 1 then
        mp.command_native({
            name = 'subprocess',
            capture_stdout = true,
            args = {'powershell', '-NoProfile', '-Command',
                    '$browser = Get-Process -Name chrome, firefox -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle } | Select-Object -First 1; if ($browser) { (New-Object -ComObject WScript.Shell).AppActivate($browser.Id); }'}
        })
        print(TIME_THRESHOLD .. " seconds remaining - switching to browser")
        mp.unobserve_property(browser_switch)
    end
end

mp.register_event("file-loaded", function()
    mp.observe_property("playtime-remaining", "native", browser_switch)
end)

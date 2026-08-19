local function switch_to_browser(_, remaining)
    if not remaining or remaining > 2 then
        return
    end

    if mp.get_property_number("playlist-count") ~= 1 then
        return
    end

    if not mp.get_property("path", ""):match("^https?://") then
        return
    end

    mp.unobserve_property(switch_to_browser)

    mp.command_native_async({
        _name = "subprocess",
        playback_only = false,
        args = {"powershell", "-NoProfile", "-WindowStyle", "Hidden", "-Command",
                "$p=Get-Process chrome,firefox -EA 0|? MainWindowTitle|select -First 1;" ..
            "if($p){(New-Object -ComObject WScript.Shell).AppActivate($p.Id)}"}
    })
end

mp.register_event("file-loaded", function()
    mp.observe_property("playtime-remaining", "number", switch_to_browser)
end)

mp.register_event("end-file", function()
    mp.unobserve_property(switch_to_browser)
end)

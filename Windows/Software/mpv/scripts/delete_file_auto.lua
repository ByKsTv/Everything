local TIME_THRESHOLD = 15

local function delete_file_auto(_, remaining_time)
    if remaining_time and remaining_time <= TIME_THRESHOLD and not mp.get_property("path", ""):match("^https?://") then
        print(TIME_THRESHOLD .. " seconds remaining - auto deleting current file")
        mp.command("script-binding delete_file/delete_file")
        mp.unobserve_property(delete_file_auto)
    end
end

mp.register_event("file-loaded", function()
    mp.observe_property("playtime-remaining", "native", delete_file_auto)
end)

local DELETE_THRESHOLD = 15

local function delete_file_near_end(_, remaining_time)
    if not remaining_time or remaining_time > DELETE_THRESHOLD then
        return
    end

    print(DELETE_THRESHOLD .. " seconds remaining - auto deleting current file")
    mp.unobserve_property(delete_file_near_end)
    mp.command("script-binding delete_file/delete_file")
end

mp.register_event("file-loaded", function()
    mp.unobserve_property(delete_file_near_end)

    local path = mp.get_property("path", "")
    if not path:match("^https?://") then
        mp.observe_property("playtime-remaining", "native", delete_file_near_end)
    end
end)

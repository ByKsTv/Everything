local function handle_mouse_move(_, mouse)
    if not mp.get_property_bool("fullscreen") then
        return
    end

    local _, height = mp.get_osd_size()

    if mouse.y < height * 0.3 then
        mp.set_property("cursor-autohide", "always")
    else
        mp.set_property("cursor-autohide", 1000)
    end
end

mp.observe_property("mouse-pos", "native", handle_mouse_move)

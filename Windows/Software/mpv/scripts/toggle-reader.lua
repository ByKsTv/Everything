local mp = require "mp"

local rmode, voff, sstep = false, 0, 0
local bstep, plimit = 100, 0.97

local function update_step()
    local h = mp.get_property_number("video-params/h", 0)
    if h > 0 then
        sstep = bstep / h
    end
end

local function flip_page(dir)
    if not rmode then
        return
    end
    mp.set_property("video-align-y", (dir == 1) and 1 or -1)
    mp.commandv((dir == 1) and "playlist-prev" or "playlist-next")
    voff = 0
    mp.set_property("video-pan-y", 0)
end

local function adjust_pan(dir)
    if not rmode then
        return
    end
    voff = voff - dir * sstep
    if voff >= plimit then
        flip_page(1)
    elseif voff <= -plimit then
        flip_page(-1)
    else
        mp.set_property("video-pan-y", voff)
    end
end

local function toggle_reader(state)
    rmode = state
    mp.osd_message("Reader Mode: " .. (rmode and "On" or "Off"))
    mp.set_property("pause", rmode and "yes" or "no")
    mp.set_property("panscan", rmode and 1 or 0)
    mp.set_property("video-align-y", rmode and -1 or 0)
    if rmode then
        update_step()
        mp.add_forced_key_binding("LEFT", "flip-forward", function()
            flip_page(1)
        end, {
            repeatable = true
        })
        mp.add_forced_key_binding("RIGHT", "flip-backward", function()
            flip_page(-1)
        end, {
            repeatable = true
        })
        mp.add_forced_key_binding("UP", "pan-up", function()
            adjust_pan(-1)
        end, {
            repeatable = true
        })
        mp.add_forced_key_binding("DOWN", "pan-down", function()
            adjust_pan(1)
        end, {
            repeatable = true
        })
    else
        mp.set_property("video-pan-y", 0)
        mp.remove_key_binding("flip-forward")
        mp.remove_key_binding("flip-backward")
        mp.remove_key_binding("pan-up")
        mp.remove_key_binding("pan-down")
    end
end

local function auto_toggle()
    local path = mp.get_property("path", "")
    if path ~= "" then
        local e = (path:match("%.([^%.]+)$") or ""):lower()
        if e == "jpg" or e == "jpeg" or e == "png" or e == "bmp" or e == "webp" then
            if not rmode then
                toggle_reader(true)
            end
        else
            if rmode then
                toggle_reader(false)
            end
        end
    end
end

mp.observe_property("video-params/h", "number", function()
    if rmode then
        update_step()
    end
end)
mp.observe_property("path", "string", auto_toggle)
mp.add_key_binding("ctrl+m", "toggle-reader", function()
    toggle_reader(not rmode)
end)

local mp = require 'mp'

local reader_mode = false
local vertical_offset = 0
local step_size = 0.1
local page_dir = 0

local function reset_page(dir)
    if not reader_mode then
        return
    end
    page_dir = dir
    if dir == 1 then
        mp.set_property("video-align-y", 1) -- Reset alignment for next file
        mp.commandv("playlist-prev")
    elseif dir == -1 then
        mp.set_property("video-align-y", -1) -- Reset alignment for next file
        mp.commandv("playlist-next")
    end
end

local function adjust_pan(dir)
    if not reader_mode then
        return
    end
    vertical_offset = vertical_offset - (dir * step_size)
    if vertical_offset > 1 then
        reset_page(1)
        vertical_offset = 0 -- Reset pan offset
    elseif vertical_offset < -1 then
        reset_page(-1)
        vertical_offset = 0 -- Reset pan offset
    end
    mp.set_property("video-pan-y", vertical_offset)
end

local function toggle_reader(state)
    reader_mode = state
    if reader_mode then
        mp.osd_message("Reader Mode: On")
        mp.set_property("pause", "yes")
        mp.set_property("panscan", 1)
        mp.set_property("video-align-y", -1)
        mp.add_forced_key_binding("LEFT", "next-page", function()
            reset_page(1)
        end, {
            repeatable = true
        })
        mp.add_forced_key_binding("RIGHT", "prev-page", function()
            reset_page(-1)
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
        mp.osd_message("Reader Mode: Off")
        mp.set_property("pause", "no")
        mp.set_property("panscan", 0)
        mp.set_property("video-pan-y", 0)
        mp.remove_key_binding("next-page")
        mp.remove_key_binding("prev-page")
        mp.remove_key_binding("pan-up")
        mp.remove_key_binding("pan-down")
    end
end

local function auto_toggle_reader()
    local path = mp.get_property("path", "")
    if path == "" then
        return
    end

    local image_extensions = {
        jpg = true,
        jpeg = true,
        png = true,
        bmp = true,
        gif = true,
        tiff = true
    }

    local ext = path:match("%.([^%.]+)$")
    if ext and image_extensions[ext:lower()] then
        if not reader_mode then
            toggle_reader(true)
        end
    else
        if reader_mode then
            toggle_reader(false)
        end
    end
end

mp.observe_property("path", "string", auto_toggle_reader)
mp.add_key_binding("ctrl+m", "toggle-reader", function()
    toggle_reader(not reader_mode)
end)

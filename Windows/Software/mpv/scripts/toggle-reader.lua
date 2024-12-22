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
        mp.commandv("playlist-prev")
    elseif dir == -1 then
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
        vertical_offset = -1
    elseif vertical_offset < -1 then
        reset_page(-1)
        vertical_offset = 1
    end
    mp.set_property("video-pan-y", vertical_offset)
end

local function toggle_reader()
    reader_mode = not reader_mode
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
        mp.set_property("panscan", 0)
        mp.set_property("video-pan-y", 0)
        mp.remove_key_binding("next-page")
        mp.remove_key_binding("prev-page")
        mp.remove_key_binding("pan-up")
        mp.remove_key_binding("pan-down")
    end
end

mp.add_key_binding("ctrl+m", "toggle-reader", toggle_reader)

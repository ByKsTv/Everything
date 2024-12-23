local mp = require 'mp'

local reader_mode = false
local vertical_offset = 0
local page_dir = 0

local function update_step_size()
    local video_height = mp.get_property("video-params/h", nil) -- Get the height as a string
    if video_height then
        video_height = tonumber(video_height) -- Convert to a number
    end

    if video_height and video_height > 0 then
        step_size = 50 / video_height -- Dynamically calculate based on height
    else
        step_size = 0.005 -- Default fallback value
    end
    -- mp.osd_message(string.format("Step size updated: %.6f", step_size)) -- Optional debug message
end

local function reset_page(dir)
    if not reader_mode then
        return
    end
    page_dir = dir

    -- Flip to previous/next
    if dir == 1 then
        mp.set_property("video-align-y", 1)
        mp.commandv("playlist-prev")
    elseif dir == -1 then
        mp.set_property("video-align-y", -1)
        mp.commandv("playlist-next")
    end

    -- After flipping pages, ensure the offset is back to 0
    vertical_offset = 0
    mp.set_property("video-pan-y", 0)
end

local function adjust_pan(dir)
    if not reader_mode then
        return
    end

    -- Compute the potential new offset BEFORE applying it
    local new_offset = vertical_offset - (dir * step_size)
    local threshold = 1

    -- If this would exceed the threshold, flip pages immediately
    if new_offset > threshold then
        reset_page(1)
    elseif new_offset < -threshold then
        reset_page(-1)
    else
        -- Otherwise, safely apply the new offset
        vertical_offset = new_offset
        mp.set_property("video-pan-y", vertical_offset)
    end
end

local function toggle_reader(state)
    reader_mode = state
    if reader_mode then
        mp.osd_message("Reader Mode: On")
        mp.set_property("pause", "yes")
        mp.set_property("panscan", 1)
        mp.set_property("video-align-y", -1)
        update_step_size() -- Update step_size when reader mode is enabled
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

-- Observe changes to the video resolution
mp.observe_property("video-params/h", "number", function()
    if reader_mode then
        update_step_size()
    end
end)

mp.observe_property("path", "string", auto_toggle_reader)
mp.add_key_binding("ctrl+m", "toggle-reader", function()
    toggle_reader(not reader_mode)
end)

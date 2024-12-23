local mp = require "mp"

-- User-configurable values
local config = {
    threshold = 1,
    base_step = 50
}

local reader_mode = false
local vertical_offset = 0

-- Dynamically update step size based on video height, fallback if unavailable
local function update_step_size()
    local h = mp.get_property_number("video-params/h", 0)
    if h > 0 then
        step_size = config.base_step / h
    else
        step_size = 0.005
    end
end

local function flip_page(dir)
    if not reader_mode then
        return
    end
    -- Flip (previous if dir=1, next if dir=-1)
    if dir == 1 then
        mp.set_property("video-align-y", 1)
        mp.commandv("playlist-prev")
    else
        mp.set_property("video-align-y", -1)
        mp.commandv("playlist-next")
    end
    vertical_offset = 0
    mp.set_property("video-pan-y", 0)
end

local function adjust_pan(dir)
    if not reader_mode then
        return
    end
    local new_offset = vertical_offset - dir * step_size
    if new_offset > config.threshold then
        flip_page(1)
    elseif new_offset < -config.threshold then
        flip_page(-1)
    else
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
        update_step_size()
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
        mp.osd_message("Reader Mode: Off")
        mp.set_property("pause", "no")
        mp.set_property("panscan", 0)
        mp.set_property("video-pan-y", 0)
        mp.remove_key_binding("flip-forward")
        mp.remove_key_binding("flip-backward")
        mp.remove_key_binding("pan-up")
        mp.remove_key_binding("pan-down")
    end
end

-- Automatically enable/disable Reader Mode for images
local function auto_toggle()
    local path = mp.get_property("path", "")
    if path ~= "" then
        local ext = path:match("%.([^%.]+)$") or ""
        local img_exts = {
            jpg = true,
            jpeg = true,
            png = true,
            bmp = true,
            gif = true,
            tiff = true
        }
        if img_exts[ext:lower()] then
            if not reader_mode then
                toggle_reader(true)
            end
        else
            if reader_mode then
                toggle_reader(false)
            end
        end
    end
end

mp.observe_property("video-params/h", "number", function()
    if reader_mode then
        update_step_size()
    end
end)
mp.observe_property("path", "string", auto_toggle)
mp.add_key_binding("ctrl+m", "toggle-reader", function()
    toggle_reader(not reader_mode)
end)

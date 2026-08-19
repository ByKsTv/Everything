-- clipboard-url-loader.lua
-- Watches the clipboard while mpv is idle/at eof and auto-loads any URL that's copied.
local mp = require("mp")
local msg = require("mp.msg")
local options = require("mp.options")
local has_ffi, ffi = pcall(require, "ffi")

local opts = {
    enabled = true,
    poll_interval = 0.5, -- seconds between clipboard polls
    clipboard_timeout = 10 -- seconds to wait for update-clipboard
}
options.read_options(opts, "clipboard-url-loader")

local URL_PATTERN = "^(https?://%S+)$"

local monitor_timer
local last_clipboard_text = ""

----------------------------------------------------------------------
-- Windows-only foreground/focus helpers
----------------------------------------------------------------------

local focus_mpv -- forward declaration, no-op on non-Windows

if has_ffi and ffi.os == "Windows" then
    local ok, user32, kernel32
    ok, user32 = pcall(ffi.load, "user32")
    if ok then
        ok, kernel32 = pcall(ffi.load, "kernel32")
    end

    if ok then
        ffi.cdef [[
            typedef void* HWND;
            typedef unsigned long DWORD;
            typedef int BOOL;
            HWND GetForegroundWindow(void);
            DWORD GetWindowThreadProcessId(HWND, DWORD*);
            BOOL AttachThreadInput(DWORD, DWORD, BOOL);
            BOOL SetForegroundWindow(HWND);
            HWND SetFocus(HWND);
            DWORD GetCurrentThreadId(void);
        ]]

        local function attach_thread_input(current_thread_id, target_thread_id)
            if target_thread_id == 0 or target_thread_id == current_thread_id then
                return false
            end
            return user32.AttachThreadInput(current_thread_id, target_thread_id, 1) ~= 0
        end

        local function detach_thread_input(current_thread_id, target_thread_id)
            user32.AttachThreadInput(current_thread_id, target_thread_id, 0)
        end

        focus_mpv = function()
            local window_id = mp.get_property_number("window-id")
            if not window_id or window_id == 0 then
                msg.warn("No mpv window to focus")
                return
            end

            local mpv_window = ffi.cast("HWND", window_id)
            if mpv_window == nil then
                msg.warn("Invalid mpv window handle")
                return
            end

            local mpv_thread_id = user32.GetWindowThreadProcessId(mpv_window, nil)
            if mpv_thread_id == 0 then
                msg.warn("Could not find mpv window thread")
                return
            end

            if mp.get_property_bool("window-minimized", false) then
                mp.set_property_bool("window-minimized", false)
            end

            local current_thread_id = kernel32.GetCurrentThreadId()
            local foreground_window = user32.GetForegroundWindow()
            local foreground_thread_id = 0
            if foreground_window ~= nil then
                foreground_thread_id = user32.GetWindowThreadProcessId(foreground_window, nil)
            end

            local foreground_attached = attach_thread_input(current_thread_id, foreground_thread_id)
            local mpv_attached = false
            if mpv_thread_id ~= foreground_thread_id then
                mpv_attached = attach_thread_input(current_thread_id, mpv_thread_id)
            end

            msg.info("Focusing mpv")
            user32.SetForegroundWindow(mpv_window)
            user32.SetFocus(mpv_window)

            if mpv_attached then
                detach_thread_input(current_thread_id, mpv_thread_id)
            end
            if foreground_attached then
                detach_thread_input(current_thread_id, foreground_thread_id)
            end
        end
    else
        msg.warn("Could not load user32/kernel32 via FFI; window focusing disabled")
        focus_mpv = function()
        end
    end
else
    -- Non-Windows: no-op. mpv already raises its own window on loadfile in most WMs.
    focus_mpv = function()
    end
end

----------------------------------------------------------------------
-- Clipboard monitoring
----------------------------------------------------------------------

local function read_clipboard()
    local ok, err = pcall(mp.commandv, "update-clipboard", "text", tostring(opts.clipboard_timeout))
    if not ok then
        msg.warn("update-clipboard failed: " .. tostring(err))
    end
    return mp.get_property("clipboard/text", "")
end

local function stop_monitor()
    if not monitor_timer then
        return
    end
    monitor_timer:kill()
    monitor_timer = nil
    msg.info("Stopped watching clipboard")
end

local function load_url(url)
    stop_monitor()
    msg.info("Loading URL: " .. url)
    local ok, err = pcall(mp.commandv, "loadfile", url, "replace")
    if not ok then
        msg.error("Could not load URL: " .. tostring(err))
        return
    end
    focus_mpv()
end

local function check_clipboard()
    local current_text = read_clipboard()
    if current_text == last_clipboard_text then
        return
    end
    last_clipboard_text = current_text

    local trimmed = current_text:match("^%s*(.-)%s*$")
    local url = trimmed:match(URL_PATTERN)
    if not url then
        msg.verbose("Clipboard changed, but no URL found")
        return
    end
    load_url(url)
end

local function start_monitor()
    if not opts.enabled or monitor_timer then
        return
    end
    last_clipboard_text = read_clipboard()
    msg.info("Waiting for URL")
    monitor_timer = mp.add_periodic_timer(opts.poll_interval, check_clipboard)
end

local function start_monitor_if_true(_, value)
    if value then
        start_monitor()
    end
end

mp.register_event("start-file", stop_monitor)
mp.register_event("shutdown", stop_monitor)
mp.observe_property("idle-active", "bool", start_monitor_if_true)
mp.observe_property("eof-reached", "bool", start_monitor_if_true)

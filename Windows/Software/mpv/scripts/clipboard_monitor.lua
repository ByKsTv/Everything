local ffi = require('ffi')
local utils = require('mp.utils')
local msg = require('mp.msg')

-- FFI Definitions for Windows API functions
ffi.cdef [[
    typedef void* HWND;
    typedef unsigned long DWORD;
    typedef int BOOL;
    typedef void* LPARAM;
    typedef int (*WNDENUMPROC)(HWND, LPARAM);

    BOOL EnumWindows(WNDENUMPROC lpEnumFunc, LPARAM lParam);
    DWORD GetWindowThreadProcessId(HWND hWnd, DWORD* lpdwProcessId);
    BOOL IsWindowVisible(HWND hWnd);
    BOOL ShowWindow(HWND hWnd, int nCmdShow);
    BOOL SetForegroundWindow(HWND hWnd);
    void keybd_event(unsigned char bVk, unsigned char bScan, DWORD dwFlags, unsigned long dwExtraInfo);

    typedef void* HANDLE;
    typedef const char* LPCSTR;
    typedef unsigned int UINT;

    HANDLE GetClipboardData(UINT uFormat);
    BOOL OpenClipboard(void* hWndNewOwner);
    BOOL CloseClipboard();
    BOOL EmptyClipboard();
    HANDLE SetClipboardData(UINT uFormat, HANDLE hMem);
    const char* GlobalLock(HANDLE hMem);
    BOOL GlobalUnlock(HANDLE hMem);

    enum {
        CF_TEXT = 1
    };
]]

-- Constants
local user32 = ffi.load("user32")
local kernel32 = ffi.load("kernel32")
local SW_RESTORE = 9
local VK_MENU = 0x12 -- Alt key
local KEYEVENTF_EXTENDEDKEY = 0x0001
local KEYEVENTF_KEYUP = 0x0002

-- Bring MPV window to the foreground
local function bring_to_foreground()
    local pid = mp.get_property_native("pid")
    if not pid then
        return
    end

    local target_hwnd = nil
    user32.EnumWindows(ffi.cast("WNDENUMPROC", function(hwnd, _)
        local window_pid = ffi.new("DWORD[1]")
        user32.GetWindowThreadProcessId(hwnd, window_pid)
        if window_pid[0] == pid and user32.IsWindowVisible(hwnd) then
            target_hwnd = hwnd
            return 0 -- Stop
        end
        return 1 -- Continue
    end), nil)

    if target_hwnd then
        user32.ShowWindow(target_hwnd, SW_RESTORE)
        user32.keybd_event(VK_MENU, 0, KEYEVENTF_EXTENDEDKEY, 0)
        user32.keybd_event(VK_MENU, 0, KEYEVENTF_EXTENDEDKEY + KEYEVENTF_KEYUP, 0)
        user32.SetForegroundWindow(target_hwnd)
    end
end

-- Helper function to get clipboard content
local function get_clipboard_content()
    if not user32.OpenClipboard(nil) then
        return nil
    end

    local handle = user32.GetClipboardData(ffi.C.CF_TEXT)
    if handle == nil then
        user32.CloseClipboard()
        return nil
    end

    local data = ffi.string(kernel32.GlobalLock(handle))
    kernel32.GlobalUnlock(handle)
    user32.CloseClipboard()
    return data
end

-- Helper function to clear clipboard
local function clear_clipboard()
    if user32.OpenClipboard(nil) then
        user32.EmptyClipboard()
        user32.CloseClipboard()
    end
end

local function monitor_clipboard()
    print("Waiting for user to copy URL")
    clear_clipboard()
    local last_clipboard = ""

    -- Define the timer variable outside to control it later
    local clipboard_timer = nil

    -- Create the periodic timer
    clipboard_timer = mp.add_periodic_timer(1, function()
        print("Waiting")
        local new_clipboard = get_clipboard_content()
        if new_clipboard and new_clipboard ~= last_clipboard and new_clipboard:match("^https?://") then
            last_clipboard = new_clipboard

            -- Print the detected URL
            print("Detected URL: " .. new_clipboard)

            mp.commandv("loadfile", new_clipboard)
            bring_to_foreground()
            clear_clipboard()

            -- Stop the timer once the action is performed
            clipboard_timer:kill()
            print("URL loaded and timer stopped.")
        end
    end)
end

local idle_active = false

mp.observe_property("idle-active", "bool", function(_, is_idle)
    idle_active = is_idle
end)

mp.observe_property("path", "string", function(_, path)
    if idle_active and not path then
        monitor_clipboard()
    end
end)

mp.observe_property("eof-reached", "bool", function(_, eof_reached)
    if eof_reached then
        monitor_clipboard()
    end
end)

local mp = require 'mp'

-- Check interval: 1 second
local CHECK_INTERVAL = 1.0

-- UPDATED PowerShell script with simulated drag action and 300ms delay before dropping
local ps_script = [[
$mpv = Get-Process mpv -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -ne 0 } | Select-Object -First 1
if (-not $mpv) {
    return
}

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class Win32Api {
    [StructLayout(LayoutKind.Sequential)]
    public struct CURSORINFO {
        public int cbSize;
        public int flags;
        public IntPtr hCursor;
        public POINT ptScreenPos;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct POINT {
        public int x;
        public int y;
    }

    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool GetCursorInfo(ref CURSORINFO pci);

    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern IntPtr LoadCursor(IntPtr hInstance, int lpCursorName);

    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);

    [DllImport("user32.dll")]
    public static extern void mouse_event(uint dwFlags, int dx, int dy, uint dwData, UIntPtr dwExtraInfo);

    [DllImport("user32.dll")]
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

    [DllImport("user32.dll")]
    public static extern bool BringWindowToTop(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);

    [DllImport("kernel32.dll")]
    public static extern uint GetCurrentThreadId();

    [DllImport("user32.dll")]
    public static extern bool AttachThreadInput(uint idAttach, uint idAttachTo, bool fAttach);
    
    [DllImport("user32.dll")]
    public static extern bool SetCursorPos(int X, int Y);

    public const int CURSOR_SHOWING = 0x00000001;
    public const int VK_LBUTTON = 0x01;
    public const uint MOUSEEVENTF_LEFTDOWN = 0x0002;
    public const uint MOUSEEVENTF_LEFTUP = 0x0004;
    public const uint MOUSEEVENTF_MOVE = 0x0001;
    public const int IDC_ARROW = 32512;
    public const int SW_RESTORE = 9;
}
"@

$mpv_hwnd = $mpv.MainWindowHandle
$foreground = [Win32Api]::GetForegroundWindow()

# Prepare cursor info
$ci = New-Object Win32Api+CURSORINFO
$ci.cbSize = [System.Runtime.InteropServices.Marshal]::SizeOf($ci)
[Win32Api]::GetCursorInfo([ref]$ci) | Out-Null

$arrowCursor = [Win32Api]::LoadCursor([IntPtr]::Zero, [Win32Api]::IDC_ARROW)
$leftDown = ([Win32Api]::GetAsyncKeyState([Win32Api]::VK_LBUTTON)) -lt 0
$isDragging = ($ci.flags -eq [Win32Api]::CURSOR_SHOWING) -and ($ci.hCursor -ne $arrowCursor) -and $leftDown

if ($isDragging) {
    if ($foreground -ne $mpv_hwnd) {
        $pidOut = 0
        $fgThreadId = [Win32Api]::GetWindowThreadProcessId($foreground, [ref]$pidOut)
        $pidOut = 0
        $mpvThreadId = [Win32Api]::GetWindowThreadProcessId($mpv_hwnd, [ref]$pidOut)

        $currentThreadId = [Win32Api]::GetCurrentThreadId()

        [Win32Api]::AttachThreadInput($currentThreadId, $fgThreadId, $true) | Out-Null
        [Win32Api]::AttachThreadInput($currentThreadId, $mpvThreadId, $true) | Out-Null

        [Win32Api]::ShowWindowAsync($mpv_hwnd, [Win32Api]::SW_RESTORE) | Out-Null
        [Win32Api]::BringWindowToTop($mpv_hwnd) | Out-Null
        [Win32Api]::SetForegroundWindow($mpv_hwnd) | Out-Null

        [Win32Api]::AttachThreadInput($currentThreadId, $fgThreadId, $false) | Out-Null
        [Win32Api]::AttachThreadInput($currentThreadId, $mpvThreadId, $false) | Out-Null

        # Simulate actual drag action
        # Step 1: Ensure the left button is pressed
        # Note: Since $isDragging is true, the left button is already pressed by the user.
        # However, to ensure consistency, we can simulate a left button press.
        [Win32Api]::mouse_event([Win32Api]::MOUSEEVENTF_LEFTDOWN, 0, 0, 0, [uintptr]::Zero) | Out-Null

        # Step 2: Move the cursor incrementally to simulate dragging
        $steps = 10
        $deltaX = 5
        $deltaY = 5
        for ($i = 1; $i -le $steps; $i++) {
            [Win32Api]::mouse_event([Win32Api]::MOUSEEVENTF_MOVE, $deltaX, $deltaY, 0, [uintptr]::Zero) | Out-Null
            Start-Sleep -Milliseconds 20  # Short delay between movements for smoothness
        }

        # Step 3: Release the left mouse button to complete the drop
        [Win32Api]::mouse_event([Win32Api]::MOUSEEVENTF_LEFTUP, 0, 0, 0, [uintptr]::Zero) | Out-Null

        "dropped"
    }
}
]]

local check_timer = nil

local function run_drag_check()
    local res = mp.command_native({
        name = "subprocess",
        capture_stdout = true,
        playback_only = false,
        args = {"powershell", "-NoProfile", "-Command", ps_script}
    })

    if res.stdout and res.stdout:find("dropped") then
        mp.msg.info("Detected drag and drop, mpv should be foreground.")
        if check_timer and check_timer:is_enabled() then
            check_timer:stop()
        end
    end
end

local function start_checking()
    if not check_timer or not check_timer:is_enabled() then
        check_timer = mp.add_periodic_timer(CHECK_INTERVAL, run_drag_check)
    end
end

local function stop_checking()
    if check_timer and check_timer:is_enabled() then
        check_timer:stop()
    end
end

-- Conditions:
-- 1. No file playing => start checking.
-- 2. Remote (http) file playing and < 1s left => start checking.
-- Otherwise => stop checking.
local function maybe_update_timer()
    local path = mp.get_property("path")
    local time_remaining = mp.get_property_number("time-remaining")

    if path == nil then
        -- no file playing
        start_checking()
    else
        local lower_path = path:lower()
        local is_remote = (lower_path:match("^https?://") ~= nil)
        if is_remote and time_remaining and time_remaining < 1 then
            start_checking()
        else
            stop_checking()
        end
    end
end

mp.observe_property("path", "string", maybe_update_timer)
mp.observe_property("time-remaining", "number", maybe_update_timer)
mp.observe_property("idle-active", "bool", maybe_update_timer)
mp.register_event("file-loaded", maybe_update_timer)
mp.register_event("end-file", maybe_update_timer)

maybe_update_timer()

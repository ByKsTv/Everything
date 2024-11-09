mp.register_event('file-loaded', function()
    local duration = mp.get_property_native('duration', math.huge)
    if duration == math.huge then
        return
    end

    local url = mp.get_property("path")
    if not url:find("http") or mp.get_property_number('playlist-count') ~= 1 then
        return
    end

    local function on_time_pos(_, time_pos)
        if time_pos and time_pos >= duration - 1 then
            local ps_command = [[
$browser = Get-Process -Name chrome, firefox -ErrorAction SilentlyContinue |
    Where-Object { $_.MainWindowTitle } | Select-Object -First 1;
if ($browser) {
    (New-Object -ComObject WScript.Shell).AppActivate($browser.Id);
}
]]
            ps_command = ps_command:gsub("\n", " ")
            mp.command_native({
                name = 'subprocess',
                args = {'powershell', '-NoProfile', '-Command', ps_command}
            })
            mp.unobserve_property(on_time_pos)
        end
    end

    mp.observe_property('time-pos', 'native', on_time_pos)
end)

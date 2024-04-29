local function read_time1(_, time_pos)
    if time_pos and time_pos > mp.get_property_native('duration', math.huge) - 1 then
        local url = mp.get_property("path")
        if string.match(url, "youtube") then
            if mp.get_property_number('playlist-count') == 1 then
                mp.command_native({
                    name = 'subprocess',
                    capture_stdout=true,
                    args = { 
                        'powershell', 
                        '-NoProfile',
                        '-Command', 
                        'Add-Type -AssemblyName System.Windows.Forms;[System.Windows.Forms.SendKeys]::SendWait(\'%{TAB}\')'
                    }
                })
                mp.unobserve_property(read_time1)
            end
        end
    end
end

mp.register_event('file-loaded', function ()
    mp.observe_property('time-pos', 'native', read_time1)
end)
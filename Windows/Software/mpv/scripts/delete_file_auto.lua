local function read_time(_, time_pos)
    if time_pos and time_pos > mp.get_property_native('duration', math.huge) - 15 then
        mp.command('script-binding delete_file/delete_file')
        mp.unobserve_property(read_time)
    end
end

mp.register_event('file-loaded', function()
    mp.observe_property('time-pos', 'native', read_time)
end)

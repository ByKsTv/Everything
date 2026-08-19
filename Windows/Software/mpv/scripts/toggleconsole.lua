mp.add_key_binding('F1', 'toggle-console', function()
    local is_console_open = mp.get_property_native('user-data/mpv/console/open')

    mp.command(is_console_open and 'keypress ESC' or 'script-binding commands/open')
end)

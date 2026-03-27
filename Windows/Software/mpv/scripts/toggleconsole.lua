mp.add_key_binding('F1', 'toggle-console', function()
    mp.command(mp.get_property_native('user-data/mpv/console/open') and 'keypress ESC' or 'script-binding commands/open')
end)

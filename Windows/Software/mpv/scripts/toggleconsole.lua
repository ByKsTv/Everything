local open = false

mp.add_key_binding('F1', function()
    mp.commandv('script-message-to', 'console', open and 'disable' or 'enable')
    open = not open
end)

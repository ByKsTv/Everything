mp.commandv('no-osd', 'change-list', 'ytdl-raw-options', 'append',
    'cookies=' .. mp.command_native({'expand-path', '~~/cookies.firefox-private.txt'}))
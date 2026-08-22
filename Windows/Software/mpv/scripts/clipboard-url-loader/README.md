# clipboard url loader

## Build

1. Install MSYS64
   > [OLD](https://code.visualstudio.com/docs/cpp/config-mingw)

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/mpv-player/mpv/master/include/mpv/client.h" -OutFile client.h
New-Item -ItemType Directory -Force -Path mpv
Move-Item client.h mpv\client.h
```

```bash
gcc -std=c17 -O2 -Wall -Wextra -shared -static -I. -o clipboard-url-loader.dll clipboard-url-loader.c -luser32
```

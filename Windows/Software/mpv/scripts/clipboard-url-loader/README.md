# clipboard url loader

## Build

1. Install MSYS64
   > [OLD](https://code.visualstudio.com/docs/cpp/config-mingw)

```powershell
New-Item -ItemType Directory -Force .\include\mpv | Out-Null

Invoke-WebRequest `
    -Uri "https://raw.githubusercontent.com/mpv-player/mpv/master/include/mpv/client.h" `
    -OutFile ".\include\mpv\client.h"
```

```bash
gcc -std=c17 -O2 -Wall -Wextra -Wpedantic -Werror -I".\include" -shared -static-libgcc ".\clipboard-url-loader.c" -o ".\clipboard-url-loader.dll" -luser32
```

param(
    [Parameter(Mandatory)]
    [string]$InputIco,

    [string]$OutputIco = 'icon-16x16.ico'
)

$InputIco = $InputIco.Trim().Trim([char]'"')

Add-Type -AssemblyName System.Drawing

# Load source icon/image
$source = [System.Drawing.Image]::FromFile((Resolve-Path $InputIco))

# Create 16x16 bitmap
$bitmap = New-Object System.Drawing.Bitmap 16, 16
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)

$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$graphics.DrawImage($source, 0, 0, 16, 16)

# Save bitmap as PNG in memory
$pngStream = New-Object System.IO.MemoryStream
$bitmap.Save($pngStream, [System.Drawing.Imaging.ImageFormat]::Png)
$pngBytes = $pngStream.ToArray()

# Build an ICO containing the 16x16 PNG
$outputStream = [System.IO.File]::Create($OutputIco)
$writer = New-Object System.IO.BinaryWriter $outputStream

# ICO header
$writer.Write([UInt16]0)       # Reserved
$writer.Write([UInt16]1)       # Type: icon
$writer.Write([UInt16]1)       # Number of images

# Directory entry
$writer.Write([Byte]16)        # Width
$writer.Write([Byte]16)        # Height
$writer.Write([Byte]0)         # Color count
$writer.Write([Byte]0)         # Reserved
$writer.Write([UInt16]1)       # Color planes
$writer.Write([UInt16]32)      # Bits per pixel
$writer.Write([UInt32]$pngBytes.Length)
$writer.Write([UInt32]22)      # Image data offset

# Image data
$writer.Write($pngBytes)

$writer.Close()

$graphics.Dispose()
$bitmap.Dispose()
$source.Dispose()
$pngStream.Dispose()

Write-Host "Created: $OutputIco"
from pathlib import Path
import lz4.block  # type: ignore

src = Path("search.json.mozlz4")
data = src.read_bytes()

header = b"mozLz40\0"
if not data.startswith(header):
    raise ValueError("Not a mozlz4 file (missing mozLz40 header)")

raw = lz4.block.decompress(data[len(header) :])
print(raw.decode("utf-8"))

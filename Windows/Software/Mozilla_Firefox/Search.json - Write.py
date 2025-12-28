from pathlib import Path
import lz4.block  # type: ignore

header = b"mozLz40\0"

# Load edited JSON text from a file you edited (recommended)
edited_json = Path("search.json").read_text(encoding="utf-8").encode("utf-8")

compressed = lz4.block.compress(edited_json)
Path("search.json.mozlz4").write_bytes(header + compressed)

from PIL import Image # type: ignore
import os

input_path = r"C:\Users\Test\Downloads\New folder\input.png"
output_path = os.path.splitext(input_path)[0] + ".ico"
img = Image.open(input_path)
img.save(output_path, format="ICO", sizes=[(16, 16)])
print(f"ICO file saved as: {output_path}")

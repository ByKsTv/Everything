import os
from PIL import Image
import pillow_heif


def batch_convert_heic_to_png(directory):
    # Loop through all files in the given directory
    for filename in os.listdir(directory):
        # Check if the file has a .heic extension (case-insensitive)
        if filename.lower().endswith(".heic"):
            input_file = os.path.join(directory, filename)
            output_file = os.path.join(
                directory, f"{os.path.splitext(filename)[0]}.png"
            )

            # Open the HEIC file using pillow-heif
            heif_image = pillow_heif.read_heif(input_file)

            # Convert the HEIC file to an image using Pillow
            image = Image.frombytes(
                heif_image.mode,
                heif_image.size,
                heif_image.data,
                "raw",
                heif_image.mode,
                heif_image.stride,
            )

            # Save the image as a PNG
            image.save(output_file, "PNG")
            print(f"Converted {filename} to PNG successfully.")


# Example usage: Replace with your actual directory containing HEIC files
directory_path = r"C:\Users\Test\Downloads"
batch_convert_heic_to_png(directory_path)

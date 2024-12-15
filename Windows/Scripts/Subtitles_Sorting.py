import os
import shutil
from pathlib import Path

ExtractFontsFrom = r"Path_To_TVShow"
MoveFontsTo = os.path.join(ExtractFontsFrom, "Fonts")
subs_path = os.path.join(ExtractFontsFrom, "Subs")

if not os.path.exists(MoveFontsTo):
    os.makedirs(MoveFontsTo)

font_extensions = (".otf", ".ttf", ".woff", ".woff2", ".eot", ".ttc")

for root, dirs, files in os.walk(ExtractFontsFrom):
    for file in files:
        if file.lower().endswith(font_extensions):
            source_file = os.path.join(root, file)
            destination_file = os.path.join(MoveFontsTo, file)

            print(f"Copying: {source_file} to {destination_file}")
            shutil.copy2(source_file, destination_file)

video_files = sorted(
    [f for f in os.listdir(ExtractFontsFrom) if f.endswith((".mkv", ".m2ts"))]
)

print("Video files:")
for video in video_files:
    print(video)


def get_largest_eng_subtitle(folder):
    print(f"Checking folder: {folder}")
    eng_subs = [
        f
        for f in os.listdir(folder)
        if "eng" in f and f.endswith((".srt", ".sub", ".idx", ".ass", ".sup"))
    ]
    print("Found 'eng' subtitle files:")
    for sub in eng_subs:
        print(sub)
    if not eng_subs:
        print("No 'eng' subtitle found. Searching for 'und' subtitle files.")
        eng_subs = [
            f
            for f in os.listdir(folder)
            if "und" in f and f.endswith((".srt", ".sub", ".idx", ".ass", ".sup"))
        ]
        print("Found 'und' subtitle files:")
        for sub in eng_subs:
            print(sub)
    if not eng_subs:
        return None
    largest_sub = max(eng_subs, key=lambda f: os.path.getsize(os.path.join(folder, f)))
    return largest_sub


for root, dirs, files in os.walk(subs_path):
    for subdir in sorted(dirs):
        subdir_path = os.path.join(root, subdir)
        largest_sub = get_largest_eng_subtitle(subdir_path)
        if largest_sub:
            new_subtitle_name = (
                os.path.splitext(video_files[0])[0]
                + ".eng"
                + os.path.splitext(largest_sub)[1]
            )
            old_subtitle_path = os.path.join(subdir_path, largest_sub)
            new_subtitle_path = os.path.join(subs_path, new_subtitle_name)

            print(f"Renaming {old_subtitle_path} to {new_subtitle_path}")

            shutil.move(old_subtitle_path, new_subtitle_path)

            video_files.pop(0)
        else:
            print(f"No 'eng' subtitle found in {subdir_path}")

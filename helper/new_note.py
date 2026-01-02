#!/usr/bin/env python3
import os, subprocess
from datetime import datetime

NOTES_DIR = os.path.expanduser("~/Documents/Zettelkasten/")

title_input = input("Titel: ")
path_input = os.path.join(*input("Pfad: ").split(" ")).lower()

title = "_".join(str.split(title_input, " "))
filename = f"{datetime.today().strftime('%Y-%m-%d')}_{title}.md"
directory_path = os.path.join(NOTES_DIR, path_input).lower()
filepath = os.path.join(NOTES_DIR, path_input,  filename)

if not os.path.exists(filepath):
    subprocess.run(["mkdir", "-p", directory_path])
    with open(filepath, "w") as f:
        f.write(f"# {title}\n\n") 
    subprocess.run(["nvim", filepath])
else:
    print("Notiz existiert bereits: " + filepath)



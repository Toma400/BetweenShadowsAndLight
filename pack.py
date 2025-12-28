import zipfile
import shutil
import os

FILES = [
    "lang/english.toml",
    "lang/polish.toml",
    "Between Shadows and Light.exe",
    "settings.toml"
]

os.system("nim c bsal.nim")
# os.system("rcedit-x64 'Between Shadows and Light.exe' --set-icon 'bsal.ico'")
# todo: uncomment above when BSaL icon is made

with zipfile.ZipFile("BetweenShadowsAndLight.zip", mode="w") as archive:
    for f in FILES:
        with archive.open(f, "w") as fw:
            with open(f, "rb") as fr:
                fw.write(fr.read())
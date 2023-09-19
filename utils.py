import toml
import os

settings  = toml.load("settings.toml")
lang_list = [f for (_, _, f) in os.walk("lang")]
languages = {l.replace(".toml", ""): toml.load(f"lang/{l}") for l in lang_list[0]}

class Settings:
    lang = settings["language"]

def langstr(key: str) -> str:
    return languages[Settings.lang][key]
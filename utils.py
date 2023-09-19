import toml
import os

settings     = toml.load("settings.toml")
lang_list    = [f2.replace(".toml", "") for f2 in [f for (_, _, f) in os.walk("lang")][0]]
languages    = {l: toml.load(f"lang/{l}.toml") for l in lang_list}

def current_lang() -> str:
    return settings["language"]

def langstr(key: str) -> str:
    return languages[current_lang()][key]

def langswitch(key: str):
    if key in lang_list:
        settings["language"] = key
    with open("settings.toml", "w") as s:
        toml.dump(settings, s)
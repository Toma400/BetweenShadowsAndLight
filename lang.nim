import std/strformat
import std/strutils
import std/sequtils
import parsetoml
import os

var settings* = parseFile("settings.toml")

proc getAvailableLangs* (): seq[string] =
    result = toSeq(walkFiles("lang/*.toml"))
    for i, lang in result.pairs():
        result[i] = result[i].replace(".toml", "").replace(r"lang\", "")

proc currentLang (): string =
    return settings["language"].getStr()

proc currentLangFile* (): TomlValueRef =
    return parseFile(fmt"lang/{currentLang()}.toml")
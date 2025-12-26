import std/strformat
import std/strutils
import std/tables
import parsetoml
import lang

type
  MenuType* = enum
    START
    SETTINGS
  Game* = ref object # singular instance of object
    run      : bool
    menu     : MenuType
    lang_ref : TomlValueRef

const LOGO* = """|__) __|_    _ _ _   (_ |_  _  _| _     _   _  _  _|  |  . _ |_ |_
                 |__)(- |_\)/(-(-| )  __)| )(_|(_|(_)\)/_)  (_|| )(_|  |__|(_)| )|_""".unindent &
              "\n - Remastered -                                            _)\n" &
                "                                                       version 1.0\n"

proc newGame* (): Game =
    new(result)
    result.run      = true # starts the game
    result.lang_ref = currentLangFile()
    result.menu     = START

proc isRunning* (g: Game): bool =
    return g.run

proc getKey* (g: Game, k: string): string =
    if k in g.lang_ref:
        return g.lang_ref[k].getStr()
    else: return fmt"Error. No key {k} in language file."

proc getMenu* (g: Game): MenuType =
    return g.menu

proc switchMenu* (g: Game, m: MenuType) =
    g.menu = m

proc switchLanguage* (g: Game, lang: string) =
    settings["language"] = ?lang
    writeFile("settings.toml", $settings) # saves updated settings
    settings = parseFile("settings.toml") # reloads file
    g.lang_ref = currentLangFile()        # updates game instance

proc exitGame* (g: Game) =
    g.run = false
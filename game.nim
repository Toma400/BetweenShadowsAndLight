import std/strformat
import std/strutils
import std/tables
import parsetoml
import location
import player
import lang
import os

export player

type
  MenuType* = enum
    # main menu
    START
    PLAY
    LOAD
    SETTINGS
    # gameplay menus
    mCHARACTER
    mINVENTORY
    mLOCATION
    mMAP
    mDIARY
  Game* = ref object # singular instance of object
    run       : bool
    menu      : MenuType
    player*   : Player       # checking against `player.name == ""` means not started game (nil equivalent)
    location* : Location
    tutorial* : bool         # whether tips are on/off
    lang_ref  : TomlValueRef

const LOGO* = """|__) __|_    _ _ _   (_ |_  _  _| _     _   _  _  _|  |  . _ |_ |_
                 |__)(- |_\)/(-(-| )  __)| )(_|(_|(_)\)/_)  (_|| )(_|  |__|(_)| )|_""".unindent &
              "\n - Remastered -                                            _)\n" &
                "                                                       version 1.0\n"
const DIVIDER*  = "---------------------------------------------------------------"
const DIVSHORT* = "------------------------------------------------"

proc newGame* (): Game =
    new(result)
    result.run      = true # starts the game
    result.lang_ref = currentLangFile()
    result.menu     = START
    result.player   = newPlayer("", VOIDG, VOIDR, VOIDC) # placeholder
    result.tutorial = settings["tutorial"].getBool()
    result.location = SHIP                               # starting location (overwritten during load)

proc `$`* (g: Game): string =
    return $g.player

proc isRunning* (g: Game): bool =
    return g.run

proc getKey* (g: Game, k: string): string =
    if k in g.lang_ref:
        return g.lang_ref[k].getStr()
    else: return fmt"Error. No key {k} in language file."

proc getTutorialKey* (g: Game, k: string): string = # UI showcasing that >> << brackets tell you tips
    return fmt">> {getKey(g, k)} <<"

proc getButtonKey* (g: Game, k: string): string = # UI showcasing you that brackets allow you to write exact words to "press" option
    return fmt"[{getKey(g, k)}]"

proc getMenu* (g: Game): MenuType =
    return g.menu

proc switchMenu* (g: Game, m: MenuType) =
    g.menu = m

proc switchLanguage* (g: Game, lang: string) =
    settings["language"] = ?lang
    writeFile("settings.toml", $settings) # saves updated settings
    settings = parseFile("settings.toml") # reloads file
    g.lang_ref = currentLangFile()        # updates game instance

proc switchTutorial* (g: Game) =
    settings["tutorial"] = ?(not settings["tutorial"].getBool)
    writeFile("settings.toml", $settings)       # saves updated settings
    settings = parseFile("settings.toml")       # reloads file
    g.tutorial = settings["tutorial"].getBool() # updates game instance

proc createCharacter* (g: Game, name: string, gender: Gender, race: Race, class: Class) =
    g.player = newPlayer(name, gender, race, class)

proc getPlayerName* (g: Game): string =
    return getPlayerName(g.player)

proc getMessages* (g: Game): seq[string] =
    # should not be used anywhere but on `PLAY` menu print since it clears messages alongside
    for msg_key in getAndClearMessages(g.player):
        result.add(getKey(g, msg_key))

proc clearScreen* () =
    discard execShellCmd("cls")

proc exitGame* (g: Game) =
    g.run = false
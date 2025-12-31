import std/strformat
import std/strutils
import std/tables
import parsetoml
#import location
import player
import item
import lang
import os

export player

type
  MenuType* = enum
    # main menu
    START
    LOAD
    SETTINGS
    # gameplay menus
    mDEFAULT
    mCHARACTER
    mINVENTORY
    mLOCATION
    mMAP
    mDIARY
    mDIALOGUE
  Game* = ref object # singular instance of object
    run       : bool
    menu      : MenuType
    player*   : Player       # checking against `player.name == ""` means not started game (nil equivalent)
    location* : Location
    tutorial* : bool         # whether tips are on/off
    lang_ref  : TomlValueRef
  Location* = enum
    SHIP
    SHIP_DOCKED # remove if not needed
    DOCKS
    EVROS
    FIELDS
    # "cheat" locations used in OG:
    DESERTED_ISLAND
    # DESERT_ISLAND_HOME

const VERSION = 1.0
const AUTHOR  = "Toma400"
const LICENCE = "All Rights Reserved"
const LOGO* = """|__) __|_    _ _ _   (_ |_  _  _| _     _   _  _  _|  |  . _ |_ |_
                 |__)(- |_\)/(-(-| )  __)| )(_|(_|(_)\)/_)  (_|| )(_|  |__|(_)| )|_""".unindent &
              "\n - Remastered -                                            _)\n" &
             fmt"                                                       version {VERSION}" & "\n"
const DIVIDER*  = "---------------------------------------------------------------"
const DIVSHORT* = "------------------------------------------------"

let NO_PLAYER* = newPlayer("", VOIDG, VOIDR, VOIDC)
let DEF_LOC*   = SHIP

proc newGame* (): Game =
    new(result)
    result.run      = true # starts the game
    result.lang_ref = currentLangFile()
    result.menu     = START
    result.player   = NO_PLAYER                      # placeholder
    result.tutorial = settings["tutorial"].getBool()
    result.location = DEF_LOC                        # starting location (overwritten during load)

proc resetGameData* (g: Game) =
    # used when exiting the game, so that all data is cleared
    g.player   = NO_PLAYER     # resets to that 'new game' lets you create new char
    g.location = DEF_LOC
    CHESTS     = CHESTS_PREFAB # and that all chests have their contents resetted

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

proc getOptionKey* (g: Game, k: string, num: int): string = # UI showcasing numerical options
    return fmt"[{num}] {getKey(g, k)}"

proc getMenu* (g: Game): MenuType =
    return g.menu

proc switchMenu* (g: Game, m: MenuType) =
    g.menu = m

proc startDialogue* (g: Game, npc: NPC) =
    setDialogueName(g.player, npc)
    switchMenu(g, mDIALOGUE)

proc isDialogueStarted* (g: Game): bool =
    return getDialogueName(g.player) != DUMMY and g.menu == mDIALOGUE

proc endDialogue* (g: Game, menu_to_be_switched_to: MenuType) =
    clearDialogueVariables(g.player)
    setDialogueName(g.player, DUMMY)
    switchMenu(g, menu_to_be_switched_to)

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

proc printMessages* (g: Game) =
    # shortcut for the above
    for msg in getMessages(g):
        echo msg

proc waitForPlayer* () =
    # used a lot for stopping execution flow
    discard readLine(stdin)

proc changeLocation* (g: Game, loc: Location) =
    g.menu     = mDEFAULT
    g.location = loc

proc clearScreen* () =
    discard execShellCmd("cls")

proc chest* (g: Game, lockpower: var int = 0, contents: var seq[string]) = # open by default (0)
    var CHEST_MODE = 0 # default, no mode selected

    if lockpower > 0: # if open, skip unlocking
        while true:
            clearScreen()
            echo getKey(g, "game__lock_lockpicks") & ": " & $g.player.lockpicks
            echo getOptionKey(g, "game__lock_start", 1)
            echo getOptionKey(g, "game__lock_give_up", 2)
            let prompt = readLine(stdin)
            if prompt != "1": return # early return
            else: # try opening
                let res = lock(g.player, lockpower)
                printMessages(g) # prints results/warnings
                waitForPlayer()
                if not res: continue # try again
                else:
                    lockpower = 0 # unlocks chest
                    break # and proceeds to contents
    while true:
        clearScreen()
        echo DIVIDER
        echo getKey(g, "game__chest")
        for ix, item in contents:
            if not isSpecialItem(item):
                echo getOptionKey(g, "item__" & item, ix + 1)
            else:
                let si = debundleSpecialItem(item)
                echo getOptionKey(g, "item__" & $si[1], ix + 1) & ": " & $si[0]
        echo getKey(g, "game__gui_inventory") # lists inventory items
        for ix, item in getInventory(g.player).pairs():
            echo getOptionKey(g, "item__" & item, ix + 1)
        echo DIVIDER
        if CHEST_MODE == 0:
            echo getOptionKey(g, "game__chest_take", 1)
            echo getOptionKey(g, "game__chest_put", 2)
            echo getOptionKey(g, "loc__ship_do_nothing", 3)
            let prompt = readLine(stdin)
            case prompt:
                of "1": CHEST_MODE = 1
                of "2": CHEST_MODE = 2
                of "3": return # exits the chest menu
                else: continue
        elif CHEST_MODE == 1: # taking
            if len(contents) == 0:
                echo getKey(g, "game__chest_empty")
                waitForPlayer()
                CHEST_MODE = 0 # goes back
            else:
                echo getKey(g, "game__chest_choose")
                let prompt = readLine(stdin)
                if prompt == "": # goes back to decision mode
                    CHEST_MODE = 0
                    continue
                try:
                    let p = parseInt(prompt)
                    if p > len(contents) or p < 1:
                        echo getKey(g, "game__chest_big")
                        waitForPlayer()
                        continue
                    else: # correct pick!
                        if isSpecialItem(contents[p-1]):
                            let si = debundleSpecialItem(contents[p-1])
                            case si[1]:
                                of COIN: g.player.money     += si[0]
                                of LOCK: g.player.lockpicks += si[0]
                            contents.delete(p-1)
                        else: # normal items
                            addItemToInventory(g.player, contents[p-1])
                            contents.delete(p-1)
                        continue
                except ValueError: # non-int value
                    continue

        elif CHEST_MODE == 2: # putting
            if len(getInventory(g.player)) == 0:
                echo getKey(g, "game__chest_empty2")
                waitForPlayer()
                CHEST_MODE = 0 # goes back
            else:
                echo getKey(g, "game__chest_choose2")
                let prompt = readLine(stdin)
                if prompt == "": # goes back to decision mode
                    CHEST_MODE = 0
                    continue
                try:
                    let p = parseInt(prompt)
                    if p > len(getInventory(g.player)) or p < 1:
                        echo getKey(g, "game__chest_big")
                        waitForPlayer()
                        continue
                    else: # correct pick! no checks for special items because you can't put money etc. back
                        contents.add(getInventory(g.player)[p-1]) # done first because it is still reachable
                        removeItemFromInventory(g.player, p-1)
                        continue
                except ValueError: # non-int value
                    continue

proc chest* (g: Game, raw_val: var (int, seq[string])) = # variant to get directly CHESTS values
    chest(g, raw_val[0], raw_val[1])

proc exitGame* (g: Game) =
    g.run = false
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
    DESERTED_HOME
    BAEDOOR # dummy location, also unused in OG

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

proc journey* (g: Game, loc: Location, distance: int) =
    # should be used whenever we want to substract `sp` points
    g.player.sp -= int(distance*15/getEndurance(g.player)) # ENDURANCE IS NOT REACHABLE
    changeLocation(g, loc)

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
            echo getOptionKey(g, "loc__do_nothing", 3)
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

proc shop* (g: Game, npc: NPC) =
    # mode for purchase (0 = none, 1 = buy, 2 = sell)
    var MODE   = 0
    let buy_offers  = if npc in BUYING_OFFERS: BUYING_OFFERS[npc] else: @[] # .id / .value
    let sell_offers = if npc in SELLING_OFFERS: SELLING_OFFERS[npc] else: @[] # .id / .value
    let can_buy  = len(buy_offers)  > 0
    let can_sell = len(sell_offers) > 0
    while true:
        clearScreen()
        echo DIVIDER
        if can_buy: # can_buy
            echo "{" & getKey(g, "game__trade_seller")  & "}"
            for ix, it in buy_offers.pairs():
                echo getOptionKey(g, "item__" & it.id, ix + 1) & ": " & $it.value # no need for getter
        if can_sell: # can_sell
            echo "{" & getKey(g, "game__gui_inventory") & "}"
            for ix, it in getInventory(g.player).pairs():
                if isInOfferTable(sell_offers, it):
                    echo getOptionKey(g, "item__" & it, ix + 1) & ": " & $getValueFromOfferTable(sell_offers, it)
        echo DIVIDER
        echo getKey(g, "game__trade_money") & ": " & $g.player.money
        echo DIVIDER
        if MODE == 0: # no mode
            if can_buy:  echo getOptionKey(g, "game__trade_op1", 1)
            if can_sell: echo getOptionKey(g, "game__trade_op2", 2)
            echo getOptionKey(g, "game__trade_op3", 3)
            let prompt = readLine(stdin)
            case prompt:
                of "1":
                    if can_buy: MODE = 1 # else: loop back
                of "2":
                    if can_sell: MODE = 2 # else: loop back
                of "3": break  # exit the proc
                else: continue # loop back
        elif MODE == 1:
            echo getKey(g, "game__trade_buy")
            let prompt = readLine(stdin)
            if prompt == "": MODE = 0
            try:
                let p = parseInt(prompt)
                if p > len(buy_offers) or p < 1:
                    echo getKey(g, "game__chest_big")
                    waitForPlayer()
                    continue
                else: # correct pick!
                    let item = buy_offers[p-1]
                    if buy(g.player, item.id, item.value) == true:
                        echo getKey(g, "game__trade_bought") & " " & getKey(g, "item__" & item.id)
                    printMessages(g)
                    waitForPlayer()
                    continue
            except ValueError: continue
        elif MODE == 2:
            echo getKey(g, "game__trade_sell")
            let prompt = readLine(stdin)
            if prompt == "": MODE = 0
            try:
                let p = parseInt(prompt)
                if p > len(getInventory(g.player)) or p < 1:
                    echo getKey(g, "game__chest_big")
                    waitForPlayer()
                    continue
                elif not isInOfferTable(sell_offers, getInventory(g.player)[p-1]):
                    continue # if you try to cheese to sell something outside your item range
                else: # correct pick!
                    let item_str = getInventory(g.player)[p-1]
                    if sell(g.player, item_str, ITEMS[item_str].value) == true:
                        echo getKey(g, "game__trade_sold") & " " & getKey(g, "item__" & item_str)
                    printMessages(g)
                    waitForPlayer()
                    continue
            except ValueError: continue

proc chooseAttributeUpgrade* (g: Game, cond: var bool) =
    while cond == false:
        clearScreen()
        echo getKey(g, "game__level_up_attr")
        for i, a in ["strength", "dexterity", "intelligence", "endurance", "charisma"]:
            echo getOptionKey(g, "game__gui_" & a, i + 1)
        let prompt = readLine(stdin)
        case prompt:
            of "1": setStrength(g.player, getStrength(g.player) + 1);         cond = true
            of "2": setDexterity(g.player, getDexterity(g.player) + 1);       cond = true
            of "3": setIntelligence(g.player, getIntelligence(g.player) + 1); cond = true
            of "4": setEndurance(g.player, getEndurance(g.player) + 1);       cond = true
            of "5": setCharisma(g.player, getCharisma(g.player) + 1);         cond = true
            else: discard # just loops again

proc chooseSkillUpgrade* (g: Game, cond: var bool) =
    while cond == false:
        clearScreen()
        echo getKey(g, "game__level_up_sk")
        for i, s in ["swords", "bows", "guns", "spellcasting", "connection", "trade", "repair", "healing",
                     "lockpicking", "smithing", "herbalism", "vehicle_drive", "trapspotting", "survival", "sneaking"]:
            echo getOptionKey(g, "game__gui_" & s, i + 1)
        let prompt = readLine(stdin)
        case prompt:
            of "1": setSwords(g.player, getSwords(g.player) + 1);              cond = true
            of "2": setBows(g.player, getBows(g.player) + 1);                  cond = true
            of "3": setGuns(g.player, getGuns(g.player) + 1);                  cond = true
            of "4": setSpellcasting(g.player, getSpellcasting(g.player) + 1);  cond = true
            of "5": setConnection(g.player, getConnection(g.player) + 1);      cond = true
            of "6": setTrade(g.player, getTrade(g.player) + 1);                cond = true
            of "7": setRepair(g.player, getRepair(g.player) + 1);              cond = true
            of "8": setHealing(g.player, getHealing(g.player) + 1);            cond = true
            of "9":  setLockpicking(g.player, getLockpicking(g.player) + 1);   cond = true
            of "10": setSmithing(g.player, getSmithing(g.player) + 1);         cond = true
            of "11": setHerbalism(g.player, getHerbalism(g.player) + 1);       cond = true
            of "12": setVehicleDrive(g.player, getVehicleDrive(g.player) + 1); cond = true
            of "13": setTrapspotting(g.player, getTrapspotting(g.player) + 1); cond = true
            of "14": setSurvival(g.player, getSurvival(g.player) + 1);         cond = true
            of "15": setSneaking(g.player, getSneaking(g.player) + 1);         cond = true
            else: discard # just loops again

proc levelUp* (g: Game) =
    var # bool checkers
      at = false
      sk = false
    chooseAttributeUpgrade(g, at)
    chooseSkillUpgrade(g, sk)

proc WAITING_FOR_IMPLEMENTATION* () = discard # used so that I know points of the game that needs to be made still

proc exitGame* (g: Game) =
    g.run = false
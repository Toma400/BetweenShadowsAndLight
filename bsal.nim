import std/strutils
import std/tables
import mechanics
import dialogues
import inventory
import location
import battle
import player
import quest
import lang
import item
import init
import game
import char
import os

var g = newGame()

while isRunning(g):
    clearScreen() # clears each draw
    case getMenu(g):
        of START:
            echo LOGO
            echo getKey(g, "menu__start")
            echo getKey(g, "menu__load")
            echo getKey(g, "menu__settings")
            echo getKey(g, "menu__quit")
            let prompt = readLine(stdin)
            if prompt.toLowerAscii in [getKey(g, "menu__start").toLowerAscii]:
                switchMenu(g, mDEFAULT)
            elif prompt.toLowerAscii in [getKey(g, "menu__load").toLowerAscii]:
                discard
            elif prompt.toLowerAscii in [getKey(g, "menu__settings").toLowerAscii]:
                switchMenu(g, SETTINGS)
            elif prompt.toLowerAscii in [getKey(g, "menu__quit").toLowerAscii, "q"]:
                exitGame(g)
        of LOAD:
            switchMenu(g, mDEFAULT) # this should eventually happen after successful load
            # you set g.player object etc. of course
        of mDEFAULT:
            # tuple used for creating character, in case one isn't made yet
            var player_tuple = (
                                name   : "",
                                gender : VOIDG,
                                class  : VOIDC,
                                race   : VOIDR,
                                attr   : "",
                                skill  : ""
                                )
            while getPlayerName(g) == "": # character wasn't created nor loaded
                initCharacter(g, player_tuple)

            if getPlayerName(g) != "": # character is created/loaded
                # general processes
                processMainQuest(g)
                processStatistics(g.player)
                if g.player.hp <= 0: switchMenu(g, mDEATH); continue
                if getExperience(g.player) > calculateExperienceCap(g.player):
                    levelUp(g)
                # echos
                echo LocationMap
                echo "[" & getKey(g, "location__" & ($g.location).toLowerAscii) & "]"
                echo getKey(g, "game__gui_health") & ": " & $g.player.hp
                echo getKey(g, "game__gui_level")  & ": " & $getLevel(g.player)
                echo getKey(g, "game__gui_weight") & ": " & $g.player.weight & " / " & $getMaxWeight(g.player)
                echo "[" & getKey(g, "game__gui_character") & "]" & " " &
                     "[" & getKey(g, "game__gui_inventory") & "]" & " " &
                     "[" & getKey(g, "game__gui_location")  & "]" & " " &
                     "[" & getKey(g, "game__gui_map")       & "]" & " " &
                     "[" & getKey(g, "game__gui_diary")     & "]" & " "
                echo DIVSHORT
                for msg in getMessages(g):
                    echo msg
                let conv = {
                    getKey(g, "game__gui_character").toLowerAscii : mCHARACTER,
                    getKey(g, "game__gui_inventory").toLowerAscii : mINVENTORY,
                    getKey(g, "game__gui_location").toLowerAscii  : mLOCATION,
                    getKey(g, "game__gui_map").toLowerAscii       : mMAP,
                    getKey(g, "game__gui_diary").toLowerAscii     : mDIARY
                }.toTable
                let prompt = readLine(stdin)
                if prompt.toLowerAscii in conv:
                    switchMenu(g, conv[prompt.toLowerAscii])
                elif prompt == "cheat": # cheat menu, but not the right one
                    g.player.money += 150
                    addItemToInventory(g.player, "wood")
                    addItemToInventory(g.player, "chainmail_broken")
                    addItemToInventory(g.player, "iron")
                    addItemToInventory(g.player, "water_cooked")
                    addItemToInventory(g.player, "hyerbitus")
                    changeLocation(g, EVROS)
                    WAITING_FOR_IMPLEMENTATION() # todo: make it cheat screen, like in OG

        of SETTINGS:
            echo getKey(g, "menu__langcur") & " " & getKey(g, "menu__lang")
            echo getKey(g, "menu__langav")
            for lang in getAvailableLangs():
                echo "- " & lang
            let tut_state = if g.tutorial: getKey(g, "menu__enabled") else: getKey(g, "menu__disabled")
            echo getKey(g, "menu__tutorial") & ": " & tut_state
            echo getKey(g, "menu__set_note").replace("%TUT", getKey(g, "menu__tutorial"))
            let prompt = readLine(stdin)
            if prompt == "":
                switchMenu(g, START)
            elif prompt in getAvailableLangs():
                switchLanguage(g, prompt)
            elif prompt.toLowerAscii == getKey(g, "menu__tutorial").toLowerAscii:
                switchTutorial(g)

        of mCHARACTER:
            characterStatistics(g)

        of mINVENTORY:
            characterInventory(g)

        of mLOCATION:
            processStatistics(g.player)
            if g.player.hp <= 0: switchMenu(g, mDEATH); continue
            case g.location: # no -else- so that lacking location is caught by compiler
                of SHIP:
                    echo getOptionKey(g, "loc__ship_talk_sailor",  1)
                    echo getOptionKey(g, "loc__ship_search_deck",  2)
                    echo getOptionKey(g, "loc__ship_look_around",  3)
                    echo getOptionKey(g, "loc__ship_talk_captain", 4)
                    echo getOptionKey(g, "loc__do_nothing",   5)
                    if isQuestActive(g.player, TALK_TO_COOK):
                        echo getOptionKey(g, "loc__ship_go_to_kitchen", 6)
                    let prompt = readLine(stdin)
                    case prompt:
                        of "1": startDialogue(g, SAILOR)
                        of "2": ship_SearchDeck(g.player)
                        of "3": ship_lookAround(g.player)
                        of "4": startDialogue(g, CAPTAIN)
                        of "5": switchMenu(g, mDEFAULT); continue
                        of "6":
                            if isQuestActive(g.player, TALK_TO_COOK):
                                startDialogue(g, COOK)
                            else: continue
                        else:   continue
                    if isDialogueStarted(g): continue # lets `mDIALOGUE` handle everything
                    printMessages(g)
                    waitForPlayer()
                of SHIP_DOCKED: # made dedicated options so it reflects changes
                    echo getOptionKey(g, "loc__ship_search_deck",  1)
                    echo getOptionKey(g, "loc__ship_look_around",  2)
                    echo getOptionKey(g, "loc__ship_talk_captain", 3)
                    echo getOptionKey(g, "loc__do_nothing", 4)
                    let prompt = readLine(stdin)
                    case prompt:
                        of "1": ship_SearchDeck(g.player)
                        of "2": ship_lookAroundPort(g.player)
                        of "3": startDialogue(g, CAPTAIN_DOCKED)
                        of "4": switchMenu(g, mDEFAULT); continue
                        else: continue
                    printMessages(g)
                    waitForPlayer()
                of DESERTED_ISLAND:
                    echo getKey(g, "loc__island")
                    echo getOptionKey(g, "loc__island_look_around", 1)
                    echo getOptionKey(g, "loc__island_barrels", 2)
                    echo getOptionKey(g, "loc__do_nothing", 3)
                    let prompt = readLine(stdin)
                    case prompt:
                        of "1": island_SearchArea(g.player)
                        of "2": island_OpenBarrel(g)
                        of "3": switchMenu(g, mDEFAULT); continue
                        else: continue
                    printMessages(g)
                    waitForPlayer()
                of DESERTED_HOME:
                    echo getKey(g, "loc__abhouse_enter")
                    echo getKey(g, "loc__abhouse_enter2")
                    echo getOptionKey(g, "loc__abhouse_que1", 1)
                    echo getOptionKey(g, "loc__abhouse_que2", 2)
                    echo getOptionKey(g, "loc__abhouse_que3", 3)
                    echo getOptionKey(g, "loc__do_nothing", 4)
                    let prompt = readLine(stdin)
                    case prompt:
                        of "1": home_ReadBook(g.player)
                        of "2": home_OpenChest(g)
                        of "3": home_Sleep(g.player)
                        of "4": switchMenu(g, mDEFAULT); continue
                        else: continue
                    printMessages(g)
                    waitForPlayer()
                of DOCKS:
                    echo getKey(g, "loc__docks")
                    echo getOptionKey(g, "loc__docks_que1", 1)
                    echo getOptionKey(g, "loc__docks_que2", 2)
                    echo getOptionKey(g, "loc__docks_que3", 3)
                    echo getOptionKey(g, "loc__docks_que4", 4)
                    echo getOptionKey(g, "loc__docks_que5", 5)
                    echo getOptionKey(g, "loc__do_nothing", 6)
                    let prompt = readLine(stdin)
                    case prompt:
                        of "1": startDialogue(g, TAVERN_BARMAN)
                        of "2": startDialogue(g, MAGICIAN)
                        of "3": startDialogue(g, SAILOR_DOCKS)
                        of "4": startDialogue(g, LE_VELGA)
                        of "5": WAITING_FOR_IMPLEMENTATION() # magazyn
                        of "6": switchMenu(g, mDEFAULT); continue
                        else: continue
                    printMessages(g)
                    waitForPlayer()
                of EVROS:
                    echo getKey(g, "loc__evros")
                    echo getOptionKey(g, "loc__evros_que1", 1)
                    echo getOptionKey(g, "loc__evros_que2", 2)
                    echo getOptionKey(g, "loc__evros_que3", 3)
                    echo getOptionKey(g, "loc__evros_que4", 4)
                    echo getOptionKey(g, "loc__evros_que5", 5)
                    echo getOptionKey(g, "loc__do_nothing", 6)
                    let prompt = readLine(stdin)
                    case prompt:
                        of "1": startDialogue(g, MERCHANT)
                        of "2": startDialogue(g, HERBALIST)
                        of "3": startDialogue(g, SMITH)
                        of "4": banking(g)
                        of "5": startDialogue(g, PAPERBOY)
                        of "6": switchMenu(g, mDEFAULT); continue
                        else: continue
                    printMessages(g)
                    waitForPlayer()
                of FIELDS:
                    echo getKey(g, "loc__fields")
                    echo getOptionKey(g, "loc__fields_que1", 1)
                    echo getOptionKey(g, "loc__fields_que2", 2)
                    echo getOptionKey(g, "loc__fields_que3", 3)
                    echo getOptionKey(g, "loc__fields_que4", 4)
                    if hasItem(g.player, "sickle"): # makes more sense than quest gatekeeping
                        echo getOptionKey(g, "loc__fields_que5", 5)
                    echo getOptionKey(g, "loc__do_nothing", 6)
                    let prompt = readLine(stdin)
                    case prompt:
                        of "1":
                            if not combat(g, RAT, crouch_available=true):
                                switchMenu(g, mDEATH); continue
                        of "2": startDialogue(g, FARMER)
                        of "3": getGatherableItems(g, "hyerbitus", HYERBITUS_GROWTH) # waitForPlayer() happens later
                        of "4": discard; WAITING_FOR_IMPLEMENTATION() # fireplace/cooking
                        of "5":
                            if hasItem(g.player, "sickle"):
                                getGatherableItems(g, "wheat", WHEAT_GROWTH) # waitForPlayer() happens later
                        of "6": switchMenu(g, mDEFAULT); continue
                        else: continue
                    printMessages(g)
                    waitForPlayer()
                of BAEDOOR:
                    discard # not achievable

        of mMAP:
            echo LocationMap
            echo getKey(g, "travel__ask")
            for ix, dest in LocationDestinations[g.location].pairs():
                # if showing conditional is needed, it will go here
                echo getOptionKey(g, dest.key, ix + 1)
            let prompt = readLine(stdin)
            if prompt == "": # go back
                switchMenu(g, mDEFAULT)
                continue
            try:
                let p = parseInt(prompt)
                if p <= 0 or p > len(LocationDestinations):
                    continue
                else:
                    let dest = LocationDestinations[g.location][p-1]
                    if dest.cond == true: # checks whether condition is met
                        if not randomEncounter(g, dest.enc.en, dest.enc.chance): # random encounter
                            switchMenu(g, mDEATH)
                        journey(g, dest.loc, dest.cost) # menu switch is done here too
                    else:
                        echo getKey(g, dest.failed)
                        waitForPlayer()
            except ValueError:
                continue

        of mDIARY:
            echo "{ " & getKey(g, "game__gui_drinit") & " }"
            echo getKey(g, "game__gui_drhelp")
            echo "[" & getKey(g, "game__gui_drdiary")    & "]" & " " &
                 "[" & getKey(g, "game__gui_drsave")     & "]" & " " &
                 "[" & getKey(g, "game__gui_drsavequit") & "]" & " " &
                 "[" & getKey(g, "game__gui_drquit")     & "]"
            let prompt = readLine(stdin).toLowerAscii
            if prompt == getKey(g, "game__gui_drdiary").toLowerAscii:
                clearScreen()
                echo DIVIDER
                echo "{ " & getKey(g, "game__gui_drdiary2") & " }"
                for q in getActiveQuests(g.player):
                    echo "- " & getKey(g, $q)
                echo DIVIDER
                waitForPlayer()
                continue
            elif prompt == getKey(g, "game__gui_drsave").toLowerAscii:
                continue; WAITING_FOR_IMPLEMENTATION()
            elif prompt == getKey(g, "game__gui_drsavequit").toLowerAscii:
                continue; WAITING_FOR_IMPLEMENTATION()
            elif prompt == getKey(g, "game__gui_drquit").toLowerAscii:
                resetGameData(g)
                switchMenu(g, START)
            else:
                switchMenu(g, mDEFAULT)

        of mDIALOGUE:
            processDialogue(g)

        of mDEATH:
            case getGender(g.player):
                of MALE:      echo getKey(g, "game__death_m")
                of FEMALE:    echo getKey(g, "game__death_f")
                of NONBINARY: echo getKey(g, "game__death_n")
                else: discard # not reachable
            waitForPlayer()
            switchMenu(g, START)

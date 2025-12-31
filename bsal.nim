import std/strutils
import std/tables
import dialogues
import location
import player
import quest
import lang
import item
import init
import game
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
                    # getKey(g, "game__gui_inventory").toLowerAscii : mINVENTORY,
                    getKey(g, "game__gui_location").toLowerAscii  : mLOCATION,
                    getKey(g, "game__gui_map").toLowerAscii       : mMAP,
                    getKey(g, "game__gui_diary").toLowerAscii     : mDIARY
                }.toTable
                let prompt = readLine(stdin)
                if prompt.toLowerAscii in conv:
                    switchMenu(g, conv[prompt.toLowerAscii])
                elif prompt == "cheat":
                    discard # todo: make it cheat screen, like in OG
                # todo: discard readLine(stdin) # used so that you don't get result cleared

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
            echo getKey(g, "game__gui_chinit")
            echo "[" & getPlayerName(g.player) & "]"
            echo getKey(g, "gender__" & ($getGender(g.player)).toLowerAscii)
            echo getKey(g, "race__"   & ($getRace(g.player)).toLowerAscii)
            echo getKey(g, "class__"  & ($getClass(g.player)).toLowerAscii)
            echo getKey(g, "game__gui_level")  & ": " & $getLevel(g.player)
            echo getKey(g, "game__gui_xp")     & ": " & $getExperience(g.player) & " / " & $getMaxWeight(g.player)
            echo getKey(g, "game__gui_sp")     & ": " & $g.player.sp
            echo "{" & getKey(g, "game__gui_health") & ": " & $g.player.hp & " / " & $getMaxHealth(g.player) & "}" &
                 "{" & getKey(g, "game__gui_mana")   & ": " & $g.player.mp & " / " & $getMaxMana(g.player)   & "}" &
                 "{" & getKey(g, "game__gui_attack")  & ": " & $getAttack(g.player)  & "}" &
                 "{" & getKey(g, "game__gui_defence") & ": " & $getDefence(g.player) & "}" &
                 # armor | todo: apparently there's [armor / maxarmor]?? is it like item resistance/durability?
                 #         ...but then there's also `armor_hp` wtf
                 "" # for now, so that the above not being filled don't break the string
                 # magic defence (if it exists), from what I see as new line
            echo DIVSHORT
            # attrs
            # skills
            discard readLine(stdin) # let player see statistics before they are moved to old menu
  # basic_armor()
  # print ("Twoja postać:","\n\n[",name,"]\n",gender,"\n",race,"\n",craft,"\n")
  # print ("Poziom", level, "\n")
  # print ("-Punkty doświadczenia:",xp,"/",xp_level,"-")
  # print ("-Wypoczęcie:",sp,"-")
  # print ("[HP",hp,"/",hp_level,"][Mana",mp,"/",mp_level,"][Atak",eq_attack,"][Obrona",eq_defence,"(",armor_hp,"%)]")
  # if eq_mdefence > 0:
  #   print ("[Obrona magiczna",eq_mdefence,"]")
  # print ("---------------------")
  # print ("[SIŁA",strength,"]\n[ZWINNOŚĆ",dexterity,"]\n[INTELIGENCJA",intelligence,"]\n[WYTRZYMAŁOŚĆ",endurance,"]""\n[CHARYZMA",charisma,"]")
  # print ("\n[BROŃ BIAŁA",swords,"]\n[STRZELECTWO",bows,"]\n[BROŃ PALNA",guns,"]\n[RZUCANIE ZAKLĘĆ",castspelling,"]\n[SIŁA ZJEDNOCZENIA",connection,"]\n[HANDEL",trade,"]\n[NAPRAWA",repair,"]\n[LECZENIE",healing,"]\n[OTWIERANIE ZAMKÓW",lockpicking,"]\n[SKRADANIE",sneaking,"]\n[KOWALSTWO",smithing,"]\n[ZIELARSTWO",herbalism,"]\n[KIEROWANIE POJAZDAMI",vehicle_drive,"]\n[PUŁAPKI",trapspotting,"]\n[PRZETRWANIE",survival,"]")

            switchMenu(g, mDEFAULT)

        of mINVENTORY: break
        of mLOCATION:
            processStatistics(g.player)
            case g.location:
                of SHIP:
                    echo getOptionKey(g, "loc__ship_talk_sailor",  1)
                    echo getOptionKey(g, "loc__ship_search_deck",  2)
                    echo getOptionKey(g, "loc__ship_look_around",  3)
                    echo getOptionKey(g, "loc__ship_talk_captain", 4)
                    echo getOptionKey(g, "loc__ship_do_nothing",   5)
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
                    discard readLine(stdin)
                of DESERTED_ISLAND:
                    echo getKey(g, "loc__island")
                    echo getOptionKey(g, "loc__island_look_around", 1)
                    echo getOptionKey(g, "loc__island_barrels", 2)
                    echo getOptionKey(g, "loc__ship_do_nothing", 3)
                    let prompt = readLine(stdin)
                    case prompt:
                        of "1": island_SearchArea(g.player)
                        of "2": island_OpenBarrel(g)
                        of "3": switchMenu(g, mDEFAULT); continue
                        else: continue
                    printMessages(g)
                    discard readLine(stdin)
                # other locations, not important for now
                else:
                    break

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
                # if location conditional is needed, have it here
                if p <= 0 or p > len(LocationDestinations):
                    continue
                else:
                    changeLocation(g, LocationDestinations[g.location][p-1].loc)
                    # if tiredness change is needed, make it happen here
                    switchMenu(g, mDEFAULT)
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
                continue
            elif prompt == getKey(g, "game__gui_drsavequit").toLowerAscii:
                continue
            elif prompt == getKey(g, "game__gui_drquit").toLowerAscii:
                resetGameData(g)
                switchMenu(g, START)
            else:
                switchMenu(g, mDEFAULT)
        of mDIALOGUE:
            processDialogue(g)
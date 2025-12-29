import std/strutils
import std/tables
import location
import player
import lang
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
                switchMenu(g, PLAY)
            elif prompt.toLowerAscii in [getKey(g, "menu__load").toLowerAscii]:
                discard
            elif prompt.toLowerAscii in [getKey(g, "menu__settings").toLowerAscii]:
                switchMenu(g, SETTINGS)
            elif prompt.toLowerAscii in [getKey(g, "menu__quit").toLowerAscii, "q"]:
                exitGame(g)
        of LOAD:
            switchMenu(g, PLAY) # this should eventually happen after successful load
            # you set g.player object etc. of course
        of PLAY:
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
                echo DIVIDER
                echo ">> " & getKey(g, "game__tut_1") & " <<"
                echo ">> " & getKey(g, "game__tut_2") & " <<"
                echo ">> " & getKey(g, "game__tut_3") & " <<"
                echo DIVIDER
                # name pick
                while player_tuple.name == "":
                    echo getKey(g, "game__crq_1")
                    let prompt = readLine(stdin)
                    if prompt != "":
                        player_tuple.name = prompt
                    clearScreen()
                # gender pick
                while player_tuple.gender == VOIDG:
                    echo getKey(g, "game__crq_2")
                    echo getKey(g, "gender__male")
                    echo getKey(g, "gender__female")
                    echo getKey(g, "gender__nonbinary")
                    let prompt = readLine(stdin)
                    let conv   = {
                                  getKey(g, "gender__male").toLowerAscii:      getdGender["male"],
                                  getKey(g, "gender__female").toLowerAscii:    getdGender["female"],
                                  getKey(g, "gender__nonbinary").toLowerAscii: getdGender["nonbinary"]
                                  }.toTable
                    if prompt.toLowerAscii in conv:
                        player_tuple.gender = conv[prompt.toLowerAscii]
                    clearScreen()
                # race pick
                while player_tuple.race == VOIDR:
                    echo getKey(g, "game__crq_3")
                    echo DIVIDER
                    var conv = newTable[string, Race]() # prompt comparison, Race
                    for race_name in getdRace.keys:      # print race, then add to comparison table
                        echo "[" & getKey(g, "race__" & race_name) & "]"
                        echo getKey(g, "race__" & race_name & "_descr")
                        echo DIVIDER
                        conv[getKey(g, ("race__" & race_name)).toLowerAscii] = getdRace[race_name]
                    let prompt = readLine(stdin)
                    if prompt.toLowerAscii in conv:
                        player_tuple.race = conv[prompt.toLowerAscii]
                    clearScreen()
                # class pick
                while player_tuple.class == VOIDC:
                    echo getKey(g, "game__crq_4")
                    echo DIVIDER
                    var conv = newTable[string, Class]() # prompt comparison, Class
                    for class_name in getdClass.keys:     # print class, then add to comparison table
                        echo "- " & getKey(g, "class__" & class_name)
                        conv[getKey(g, ("class__" & class_name)).toLowerAscii] = getdClass[class_name]
                    let prompt = readLine(stdin)
                    if prompt.toLowerAscii in conv:
                        player_tuple.class = conv[prompt.toLowerAscii]
                    clearScreen()
                # # attribute pick
                # while player_tuple.attr == "":
                #     break
                # # skill pick
                # while player_tuple.skill == "":
                #     break

                # after all picks are done
                createCharacter(g, player_tuple.name, player_tuple.gender, player_tuple.race, player_tuple.class)
                # modifyAttributes(g.player, player_tuple.attr, 1)
                # modifySkills(g.player, player_tuple.skill, 1)

            if getPlayerName(g) != "": # character is created/loaded
                # general processes
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
                    # getKey(g, "game__gui_location").toLowerAscii  : mLOCATION,
                    # getKey(g, "game__gui_map").toLowerAscii       : mMAP,
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
            let prompt = readLine(stdin)
            if prompt in getAvailableLangs():
                switchLanguage(g, prompt)
                switchMenu(g, START)
            else:
                switchMenu(g, START)

        of mCHARACTER:
            echo getKey(g, "game__gui_chinit")
            echo "[" & getPlayerName(g.player) & "]"
            echo getKey(g, "gender__" & ($getGender(g.player)).toLowerAscii)
            echo getKey(g, "race__"   & ($getRace(g.player)).toLowerAscii)
            echo getKey(g, "class__"  & ($getClass(g.player)).toLowerAscii)
            echo getKey(g, "game__gui_level")  & ": " & $getLevel(g.player)
            echo getKey(g, "game__gui_xp")     & ": " & $g.player.xp & " / " & $getMaxWeight(g.player)
            echo getKey(g, "game__gui_sp")     & ": " & $g.player.sp
            echo "[" & getKey(g, "game__gui_health") & ": " & $g.player.hp & " / " & $getMaxHealth(g.player) & "]" &
                 "[" & getKey(g, "game__gui_mana")   & ": " & $g.player.mp & " / " & $getMaxMana(g.player)   & "]" &
                 "[" & getKey(g, "game__gui_attack")  & ": " & $getAttack(g.player)  & "]" &
                 "[" & getKey(g, "game__gui_defence") & ": " & $getDefence(g.player) & "]" &
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

            switchMenu(g, PLAY)

        of mINVENTORY: break
        of mLOCATION:  break
        of mMAP:       break
        of mDIARY:
            echo getKey(g, "game__gui_drinit")
            echo "[" & getKey(g, "game__gui_drdiary")    & "]" & " " &
                 "[" & getKey(g, "game__gui_drsave")     & "]" & " " &
                 "[" & getKey(g, "game__gui_drsavequit") & "]" & " " &
                 "[" & getKey(g, "game__gui_drquit")     & "]"
            let prompt = readLine(stdin).toLowerAscii
            if prompt == getKey(g, "game__gui_drdiary").toLowerAscii:
                continue
            elif prompt == getKey(g, "game__gui_drsave").toLowerAscii:
                continue
            elif prompt == getKey(g, "game__gui_drsavequit").toLowerAscii:
                continue
            elif prompt == getKey(g, "game__gui_drquit").toLowerAscii:
                switchMenu(g, START)
            else:
                switchMenu(g, PLAY)
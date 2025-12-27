import std/strutils
import std/tables
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
                                race   : VOIDR
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
                    echo getKey(g, "gender__1")
                    echo getKey(g, "gender__2")
                    echo getKey(g, "gender__3")
                    let prompt = readLine(stdin)
                    let conv   = {
                                  getKey(g, "gender__1").toLowerAscii: getGender["male"],
                                  getKey(g, "gender__2").toLowerAscii: getGender["female"],
                                  getKey(g, "gender__3").toLowerAscii: getGender["nonbinary"]
                                  }.toTable
                    if prompt.toLowerAscii in conv:
                        player_tuple.gender = conv[prompt.toLowerAscii]
                    clearScreen()
                # race pick
                while player_tuple.race == VOIDR:
                    echo getKey(g, "game__crq_3")
                    echo DIVIDER
                    var conv = newTable[string, Race]() # prompt comparison, Race
                    for race_name in getRace:           # print race, then add to comparison table
                        echo "[" & getKey(g, "race__" & race_name) & "]"
                        echo getKey(g, "race__" & race_name & "_descr")
                        echo DIVIDER
                        conv[getKey(g, ("race__" & race_name).toLowerAscii)] = getRace[race_name]
                    let prompt = readLine(stdin)
                    if prompt.toLowerAscii in conv:
                        player_tuple.race = conv[prompt.toLowerAscii]
                    clearScreen()
                # class pick
                while player_tuple.class == VOIDC:
                    echo getKey(g, "game__crq_4")
                    echo DIVIDER
                    var conv = newTable[string, Class]() # prompt comparison, Class
                    for class_name in getClass:          # print class, then add to comparison table
                        echo "- " & getKey(g, "class__" & class_name)
                        conv[getKey(g, ("class__" & class_name).toLowerAscii)] = getClass[class_name]
                    let prompt = readLine(stdin)
                    if prompt.toLowerAscii in conv:
                        player_tuple.class = conv[prompt.toLowerAscii]
                    clearScreen()

                # after all picks are done
                createCharacter(g, player_tuple.name, player_tuple.gender, player_tuple.race, player_tuple.class)
                break

            if getPlayerName(g) != "": # character is created/loaded
                echo $g
                switchMenu(g, START)

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
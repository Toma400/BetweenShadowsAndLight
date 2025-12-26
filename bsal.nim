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
                    for race_key in ["race__human", "race__ett", "race__vindean", "race__saphtri", "race__voitri", "race__ormath"]:
                        echo "[" & getKey(g, race_key) & "]"
                        echo getKey(g, race_key & "_descr")
                        echo DIVIDER
                    let prompt = readLine(stdin)
                    let conv   = {
                                  getKey(g, "race__human").toLowerAscii:   getRace["human"],
                                  getKey(g, "race__ett").toLowerAscii:     getRace["ett"],
                                  getKey(g, "race__vindean").toLowerAscii: getRace["vindean"],
                                  getKey(g, "race__saphtri").toLowerAscii: getRace["saphtri"],
                                  getKey(g, "race__voitri").toLowerAscii:  getRace["voitri"],
                                  getKey(g, "race__ormath").toLowerAscii:  getRace["ormath"],
                                  }.toTable
                    if prompt.toLowerAscii in conv:
                        player_tuple.race = conv[prompt.toLowerAscii]
                    clearScreen()
                # class pick
                while player_tuple.class == VOIDC:
                    echo getKey(g, "game__crq_4")
                    echo DIVIDER
                    for class_key in ["class__undefined", "class__warrior", "class__gunslinger", "class__mage",
                                      "class__merchant", "class__assassin", "class__engineer", "class__outlander",
                                      "class__necromant", "class__healer"]:#, "class__shaman"]:
                        echo "- " & getKey(g, class_key)
                    let prompt = readLine(stdin)
                    let conv   = {
                                  getKey(g, "class__undefined").toLowerAscii:  getClass["undefined"],
                                  getKey(g, "class__warrior").toLowerAscii:    getClass["warrior"],
                                  getKey(g, "class__gunslinger").toLowerAscii: getClass["gunslinger"],
                                  getKey(g, "class__mage").toLowerAscii:       getClass["mage"],
                                  getKey(g, "class__merchant").toLowerAscii:   getClass["merchant"],
                                  getKey(g, "class__assassin").toLowerAscii:   getClass["assassin"],
                                  getKey(g, "class__engineer").toLowerAscii:   getClass["engineer"],
                                  getKey(g, "class__outlander").toLowerAscii:  getClass["outlander"],
                                  getKey(g, "class__necromant").toLowerAscii:  getClass["necromant"],
                                  getKey(g, "class__healer").toLowerAscii:     getClass["healer"],
                                  # getKey(g, "class__shaman").toLowerAscii:     getClass["undefined"],
                                 }.toTable
                    if prompt.toLowerAscii in conv:
                        player_tuple.class = conv[prompt.toLowerAscii]
                    clearScreen()

                # after all picks are done
                createCharacter(g, player_tuple.name, player_tuple.gender, player_tuple.race, player_tuple.class)
                break
            # todo v
            # else:
            #     discard
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
            elif prompt.toLowerAscii in ["q"]:
                switchMenu(g, START)
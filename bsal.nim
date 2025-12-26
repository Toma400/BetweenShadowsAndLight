import std/strutils
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
                                name : ""
                                )
            while getPlayerName(g) == "": # character wasn't created nor loaded
                clearScreen() # clears each draw

                echo DIVIDER
                echo ">> " & getKey(g, "game__tut_1") & " <<"
                echo ">> " & getKey(g, "game__tut_2") & " <<"
                echo ">> " & getKey(g, "game__tut_3") & " <<"
                echo DIVIDER
                while player_tuple.name == "":
                    echo getKey(g, "game__crq_1")
                    let prompt = readLine(stdin)
                    if prompt != "":
                        player_tuple.name = prompt
                createCharacter(g, player_tuple.name)
            # todo v
            # else:
            #     discard
            if getPlayerName(g) != "": # character is created/loaded
                echo getPlayerName(g) & "!:)"
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
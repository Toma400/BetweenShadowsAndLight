import std/strutils
import lang
import game

var g = newGame()

while isRunning(g):
    case getMenu(g):
        of START:
            echo LOGO
            echo getKey(g, "menu__start")
            echo getKey(g, "menu__load")
            echo getKey(g, "menu__settings")
            echo getKey(g, "menu__quit")
            let prompt = readLine(stdin)
            if prompt.toLowerAscii in [getKey(g, "menu__start").toLowerAscii]:
                discard
            elif prompt.toLowerAscii in [getKey(g, "menu__load").toLowerAscii]:
                discard
            elif prompt.toLowerAscii in [getKey(g, "menu__settings").toLowerAscii]:
                switchMenu(g, SETTINGS)
            elif prompt.toLowerAscii in [getKey(g, "menu__quit").toLowerAscii, "q"]:
                exitGame(g)
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
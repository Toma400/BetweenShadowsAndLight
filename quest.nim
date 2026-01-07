import location
import player
import battle
import game

proc processMainQuest* (g: Game) =
    let mqv = getMainQuestProgress(g.player) # main quest value
    if mqv > 2: return # todo: end of main quest, skips the checks / update when all ifs are done to proper int value
    elif mqv == 1:
        # intro talk on where you are and how you got there
        echo getKey(g, "quest__mq_intro1")
        waitForPlayer()
        echo getKey(g, "quest__mq_intro2")
        waitForPlayer()

        if g.tutorial == true:
            echo getTutorialKey(g, "quest__mq_tut1")
            echo getTutorialKey(g, "quest__mq_tut2")
            echo getTutorialKey(g, "quest__mq_tut3")
            # sleep(4)
            echo "[" & getKey(g, "game__gui_character") & "]" & " " &
                 "[" & getKey(g, "game__gui_inventory") & "]" & " " &
                 "[" & getKey(g, "game__gui_location")  & "]" & " " &
                 "[" & getKey(g, "game__gui_map")       & "]" & " " &
                 "[" & getKey(g, "game__gui_diary")     & "]" & " "
            # sleep(2)
            echo getTutorialKey(g, "quest__mq_tut4")
            echo getTutorialKey(g, "quest__mq_tut5")
            echo getTutorialKey(g, "quest__mq_tut6")
            echo getTutorialKey(g, "quest__mq_tut7")
            waitForPlayer()

        setMainQuestProgress(g.player, 2)
        clearScreen() # so that normal menu can come up

    elif mqv == 2 and g.player.sp < 992 and g.location == SHIP:# and len(g.player.inv) > 0: # todo: rethink if making non-empty inventory makes sense
                                                                                            # specifically for failed quest case
        clearScreen() # so we have clear canvas
        echo getKey(g, "quest__mq_pir1")
        waitForPlayer()
        echo getKey(g, "quest__mq_pir2")
        echo getKey(g, "quest__mq_pir3")
        waitForPlayer()
        echo getKey(g, "quest__mq_pir4")
        echo getKey(g, "quest__mq_pir5")
        waitForPlayer()
        if g.tutorial:
            echo getTutorialKey(g, "game__tut_7")
            echo getTutorialKey(g, "game__tut_8")
            waitForPlayer()
        if not combat(g, PIRATE_WOUNDED):
            return # early return
            # no need to switchMenu, because if hp <= 0
            # bsal.nim's further check will do its thing
        echo getKey(g, "quest__mq_pir6")
        waitForPlayer()
        echo getKey(g, "quest__mq_pir7")
        waitForPlayer()
        sleep(g.player)
        echo getKey(g, "quest__mq_docks")
        changeLocation(g, SHIP_DOCKED)
        if g.tutorial:
            echo getTutorialKey(g, "quest__mq_tut8")
        waitForPlayer()
        setMainQuestProgress(g.player, 3)
        clearScreen()

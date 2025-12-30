import player
import game

proc processMainQuest* (g: Game) =
    if getMainQuestProgress(g.player) == 1:
        # intro talk on where you are and how you got there
        echo getKey(g, "quest__mq_intro1")
        discard readLine(stdin)
        echo getKey(g, "quest__mq_intro2")
        discard readLine(stdin)

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
            discard readLine(stdin)

        setMainQuestProgress(g.player, 2)
        clearScreen() # so that normal menu can come up
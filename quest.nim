import location
import player
import game

proc processMainQuest* (g: Game) =
    let mqv = getMainQuestProgress(g.player) # main quest value
    if mqv > 5: return # todo: end of main quest, skips the checks / update when all ifs are done to proper int value
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
        # when player did some minimal actions and has anything in inventory
        # sleep(2)
        echo DIVIDER
        # sleep(1)
        setMainQuestProgress(g.player, 3)
  # print ("Nagle...")
  # time.sleep(1)
  # print ("...zaatakowali nas piraci!")
  # print ("Słyszę szczęk broni dookoła, na pokładzie zapanował okropny chaos..")
  # time.sleep (5)
  # print ("Widzę, że kapitana atakuje od tyłu jeden z tych rzezimieszków!")
  # print ("Muszę stawić mu czoła, próbując walczyć tym, cokolwiek mam przy sobie")
  # time.sleep (6)
  # if tutorial_system == 1:
  #   print (">> Za chwilę pojawi się panel walki - jest on raczej intuicyjny. Powinniśmy jednak napomknieć o tym, że są różne rodzaje ataku - zależne od aktualnie trzymanej broni. Każdy z nich ma inną charakterystykę, skupiającą się na innej taktyce walki <<")
  #   print (">> Jeżeli do tej pory nie korzystałeś z ekwipunku, i nie dobyłeś broni (poprzez 'włożenie jej na siebie'), uczyń to teraz, wybierając w drugim menu '9' <<")
  #   time.sleep (8)
  # else:
  #   pass
  # fight ("Ranny Pirat",1,40,5,0,0,0)
  # if start != "death":
  #   mainquest = 3
  #   m_quest3 ()
  # else:
  #   pass

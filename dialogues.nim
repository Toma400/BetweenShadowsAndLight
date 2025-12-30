import player
import game

proc processDialogue* (g: Game) =
    # use `vars` and `dial_vars` for dialogue checks against events!
    # - `vars` are constant once added, and global (e.g. for quest decisions)
    # - `dial_vars` are purely for branching choices and are resetted each dialogue
    #               they can be used as `case` and be conditions of top level, so
    #               that nesting is not needed in their case
    # !! always make option that runs `endDialogue` so that the dialogue ends !!
    #
    # since this is no longer explicit part of loop, use `return` instead of `continue`
    case getDialogueName(g.player):
        of DUMMY: endDialogue(g, mDEFAULT)
        of CAPTAIN:
            echo getKey(g, "loc__ship_captain")
            echo getOptionKey(g, "loc__ship_captain_answer", 1)
            let prompt = readLine(stdin)
            case prompt:
                of "1":     endDialogue(g, mLOCATION)
                of "cheat": discard
                else:       return
                #todo:  ---cheat option

        of SAILOR:
            let dvars = getDialogueVariables(g.player)

            if checkVariable(g.player, SAM_KNOWS_YOU):
                if "que2" notin dvars:
                    echo getKey(g, "loc__ship_sailor_que1")
                    if not isQuestFinished(g.player, TALK_TO_COOK) and not checkVariable(g.player, KNIFE_BOUGHT):
                        echo getOptionKey(g, "loc__ship_sailor_que1a1", 1)
                    echo getOptionKey(g, "loc__ship_sailor_que1a2", 2)
                    if checkVariable(g.player, ISLAND_SEEN):
                        echo getOptionKey(g, "loc__ship_sailor_que1a3", 3)
                    if isQuestActive(g.player, BRING_SWEET_ROLL) and hasItem(g.player, "sweet_roll"):
                        echo getOptionKey(g, "loc__ship_sailor_que1a4", 4)
                    # if quest is active and you have sweet roll, [4] Mam dla Ciebie bułkę! is also printed as option
                    let prompt = readLine(stdin)
                    case prompt:
                        of "1":
                            if not isQuestFinished(g.player, TALK_TO_COOK) and not checkVariable(g.player, KNIFE_BOUGHT):
                                addDialogueVariable(g.player, "que2") # branches flow
                        of "2":
                            echo getKey(g, "loc__ship_sailor_dunno")
                            discard readLine(stdin)
                            endDialogue(g, mLOCATION)
                        of "3":
                            if checkVariable(g.player, ISLAND_SEEN):
                                echo getKey(g, "loc__ship_sailor_island")
                                discard readLine(stdin)
                                endDialogue(g, mLOCATION)
                            else: return
                        of "4":
                            if isQuestActive(g.player, BRING_SWEET_ROLL) and hasItem(g.player, "sweet_roll"):
                                addDialogueVariable(g.player, "sweet_roll") # branches flow
                            else: return
                        else: return

                elif "sweet_roll" in dvars: # when sweet roll is brought
                    echo getKey(g, "loc__ship_sailor_thanks")
                    finishQuest(g.player, BRING_SWEET_ROLL, 8)
                    discard removeItemFromInventory(g.player, "sweet_roll")
                    addItemToInventory(g.player, "rusty_knife")
                    discard readLine(stdin)
                    endDialogue(g, mLOCATION)

                elif "quest_ask" notin dvars: # picked option "1", and progressed to quest question so it's catched earlier
                    echo getKey(g, "loc__ship_sailor_quest")
                    echo getOptionKey(g, "loc__ship_sailor_questa1", 1)
                    echo getOptionKey(g, "loc__ship_sailor_questa2", 2)
                    let prompt = readLine(stdin)
                    case prompt:
                        of "1":
                            echo getKey(g, "loc__ship_sailor_waiting")
                            discard startQuest(g.player, TALK_TO_COOK)
                            discard readLine(stdin)
                            endDialogue(g, mLOCATION)
                        of "2":
                            echo getKey(g, "loc__ship_sailor_be_back")
                            discard readLine(stdin)
                            endDialogue(g, mLOCATION)
                        else: return

                else: # if you picked option "1"
                    if isQuestActive(g.player, TALK_TO_COOK):
                        echo getKey(g, "loc__ship_sailor_howlong")
                        discard readLine(stdin)
                        removeDialogueVariable(g.player, "que2") # goes back to normal flow
                    else:
                        echo getKey(g, "loc__ship_sailor_life")
                        # wait(2)
                        echo getKey(g, "loc__ship_sailor_que2")
                        echo getOptionKey(g, "loc__ship_sailor_que2a1", 1)
                        echo getOptionKey(g, "loc__ship_sailor_que2a2", 2)
                        echo getOptionKey(g, "loc__ship_sailor_que2a3", 3)
                        let prompt = readLine(stdin)
                        case prompt:
                            of "1":
                                echo getKey(g, "loc__ship_sailor_offer")
                                discard readLine(stdin)
                                let purchase = buy(g.player, "rusty_knife", 7)
                                if purchase:
                                    addVariable(g.player, KNIFE_BOUGHT)
                                    echo getKey(g, "loc__ship_sailor_bought")
                                printMessages(g) # prints in case purchase is failed
                                discard readLine(stdin)
                                endDialogue(g, mLOCATION)
                            of "2": addDialogueVariable(g.player, "quest_ask") # branches flow
                            of "3":
                                echo getKey(g, "loc__ship_sailor_be_back")
                                discard readLine(stdin)
                                endDialogue(g, mLOCATION)
                            else: return

            else: # default option at the start
                echo getKey(g, "loc__ship_sailor_greet")
                echo getOptionKey(g, "loc__ship_sailor_greeta1", 1)
                echo getOptionKey(g, "loc__ship_sailor_greeta2", 2)
                let prompt = readLine(stdin)
                case prompt:
                    of "1": discard # nothing because it just adds SAM_KNOWS_YOU and changes flow for next loop
                    of "2":
                        echo getKey(g, "loc__ship_sailor_kidding")
                        discard readLine(stdin)
                    else: return
                addVariable(g.player, SAM_KNOWS_YOU)
            # discard
            # endDialogue(g, mLOCATION)

        of COOK:
            echo getKey(g, "loc__ship_kitchen")
            echo getOptionKey(g, "loc__ship_kitchen_steal", 1)
            echo getOptionKey(g, "loc__ship_kitchen_ask", 2)
            echo getOptionKey(g, "loc__ship_do_nothing", 3)
            let prompt = readLine(stdin)
            case prompt:
                of "1":
                    let theft = crouch(g.player, 5)
                    if theft: # successful theft
                        echo getKey(g, "loc__ship_kitchen_theft")
                        addItemToInventory(g.player, "sweet_roll")
                        finishQuest(g.player, TALK_TO_COOK, 0)
                        discard startQuest(g.player, BRING_SWEET_ROLL) # next chapter
                        discard readLine(stdin)
                        endDialogue(g, mLOCATION)
                    else: # failed attempt
                        echo getKey(g, "loc__ship_cook_angry")
                        finishQuest(g.player, TALK_TO_COOK, 0)
                        discard readLine(stdin)
                        endDialogue(g, mLOCATION)
                of "2":
                    echo getKey(g, "loc__ship_cook_kind")
                    addItemToInventory(g.player, "sweet_roll")
                    finishQuest(g.player, TALK_TO_COOK, 0)
                    discard startQuest(g.player, BRING_SWEET_ROLL) # next chapter
                    discard readLine(stdin)
                of "3":
                    endDialogue(g, mLOCATION)
                else: return
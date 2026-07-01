import std/tables
import mechanics
import cheats
import player
import game
import item

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
            if "cheat" notin getDialogueVariables(g.player):
                echo getKey(g, "loc__ship_captain")
                echo getOptionKey(g, "loc__ship_captain_answer", 1)
                let prompt = readLine(stdin)
                case prompt:
                    of "1":     endDialogue(g, mLOCATION)
                    of "cheat": addDialogueVariable(g.player, "cheat") # branches flow
                    else:       return
            else:
                cheatCaptain(g)
                endDialogue(g, mDEFAULT)

        of CAPTAIN_DOCKED:
            echo getKey(g, "loc__shipd_captain")
            waitForPlayer()
            echo getKey(g, "loc__shipd_captain2")
            waitForPlayer()
            endDialogue(g, mLOCATION)

        of SAILOR:
            let dvars = getDialogueVariables(g.player)

            if checkVariable(g.player, SAM_KNOWS_YOU):
                if "que2" notin dvars and "sweet_roll" notin dvars: # most default interaction
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
                            waitForPlayer()
                            endDialogue(g, mLOCATION)
                        of "3":
                            if checkVariable(g.player, ISLAND_SEEN):
                                echo getKey(g, "loc__ship_sailor_island")
                                waitForPlayer()
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
                    waitForPlayer()
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
                            waitForPlayer()
                            endDialogue(g, mLOCATION)
                        of "2":
                            echo getKey(g, "loc__ship_sailor_be_back")
                            waitForPlayer()
                            endDialogue(g, mLOCATION)
                        else: return

                else: # if you picked option "1"
                    if isQuestActive(g.player, TALK_TO_COOK):
                        echo getKey(g, "loc__ship_sailor_howlong")
                        waitForPlayer()
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
                                waitForPlayer()
                                let purchase = buy(g.player, "rusty_knife", 7)
                                if purchase:
                                    addVariable(g.player, KNIFE_BOUGHT)
                                    echo getKey(g, "loc__ship_sailor_bought")
                                printMessages(g) # prints in case purchase is failed
                                waitForPlayer()
                                endDialogue(g, mLOCATION)
                            of "2": addDialogueVariable(g.player, "quest_ask") # branches flow
                            of "3":
                                echo getKey(g, "loc__ship_sailor_be_back")
                                waitForPlayer()
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
                        waitForPlayer()
                    else: return
                addVariable(g.player, SAM_KNOWS_YOU)
            # discard
            # endDialogue(g, mLOCATION)

        of COOK:
            echo getKey(g, "loc__ship_kitchen")
            echo getOptionKey(g, "loc__ship_kitchen_steal", 1)
            echo getOptionKey(g, "loc__ship_kitchen_ask", 2)
            echo getOptionKey(g, "loc__do_nothing", 3)
            let prompt = readLine(stdin)
            case prompt:
                of "1":
                    let theft = crouch(g.player, 5)
                    if theft: # successful theft
                        echo getKey(g, "loc__ship_kitchen_theft")
                        addItemToInventory(g.player, "sweet_roll")
                        finishQuest(g.player, TALK_TO_COOK, 0)
                        discard startQuest(g.player, BRING_SWEET_ROLL) # next chapter
                        waitForPlayer()
                        endDialogue(g, mLOCATION)
                    else: # failed attempt
                        echo getKey(g, "loc__ship_cook_angry")
                        finishQuest(g.player, TALK_TO_COOK, 0)
                        waitForPlayer()
                        endDialogue(g, mLOCATION)
                of "2":
                    echo getKey(g, "loc__ship_cook_kind")
                    addItemToInventory(g.player, "sweet_roll")
                    finishQuest(g.player, TALK_TO_COOK, 0)
                    discard startQuest(g.player, BRING_SWEET_ROLL) # next chapter
                    waitForPlayer()
                    endDialogue(g, mLOCATION)
                of "3":
                    endDialogue(g, mLOCATION)
                else: return

        of SAILOR_DOCKS:
            echo getKey(g, "loc__docks_sailor_greet")
            echo getOptionKey(g, "loc__docks_sailor_que1", 1)
            echo getOptionKey(g, "loc__docks_sailor_que2", 2)
            let prompt = readLine(stdin)
            case prompt:
                of "1":
                    echo getKey(g, "loc__docks_sailor_answer")
                    waitForPlayer()
                of "2":
                    endDialogue(g, mLOCATION)
                else: return

        of LE_VELGA:
            echo getKey(g, "loc__docks_le_velga")
            echo getOptionKey(g, "loc__docks_le_velga_que1", 1)
            echo getOptionKey(g, "loc__docks_le_velga_que2", 2)
            echo getOptionKey(g, "loc__docks_le_velga_que3", 3)
            let prompt = readLine(stdin)
            case prompt:
                of "1":
                    echo getKey(g, "loc__docks_le_velga_an1")
                    waitForPlayer()
                    echo getKey(g, "loc__docks_le_velga_an2")
                    waitForPlayer()
                of "2":
                    echo getKey(g, "loc__docks_le_velga_no")
                    waitForPlayer()
                of "3":
                    endDialogue(g, mLOCATION)
                else: return

        of ATG_SCOUT:
            if isQuestActive(g.player, ATG_1_WAREHOUSE): # picked up quest
                if getTimerCountDownValue(g.player, WAREHOUSE_QUEST) == 0: # night comes
                    echo getOptionKey(g, "loc__docks_atg_burg1", 1)
                    echo getOptionKey(g, "loc__docks_atg_burg2", 2)
                    echo getOptionKey(g, "game__leave", 3)
                    let prompt = readLine(stdin)
                    case prompt:
                      of "1":
                          if crouch(g.player, 5):
                              echo getKey(g, "loc__docks_atg_burgenter")
                              waitForPlayer()
                              if lock(g.player, 8):
                                  echo getKey(g, "loc__docks_atg_burgwin")
                                  waitForPlayer()
                                  # TODO: here ideally should be switch to separate NPC called "Warehouse"
                                  # this would ensure less nesting, but also a way in/out for other situations
                                  # when we want to steal from warehouse
                                  echo getKey(g, "loc__docks_atg_burgche")
                                  chest(g, CHESTS[WAREHOUSE_CHEST])
                                  if hasItem(g.player, "silk"):
                                      finishQuest(g.player, ATG_1_WAREHOUSE, 0) # xp gain when Silkboy is finished
                                      discard startQuest(g.player, ATG_1_SILKBOY)
                                  # endDialogue here would allow us to sell silk, but would require silk check
                                  # in second check of this dialogue; not sure if we want to cover that?
                                  # (how does OG do???)
                                  # ...but yeah, it does slightly limit player's ability
                              else:
                                  echo getKey(g, "loc__docks_atg_burgfail2")
                                  waitForPlayer()
                          else:
                              echo getKey(g, "loc__docks_atg_burgfail1")
                              waitForPlayer()
                      of "2": # guard
                          echo getKey(g, "loc__docks_atg_rep1")
                          echo getKey(g, "loc__docks_atg_rep2")
                          g.player.money += 50
                          finishQuest(g.player, ATG_1_WAREHOUSE, 10)
                          waitForPlayer()
                          endDialogue(g, mLOCATION)
                      of "3": endDialogue(g, mLOCATION)
                      else: return
                else:
                    echo getKey(g, "loc__docks_atg_wait")
                    waitForPlayer()
                    endDialogue(g, mLOCATION)
            elif isQuestActive(g.player, ATG_1_SILKBOY): # when you were able to steal the items
                # no need for silk check because unless we `endDialogue` earlier, we jump straight into this dialogue
                echo getKey(g, "loc__docks_atg_suc1")
                waitForPlayer()
                echo getKey(g, "loc__docks_atg_suc2")
                waitForPlayer()
                echo getKey(g, "loc__docks_atg_suc3")
                echo getKey(g, "loc__docks_atg_suc4")
                echo getKey(g, "loc__docks_atg_suc5")
                discard removeItemFromInventory(g.player, "silk")
                addItemToInventory(g.player, "atg_recommendation")
                finishQuest(g.player, ATG_1_SILKBOY, 20)
                # recommendation is only conveyed by letter, there's no point in adding quest
                # (it also forces player to continue ATG, while in reality it was more of an introduction/taste)
                waitForPlayer()
                endDialogue(g, mLOCATION)
            elif isQuestFinished(g.player, ATG_1_SILKBOY):
                echo getKey(g, "loc__docks_atg_reenter")
                echo getOptionKey(g, "loc__docks_atg_burg1", 1)
                echo getOptionKey(g, "game__leave", 2)
                let prompt = readLine(stdin)
                case prompt:
                    of "1":
                        if crouch(g.player, 10):
                            echo getKey(g, "loc__docks_atg_burgenter")
                            if lock(g.player, 14):
                                echo getKey(g, "loc__docks_atg_burgwin")
                                waitForPlayer()
                                chest(g, CHESTS[WAREHOUSE_CHEST])
                                endDialogue(g, mLOCATION) # maybe unnecessary? just wanted to avoid loop-back
                            else:
                                echo getKey(g, "loc__docks_atg_burgfail2")
                                waitForPlayer()
                        else:
                            echo getKey(g, "loc__docks_atg_burgfail1")
                            waitForPlayer()
                    of "2": endDialogue(g, mLOCATION)
            elif isQuestFinished(g.player, ATG_1_WAREHOUSE) or checkVariable(g.player, ATG_REJECTED): # no guy here
                # TODO: still possible to enter the warehouse here, but should be wary of whether we helped
                #       the guard, rejected ATG guy, or else
                echo getKey(g, "loc__docks_atg_finished")
                waitForPlayer()
                endDialogue(g, mLOCATION)
            else: # quest wasn't picked up yet
                if "further" notin getDialogueVariables(g.player):
                    echo getKey(g, "loc__docks_atg_ini1"); waitForPlayer()
                    echo getKey(g, "loc__docks_atg_ini2"); waitForPlayer()
                    echo getKey(g, "loc__docks_atg_ini3"); waitForPlayer()
                    echo getKey(g, "loc__docks_atg_ini4"); waitForPlayer()
                    echo getOptionKey(g, "loc__docks_atg_que1", 1)
                    echo getOptionKey(g, "loc__docks_atg_que2", 2)
                    echo getOptionKey(g, "loc__docks_atg_que3", 3)
                    let prompt = readLine(stdin)
                    case prompt:
                        of "1", "2": addDialogueVariable(g.player, "further")
                        of "3":
                            echo getKey(g, "loc__docks_atg_rej")
                            addVariable(g.player, ATG_REJECTED)
                            waitForPlayer()
                            endDialogue(g, mLOCATION)
                        else: return
                else: # "further" is in (aka the player agrees, but is given chance to resign still)
                    echo getKey(g, "loc__docks_atg_quea1")
                    echo getKey(g, "loc__docks_atg_quea2")
                    echo getOptionKey(g, "loc__docks_atg_queagr", 1)
                    echo getOptionKey(g, "loc__docks_atg_quemor", 2)
                    echo getOptionKey(g, "loc__docks_atg_querej", 3)
                    let prompt = readLine(stdin)
                    case prompt:
                        of "1":
                            echo getKey(g, "loc__docks_atg_agreed")
                            discard startQuest(g.player, ATG_1_WAREHOUSE)
                            setTimer(g.player, WAREHOUSE_QUEST)
                            waitForPlayer()
                            block learning:
                              setLockpicking(g.player, getLockpicking(g.player) + 1)
                              setSneaking(g.player,    getSneaking(g.player)    + 1)
                              g.player.lockpicks += 5
                            endDialogue(g, mLOCATION)
                        of "2", "3":
                            echo getKey(g, "loc__docks_atg_rej")
                            addVariable(g.player, ATG_REJECTED)
                            waitForPlayer()
                            endDialogue(g, mLOCATION)
                        else: return

        of TAVERN_BARMAN:
            if "buy_sleep" notin getDialogueVariables(g.player):
                echo getKey(g, "loc__docks_tavern")
                echo getOptionKey(g, "loc__docks_tavern_que1", 1)
                if not checkVariable(g.player, TAVERN_KEY):
                    echo getOptionKey(g, "loc__docks_tavern_que2", 2)
                echo getOptionKey(g, "loc__docks_tavern_que3", 3) # in OG this was guarded by reverse check to the above
                echo getOptionKey(g, "loc__docks_tavern_que4", 4)
                let prompt = readLine(stdin)
                case prompt:
                    of "1": shop(g, TAVERN_BARMAN)
                    of "2":
                        if not checkVariable(g.player, TAVERN_KEY):
                            addDialogueVariable(g.player, "buy_sleep")
                    of "3":
                        if checkVariable(g.player, TAVERN_KEY):
                            sleep(g.player)
                            echo getKey(g, "loc__docks_tavern_sleep")
                            removeVariable(g.player, TAVERN_KEY)
                            waitForPlayer()
                        else: # ...but this option existed despite the OG check above not telling player to click on 3
                            echo getKey(g, "loc__docks_tavern_noslep") # so I decided to keep nice deny answer more visible
                            waitForPlayer()
                    of "4": endDialogue(g, mLOCATION)
                    else: return
            else: # 'shop' section for renting the bed
                echo getKey(g, "loc__docks_tavern_zzzzz")
                echo getOptionKey(g, "loc__docks_tavern_sleep1", 1)
                echo getOptionKey(g, "loc__docks_tavern_sleep2", 2)
                let prompt = readLine(stdin)
                case prompt:
                    of "1":
                        if g.player.money >= 8:
                            g.player.money -= 8
                            addVariable(g.player, TAVERN_KEY)
                            echo getKey(g, "loc__docks_tavern_slepok")
                            removeDialogueVariable(g.player, "buy_sleep")
                            waitForPlayer()
                        else:
                            echo getKey(g, "game__warn_money")
                            removeDialogueVariable(g.player, "buy_sleep")
                            waitForPlayer()
                    of "2": removeDialogueVariable(g.player, "buy_sleep")
                    else: return

        of MAGICIAN:
            let dvars = getDialogueVariables(g.player)
            if "help" notin dvars and "aintrick" notin dvars: # normal section
                echo getKey(g, "loc__docks_mage")
                echo getOptionKey(g, "loc__docks_mage_que1", 1)
                echo getOptionKey(g, "loc__docks_mage_que2", 2)
                echo getOptionKey(g, "loc__docks_mage_que3", 3)
                echo getOptionKey(g, "loc__docks_mage_que4", 4)
                if isQuestActive(g.player, GET_PARCHMENT) and hasItem(g.player, "parchment"):
                    echo getOptionKey(g, "loc__docks_mage_que5", 5)
                let prompt = readLine(stdin)
                case prompt:
                    of "1": shop(g, MAGICIAN)
                    of "2": addDialogueVariable(g.player, "help")
                    of "3": addDialogueVariable(g.player, "aintrick")
                    of "4": endDialogue(g, mLOCATION)
                    of "5":
                        if isQuestActive(g.player, GET_PARCHMENT) and hasItem(g.player, "parchment"):
                            echo getKey(g, "loc__docks_mage_happy")
                            discard removeItemFromInventory(g.player, "parchment")
                            waitForPlayer()
                            echo getKey(g, "loc__docks_mage_happy2")
                            setSpellcasting(g.player, getSpellcasting(g.player) + 1)
                            finishQuest(g.player, GET_PARCHMENT, 5)
                            waitForPlayer()
                    else: return
            elif "help" notin dvars: # 'aintrick' variable section
                echo getKey(g, "loc__docks_mage_aintrick")
                waitForPlayer()
                echo getKey(g, "loc__docks_mage_a2ntrick")
                waitForPlayer()
                echo getKey(g, "loc__docks_mage_a3ntrick")
                waitForPlayer()
                if not isQuestActive(g.player, GET_PARCHMENT) and not isQuestFinished(g.player, GET_PARCHMENT):
                    echo getKey(g, "loc__docks_mage_aintask")
                    echo getOptionKey(g, "loc__docks_mage_taskre1", 1)
                    echo getOptionKey(g, "loc__docks_mage_taskre2", 2)
                    let prompt = readLine(stdin)
                    case prompt:
                        of "1":
                            discard startQuest(g.player, GET_PARCHMENT)
                            echo getKey(g, "loc__docks_mage_aintask2")
                            removeDialogueVariable(g.player, "aintrick")
                            waitForPlayer()
                        of "2": removeDialogueVariable(g.player, "aintrick")
                        else: return # will rewrite the above
                else: removeDialogueVariable(g.player, "aintrick")
            else: # 'help' variable section | after player asks if they can help
                if isQuestFinished(g.player, GET_PARCHMENT):
                    echo getKey(g, "loc__docks_mage_taskdone")
                    removeDialogueVariable(g.player, "help")
                    waitForPlayer()
                elif isQuestActive(g.player, GET_PARCHMENT):
                    echo getKey(g, "loc__docks_mage_taskpend")
                    removeDialogueVariable(g.player, "help")
                    waitForPlayer()
                else:
                    echo getKey(g, "loc__docks_mage_task")
                    echo getOptionKey(g, "loc__docks_mage_taskre1", 1)
                    echo getOptionKey(g, "loc__docks_mage_taskre2", 2)
                    let prompt = readLine(stdin)
                    case prompt:
                        of "1":
                            discard startQuest(g.player, GET_PARCHMENT)
                            echo getKey(g, "loc__docks_mage_taskacc")
                            removeDialogueVariable(g.player, "help")
                            waitForPlayer()
                        of "2": removeDialogueVariable(g.player, "help")
                        else: return # will rewrite the above

        of SMITH:
            echo getKey(g, "loc__evros_smith")
            echo getOptionKey(g, "loc__evros_smith_que1", 1)
            echo getOptionKey(g, "loc__evros_smith_que2", 2)
            echo getOptionKey(g, "loc__docks_tavern_que4", 3)
            let prompt = readLine(stdin)
            case prompt:
                of "1": shop(g, SMITH)
                of "2":
                    echo getKey(g, "loc__evros_smith_anvil")
                    waitForPlayer()
                    smithing(g)
                of "3": endDialogue(g, mLOCATION)
                else: return

        of PAPERBOY:
            echo getKey(g, "loc__evros_newspaper")
            echo getOptionKey(g, "loc__evros_newspaper_buy", 1)
            echo getOptionKey(g, "game__leave", 2)
            let prompt = readLine(stdin)
            case prompt:
                of "1":
                    echo getKey(g, "loc__evros_newspaper_bu2")
                    if not buy(g.player, "newspaper", 2):
                        printMessages(g)
                    waitForPlayer()
                of "2": endDialogue(g, mLOCATION)
                else: return

        of MERCHANT:
            let quest_active = GET_PARCHMENT in getActiveQuests(g.player) and not checkVariable(g.player, MERCHANT_ASKED)

            if "bullets" notin getDialogueVariables(g.player):
                echo getKey(g, "loc__evros_merchant")
                echo getOptionKey(g, "loc__evros_merchant_que1", 1)
                echo getOptionKey(g, "loc__evros_merchant_que2", 2)
                echo getOptionKey(g, "loc__evros_merchant_que3", 3)
                if quest_active:
                    echo getOptionKey(g, "loc__evros_merchant_que4", 4)
                let prompt = readLine(stdin)
                case prompt:
                    of "1": shop(g, MERCHANT)
                    of "2": addDialogueVariable(g.player, "bullets")
                    of "3": endDialogue(g, mLOCATION)
                    of "4":
                        if quest_active:
                            echo getKey(g, "loc__evros_merchant_prch")
                            addItemToInventory(g.player, "parchment")
                            addVariable(g.player, MERCHANT_ASKED)
                            waitForPlayer()
                    else: return

            else: # bullet buying submenu
                echo getKey(g, "loc__evros_merchant_bull")
                echo getOptionKey(g, "loc__evros_merchant_bubu", 1)
                echo getOptionKey(g, "loc__evros_merchant_buno", 2)
                let prompt = readLine(stdin)
                case prompt:
                    of "1":
                        if buy(g.player, BULLET, 10, 10):
                            echo getKey(g, "loc__evros_merchant_busu")
                            waitForPlayer()
                        else:
                            printMessages(g) # says you don't have enough money
                            waitForPlayer()
                        removeDialogueVariable(g.player, "bullets")
                    of "2": removeDialogueVariable(g.player, "bullets")
                    else: return

        of HERBALIST:
            echo getKey(g, "loc__evros_herbalist")
            echo getOptionKey(g, "loc__evros_herbalist_qu1", 1)
            echo getOptionKey(g, "loc__evros_herbalist_qu2", 2)
            echo getOptionKey(g, "loc__evros_herbalist_qu3", 3)
            if not checkVariable(g.player, HERBALIST_ASKED):
                echo getOptionKey(g, "loc__evros_herbalist_qu4", 4)
            elif hasItem(g.player, "hyerbitus"): # works only if variable exists
                echo getOptionKey(g, "loc__evros_herbalist_hrb", 4)
            let prompt = readLine(stdin)
            case prompt:
                of "1": shop(g, HERBALIST)
                of "2":
                    echo getKey(g, "loc__evros_herbalist_wrk")
                    waitForPlayer()
                    alchemy(g)
                of "3": endDialogue(g, mLOCATION)
                of "4":
                    if not checkVariable(g.player, HERBALIST_ASKED):
                        echo getKey(g, "loc__evros_herbalist_qa4")
                        addVariable(g.player, HERBALIST_ASKED)
                        waitForPlayer()
                    elif hasItem(g.player, "hyerbitus"): # works only if variable exists
                        echo getKey(g, "loc__evros_herbalist_h2b")
                        while hasItem(g.player, "hyerbitus"):
                            discard removeItemFromInventory(g.player, "hyerbitus")
                            g.player.money += 10
                        waitForPlayer()
                else: return

        of FARMER:
            if not isQuestActive(g.player, WORK_ON_A_FARM): # w/o quest
                if "work" notin getDialogueVariables(g.player):
                    echo getKey(g, "loc__fields_farmer")
                    if not isQuestFinished(g.player, WORK_ON_A_FARM): # if it's meant to be repicked, change it to something different?
                        echo getOptionKey(g, "loc__fields_farmer_ask", 1)
                    echo getOptionKey(g, "game__leave", 2)
                    let prompt = readLine(stdin)
                    case prompt:
                        of "1":
                            if not isQuestFinished(g.player, WORK_ON_A_FARM):
                                addDialogueVariable(g.player, "work")
                        of "2": endDialogue(g, mLOCATION)
                        else: return
                else:
                    echo getKey(g, "loc__fields_farmer_sure")
                    echo getOptionKey(g, "loc__fields_farmer_yes", 1)
                    echo getOptionKey(g, "loc__fields_farmer_no", 2)
                    let prompt = readLine(stdin)
                    case prompt:
                        of "1":
                            echo getKey(g, "loc__fields_farmer_yesa1")
                            discard startQuest(g.player, WORK_ON_A_FARM)
                            addItemToInventory(g.player, "sickle") # added no matter if exists in inventory since it makes more sense, else...
                            echo getKey(g, "loc__fields_farmer_yesa2") # ...we would need variable to keep track if it was given to you or not
                            removeDialogueVariable(g.player, "work")
                            waitForPlayer()
                        of "2": removeDialogueVariable(g.player, "work")
                        else: return
            else:
                if "resign" notin getDialogueVariables(g.player):
                    echo getKey(g, "loc__fields_farmer2")
                    if hasItem(g.player, "wheat"):
                        echo getOptionKey(g, "loc__fields_farmer_work1", 1)
                    echo getOptionKey(g, "loc__fields_farmer_work2", 2)
                    echo getOptionKey(g, "game__leave", 3)
                    let prompt = readLine(stdin)
                    case prompt:
                        of "1":
                            if hasItem(g.player, "wheat"):
                                echo getKey(g, "loc__fields_farmer_give")
                                while hasItem(g.player, "wheat"):
                                    discard removeItemFromInventory(g.player, "wheat")
                                    g.player.money += 9
                                waitForPlayer()
                        of "2": addDialogueVariable(g.player, "resign")
                        of "3": endDialogue(g, mLOCATION)
                        else: return
                else: # resign
                    if not hasItem(g.player, "sickle") and "sickle" notin getUsedInventory(g.player):
                        # early return in case you don't have sickle to return to her
                        removeDialogueVariable(g.player, "resign") # prevents infinite loop
                        echo getKey(g, "loc__fields_farmer_rsgn2")
                        waitForPlayer()
                        return
                    # if you have sickle
                    if g.player.weapon == "sickle": # deequipping means removal will work later
                        discard deequip(g.player, FIST)
                    echo getKey(g, "loc__fields_farmer_rsgn")
                    finishQuest(g.player, WORK_ON_A_FARM, 0)
                    discard removeItemFromInventory(g.player, "sickle")
                    waitForPlayer()
                    endDialogue(g, mLOCATION)

import std/strutils
import std/sequtils
import std/tables
import player
import game
import item

const SMITHING_RECIPES* : Table[int, Table[string, seq[tuple[id: string, amount: int]]]] = { # first int is smithing level
    # level 0 is ommited, as it doesn't allow you to smith in OG
    1: {
        "sickle": @[("iron", 1)]
    }.toTable,
    2: {
        "rapier": @[("wood", 1), ("iron", 2)]
    }.toTable,
}.toTable

const REPAIRING_RECIPES* : Table[string, tuple[repaired: string, reqs: seq[tuple[id: string, amount: int]]]] = {
    # should collect all items that have entry in BROKEN_VARIANT table (see `item.nim`) and can be repaired
    # broken variant : (repaired variant, @[resources needed <type, amount>])
    "chainmail_broken" : ("chainmail", @[("iron", 1)]),
}.toTable

const ALCHEMY_RECIPES* : Table[string, seq[string]] = {
    # amount not classified, as alchemy is based only upon singular ingredients and their proper mix
    # ORDER MATTERS - in case list is expanded, put more expensive things higher (first)
    #                 this way check will be able to pick the cheaper things only if more expensive one fail
    # also: remember items here MUST have field .ingr == true, else won't be achievable
    "potion_health_small" : @["water_cooked", "hyerbitus"],
}.toTable

const BOILING_RECIPES* : Table[string, seq[string]] = {
    # similarly to the above, soups should go first, water be at the end
    # TODO: it might be worthy doing different format, so that you can both
    #       boil `water` and `water_cooked`? so like alternative options
    #       -- but table allows us only one recipe for each item --
    # all in all, it makes sense you want to pre-emptively cook water for recipes
    "water_cooked" : @["water"],
}.toTable

const ROASTING_RECIPES* : Table[string, string] = {
    # this one is 1 -> 1 recipe, as I don't imagine it needing multiple items
    "rat_meat" : "rat_meat_roasted",
    "herring"  : "herring_roasted",
}.toTable

proc hasAllResources* (g: Game, reqseq: seq[tuple[id: string, amount: int]]): bool =
    result = true # to be overwritten if fails to gather resources
    var backup: seq[string]
    for reqit in reqseq:
        for i in 1..reqit.amount:
            if hasItem(g.player, reqit.id):
                discard removeItemFromInventory(g.player, reqit.id)
                backup.add(reqit.id) # in case not all items are available
            else:
                result = false
    if result == false:
        for it in backup: # restores all not used items
            addItemToInventory(g.player, it)

proc smithing* (g: Game) =
    var MODE     = 0 # 1 = creating, 2 = repairing
    var sm_items = newTable[string, seq[tuple[id: string, amount: int]]]()
    for lvl in 0..getSmithing(g.player): # gets all available smithing items player can create
        if lvl in SMITHING_RECIPES:
            for it, val in SMITHING_RECIPES[lvl]:
                sm_items[it] = val

    while true:
        clearScreen()
        if MODE == 0: # no mode
            echo "{ " & getKey(g, "game__smith_anvil") & " }"
            echo getOptionKey(g, "game__smith_create", 1)
            echo getOptionKey(g, "game__smith_repair", 2)
            if hasItem(g.player, "wood"):      echo getOptionKey(g, "game__smith_arrow", 3)
            if hasItem(g.player, "gunpowder"): echo getOptionKey(g, "game__smith_bullet", 4)
            echo getOptionKey(g, "game__leave", 5)
            let prompt = readLine(stdin)
            case prompt:
                of "1": MODE = 1
                of "2": MODE = 2
                of "3":
                   if removeItemFromInventory(g.player, "wood"): # this functionally includes hasItem check
                     echo getKey(g, "game__smith_arrtrue")
                     g.player.arrows += 15
                     waitForPlayer()
                of "4":
                   if removeItemFromInventory(g.player, "gunpowder"): # this functionally includes hasItem check
                     echo getKey(g, "game__smith_bulltrue")
                     g.player.ammo += 15
                     waitForPlayer()
                of "5": break # ends smithing
        elif MODE == 1: # creating
            if getSmithing(g.player) == 0:
                echo getKey(g, "game__smith_skilisue")
                waitForPlayer()
                MODE = 0
            else: # skill > 0
                echo DIVIDER
                for it in getInventory(g.player):
                    echo "- " & getKey(g, "item__" & it)
                echo DIVIDER
                var sm_ref : Table[int, string]      # referrer for later
                var ix     = 1                       # index
                for smid, smreq in sm_items.pairs(): # lists items available to smith
                    var req = "- "
                    for riq in smreq:
                        req = req & getKey(g, "item__" & riq.id) & ": " & $riq.amount & " - "
                    echo getOptionKey(g, "item__" & smid, ix) & " | " & req
                    sm_ref[ix] = smid; ix += 1 # saves to referrer, bumps index by one
                let prompt = readLine(stdin)
                try:
                    let p = parseInt(prompt)
                    if p < 1 or p > ix:
                        continue
                    else: # good pick!
                        if hasAllResources(g, sm_items[sm_ref[p]]): # cost seq
                            addItemToInventory(g.player, sm_ref[p]) # item id
                            g.player.sp -= 15                       # tiredness gain
                            echo getKey(g, "game__smith_crafted") & " " & getKey(g, "item__" & sm_ref[p])
                            waitForPlayer()
                        else:
                            echo getKey(g, "game__smith_resissue")
                            waitForPlayer()
                except ValueError: continue # go back
        elif MODE == 2: # repairing
            if getSmithing(g.player) == 0:
                echo getKey(g, "game__smith_skilisue")
                waitForPlayer()
                MODE = 0
            else: # skill > 0
                var refnums : seq[int] # referrer for available items
                for ix, it in getInventory(g.player).pairs():
                    if it in REPAIRING_RECIPES:
                        echo getOptionKey(g, "item__" & it, ix + 1)
                        refnums.add(ix + 1)
                echo DIVIDER
                echo getKey(g, "game__smith_repque")
                let prompt = readLine(stdin)
                if prompt == "": MODE = 0
                try:
                    let p = parseInt(prompt)
                    if p notin refnums: continue
                    else: # correct pick!
                        let broken_it = getInventory(g.player)[p-1] # referrer available after removing
                        if hasAllResources(g, REPAIRING_RECIPES[broken_it].reqs):
                            removeItemFromInventory(g.player, p-1) # removes broken variant
                            # resources needed for repair are removed by `hasAllResources` [!]
                            addItemToInventory(g.player, REPAIRING_RECIPES[broken_it].repaired)
                            g.player.sp -= 10
                            echo getKey(g, "game__smith_repsucc") & " " & getKey(g, "item__" & broken_it)
                        else:
                            echo getKey(g, "game__smith_resissue")
                        waitForPlayer()
                except ValueError: continue

proc alchemy* (g: Game) =
    var used_ingr : seq[string]
    var MODE      = 0 # 0 = default, 1 = adding to pot
    while true:
        clearScreen()
        if MODE == 0:
            if g.tutorial:
                echo getTutorialKey(g, "game__tut_5")
                echo getTutorialKey(g, "game__tut_6")
            echo getKey(g, "game__alchemy")
            echo DIVIDER
            echo getKey(g, "game__alchemy_used")
            for ingr in used_ingr:
                echo "- " & getKey(g, "item__" & ingr)
            echo DIVIDER
            echo getOptionKey(g, "game__alchemy_add", 1)
            echo getOptionKey(g, "game__alchemy_try", 2)
            echo getOptionKey(g, "game__leave", 3)
            let prompt = readLine(stdin)
            case prompt:
                of "1": MODE = 1
                of "2":
                    var resvlt = "" # empty means failure to craft anything
                    for recipe in ALCHEMY_RECIPES.keys:
                        var success = true # will be overwritten if it fails
                        for req_ingr in ALCHEMY_RECIPES[recipe]:
                            if req_ingr notin used_ingr: success = false
                        if success == true: # doesn't get any failed checks
                            addItemToInventory(g.player, recipe) # it's actually item brewed, not recipe lol
                            resvlt = recipe # marks the success
                            break           # ends the process
                    used_ingr = @[]         # resets the pot
                    if resvlt != "": echo getKey(g, "game__alchemy_succ") & " | " & getKey(g, "item__" & resvlt)
                    else:            echo getKey(g, "game__alchemy_fail")
                    waitForPlayer()
                of "3": break
                else: continue

        elif MODE == 1:
            var available : seq[int] # referrer to available items

            echo DIVIDER
            echo getKey(g, "game__alchemy_used")
            for ingr in used_ingr:
                echo "- " & getKey(g, "item__" & ingr)
            echo DIVIDER
            echo getKey(g, "game__alchemy_had")
            for ix, ingr in getInventory(g.player).pairs():
                if ITEMS[ingr].ingr: # if is ingredient
                    echo "- " & getOptionKey(g, "item__" & ingr, ix + 1)
                    available.add(ix + 1)
            echo DIVIDER
            echo getKey(g, "game__alchemy_pick")

            let prompt = readLine(stdin)
            if prompt == "": MODE = 0
            try:
                let p = parseInt(prompt)
                if p notin available: continue
                else: # correct pick!
                    used_ingr.add(getInventory(g.player)[p - 1])
                    removeItemFromInventory(g.player, p - 1)
            except ValueError: continue

proc banking* (g: Game) =
    var MODE = 0 # 1 = deposit money, 2 = withdraw money
    while true:
        clearScreen()
        echo getKey(g, "game__bank")
        echo getKey(g, "game__gui_money") & ": " & $g.player.money
        echo getKey(g, "game__bank_money") & ": " & $g.player.bank
        if MODE == 0: # default
            echo getKey(g, "game__bank_items")
            for it in CHESTS[BANK_CHEST][1]: # [1] = items
                echo "- " & getKey(g, "item__" & it)
            echo DIVIDER
            echo getOptionKey(g, "game__bank_mdeposit", 1)
            echo getOptionKey(g, "game__bank_mwithdraw", 2)
            echo getOptionKey(g, "game__bank_imanage", 3)
            echo getOptionKey(g, "game__bank_exit", 4)
            let prompt = readLine(stdin)
            case prompt:
                of "1": MODE = 1
                of "2": MODE = 2
                of "3": chest(g, CHESTS[BANK_CHEST])
                of "4": break
                else: continue

        elif MODE == 1: # deposit
            echo getKey(g, "game__bank_mdepam")
            let prompt = readLine(stdin)
            if prompt == "": MODE = 0
            try:
                let p = parseInt(prompt)
                if p < 1: continue
                elif p > g.player.money:
                    echo getKey(g, "game__warn_money")
                else:
                    g.player.money -= p
                    g.player.bank  += p
                    echo getKey(g, "game__bank_mdepsucc")
                waitForPlayer()
                MODE = 0
            except ValueError: continue

        elif MODE == 2: # withdraw
            if g.tutorial:
                echo getTutorialKey(g, "game__tut_4")
            echo getKey(g, "game__bank_mwithdam")
            let prompt = readLine(stdin)
            if prompt == "": MODE = 0
            try:
                let p = parseInt(prompt)
                if p < 1: continue
                elif p > g.player.money:
                    echo getKey(g, "game__bank_mwithderr")
                else:
                    g.player.bank  -= p
                    g.player.money += p
                    echo getKey(g, "game__bank_mwithsucc")
                waitForPlayer()
                MODE = 0
            except ValueError: continue

proc cooking* (g: Game, pot: bool) =
    # pot variable decides whether we can roast something
    var MODE = 0 # 1 = roasting, 2 = boiling, 3/4 = adding to the fire/pot
    # empty containers, to be used (and resetted) by respective actions
    var FIRE : string      # single item
    var POT  : seq[string] # seq
    while true:
        # info on stuff that is put on fire/pot
        if FIRE != "":
            echo getKey(g, "game__cooking_fire") & ": " & getKey(g, "item__" & FIRE)
        if len(POT) > 0:
            echo getKey(g, "game__cooking_pot") & ":"
            for it in POT:
                echo "- " & getKey(g, "item__" & it)

        if MODE == 0: # choose option
            clearScreen()
            if g.tutorial:
                echo getTutorialKey(g, "game__tut_9")
            echo getOptionKey(g, "game__cooking_roast", 1)
            if pot:
                echo getOptionKey(g, "game__cooking_boil", 2)
            echo getOptionKey(g, "game__leave", 3)
            let prompt = readLine(stdin)
            case prompt:
                of "1": MODE = 1
                of "2":
                    if pot: MODE = 2
                of "3": break
                else: continue
        elif MODE == 1: # roasting
            if g.tutorial:
                echo getTutorialKey(g, "game__tut_10")
            if FIRE == "": # empty fire
                echo getOptionKey(g, "game__cooking_ritem", 1)
            else:
                echo getOptionKey(g, "game__cooking_rdo", 1)
            echo getOptionKey(g, "game__leave", 2)
            let prompt = readLine(stdin)
            case prompt:
                of "1":
                    if FIRE == "": MODE = 3 # if empty, lets you choose item to put there
                    else: # cook stuff
                        if FIRE in ROASTING_RECIPES: # can be also gated by skill if we make that someday
                            addItemToInventory(g.player, ROASTING_RECIPES[FIRE])
                            echo getKey(g, "game__cooking_rsucc") & ": " & getKey(g, "item__" & ROASTING_RECIPES[FIRE])
                        else:
                            echo getKey(g, "game__cooking_rfail")
                        FIRE = "" # clear the fire
                        waitForPlayer()
                of "2": MODE = 0
                else: continue
        elif MODE == 2: # cooking
            echo getOptionKey(g, "game__cooking_citem", 1)
            if len(POT) > 0:
                echo getOptionKey(g, "game__cooking_cdo", 2)
            echo getOptionKey(g, "game__leave", 3)
            let prompt = readLine(stdin)
            case prompt:
                of "1": MODE = 4
                of "2": # cook stuff
                    if len(POT) > 0:
                        var resvlt = "" # empty means failure to craft anything
                        for recipe in BOILING_RECIPES.keys:
                            var success = true # will be overwritten if it fails
                            for req_ingr in BOILING_RECIPES[recipe]:
                                if req_ingr notin POT: success = false
                            if success == true: # doesn't get any failed checks
                                addItemToInventory(g.player, recipe) # it's actually item cooked, not recipe lol
                                resvlt = recipe # marks the success
                                break           # ends the process
                        POT = @[]         # resets the pot
                        if resvlt != "": echo getKey(g, "game__cooking_csucc") & " | " & getKey(g, "item__" & resvlt)
                        else:            echo getKey(g, "game__cooking_cfail")
                        waitForPlayer()
                of "3": MODE = 0
                else: continue
        elif MODE == 3: # adding to the fire
            echo DIVIDER
            var options = newSeq[int]() # numbers available
            for ix, it in getInventory(g.player).pairs():
                if it in toSeq(ROASTING_RECIPES.keys): # filter
                    echo "- " & getOptionKey(g, "item__" & it, ix + 1)
                    add(options, ix + 1)
            echo DIVIDER
            echo getKey(g, "game__cooking_ritemb")

            let prompt = readLine(stdin)
            if prompt == "": MODE = 1
            try:
                let p = parseInt(prompt)
                if p notin options: continue
                else: # correct pick!
                    FIRE = getInventory(g.player)[p - 1]
                    removeItemFromInventory(g.player, p - 1)
                    MODE = 1 # automatically goes back, as you can only add one item to fire
            except ValueError: continue
        elif MODE == 4: # adding to the pot
            echo DIVIDER
            var options = newSeq[int]() # numbers available
            for ix, it in getInventory(g.player).pairs():
                if ITEMS[it].boil == true:
                    echo "- " & getOptionKey(g, "item__" & it, ix + 1)
                    add(options, ix + 1)
            echo DIVIDER
            echo getKey(g, "game__cooking_citemb")

            let prompt = readLine(stdin)
            if prompt == "": MODE = 2
            try:
                let p = parseInt(prompt)
                if p notin options: continue
                else: # correct pick!
                    POT.add(getInventory(g.player)[p - 1])
                    removeItemFromInventory(g.player, p - 1)
            except ValueError: continue

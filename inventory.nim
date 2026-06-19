import std/strutils
import std/tables
import player
import game
import item

proc info (g: Game) =
    let inventory = getInventory(g.player)
    var avail_nb  = newSeq[int]() # allows for type checks (no books)
    while true:
        clearScreen()
        echo "{ " & getKey(g, "game__gui_inventory") & " }"
        for ix, it in inventory.pairs():
            if not isBookType(it):
                echo getOptionKey(g, "item__" & it, ix + 1)
                avail_nb.add(ix + 1)
        echo getKey(g, "game__gui_inv_infodsc")
        let prompt = readLine(stdin)
        if prompt == "": break
        try:
            let p = parseInt(prompt)
            if p notin avail_nb: continue
            else: # correct pick!
                let itobj = ITEMS[inventory[p-1]]
                echo "{ " & getKey(g, "item__" & inventory[p-1]) & " }"
                # books, worn items and countables are not included
                echo getKey(g, "item__" & inventory[p-1] & "_descr")
                # statistics - inherited from ITEM objects, unlike in OG, so it is always correct
                if itobj.attack  > 0: echo getKey(g, "game__gui_attack")  & ": " & $itobj.attack
                if itobj.defence > 0: echo getKey(g, "game__gui_defence") & ": " & $itobj.defence
                echo getKey(g, "game__gui_weight") & ": " & $itobj.weight
                waitForPlayer()
        except ValueError: continue

proc read (g: Game) =
    let inventory = getInventory(g.player)
    var avail_nb  = newSeq[int]() # allows for type checks (only books)
    while true:
        clearScreen()
        echo "{ " & getKey(g, "game__gui_inventory") & " }"
        for ix, it in inventory.pairs():
            if isBookType(it):
                echo getOptionKey(g, "item__" & it, ix + 1)
                avail_nb.add(ix + 1)
        echo getKey(g, "game__gui_inv_readdsc")
        let prompt = readLine(stdin)
        if prompt == "": break
        try:
            let p = parseInt(prompt)
            if p notin avail_nb: continue
            else: # correct pick!
                echo "{ " & getKey(g, "item__" & inventory[p-1]) & " }"
                echo getKey(g, "item__" & inventory[p-1] & "_read")
                waitForPlayer()
        except ValueError: continue

proc use (g: Game) =
    let PROHIB_CT = [NOT_CONSUMABLE, BATTLE] # gatekeeps battle too
    let inventory = getInventory(g.player)
    var allowed   = newSeq[int]() # allows for type checks later
    while true:
        clearScreen()
        echo "{ " & getKey(g, "game__gui_inventory") & " }"
        for ix, it in inventory.pairs():
            if ITEMS[it].use notin PROHIB_CT:
                echo getOptionKey(g, "item__" & it, ix + 1)
                allowed.add(ix + 1)
        echo getKey(g, "game__gui_inv_use2")
        let prompt = readLine(stdin)
        if prompt == "": break
        try:
            let p = parseInt(prompt)
            if p notin allowed: continue
            else:
                discard use(g.player, p-1)
                printMessages(g)
                waitForPlayer()
        except ValueError: continue

proc equip (g: Game) =
    var equippable : seq[int] # will store valid choices
    while true:
        let inventory = getInventory(g.player) # in loop because it needs to be updated
        clearScreen()
        echo "{ " & getKey(g, "game__gui_inventory") & " }"
        for ix, it in inventory.pairs():
            if ITEMS[it].wearable != NOT_WEARABLE or ITEMS[it].weapon != NOT_WEAPON:
                echo getOptionKey(g, "item__" & it, ix + 1)
                equippable.add(ix + 1)
        if len(equippable) == 0: # nothing to equip
            echo getKey(g, "game__gui_inv_usedno")
            waitForPlayer()
            break
        echo getKey(g, "game__gui_inv_useds")
        let prompt = readLine(stdin)
        if prompt == "": break
        try:
            let p = parseInt(prompt)
            if p notin equippable: continue
            else:
                let iid = inventory[p-1]       # keeps ID for later reference since `equip` removes the item
                let res = equip(g.player, p-1) # `equippable` check covers type, but can still yield false if slot is used
                if res == true:
                    echo getKey(g, "game__gui_inv_used") & ": " & getKey(g, "item__" & iid)
                else: # if slot used
                    echo getKey(g, "game__gui_inv_usedfl")
                waitForPlayer()
        except ValueError: continue

proc deequip (g: Game) =
    while true:
        clearScreen()
        echo "{ " & getKey(g, "game__gui_used_items") & " }"
        if g.player.armour.chest != "":
            echo getOptionKey(g, "item__" & g.player.armour.chest, 1)
        if g.player.weapon != "":
            echo getOptionKey(g, "item__" & g.player.weapon , 2)
        if g.player.weapon == "" and g.player.armour.chest == "": # nothing to deequip
            echo getKey(g, "game__gui_inv_useofno")
            waitForPlayer()
            break
        echo getKey(g, "game__gui_inv_useofds")
        let prompt = readLine(stdin)
        case prompt:
            of "1":
                if g.player.armour.chest != "": # if we add more armour variants we need to adjust this, blah blah blah
                    echo getKey(g, "game__gui_inv_useoffd") & ": " & getKey(g, "item__" & g.player.armour.chest)
                    discard deequip(g.player, aCHEST)
            of "2":
                if g.player.weapon != "":
                    echo getKey(g, "game__gui_inv_useoffd") & ": " & getKey(g, "item__" & g.player.weapon)
                    discard deequip(g.player, FIST) # doesn't matter what type tbh, so FIST is good as anything else
            of "": break
            else: continue
        waitForPlayer()

proc throw (g: Game) =
    let inventory = getInventory(g.player)
    while true:
        clearScreen()
        echo "{ " & getKey(g, "game__gui_inventory") & " }"
        for ix, it in inventory.pairs():
            echo getOptionKey(g, "item__" & it, ix + 1)
        echo getKey(g, "game__gui_inv_throwds")
        let prompt = readLine(stdin)
        if prompt == "": break
        try:
            let p = parseInt(prompt)
            if p < 1 or p > len(inventory): continue
            else: # correct pick!
                echo getKey(g, "game__gui_inv_thrown") & ": " & getKey(g, "item__" & inventory[p-1])
                removeItemFromInventory(g.player, p-1)
                waitForPlayer()
                break # it both saves on resetting `inventory`, but also makes it harder to mistakingly throw something else
        except ValueError: continue

proc characterInventory* (g: Game) =
    echo getKey(g, "game__gui_weight") & ": " & $g.player.weight & "/" & $getMaxWeight(g.player)
    echo getKey(g, "game__gui_money") & ": " & $g.player.money
    echo getKey(g, "game__lock_lockpicks") & ": " & $g.player.lockpicks
    echo getKey(g, "game__gui_projectiles") & ": " & $g.player.ammo & "/" & $g.player.arrows
    echo getKey(g, "game__gui_attack")  & ": " & $getAttack(g.player)
    echo getKey(g, "game__gui_defence") & ": " & $getDefence(g.player) & " (" & $getArmourHealthPercent(g.player.armour.chest, g.player.armour_hp) & "%)"
    # NOTE -- the above `player.armour.chest` would need to be overhauled if we add more armour types  -----------------^
    echo DIVIDER
    echo "{ " & getKey(g, "game__gui_inventory") & " }"
    for it in getInventory(g.player):
        echo "- " & getKey(g, "item__" & it)
    echo "{ " & getKey(g, "game__gui_used_items") & " }"
    for it in getUsedInventory(g.player):
        echo "- " & getKey(g, "item__" & it)
    echo DIVIDER
    echo getOptionKey(g, "game__gui_inv_info", 1)
    echo getOptionKey(g, "game__gui_inv_read", 2)
    echo getOptionKey(g, "game__gui_inv_use", 3)
    echo getOptionKey(g, "game__gui_inv_usein", 4)
    echo getOptionKey(g, "game__gui_inv_useoff", 5)
    echo getOptionKey(g, "game__gui_inv_throw", 6)
    echo getOptionKey(g, "game__gui_inv_back", 7)
    let prompt = readLine(stdin)
    case prompt:
        of "1": info(g)
        of "2": read(g)
        of "3": use(g)
        of "4": equip(g)
        of "5": deequip(g)
        of "6": throw(g)
        of "7": switchMenu(g, mDEFAULT)
        else: return # loops back

proc fightInventory* (g: Game) =
    # more concise/limited variant of the above, accessible during the fight
    while true:
        echo getKey(g, "game__gui_weight") & ": " & $g.player.weight & "/" & $getMaxWeight(g.player)
        echo getKey(g, "game__gui_projectiles") & ": " & $g.player.ammo & "/" & $g.player.arrows
        echo DIVIDER
        echo getKey(g, "game__gui_health") & ": " & $g.player.hp & " / " & $getMaxHealth(g.player)
        echo getKey(g, "game__gui_mana")   & ": " & $g.player.mp & " / " & $getMaxMana(g.player)
        echo getKey(g, "game__gui_attack")  & ": " & $getAttack(g.player)
        echo getKey(g, "game__gui_defence") & ": " & $getDefence(g.player) & " (" & $getArmourHealthPercent(g.player.armour.chest, g.player.armour_hp) & "%)"
                  # NOTE -- the above `player.armour.chest` ^^^ would need to be overhauled if we add more armour types
        echo DIVIDER
        echo "{ " & getKey(g, "game__gui_inventory") & " }"
        for it in getInventory(g.player):
            echo "- " & getKey(g, "item__" & it)
        echo "{ " & getKey(g, "game__gui_used_items") & " }"
        for it in getUsedInventory(g.player):
            echo "- " & getKey(g, "item__" & it)
        echo DIVIDER
        echo getOptionKey(g, "game__gui_inv_use", 1)
        echo getOptionKey(g, "game__gui_inv_usein", 2)
        echo getOptionKey(g, "game__gui_inv_useoff", 3)
        echo getOptionKey(g, "game__gui_inv_back", 4)
        let prompt = readLine(stdin)
        case prompt:
            of "1": use(g)
            of "2": equip(g)
            of "3": deequip(g)
            of "4": break
            else: continue # loops back

proc specialInventory* (g: Game, att_value: var int) =
    # variant of `fightInventory` for explosives and scrolls
    while true:
        echo getKey(g, "game__gui_health") & ": " & $g.player.hp & " / " & $getMaxHealth(g.player)
        echo getKey(g, "game__gui_mana")   & ": " & $g.player.mp & " / " & $getMaxMana(g.player)
        echo getKey(g, "game__gui_attack")  & ": " & $getAttack(g.player)
        echo getKey(g, "game__gui_defence") & ": " & $getDefence(g.player) & " (" & $getArmourHealthPercent(g.player.armour.chest, g.player.armour_hp) & "%)"
                  # NOTE -- the above `player.armour.chest` ^^^ would need to be overhauled if we add more armour types
        echo DIVIDER
        let inventory     = getInventory(g.player)      # only use for reading
        let id_transcript = newOrderedTable[int, int]() # relative printed index -- inventory index
        var count         = 0
        var used_item     = 0 # default (unreachable) value
        for ix, it in inventory.pairs():
            if ITEMS[it].use == BATTLE or it in ["scroll_heal"]:
                count += 1 # set before so that
                id_transcript[count] = ix
        for ix in id_transcript.keys():
            echo getOptionKey(g, "item__" & inventory[ix], ix)

        if count > 0: # any item is available at all
            echo getKey(g, "game__combat_thruse")
            let prompt = readLine(stdin)
            if prompt == "": break
            else:
              try:
                  used_item = parseInt(prompt)
                  if used_item notin 1..count:
                      continue # loops back?
              except: continue # loops back
        else:
            echo getKey(g, "game__combat_thrnone")
            waitForPlayer()
            break

        # use of the item (check for used_item != 0 doesn't needed, resolved above)
        let inv_index = id_transcript[used_item]
        let item_id   = getInventory(g.player)[inv_index]
        if "scroll_" in item_id: # works for all BATTLE scrolls & UNIQUE ones
            let data = ITEMS[item_id].scroll
            if magicUse(g.player, data.cost, data.hp, data.att, data.msg, att_value):
                removeItemFromInventory(g.player, inv_index)
        elif ITEMS[item_id].use == BATTLE: # all non-scroll items (e.g. dynamite)
            let data = ITEMS[item_id]
            if techUse(g.player, data.attack, att_value):
                removeItemFromInventory(g.player, inv_index)
        else: continue # ???? should not happen???

        for msg in getMessages(g): # these should be read here bc it doesn't happen in battle menu
            echo msg
        break

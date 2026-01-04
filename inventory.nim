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
        except ValueError: continue

proc characterInventory* (g: Game) =
    echo getKey(g, "game__gui_weight") & ": " & $g.player.weight & "/" & $getMaxWeight(g.player)
    echo getKey(g, "game__gui_money") & ": " & $g.player.money
    echo getKey(g, "game__lock_lockpicks") & ": " & $g.player.lockpicks
    echo getKey(g, "game__gui_projectiles") & ": " & $g.player.ammo & "/" & $g.player.arrows
    echo "{ " & getKey(g, "game__gui_inventory") & " }"
    for it in getInventory(g.player):
        echo "- " & getKey(g, "item__" & it)
    echo "{ " & getKey(g, "game__gui_used_items") & " }"
    for it in getUsedInventory(g.player):
        echo "- " & getKey(g, "item__" & it)
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
        of "3": discard; WAITING_FOR_IMPLEMENTATION()
        of "4": discard; WAITING_FOR_IMPLEMENTATION()
        of "5": discard; WAITING_FOR_IMPLEMENTATION()
        of "6": throw(g)
        of "7": switchMenu(g, mDEFAULT)
        else: return # loops back
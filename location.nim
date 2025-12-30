import std/strutils
import std/tables
import player
import game
import item

# apparently used for all locations? and OG had maps for Baedoor City and unknown abandoned island
const LocationMap* = """
    ✺----------------------------------------------✺
    | Λ Λ Λ Λ Λ Λ                      )           |
    | Λ           ░░░░░░░░░░░░░░░░    (      ~~    |
    |Λ  ░░░░░░░░░░░░░░░░░░░  ♖-------♖)            |
    | Λ ░░░░░░░░░░░░░░░░░░░  |  Baedoor ♖)      ~~ |
    |Λ  ░░░░░░░░░░░░░░░░░░░  ♖-------♖⚓)           |
    |Λ  ۩  ░░░░░░░░░░░░░░░░           (      ~~ X  |
    | Λ Λ Λ Λ Λ Λ Λ   Λ ░░░░░░░░░░░░░  )           |
    ✺----------------------------------------------✺
    """.unindent

# TODO: before `processStatistics` is done, run `location` procs or whatever that allows us to prevent normal menu to happen
# or, we make separate proc that is just `processQuestTexts` or something
# just for stuff that is not inherently loc-based but quest-based and should be prioritised/focused on (such as mquest)
# or if it's just mquest, we make it `mainQuest` proc???
# proc locationShip* () =
#     discard

proc ship_SearchDeck* (p: var Player) =
    if p.money < 3:
        addMessage(p, "loc__ship_search_success")
        p.money += 3
    else:
        addMessage(p, "loc__ship_search_fail")

proc ship_lookAround* (p: var Player) =
    addMessage(p, "loc__ship_looked_around")
    addVariable(p, ISLAND_SEEN)

proc island_SearchArea* (p: var Player) =
    addMessage(p, "loc__island_roots")
    addItemToInventory(p, "roots")

proc island_OpenBarrel* (g: Game) =
    echo getKey(g, "loc__island_barrel_open")
    waitForPlayer()
    # p.lockpicks += 1 #????????? was in OG
    chest(g, CHESTS[DESERTED_BARREL])
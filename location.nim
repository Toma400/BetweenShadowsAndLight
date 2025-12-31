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
    |Λ  &  ░░░░░░░░░░░░░░░░           (      ~~ X  |
    | Λ Λ Λ Λ Λ Λ Λ   Λ ░░░░░░░░░░░░░  )           |
    ✺----------------------------------------------✺
    """.unindent
# & = ۩

const LocationDestinations* : Table[Location, seq[tuple[loc: Location, key: string, cost: int, cond: bool, failed: string]]] = {
    # travel destinations - if there's predicates needed for travel (or tiredness counts) make value a seq[tuple<Loc, val1, val2>]
    # - loc    - Location to be travelled to
    # - key    - translation key that will show for this option
    # - cost   - sp cost
    # - cond   - anonymous proc that is checked against, or `true` if location can be reached no matter what
    # - failed - translation key for message if `cond` results with false (can be "" for `cond == true`)
    SHIP            : @[(loc: EVROS,           key: "travel__sh_dummy",     cost:  0, cond: false, failed: "travel__sh_dummyfail")],
    SHIP_DOCKED     : @[],
    DESERTED_ISLAND : @[(loc: DESERTED_HOME,   key: "travel__desi_to_desh", cost:  0, cond: true,  failed: ""),
                        (loc: BAEDOOR,         key: "travel__desi_to_bae",  cost:  0, cond: false, failed: "travel__desi_to_baef"),
                        (loc: DOCKS,           key: "travel__desi_to_dock", cost: 10, cond: true,  failed: "")],
    DESERTED_HOME   : @[(loc: DESERTED_ISLAND, key: "travel__desh_to_desi", cost:  0, cond: true,  failed: "")],
    DOCKS           : @[],
    EVROS           : @[], # todo: IN OG IT ALLOWS TO COME BACK TO DESERTED ISLAND!
    FIELDS          : @[],
    # BAEDOOR # not used here because it's a dummy location
}.toTable

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
    # p.lockpicks += 1 # todo: was in OG for some reason
    chest(g, CHESTS[DESERTED_BARREL])

proc home_ReadBook* (p: Player) =
    addMessage(p, "loc__abhouse_book")

proc home_OpenChest* (g: Game) =
    echo getKey(g, "loc__abhouse_chest")
    waitForPlayer()
    chest(g, CHESTS[SHELTER_CHEST])

proc home_Sleep* (p: Player) =
    addMessage(p, "loc__abhouse_sleep")
    sleep(p)

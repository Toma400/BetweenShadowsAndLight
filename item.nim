import std/strutils
import tables

type
  Chest* = enum
    DESERTED_BARREL
    SHELTER_CHEST
    WAREHOUSE_CHEST
  Item = object
    weight*: int
  SpecialItem* = enum
    COIN = "coin"
    LOCK = "lock"

const ITEMS* = { # ID : object
    # food
    "roots"            : Item(weight: 0), # korzonki
    "rat_meat"         : Item(weight: 0), # szczurze mięso
    "rat_meat_roasted" : Item(weight: 0), # pieczone szczurze mięso
    "sweet_roll"       : Item(weight: 0), # słodka bułka
    "herring"          : Item(weight: 0), # śledź
    "herring_roasted"  : Item(weight: 0), # pieczony śledź
    "beer"             : Item(weight: 0), # piwo
    # utilities
    "water"        : Item(weight: 0), # woda
    "water_cooked" : Item(weight: 0), # podgrzana woda
    "iron"         : Item(weight: 2), # żelazo
    "wood"         : Item(weight: 1), # drewno
    "wheat"        : Item(weight: 0), # pszenica
    "parchment"    : Item(weight: 0), # pergamin
    "silk"         : Item(weight: 2), # jedwab
    # weapons
    "rusty_knife"     : Item(weight: 1), # zardzewiały nóż
    "sickle"          : Item(weight: 1), # sierp
    "rapier"          : Item(weight: 1), # rapier
    "bandit_revolver" : Item(weight: 1), # bandycki rewolwer
    "decor_shotgun"   : Item(weight: 2), # zdobiona strzelba
    "dynamite"        : Item(weight: 0), # dynamit
    # armors
    "chainmail"        : Item(weight: 1), # kolczuga
    "chainmail_broken" : Item(weight: 1), # uszkodzona kolczuga
    # scrolls
    "scroll_heal"     : Item(weight: 0), # zwój uzdrowienia
    "scroll_fireball" : Item(weight: 0), # zwój ognistej kuli
    # magic weapons
    "staff_fire"  : Item(weight: 1), # kostur ognia
    "staff_earth" : Item(weight: 1), # kostur ziemi
    "staff_conn"  : Item(weight: 1), # kostur połączenia
    "staff_chaos" : Item(weight: 1), # kostur chaosu
    # alchemy
    "hyerbitus_flower"    : Item(weight: 0), # kwiat hyerbitusa
    "antidote"            : Item(weight: 0), # odtrutka
    "potion_health_small" : Item(weight: 0), # mała mikstura zdrowia
    "potion_mana_small"   : Item(weight: 0), # mała mikstura many
    # other
    "book"     : Item(weight: 0), # gazety, księgi, przepisy | TODO: imo we need to split this into each category, see language files recognising each entry separately
    # specials
    # - money
    # - ammo
    # - arrows
    # - lockpicks
}.toTable

const CHESTS_PREFAB* : Table[Chest, (int, seq[string])] = {
    DESERTED_BARREL: (0, @["4 coins", "15 locks", "sweet_roll", "herring", "herring", "herring"]),
    SHELTER_CHEST:   (0, @["500 coins", "decor_shotgun", "chainmail"]),
    WAREHOUSE_CHEST: (0, @["300 coins", "silk"]),
}.toTable

var CHESTS* = CHESTS_PREFAB # variable version which is editable

proc isSpecialItem* (item_str: string): bool =
    return " " in item_str

proc debundleSpecialItem* (item_str: string): tuple[amount: int, kind: SpecialItem] =
    let spl = item_str.split(" ")
    let itm = if endsWith(spl[1], "s"): spl[1][0..len(spl[1])-2] else: spl[1] # cut 's' if exists
    result.amount = parseInt(spl[0])
    result.kind   = parseEnum[SpecialItem](itm)
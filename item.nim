import std/strutils
import tables

type
  Chest* = enum
    DESERTED_BARREL
    SHELTER_CHEST
    WAREHOUSE_CHEST
    BANK_CHEST
  Item = object
    weight*  : int
    attack*  : int  # defaults to 0, meaning no weapon type
    defence* : int  # defaults to 0, meaning no armour type (or broken armour)
    ingr*    : bool # if can be used on alchemy table
    #value*  : int  # default value! traders set this separately
  SpecialItem* = enum
    COIN   = "coin"
    LOCK   = "lock"
    BULLET = "bullet"
    ARROW  = "arrow"

proc isBookType* (item_str: string): bool = return "book" in item_str or "newspaper" in item_str or "recipe" in item_str
#proc isWearable* (item_str: string): bool = ITEMS[item_str] # to filter items that can be worn?
# similar to activators?
# similar to readable things? (separate type?)

const ITEMS* = { # ID : object
    # specials
    # - money
    # - bullets
    # - arrows
    # - lockpicks
    # food
    "roots"            : Item(weight: 0, ingr: true), # korzonki
    "rat_meat"         : Item(weight: 0, ingr: true), # szczurze mięso
    "rat_meat_roasted" : Item(weight: 0),             # pieczone szczurze mięso
    "sweet_roll"       : Item(weight: 0),             # słodka bułka
    "herring"          : Item(weight: 0, ingr: true), # śledź
    "herring_roasted"  : Item(weight: 0),             # pieczony śledź
    "beer"             : Item(weight: 0),             # piwo
    # utilities
    "water"        : Item(weight: 0, ingr: true), # woda
    "water_cooked" : Item(weight: 0, ingr: true), # podgrzana woda
    "iron"         : Item(weight: 2),             # żelazo
    "wood"         : Item(weight: 1),             # drewno
    "wheat"        : Item(weight: 0, ingr: true), # pszenica
    "parchment"    : Item(weight: 0),             # pergamin
    "gunpowder"    : Item(weight: 0, ingr: true), # proch
    "silk"         : Item(weight: 2),             # jedwab
    # weapons
    "rusty_knife"     : Item(weight: 1, attack:  4), # zardzewiały nóż
    "sickle"          : Item(weight: 1, attack:  4), # sierp
    "rapier"          : Item(weight: 1, attack: 10), # rapier
    "bandit_revolver" : Item(weight: 1, attack:  5), # bandycki rewolwer | pwr_magic > 10 disables it
    "decor_shotgun"   : Item(weight: 2, attack: 22), # zdobiona strzelba | pwr_magic > 10 disables it
    "dynamite"        : Item(weight: 0, attack: 25), # dynamit           | pwr_magic > 10 disables it // can only use it during fight?
    # armours
    "chainmail"        : Item(weight: 1, defence: 6), # kolczuga
    "chainmail_broken" : Item(weight: 1, defence: 0), # uszkodzona kolczuga
    # scrolls
    "scroll_heal"     : Item(weight: 0), # zwój uzdrowienia   | MP-10, HP+??? // prob usable whenever, but including fight?
    "scroll_fireball" : Item(weight: 0), # zwój ognistej kuli | A=18, MP-32 // I can guess also only usable in fight
    # magic weapons
    "staff_fire"  : Item(weight: 1), # kostur ognia
    "staff_earth" : Item(weight: 1), # kostur ziemi
    "staff_conn"  : Item(weight: 1), # kostur połączenia
    "staff_chaos" : Item(weight: 1), # kostur chaosu
    # alchemy
    "hyerbitus"           : Item(weight: 0, ingr: true), # kwiat hyerbitusa
    "antidote"            : Item(weight: 0),             # odtrutka
    "potion_health_small" : Item(weight: 0),             # mała mikstura zdrowia
    "potion_mana_small"   : Item(weight: 0),             # mała mikstura many
    # readables
    "newspaper"            : Item(weight: 0),
    "recipe_health_potion" : Item(weight: 0),
    "book"                 : Item(weight: 0),
}.toTable

# before you add new chest here, add one in enum above; for most use cases, use `CHESTS` instead of prefab, prefab is const referrer only [!]
const CHESTS_PREFAB* : Table[Chest, (int, seq[string])] = {
    DESERTED_BARREL: (0, @["4 coins", "15 locks", "sweet_roll", "herring", "herring", "herring"]),
    SHELTER_CHEST:   (0, @["500 coins", "decor_shotgun", "chainmail"]),
    WAREHOUSE_CHEST: (0, @["300 coins", "silk"]),
    BANK_CHEST:      (0, @[]),
}.toTable

var CHESTS* = CHESTS_PREFAB # variable version which is editable

proc isSpecialItem* (item_str: string): bool =
    return " " in item_str

proc debundleSpecialItem* (item_str: string): tuple[amount: int, kind: SpecialItem] =
    let spl = item_str.split(" ")
    let itm = if endsWith(spl[1], "s"): spl[1][0..len(spl[1])-2] else: spl[1] # cut 's' if exists
    result.amount = parseInt(spl[0])
    result.kind   = parseEnum[SpecialItem](itm)
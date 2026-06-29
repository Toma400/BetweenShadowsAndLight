import std/strutils
import tables

type
  Chest* = enum
    DESERTED_BARREL
    SHELTER_CHEST
    WAREHOUSE_CHEST
    BANK_CHEST
  WeaponType* = enum
    NOT_WEAPON   # first type so it's set as default
    FIST         #              | attack_error == 1 in OG
    CLOSE_COMBAT #              | eq_style == 1 in OG
    RANGED       # uses arrows  | eq_style == 2 in OG
    FIREARM      # uses bullets | eq_style == 3 in OG
    MAGIC        # staffs       | eq_style == 4 in OG
  WearableType* = enum
    NOT_WEARABLE # first type so it's set as default
    # armours
    aCHEST
  ConsumableType* = enum
    NOT_CONSUMABLE # first type so it's set as default
    REG_HEAL
    REG_MANA
    POISON
    BATTLE         # should only be used in battle, skipped during normal inventory calls
    UNIQUE         # either unique effect, or specific conditions - needs to be manually added in `player.nim/use` proc [!]
  Item = object
    weight*  : int
    attack*  : int        # defaults to 0, meaning no weapon type
    defence* : int        # defaults to 0, meaning no armour type (or broken armour)
    ingr*    : bool       # if can be used on alchemy table
    boil*    : bool       # if can be boiled
    health*  : int        # used by WearableType
    use_val* : int        # used by ConsumableType
    use_str* : string     # additional string printed after use (keep empty if not needed)
    # item types -- if NOT_WEAPON && NOT_WEARABLE, it can't be put on player
    weapon*   : WeaponType
    wearable* : WearableType
    # if NOT_CONSUMABLE, it can't be used by player
    use*      : ConsumableType
    #value*  : int  # default value! traders set this separately
    scroll*   : tuple[cost, hp, att: int, msg: string]
  SpecialItem* = enum
    COIN   = "coin"
    LOCK   = "lock"
    BULLET = "bullet"
    ARROW  = "arrow"

proc isBookType* (item_str: string): bool = return "book" in item_str or "newspaper" in item_str or "recipe" in item_str
#proc isWearable* (item_str: string): bool = ITEMS[item_str] # to filter items that can be worn?
# similar to activators?
# similar to readable things? (separate type?)

# const used for spellcasting
const STAFFS* = {
    "staff_fire": {
        "fireball":    (mana_cost: 20, attack: 15, heal: 0,  self_dmg: 0)
    }.toTable,
    "staff_earth": {
        "thorns":      (mana_cost:  9, attack: 8,  heal: 0,  self_dmg: 0)
    }.toTable,
    "staff_conn": {
        "small_heal":  (mana_cost: 10, attack: 0,  heal: 20, self_dmg: 0)
    }.toTable,
    "staff_chaos": {
        "soul_devour": (mana_cost: 30, attack: 40, heal: 0,  self_dmg: 25)
    }.toTable,
}.toTable

const ITEMS* = { # ID : object
    # --- SPECIAL ---
    # - money      | countable, use `specialItem` to work with it
    # - bullets    | countable, use `specialItem` to work with it
    # - arrows     | countable, use `specialItem` to work with it
    # - lockpicks  | countable, use `specialItem` to work with it
    "fists"            : Item(weight: 0, attack:  2, weapon:     FIST), # used if `weapon` field of Player is empty
    "body"             : Item(weight: 0, defence: 0, wearable: aCHEST), # used if `armour` field of Player is empty
    # --- FOOD ---
    "roots"            : Item(weight: 0, ingr: true, use: UNIQUE),                # korzonki
    "rat_meat"         : Item(weight: 0, ingr: true, use: UNIQUE),                # szczurze mięso
    "rat_meat_roasted" : Item(weight: 0,             use: REG_HEAL, use_val: 20), # pieczone szczurze mięso
    "sweet_roll"       : Item(weight: 0,             use: REG_HEAL, use_val:  5), # słodka bułka
    "herring"          : Item(weight: 0, ingr: true, use: REG_HEAL, use_val:  7), # śledź
    "herring_roasted"  : Item(weight: 0,             use: REG_HEAL, use_val: 15), # pieczony śledź
    "beer"             : Item(weight: 0,             use: UNIQUE),                # piwo
    # --- UTILITIES ---
    "water"        : Item(weight: 0, ingr: true, boil: true), # woda
    "water_cooked" : Item(weight: 0, ingr: true),             # podgrzana woda
    "iron"         : Item(weight: 2),                         # żelazo
    "wood"         : Item(weight: 1),                         # drewno
    "wheat"        : Item(weight: 0, ingr: true),             # pszenica
    "parchment"    : Item(weight: 0),                         # pergamin
    "gunpowder"    : Item(weight: 0, ingr: true),             # proch
    "silk"         : Item(weight: 2),                         # jedwab
    # --- WEAPONS ---
    "rusty_knife"     : Item(weight: 1, attack:  4, weapon: CLOSE_COMBAT), # zardzewiały nóż
    "sickle"          : Item(weight: 1, attack:  4, weapon: CLOSE_COMBAT), # sierp
    "rapier"          : Item(weight: 1, attack: 10, weapon: CLOSE_COMBAT), # rapier
    "bandit_revolver" : Item(weight: 1, attack:  5, weapon: FIREARM),      # bandycki rewolwer | pwr_magic > 10 disables it
    "decor_shotgun"   : Item(weight: 2, attack: 22, weapon: FIREARM),      # zdobiona strzelba | pwr_magic > 10 disables it
    "dynamite"        : Item(weight: 0, attack: 25, use: BATTLE),          # dynamit           | pwr_magic > 10 disables it // can only use it during fight?
    # --- ARMOURS ---
    # broken variants should not be WearableType and be (def:0/hp:0)
    "chainmail"        : Item(weight: 1, defence: 6, health: 50, wearable: aCHEST), # kolczuga
    "chainmail_broken" : Item(weight: 1, defence: 0, health:  0),                   # uszkodzona kolczuga
    # --- SCROLLS ---
    "scroll_heal"     : Item(weight: 0, scroll: (10, 20,  0, "item__generic_heal"), use: UNIQUE), # zwój uzdrowienia   // prob usable whenever, but including fight?
    "scroll_fireball" : Item(weight: 0, scroll: (32,  0, 18, "item__fireball_use"), use: BATTLE), # zwój ognistej kuli // I can guess also only usable in fight
    # --- MAGIC WEAPONS ---
    # new ones need to be added to -STAFFS- const to be used correctly; also add implementation to `battle.spell` proc's switch
    "staff_fire"  : Item(weight: 1, weapon: MAGIC), # kostur ognia
    "staff_earth" : Item(weight: 1, weapon: MAGIC), # kostur ziemi
    "staff_conn"  : Item(weight: 1, weapon: MAGIC), # kostur połączenia
    "staff_chaos" : Item(weight: 1, weapon: MAGIC), # kostur chaosu
    # --- ALCHEMY ---
    "hyerbitus"           : Item(weight: 0, ingr: true, use: POISON,   use_val:  1, use_str: "item__hyerbitus_use"), # kwiat hyerbitusa
    "antidote"            : Item(weight: 0,             use: POISON,   use_val:  0), # | 0 resets poisoning fully    # odtrutka
    "potion_health_small" : Item(weight: 0,             use: REG_HEAL, use_val: 25),                                 # mała mikstura zdrowia
    "potion_mana_small"   : Item(weight: 0,             use: REG_MANA, use_val: 25),                                 # mała mikstura many
    # --- READABLES ---
    "newspaper"            : Item(weight: 0),
    "atg_recommendation"   : Item(weight: 0),
    "recipe_health_potion" : Item(weight: 0),
    "book"                 : Item(weight: 0), # TODO: description is empty, meaning it's more of placeholder
}.toTable

const BROKEN_VARIANT* = {
    # if entry is meant to be repairable, visit `mechanics.nim` REPAIRING_RECIPES table
    "chainmail" : "chainmail_broken"
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

proc getArmourHealthPercent* (item: string, current_health: int): int =
    if item == "" or ITEMS[item].health == 0: return 0 # catches division by 0
    return int(current_health/ITEMS[item].health) * 100

proc getArmourHealthPercent* (item: Item, current_health: int): int =
    if item.health == 0: return 0 # catches division by 0
    return int(current_health/item.health) * 100

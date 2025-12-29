import tables

type
  Item* = object

const ITEMS = { # ID : object
    # food
    "roots"            : Item(), # korzonki
    "rat_meat"         : Item(), # szczurze mięso
    "rat_meat_roasted" : Item(), # pieczone szczurze mięso
    "sweet_roll"       : Item(), # słodka bułka
    "herring"          : Item(), # śledź
    "herring_roasted"  : Item(), # pieczony śledź
    "beer"             : Item(), # piwo
    # utilities
    "water"        : Item(), # woda
    "water_cooked" : Item(), # podgrzana woda
    "iron"         : Item(), # żelazo
    "wood"         : Item(), # drewno
    "wheat"        : Item(), # pszenica
    "parchment"    : Item(), # pergamin
    "silk"         : Item(), # jedwab
    # weapons
    "rusty_knife"     : Item(), # zardzewiały nóż
    "sickle"          : Item(), # sierp
    "rapier"          : Item(), # rapier
    "bandit_revolver" : Item(), # bandycki rewolwer
    "decor_shotgun"   : Item(), # zdobiona strzelba
    "dynamite"        : Item(), # dynamit
    # armors
    "chainmail"        : Item(), # kolczuga
    "chainmail_broken" : Item(), # uszkodzona kolczuga
    # scrolls
    "scroll_heal"     : Item(), # zwój uzdrowienia
    "scroll_fireball" : Item(), # zwój ognistej kuli
    # magic weapons
    "staff_fire"  : Item(), # kostur ognia
    "staff_earth" : Item(), # kostur ziemi
    "staff_conn"  : Item(), # kostur połączenia
    "staff_chaos" : Item(), # kostur chaosu
    # alchemy
    "hyerbitus_flower"    : Item(), # kwiat hyerbitusa
    "antidote"            : Item(), # odtrutka
    "potion_health_small" : Item(), # mała mikstura zdrowia
    "potion_mana_small"   : Item(), # mała mikstura many
    # other
    "book"     : Item(), # gazety, księgi, przepisy
    # specials
    # - money
    # - ammo
    # - arrows
    # - lockpicks
}.toTable
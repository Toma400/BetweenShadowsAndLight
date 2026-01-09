import std/strformat
import std/strutils
import std/tables
import std/random
import item

randomize()

type
  Gender* = enum
    MALE
    FEMALE
    NONBINARY
    VOIDG    # used for initial
  Race* = enum
    HUMAN
    VINDEAN
    ETT #???
    PAHTRI
    VOITRI
    ORMATH
    VOIDR    # used for initial
  Class* = enum
    UNDEFINED
    WARRIOR
    GUNSLINGER
    MAGE
    MERCHANT
    ASSASSIN
    ENGINEER
    OUTLANDER
    NECROMANT
    HEALER
    SHAMAN
    VOIDC
  Attributes* = object
    strength     : int
    dexterity    : int
    intelligence : int
    endurance    : int
    charisma     : int
  Skills* = object
    swords        : int
    bows          : int
    guns          : int
    spellcasting  : int
    connection    : int
    trade         : int
    repair        : int
    healing       : int
    lockpicking   : int
    smithing      : int
    herbalism     : int
    vehicle_drive : int
    trapspotting  : int
    survival      : int
    sneaking      : int
  Timer* = enum # remember to add timer count value in hash below [!]
    HYERBITUS_GROWTH
    WHEAT_GROWTH
    # todo: warehouse/night
  Variable* = enum # variables used for checks
    ISLAND_SEEN      # | allows for bringing island topic when talking to sailor
    SAM_KNOWS_YOU    # | used for just silly acknowledging you are known to Sam
    KNIFE_BOUGHT     # | used to disable "Talk To Cook" quest if we purchase knife
    TAVERN_KEY       # | indicates whether you can sleep in tavern or not
    MERCHANT_ASKED   # | to indicate merchant giving you parchment (so that you can't cheese it)
    HERBALIST_ASKED  # | to indicate dialogue passing once
  NPC* = enum # npcs you can dialogue with
    CAPTAIN_DOCKED
    CAPTAIN
    SAILOR
    COOK
    SAILOR_DOCKS
    LE_VELGA
    TAVERN_BARMAN
    MAGICIAN
    SMITH
    PAPERBOY
    MERCHANT
    HERBALIST
    FARMER
    DUMMY   # used to indicate default state (no dialogue)
  Quest* = enum # strings are language keys  | xp gain
    TALK_TO_COOK     = "quest__cook"       # | 0 xp (partial quest)
    BRING_SWEET_ROLL = "quest__sweet_roll" # | 8 xp
    GET_PARCHMENT    = "quest__parchment"  # | 5 xp (0 in OG)
    WORK_ON_A_FARM   = "quest__farm"       # | circular (work)
    # non-listed quasi-quest: delivery for the herbalist (gives 0 xp)
  Player* = ref object
    name   : string
    gender : Gender
    race   : Race
    class  : Class
    attrs  : Attributes
    skills : Skills
    msg    : seq[string]   # seq of keys, printed by Game object
    vars   : seq[Variable]
    # other values | max values are editable by procs for explicitness
    level  : int
    hp*    : int # health
    hp_max : int
    mp*    : int # mana
    mp_max : int
    sp*    : int # tiredness
    sp_max : int
    xp     : int # experience
    weight*    : int
    weight_max : int
    # values used by various actions
    attack  : int
    defence : int
    poison  : int
    # inventory
    # inv_used is distributed into `weapon` and `armour` for better control
    # OG used seq[string] and `eq_style==0`/`eq_style2=0` for checking if weapon/armour slot is empty
    # ...but that's messy as hell
    inv        : seq[string]
    weapon*    : string
    armour*    : tuple[chest: string]
    armour_hp* : int # summary of all `armour` def points -- would need refactoring with more armour types
    # inventory-related
    bank*      : int # bank account balance
    money*     : int
    ammo*      : int
    arrows*    : int
    lockpicks* : int
    # powers
    pwr_magic* : int
    pwr_tech*  : int
    pwr_conn*  : int
    pwr_chaos* : int
    # quest values
    dialogue    : NPC         # the person player talks with
    dial_vars   : seq[string] # variables used during dialogue (for branching) | removed everytime dialogue ends
    main_quest  : int         # main quest progress
    quests      : seq[Quest]  # active quests
    quests_done : seq[Quest]  # finished/failed quests
    # timers
    # table[event, <is_started, counter>] - is_started == true means the counter is set, so it needs to be counted down
    # events that require time to pass start the timer by passing counter that slowly goes down
    timers : Table[Timer, tuple[is_started: bool, counter: int]]
const
  SP_MAX  = 1000 # not fixed value (worth changing for BRPGS 3.x)
  DEF_ATT = 2    # default attack  | I can imagine fists?
  DEF_DEF = 0    # default defence
  TIMER_COUNTS = {
      HYERBITUS_GROWTH : 10,
      WHEAT_GROWTH     :  7,
  }.toTable

# TRADE TABLES
# Entry means `shop` proc enables shopping in particular NPC
# No entry or empty seq means shopping menu will be non-available
# These tables do not list singular purchases available via `buy` [!]
const BUYING_OFFERS* : Table[NPC, seq[tuple[id: string, value: int]]] = {
    TAVERN_BARMAN : @[("beer", 8)],
    MAGICIAN      : @[("scroll_heal", 18), ("scroll_fireball", 20), ("staff_fire", 45), ("staff_earth", 44), ("staff_conn", 35), ("antidote", 15), ("potion_mana_small", 12), ("potion_health_small", 14)],
    SMITH         : @[("chainmail", 50), ("rapier", 30), ("dynamite", 27)],
    MERCHANT      : @[("decor_shotgun", 122), ("potion_health_small", 12), ("antidote", 14), ("scroll_heal", 20), ("water", 9), ("parchment", 6)],
    HERBALIST     : @[("potion_health_small", 12), ("recipe_health_potion", 25)],
}.toTable
const SELLING_OFFERS* : Table[NPC, seq[tuple[id: string, value: int]]] = {
    SMITH    : @[("iron", 10)],
    MERCHANT : @[("bandit_revolver", 11), ("decor_shotgun", 110), ("potion_health_small", 8), ("silk", 100)],
}.toTable
# proc to check existence of particular product in tables above
proc isInOfferTable* (oftable: seq[tuple[id: string, value: int]], item_id: string): bool =
    for it in oftable:
        if it.id == item_id: return true
    return false
# getter of value
proc getValueFromOfferTable* (oftable: seq[tuple[id: string, value: int]], item_id: string): int =
    for it in oftable:
        if it.id == item_id: return it.value

# dictionaries
let getdGender* = {
    "male":      MALE,
    "female":    FEMALE,
    #TODO: v1.2: "nonbinary": NONBINARY
}.toTable
let getdRace* = {
    "human":   HUMAN,
    "ett":     ETT,
    "vindean": VINDEAN,
    "pahtri":  PAHTRI,
    "voitri":  VOITRI,
    "ormath":  ORMATH
}.toOrderedTable
let getdClass* = {
    "undefined":  UNDEFINED,
    "warrior":    WARRIOR,
    "gunslinger": GUNSLINGER,
    "mage":       MAGE,
    "merchant":   MERCHANT,
    "assassin":   ASSASSIN,
    "engineer":   ENGINEER,
    "outlander":  OUTLANDER,
    "necromant":  NECROMANT,
    "healer":     HEALER,
    #"shaman":     SHAMAN
}.toOrderedTable

proc `$`* (p: Player): string =
    result = fmt"""[{p.name}]
    Gender: {$p.gender}
    Race:   {$p.race}
    Class:  {$p.class}
    Attributes:
        Strength     | {p.attrs.strength}
        Dexterity    | {p.attrs.dexterity}
        Intelligence | {p.attrs.intelligence}
        Endurance    | {p.attrs.endurance}
        Charisma     | {p.attrs.charisma}
    Skills:
        Bows          | {p.skills.bows}
        Swords        | {p.skills.swords}
        Guns          | {p.skills.guns}
        Spellcasting  | {p.skills.spellcasting}
        Trade         | {p.skills.trade}
        Repair        | {p.skills.repair}
        Healing       | {p.skills.healing}
        Sneaking      | {p.skills.sneaking}
        Lockpicking   | {p.skills.lockpicking}
        Smithing      | {p.skills.smithing}
        Herbalism     | {p.skills.herbalism}
        Vehicle Drive | {p.skills.vehicle_drive}
        Trapspotting  | {p.skills.trapspotting}
        Survival      | {p.skills.survival}
        Connection    | {p.skills.connection}
    Powers:
        Magic      | {p.pwr_magic}
        Technology | {p.pwr_tech}
        Chaos      | {p.pwr_chaos}
        Connection | {p.pwr_conn}
    """.unindent

proc setGenderModifiers (p: var Player) =
    case p.gender: # gender modifiers
      of MALE:      p.attrs.endurance -= 1
      of FEMALE:    p.attrs.strength  -= 1
      of NONBINARY: p.attrs.dexterity -= 1
      else:         discard

proc setRaceModifiers (p: var Player) =
    case p.race:
      of HUMAN: discard # literally no changes lol
      of VINDEAN:
          p.attrs.endurance += 2
          p.attrs.strength  += 1
          p.attrs.dexterity -= 2
      of ETT:
          p.attrs.strength     += 1
          p.attrs.intelligence += 1
          p.attrs.endurance    += 1
          p.attrs.dexterity    -= 2
          p.pwr_tech  += 5
          p.pwr_magic -= 5
      of PAHTRI:
          p.attrs.dexterity    += 2
          p.attrs.intelligence += 1
          p.attrs.strength     -= 1
          p.attrs.endurance    -= 1
      of VOITRI:
          p.attrs.intelligence += 2
          p.attrs.dexterity    += 1
          p.attrs.strength     -= 1
          p.attrs.endurance    -= 1
          p.pwr_magic += 5
          p.pwr_tech  -= 5
      of ORMATH:
          p.attrs.endurance   += 1
          p.attrs.dexterity   += 1
          p.attrs.strength    -= 2
          p.skills.connection += 1
          p.pwr_conn += 10
      else: discard

proc setClassModifiers (p: var Player) =
    case p.class:
      of UNDEFINED:
          p.attrs.charisma += 1
      of WARRIOR:
          p.attrs.intelligence -= 1
          p.skills.swords      += 1
          p.skills.bows        += 1
          p.skills.guns        -= 1
      of GUNSLINGER:
          p.skills.guns         += 2
          p.skills.spellcasting  = 0
          p.skills.repair       += 1
          p.pwr_tech  += 5
          p.pwr_magic -= 5
      of MAGE:
          p.skills.spellcasting += 2
          p.skills.healing      += 1
          p.skills.guns          = 0
          p.pwr_magic += 5
          p.pwr_tech  -= 5
      of MERCHANT:
          p.attrs.charisma += 1
          p.attrs.strength -= 1
          p.skills.trade    = 3
      of ASSASSIN:
          p.attrs.dexterity   += 2
          p.attrs.strength    -= 1
          p.skills.sneaking   += 1
          p.skills.lockpicking = 1
      of ENGINEER:
          p.skills.repair        += 2
          p.skills.smithing      += 1
          p.skills.vehicle_drive += 1
          p.pwr_tech  += 15
          p.pwr_magic -= 15
      of OUTLANDER:
          p.attrs.charisma      -= 2
          p.skills.repair       += 1
          p.skills.survival     += 1
          p.skills.trapspotting += 1
          p.skills.healing      += 1
      of NECROMANT:
          p.skills.spellcasting = 2
          p.skills.guns         = 0
          p.pwr_chaos += 8
          p.pwr_conn  -= 20
          p.pwr_tech  -= 5
          p.pwr_magic += 5
      of HEALER:
          p.attrs.strength   -= 1
          p.skills.healing   += 2
          p.skills.herbalism += 2
          p.skills.guns      -= 1
          p.pwr_magic += 5
          p.pwr_tech  -= 5
      of SHAMAN:
          p.skills.connection += 2
          p.skills.herbalism  += 1
          p.skills.guns       -= 1
          p.pwr_conn  += 5
          p.pwr_chaos -= 10
      else: discard

# attribute getters/setters
proc getStrength*     (p: Player): int    = return p.attrs.strength
proc setStrength*     (p: Player, v: int) = p.attrs.strength = v
proc getDexterity*    (p: Player): int    = return p.attrs.dexterity
proc setDexterity*    (p: Player, v: int) = p.attrs.dexterity = v
proc getIntelligence* (p: Player): int    = return p.attrs.intelligence
proc setIntelligence* (p: Player, v: int) = p.attrs.intelligence = v
proc getEndurance*    (p: Player): int    = return p.attrs.endurance
proc setEndurance*    (p: Player, v: int) = p.attrs.endurance = v
proc getCharisma*     (p: Player): int    = return p.attrs.charisma
proc setCharisma*     (p: Player, v: int) = p.attrs.charisma = v

# skill getters/setters
proc getSwords* (p: Player): int       = return p.skills.swords
proc getBows* (p: Player): int         = return p.skills.bows
proc getGuns* (p: Player): int         = return p.skills.guns
proc getSpellcasting* (p: Player): int = return p.skills.spellcasting
proc getConnection* (p: Player): int   = return p.skills.connection
proc getTrade* (p: Player): int        = return p.skills.trade
proc getRepair* (p: Player): int       = return p.skills.repair
proc getHealing* (p: Player): int      = return p.skills.healing
proc getLockpicking* (p: Player): int  = return p.skills.lockpicking
proc getSmithing* (p: Player): int     = return p.skills.smithing
proc getHerbalism* (p: Player): int    = return p.skills.herbalism
proc getVehicleDrive* (p: Player): int = return p.skills.vehicle_drive
proc getTrapspotting* (p: Player): int = return p.skills.trapspotting
proc getSurvival* (p: Player): int     = return p.skills.survival
proc getSneaking* (p: Player): int     = return p.skills.sneaking
proc setSwords* (p: Player, v: int)       = p.skills.swords        = v
proc setBows* (p: Player, v: int)         = p.skills.bows          = v
proc setGuns* (p: Player, v: int)         = p.skills.guns          = v
proc setSpellcasting* (p: Player, v: int) = p.skills.spellcasting  = v
proc setConnection* (p: Player, v: int)   = p.skills.connection    = v
proc setTrade* (p: Player, v: int)        = p.skills.trade         = v
proc setRepair* (p: Player, v: int)       = p.skills.repair        = v
proc setHealing* (p: Player, v: int)      = p.skills.healing       = v
proc setLockpicking* (p: Player, v: int)  = p.skills.lockpicking   = v
proc setSmithing* (p: Player, v: int)     = p.skills.smithing      = v
proc setHerbalism* (p: Player, v: int)    = p.skills.herbalism     = v
proc setVehicleDrive* (p: Player, v: int) = p.skills.vehicle_drive = v
proc setTrapspotting* (p: Player, v: int) = p.skills.trapspotting  = v
proc setSurvival* (p: Player, v: int)     = p.skills.survival      = v
proc setSneaking* (p: Player, v: int)     = p.skills.sneaking      = v

proc calculateMaxMana* (p: Player): int =
    # NOT A SETTER
    result = 20 + p.attrs.intelligence * 10 + p.pwr_magic * 10
    if result < 100:
      result = 100

proc calculateMaxHealth* (p: Player): int =
    # NOT A SETTER
    result = 20 + p.attrs.endurance * 10
    if result < 100:
      result = 100

proc calculateMaxWeight* (p: Player): int =
    # NOT A SETTER
    return p.attrs.strength * 3

proc calculateExperienceCap* (p: Player): int =
    # NOT A SETTER | equivalent of `xp_level` variable in OG
    result = p.level * 12
    if result < 100:
      result = 100

proc calculateBankValue* (base: int): int =
    # NOT A SETTER | takes p.bank value
    # no condition like in OG because base=0 will return 0 anyway
    return (int(base/100))*3 + base

proc addMessage* (p: Player, msg_key: string) =
    p.msg.add(msg_key)
proc addVariable* (p: Player, variable: Variable) =
    if variable notin p.vars:
        p.vars.add(variable)
proc addExperience* (p: Player, xp: int) =
    let int_mod = getIntelligence(p)/50 + 1
    p.xp += int(float(xp)*int_mod)

# dialogue variables
proc addDialogueVariable* (p: Player, variable: string) =
    if variable notin p.dial_vars:
        p.dial_vars.add(variable)
proc removeDialogueVariable* (p: Player, variable: string) =
    if variable in p.dial_vars:
        p.dial_vars.delete(find(p.dial_vars, variable))
proc getDialogueVariables* (p: Player): seq[string] =
    return p.dial_vars
proc clearDialogueVariables* (p: Player) =
    p.dial_vars = @[]

# timer
proc setTimer* (p: Player, tim: Timer) =
    p.timers[tim] = (is_started : true,
                     counter    : TIMER_COUNTS[tim]) # sets the timer on value set in const hash

proc isTimerStarted* (p: Player, tim: Timer): bool =
    return p.timers[tim].is_started

proc getTimerCountDownValue* (p: Player, tim: Timer): int =
    return p.timers[tim].counter

proc countDownTimers* (p: Player, val: int = 1) =
    for tim in p.timers.keys():
        if p.timers[tim].is_started:
            p.timers[tim].counter -= val
        if p.timers[tim].counter <= 0: # we should catch it before it gets below, but just in case
            p.timers[tim].is_started = false
            p.timers[tim].counter    = 0     # similarly we set it to 0 just in case

proc resetTimer* (p: Player, tim: Timer) = # ends countdown
    p.timers[tim] = (is_started : false,
                     counter    : 0)

proc processStatistics* (p: Player) =
    # TIREDNESS
    p.sp -= 1 # crazy how little this is
    if p.weight > p.weight_max:
        p.sp -= 50
        addMessage(p, "game__warn_weight")
    if p.sp < 100:
        addMessage(p, "game__warn_tired")
        # kept the original logic below, but used short circuiting way
        if p.sp   <= 0:
            p.hp -= 10 # 2 + 8 in original (hard to tell if intentional or if it meant to be 8)
        elif p.sp < 10:
            p.hp -= 2
    # POISONING
    if p.poison > 0:
        addMessage(p, "game__warn_poison")
        p.hp -= 3 * p.poison # OG does inflict -3 no matter the poisoning strength
    # GLOBAL
    p.bank = calculateBankValue(p.bank)

    # UPDATES
    # max value updates
    p.hp_max     = calculateMaxHealth(p)
    p.mp_max     = calculateMaxMana(p)
    p.sp_max     = SP_MAX
    p.weight_max = calculateMaxWeight(p)
    # limiters
    if p.pwr_magic > 20: p.pwr_magic = 20
    if p.pwr_tech  > 20: p.pwr_tech  = 20
    if p.pwr_conn  > 20: p.pwr_conn  = 20
    if p.pwr_chaos > 20: p.pwr_chaos = 20
    # level up removed from here because circular imports, moved to body

    countDownTimers(p)

    if len(p.msg) > 0:
        addMessage(p, "game__warn_div")

proc newPlayer* (name: string, gender: Gender, race: Race, class: Class): Player =
    new(result)
    result.name   = name
    result.race   = race
    result.class  = class
    result.gender = gender
    result.attrs  = Attributes( # defaults
                               strength     : 8,
                               dexterity    : 8,
                               intelligence : 8,
                               endurance    : 8,
                               charisma     : 8
                               )
    result.skills = Skills( # defaults
                            bows          : 1,
                            swords        : 1,
                            guns          : 1,
                            spellcasting  : 0,
                            trade         : 1,
                            repair        : 0,
                            healing       : 0,
                            lockpicking   : 0,
                            smithing      : 0,
                            herbalism     : 0,
                            vehicle_drive : 0,
                            trapspotting  : 0,
                            survival      : 0,
                            sneaking      : 0,
                            connection    : 0
                           )
    setGenderModifiers(result)
    setRaceModifiers(result)
    setClassModifiers(result)
    # defaults (base stats)
    result.hp_max     = calculateMaxHealth(result)
    result.mp_max     = calculateMaxMana(result)
    result.sp_max     = SP_MAX
    result.weight_max = calculateMaxWeight(result)
    result.defence    = DEF_DEF
    result.attack     = DEF_ATT
    # defaults (inventory stats)
    result.money      = 0
    result.ammo       = 0
    result.arrows     = 0
    result.lockpicks  = 0
    # settings values to their respective maxes/mins
    result.level  = 1
    result.weight = 0
    result.xp     = 0
    result.hp     = result.hp_max
    result.mp     = result.mp_max
    result.sp     = result.sp_max
    # quests
    result.main_quest  = 1   # fist stage started
    result.quests      = @[]
    result.quests_done = @[]
    for tim in Timer.low..Timer.high:
        result.timers[tim] = (false, 0)

# various getters
proc getPlayerName* (p: Player): string = return p.name
proc getLevel*      (p: Player): int    = return p.level
proc getMaxWeight*  (p: Player): int    = return p.weight_max
proc getMaxHealth*  (p: Player): int    = return p.hp_max
proc getMaxMana*    (p: Player): int    = return p.mp_max
proc getGender*     (p: Player): Gender = return p.gender
proc getRace*       (p: Player): Race   = return p.race
proc getClass*      (p: Player): Class  = return p.class
proc getAttack*     (p: Player): int    = return p.attack
proc getDefence*    (p: Player): int    = return p.defence
proc getPoison*     (p: Player): int    = return p.poison
proc getExperience* (p: Player): int    = return p.xp

proc getMainQuestProgress* (p: Player):     int  = return p.main_quest
proc setMainQuestProgress* (p: Player, val: int) = p.main_quest = val

proc getDialogueName* (p: Player):      NPC  = return p.dialogue
proc setDialogueName* (p: Player, name: NPC) = p.dialogue = name

proc getAndClearMessages* (p: Player): seq[string] =
    # SHOULD ONLY BE USED BY -GAME- OBJECT, it's collection of keys, not echoable strings
    result = p.msg
    p.msg = @[] # clears the old one

proc checkVariable* (p: Player, variable: Variable): bool =
    # checks existence of particular variable
    if variable in p.vars:
        return true
    return false

proc removeVariable* (p: Player, variable: Variable) =
    # remover with silent error (no info if we try to remove non-existing var)
    if variable in p.vars:
        p.vars.delete(find(p.vars, variable))

proc sleep* (p: Player) =
    p.hp = p.hp_max
    p.sp = p.sp_max
    p.mp = p.mp_max

    for tim in Timer.low..Timer.high:
        resetTimer(p, tim)

proc isQuestActive*   (p: Player, quest: Quest): bool = return quest in p.quests
proc isQuestFinished* (p: Player, quest: Quest): bool = return quest in p.quests_done
proc getActiveQuests* (p: Player): seq[Quest]         = return p.quests

proc startQuest* (p: Player, quest: Quest, repeatable: bool = false): bool =
    # returns whether quest can be done
    if quest in p.quests_done and repeatable == false: return false
    else:
        p.quests.add(quest)
        return true

proc finishQuest* (p: Player, quest: Quest, xp_gained: int) =
    p.quests.delete(p.quests.find(quest))
    p.quests_done.add(quest)
    addExperience(p, xp_gained)

proc hasItem* (p: Player, item_str: string): bool =
    return item_str in p.inv

proc addItemToInventory* (p: Player, item_str: string) =
    p.inv.add(item_str)
    p.weight += ITEMS[item_str].weight

proc removeItemFromInventory* (p: Player, item_str: string): bool =
    # only checks regular inventory
    if hasItem(p, item_str):
        p.inv.delete(find(p.inv, item_str))
        return true
    return false

proc removeItemFromInventory* (p: Player, item_index: int) =
    p.inv.delete(item_index)

proc use* (p: Player, item_index: int): bool =
    result       = true # to be overwritten
    var consumed = true # to be overwritten if not
    let item_str = p.inv[item_index]
    let item     = ITEMS[item_str]
    case item.use:
        of NOT_CONSUMABLE: return false # should be gated before evoking proc tho
        of BATTLE:         return false # kinda like the above bc has unique use
        of REG_HEAL:
            p.hp += item.use_val
            if p.hp > p.hp_max:    p.hp = p.hp_max
            addMessage(p, "item__generic_heal")
        of REG_MANA:
            p.mp += item.use_val
            if p.mp > p.mp_max:    p.mp = p.mp_max
            addMessage(p, "item__generic_reg")
        of POISON:
            if item.use_val != 0: # poison or leveled antidotes (-n..0..+n)
                p.poison += item.use_val # -1 means weak antidote, 1+ means poison
                if item.use_val > 0: addMessage(p, "item__generic_poi") # poison
                if p.poison >= 0: # only if it actually helped
                    if item.use_val < 0: addMessage(p, "item__generic_ant") # antidote
                else: # if done on healthy player
                    p.poison = 0 # resets so that player can't "get poison resistance" this way
            else: # if POISON set and val is 0, it means resetter (antidote)
                if p.poison > 0: # doesn't make sense for it to work if we are okay
                    p.poison = item.use_val # aka 0
                    addMessage(p, "item__generic_ant") # antidote
        of UNIQUE:
          case item_str:
            of "roots":
                p.hp += 2*getSurvival(p)
                if 2*getSurvival(p) > 10:
                    addMessage(p, "item__generic_heal")
            of "rat_meat":
                if getSurvival(p) == 0:
                    p.poison += 1 # poisoning
                    addMessage(p, "item__generic_poi")
                else:
                    p.hp += 3*getSurvival(p)
                    if 3*getSurvival(p) > 10:
                        addMessage(p, "item__generic_heal")
            of "beer":
                p.hp += 8
                p.sp -= 15
            of "scroll_heal":
                if p.mp < 10:
                    consumed = false
                    addMessage(p, "game__warn_mana")
                elif p.pwr_tech > 10:
                    consumed = false
                    addMessage(p, "game__warn_tech")
                else:
                    p.mp -= 10
                    p.hp += 20
                    addMessage(p, "item__generic_heal")
            of "water":
                p.sp += 15
                p.hp += 3*getSurvival(p)
                if 3*getSurvival(p) > 10:
                    addMessage(p, "item__generic_heal")
            of "water_cooked":
                p.hp += 5 + 3*getSurvival(p)
                if 3*getSurvival(p) > 5: # adjusts to additional 5 pts
                    addMessage(p, "item__generic_heal")
    if consumed:
        if item.use_str != "": addMessage(p, item.use_str)
        removeItemFromInventory(p, item_index)

proc equip* (p: Player, item_index: int): bool =
    result       = true # to be overwritten
    let item_str = p.inv[item_index]
    let item     = ITEMS[item_str]
    if item.weapon != NOT_WEAPON:
        p.weapon = item_str
    elif item.wearable != NOT_WEARABLE:
        case item.wearable: # do not use 'else', it's meant to err with new armour types [!]
          of NOT_WEARABLE: discard # never reached
          of aCHEST: p.armour.chest = item_str; p.armour_hp = item.health; p.defence = item.defence
          # the above would need refactoring if more armour types are to be added
    else: result = false
    if result == true:
        removeItemFromInventory(p, item_index)

proc equip* (p: Player, item_str: string): bool =
    if hasItem(p, item_str):
        return equip(p, find(p.inv, item_str))
    return false

proc deequip* (p: Player, kind: WeaponType): bool =
    # weapon type is whatever, as it just lets Nim know it's weapon-specific proc picked
    result = true
    if p.weapon == "": return false # err
    else:
        addItemToInventory(p, p.weapon)
        p.weapon = "" # resets

proc deequip* (p: Player, kind: WearableType, destroy: bool = false): bool =
    result = true
    case kind:
      of NOT_WEARABLE: return false # err, but should not be reached
      of aCHEST:
          if p.armour.chest == "": return false # err
          else:
              addItemToInventory(p, p.armour.chest)
              # if we add more armour types, this would need to be overhauled
              # we need to keep `= ""` at the end, so `destroy` has reference
              # but then we need checks for p.armour.X so that we only affect
              # part of armour we want
              if destroy:
                  discard removeItemFromInventory(p, p.armour.chest)
                  addItemToInventory(p, BROKEN_VARIANT[p.armour.chest])
              p.armour.chest = "" # for now here, was under case of aCHEST before destroy pushed it down
              p.armour_hp = 0
              p.defence   = 0

proc getInventory* (p: Player): seq[string] =
    return p.inv

proc getUsedInventory* (p: Player): seq[string] =
    for kind, arm_piece in p.armour.fieldPairs():
        if arm_piece != "": result.add(arm_piece)
    if p.weapon       != "": result.add(p.weapon)

proc buy* (p: Player, item_str: string, value: int): bool =
    if value > p.money:
        addMessage(p, "game__warn_money")
        return false
    else:
        p.money -= value
        addItemToInventory(p, item_str)
        return true

proc buy* (p: Player, spitem: SpecialItem, count: int, value: int): bool =
    if value > p.money:
        addMessage(p, "game__warn_money")
        return false
    else:
        p.money -= value
        case spitem:
          of COIN:   p.money     += count # doesn't make sense??? but abstract systems are abstract
          of LOCK:   p.lockpicks += count
          of BULLET: p.ammo      += count
          of ARROW:  p.arrows    += count
        return true

proc sell* (p: Player, item_str: string, value: int): bool =
    if hasItem(p, item_str):
        discard removeItemFromInventory(p, item_str)
        p.money += value
        return true
    addMessage(p, "game__trade_no_item")
    return false

proc crouch* (p: Player, detect_value: int): bool =
    # 'true' indicates successful crouching
    p.sp -= 5
    let chance = getSneaking(p) * int(getDexterity(p)/2) + rand(1..4)
    if chance > detect_value:
        addExperience(p, 10)
        return true
    p.sp -= 20 # additional tiredness inflicted
    return false

proc lock* (p: Player, lockpower: int): bool =
    # 'true' indicate successful lockpicking
    # ---
    # unlike OG, remaster will not loop, so that
    # loop needs to be controlled by caller
    # (similarly with whole feedback on lockpick
    #  amount and decisions)
    while true:
        if p.lockpicks == 0:
            addMessage(p, "game__warn_lockpicks")
            return false # breaks out of loop
        # 'else'
        p.sp -= 5
        let chance = getLockpicking(p) * 5 + rand(1..5)
        if chance >= lockpower:
            addExperience(p, 10)
            addMessage(p, "game__lock_open")
            return true
        else:
            p.lockpicks -= 1
            addMessage(p, "game__lock_fail")
            return false

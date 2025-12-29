import std/strformat
import std/strutils
import std/tables

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
    SAPHTRI
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
  Player* = ref object
    name   : string
    gender : Gender
    race   : Race
    class  : Class
    attrs  : Attributes
    skills : Skills
    msg    : seq[string] # seq of keys, printed by Game object
    # other values | max values are editable by procs for explicitness
    level  : int
    hp*    : int # health
    hp_max : int
    mp*    : int # mana
    mp_max : int
    sp*    : int # tiredness
    sp_max : int
    xp*    : int # experience
    weight*    : int
    weight_max : int
    # values used by various actions
    attack  : int
    defence : int
    # inventory-related
    money     : int
    ammo      : int
    arrows    : int
    lockpicks : int
    # powers
    pwr_magic : int
    pwr_tech  : int
    pwr_conn  : int
    pwr_chaos : int
const
  SP_MAX  = 1000 # not fixed value (worth changing for BRPGS 3.x)
  DEF_ATT = 2    # default attack  | I can imagine fists?
  DEF_DEF = 0    # default defence

# dictionaries
let getdGender* = {
    "male":      MALE,
    "female":    FEMALE,
    "nonbinary": NONBINARY
}.toTable
let getdRace* = {
    "human":   HUMAN,
    "ett":     ETT,
    "vindean": VINDEAN,
    "saphtri": SAPHTRI,
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
      of SAPHTRI:
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

# proc modifyAttributes* (p: var Player, attr: string, val: int): bool =
#     # returns 'false' in case of failing (error)
#     case attr:
#       of "strength":     p.attrs.strength     += val
#       of "charisma":     p.attrs.charisma     += val
#       of "dexterity":    p.attrs.dexterity    += val
#       of "intelligence": p.attrs.intelligence += val
#       of "endurance":    p.attrs.endurance    += val
#       else: return false
#     return true
#
# proc modifySkills* (p: var Player, skill: string, val: int): bool =
#     # returns 'false' in case of failing (error)
#     case skill:
#       of "swords": p.skills.swords += val
#       of "bows":   p.skills.bows   += val
#       of "guns":   p.skills.guns   += val
#       else: return false
#     return true

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

proc processStatistics* (p: Player) =
    # TIREDNESS
    p.sp -= 1 # crazy how little this is
    if p.weight > p.weight_max:
        p.sp -= 50
        p.msg.add("game__warn_weight")
    if p.sp < 100:
        p.msg.add("game__warn_tired")
        # kept the original logic below, but used short circuiting way
        if p.sp   <= 0:
            p.hp -= 10 # 2 + 8 in original (hard to tell if intentional or if it meant to be 8)
        elif p.sp < 10:
            p.hp -= 2

    p.hp_max     = calculateMaxHealth(p)
    p.mp_max     = calculateMaxMana(p)
    p.sp_max     = SP_MAX
    p.weight_max = calculateMaxWeight(p)

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

proc getAndClearMessages* (p: Player): seq[string] =
    # SHOULD ONLY BE USED BY -GAME- OBJECT, it's collection of keys, not echoable strings
    result = p.msg
    p.msg = @[] # clears the old one

proc sleep* (p: Player) =
    p.hp = p.hp_max
    p.sp = p.sp_max
    p.mp = p.mp_max

    # todo:
    # if timer == 1 or timer2 == 1 or timer3 == 1:
    #     timer = 0
    #     timer2 = 0
    #     timer3 = 0
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
    bows          : int
    swords        : int
    guns          : int
    spellcasting  : int
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
    connection    : int
  Player* = ref object
    name   : string
    gender : Gender
    race   : Race
    class  : Class
    attrs  : Attributes
    skills : Skills

let getGender* = {
    "male":      MALE,
    "female":    FEMALE,
    "nonbinary": NONBINARY
}.toTable
let getRace* = {
    "human":   HUMAN,
    "ett":     ETT,
    "vindean": VINDEAN,
    "saphtri": SAPHTRI,
    "voitri":  VOITRI,
    "ormath":  ORMATH
}.toOrderedTable
let getClass* = {
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
          # pwr_tech +5, pwr_magic -5
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
          # pwr_magic +5, pwr_tech -5
      of ORMATH:
          p.attrs.endurance   += 1
          p.attrs.dexterity   += 1
          p.attrs.strength    -= 2
          p.skills.connection += 1
          # pwr_conn +10
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
          # pwr_tech +5, pwr_magic -5
      of MAGE:
          p.skills.spellcasting += 2
          p.skills.healing      += 1
          p.skills.guns          = 0
          # pwr_magic +5, pwr_tech -5
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
          # pwr_tech +15, pwr_magic -15
      of OUTLANDER:
          p.attrs.charisma      -= 2
          p.skills.repair       += 1
          p.skills.survival     += 1
          p.skills.trapspotting += 1
          p.skills.healing      += 1
      of NECROMANT:
          p.skills.spellcasting = 2
          p.skills.guns         = 0
          # pwr_chaos +8, pwr_conn -20, pwr_tech -5, pwr_magic +5
      of HEALER:
          p.attrs.strength   -= 1
          p.skills.healing   += 2
          p.skills.herbalism += 2
          p.skills.guns      -= 1
          # pwr_magic +5, pwr_tech -5
      of SHAMAN:
          p.skills.connection += 2
          p.skills.herbalism  += 1
          p.skills.guns       -= 1
          # pwr_conn +5, pwr_chaos -10
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

proc getPlayerName* (p: Player): string =
    return p.name
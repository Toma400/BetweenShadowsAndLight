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
  Player* = ref object
    name   : string
    gender : Gender
    race   : Race

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
}.toTable

proc `$`* (p: Player): string =
    result = "[" & p.name & "]\n" &
             "Gender: " & $p.gender & "\n" &
             "Race:   " & $p.race & "\n"

proc newPlayer* (name: string, gender: Gender, race: Race): Player =
    new(result)
    result.name   = name
    result.race   = race
    result.gender = gender

proc getPlayerName* (p: Player): string =
    return p.name
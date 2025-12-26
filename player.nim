type
  Player* = ref object
    name: string

proc newPlayer* (name: string): Player =
    new(result)
    result.name = name

proc getPlayerName* (p: Player): string =
    return p.name
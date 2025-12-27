import std/strutils
import std/tables

type
  Location* = enum
    SHIP
    SHIP_DOCKED # remove if not needed
    DOCKS
    EVROS
    FIELDS

# apparently used for all locations? and OG had maps for Baedoor City and unknown abandoned island
const LocationMap* = """
    ✺---------------------------------------------✺
    | Λ Λ Λ Λ Λ Λ                      )           |
    | Λ           ░░░░░░░░░░░░░░░░    (      ~~    |
    |Λ  ░░░░░░░░░░░░░░░░░░░  ♖-------♖)           |
    | Λ ░░░░░░░░░░░░░░░░░░░  |  Baedoor ♖)      ~~ |
    |Λ  ░░░░░░░░░░░░░░░░░░░  ♖-------♖⚓)         |
    |Λ  ۩  ░░░░░░░░░░░░░░░░           (      ~~ ✖  |
    | Λ Λ Λ Λ Λ Λ Λ   Λ ░░░░░░░░░░░░░  )           |
    ✺---------------------------------------------✺
    """.unindent
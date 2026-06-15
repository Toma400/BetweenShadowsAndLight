# Cheat tracker, so they are all stored in one place
import player
import game

proc cheatBattleHeal* (g: Game) =
    # heals you during the fight ('heal' prompt)
    g.player.hp = calculateMaxHealth(g.player)

proc cheatBattleKill* (g: Game, enhp: var int) =
    # kills the enemy
    enhp = 0

proc cheatCaptain* (g: Game) =
    # OG cheat
    echo getKey(g, "loc__ship_captain_cheat1")
    changeLocation(g, DESERTED_ISLAND)
    waitForPlayer()
    echo getKey(g, "loc__ship_captain_cheat2")
    waitForPlayer()

proc cheatSkip* (g: Game) =
    # allows you to skip tutorial/get to Evros
    g.player.money += 150
    changeLocation(g, EVROS)
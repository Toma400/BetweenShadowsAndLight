# PLACEHOLDER, BUT SHOULD GET PROCS FOR ALL CHEATS
# (this way it's easy to track them)
import player
import game

proc cheatBattleHeal* (g: Game) =
    # heals you during the fight ('heal' prompt)
    g.player.hp = calculateMaxHealth(g.player)

proc cheatBattleKill* (g: Game, enhp: var int) =
    # kills the enemy
    enhp = 0
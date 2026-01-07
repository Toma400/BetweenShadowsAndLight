# PLACEHOLDER, BUT SHOULD GET PROCS FOR ALL CHEATS
# (this way it's easy to track them)
import player
import game

proc cheatHeal* (g: Game) =
    # heals you during the fight ('heal' prompt)
    g.player.hp = calculateMaxHealth(g.player)

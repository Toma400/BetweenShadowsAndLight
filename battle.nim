import std/strutils
import std/random
import std/tables
import inventory
import cheats
import player
import item
import game

randomize()

type
  Enemy* = enum
    RAT            = "rat"
    PIRATE         = "pirate"
    PIRATE_WOUNDED = "pirate_wounded"
  FightOutcome* = enum
    WIN
    DEATH
    # ESCAPE # todo: add in 1.2+

const ENEMIES* : Table[Enemy, tuple[lvl, hp, dmg, rng, xp_gained, detect: int]] = {
    # `rng` usage explained in `fight` at the end of the proc
    RAT            : (lvl: 1, hp: 15, dmg:  5, rng: 1, xp_gained:  5, detect: 7),
    # pirates got `detect` value based on my perception of mechanic, their values
    # weren't noted in OG due to their `i_crouch` switch being false
    PIRATE_WOUNDED : (lvl: 1, hp: 40, dmg:  5, rng: 0, xp_gained: 18, detect:  7),
    PIRATE         : (lvl: 1, hp: 70, dmg: 10, rng: 0, xp_gained: 22, detect: 10),
}.toTable

const LOOT_TABLE* : Table[Enemy, seq[string]] = {
    # no need to add empty sequed enemies (the loot picker in `combat` will yield empty seq anyway)
    RAT            : @["rat_meat", "1 coin"],
    PIRATE         : @["rapier", "15 coins", "2 locks"],
    PIRATE_WOUNDED : @["bandit_revolver", "20 coins", "5 bullets"],
}.toTable

proc spell (g: Game, attack_val: var int) =
    let mod_magic = int(g.player.pwr_magic/2) - int(g.player.pwr_tech/2)
    let mod_chaos = int(g.player.pwr_chaos/2) - int(g.player.pwr_conn/2)  - int(g.player.pwr_tech/2)
    let mod_conn  = int(g.player.pwr_conn/2)  - int(g.player.pwr_chaos/2) - int(g.player.pwr_tech/2)

    proc spellUse (g: Game, aval: var int, staff, spell: string): bool =
        if g.player.mp >= STAFFS[staff][spell].mana_cost:
            aval         = STAFFS[staff][spell].attack
            g.player.mp -= STAFFS[staff][spell].mana_cost
            g.player.hp += STAFFS[staff][spell].heal
            g.player.hp -= STAFFS[staff][spell].self_dmg
            return true
        return false

    if getSpellcasting(g.player) < 1:
        echo getKey(g, "game__combat_skissue")
        waitForPlayer()
    elif g.player.weapon notin STAFFS:
        echo getKey(g, "game__combat_stissue")
        waitForPlayer()
     # and having mod_magic at some level????
    else: # proper spellcasting
        clearScreen()
        var spell_result = false
        echo getKey(g, "game__combat_schoose")
        case g.player.weapon:
            of "staff_fire":
                echo getOptionKey(g, "game__combat_sfire1",  1)
                let prompt = readLine(stdin)
                case prompt:
                  of "1": spell_result = spellUse(g, attack_val, "staff_fire", "fireball")
                  else: return
            of "staff_earth": # earth
                echo getOptionKey(g, "game__combat_searth1", 1)
                let prompt = readLine(stdin)
                case prompt:
                  of "1": spell_result = spellUse(g, attack_val, "staff_earth", "thorns")
                  else: return
            of "staff_conn": # connection
                echo getOptionKey(g, "game__combat_sconn1",  1)
                let prompt = readLine(stdin)
                case prompt:
                  of "1": spell_result = spellUse(g, attack_val, "staff_conn", "small_heal")
                  else: return
            of "staff_chaos": # chaos
                echo getOptionKey(g, "game__combat_schaos1", 1)
                let prompt = readLine(stdin)
                case prompt:
                  of "1": spell_result = spellUse(g, attack_val, "staff_chaos", "soul_devour")
                  else: return
        if spell_result:
            echo getKey(g, "game__combat_snemana")
            waitForPlayer()

proc fight (g: Game, enemy: Enemy): FightOutcome =
    # main combat; return true when won, false when failed (death or escape)
    var ENHP = ENEMIES[enemy].hp
    var TURN = 0
    while true:
        clearScreen()
        # --- SETTERS : used here because it adjusts to inventory changes ---
        var WPN = if g.player.weapon       != "": ITEMS[g.player.weapon]       else: ITEMS["fists"]
        var ARM = if g.player.armour.chest != "": ITEMS[g.player.armour.chest] else: ITEMS["body"]
        # --- GENERAL UPDATES ---
        TURN        += 1
        g.player.sp -= 5
        if g.player.armour_hp <= 0: # ideally this shouldn't ever be reached since we deequip player after breaking armour
            ARM = ITEMS["body"]
        # --- TURN-SPECIFIC VALUES : meant to be overwritten (by attack picked/checks) ---
        var att_value = WPN.attack
        var def_value = ARM.defence
        var arm_dmg   = ARM.defence # recognises whether def bonus comes from armor or other means (e.g. dexterity)
        var has_ammo  = true        # default is yes because if weapon is not ranged, it skips later warning
        # --- AMMO CHECK ---
        if WPN.weapon == RANGED or WPN.weapon == FIREARM:
            if WPN.weapon == RANGED:
                has_ammo = g.player.arrows > 0
            elif WPN.weapon == FIREARM:
                has_ammo = g.player.ammo > 0
            if not has_ammo: # sets fists as used weapon, need to use inventory to change
                WPN = ITEMS["fists"] # ^ this allows for no ammo checks later
        # --- GUI ---
        echo "{ " & getKey(g, "game__combat_turn") & ": " & $TURN & " } ---------------------"
        echo getKey(g, "creature__" & $enemy)
        echo getKey(g, "game__gui_health") & ": " & $ENHP
        echo DIVIDER
        echo getKey(g, "game__gui_health")  & ": " & $g.player.hp
        echo getKey(g, "game__gui_mana")    & ": " & $g.player.mp
        echo getKey(g, "game__gui_attack")  & ": " & $getAttack(g.player)
        echo getKey(g, "game__gui_defence") & ": " & $getDefence(g.player) & " (" & $getArmourHealthPercent(ARM, g.player.armour_hp) & "%)"
        echo DIVIDER
        if not has_ammo:
            echo getKey(g, "game__combat_no_ammo")
            echo DIVIDER

        # --- ATTACK PICKER ---
        echo getKey(g, "game__combat_choice2")
        echo getOptionKey(g, "game__combat_attack1", 1)
        case WPN.weapon:
            of NOT_WEAPON: return DEATH # should not be reached unless there's bug in putting weapon on.. so the penalty for bug is DEATH
            of FIST:       discard      # no unique attacks
            of CLOSE_COMBAT:
                echo getOptionKey(g, "game__combat_attack2", 2)
                echo getOptionKey(g, "game__combat_attack3", 3)
                echo getOptionKey(g, "game__combat_attack4", 4)
            of RANGED, FIREARM:
                echo getOptionKey(g, "game__combat_attack5", 5)
                echo getOptionKey(g, "game__combat_attack6", 6)
            of MAGIC:
                echo getOptionKey(g, "game__combat_attack7", 7)
        echo getOptionKey(g, "game__combat_attack8", 8)
        echo getOptionKey(g, "game__combat_attack9", 9)
        # --- PLAYER PART OF TURN ---
        let prompt = readLine(stdin)
        case prompt:
            of "1": # standard attack | provides small defence gain
                att_value = rand(1..2)
                def_value = rand(0..2)
                arm_dmg   = def_value  # bonus comes from armor itself
                case WPN.weapon: # projectiles update & attack value calculation
                    of NOT_WEAPON:                         discard # not reachable
                    of FIST:                               att_value += att_value
                    of CLOSE_COMBAT:                       att_value += att_value * getSwords(g.player)
                    of RANGED:       g.player.arrows -= 1; att_value += att_value * getBows(g.player)
                    of FIREARM:      g.player.ammo   -= 1; att_value += att_value * getGuns(g.player)
                    of MAGIC:                              att_value += att_value * getSpellcasting(g.player)
                if WPN.weapon != FIST: def_value = ARM.defence + def_value
                else:                  def_value = ARM.defence             # fists get deboost/no bonus
            of "2": # swift attack | smaller attack value, but defence bonus depending on dexterity
                if WPN.weapon != CLOSE_COMBAT: continue # loops back, being soft penalty (sp-5)
                else: # correct option
                    att_value += rand(-2..0)
                    def_value += rand(0..getDexterity(g.player))
                    # arm_dmg is not raised, bonus comes from dexterity
                    if att_value < 0: att_value = 0 # OG doesn't have this, but it's good edge case handling
            of "3": # swing attack | stronger attack, but cancels armor defence
                if WPN.weapon != CLOSE_COMBAT: continue # loops back, being soft penalty (sp-5)
                else: # correct option
                    att_value += rand(0..getStrength(g.player))
                    def_value  = 0
                    # arm_dmg is used nevertheless
            of "4": # defensive attack | smaller attack value, but defence bonus depending on endurance
                if WPN.weapon != CLOSE_COMBAT: continue # loops back, being soft penalty (sp-5)
                else: # correct option
                    att_value += rand(-2..0)
                    def_value += rand(0..getEndurance(g.player))
                    arm_dmg    = def_value # defence bonus comes from armor by context
            of "5": # shooting and back | does not provide defence bonus, but does not set defence penalty
                if WPN.weapon notin [RANGED, FIREARM]: continue # loops back, being soft penalty (sp-5)
                else: # correct option
                    if   WPN.weapon == RANGED:  g.player.arrows -= 1; att_value += rand(1..2) * getBows(g.player)
                    elif WPN.weapon == FIREARM: g.player.ammo   -= 1; att_value += rand(1..2) * getGuns(g.player) + g.player.pwr_tech
                    if att_value < 0: att_value = 0 # OG had it only for firearms (I dunno if it makes sense in any case, but...)
            of "6": # precise shoot | big damage bonus, but sets defence as negative/cancels it
                if WPN.weapon notin [RANGED, FIREARM]: continue # loops back, being soft penalty (sp-5)
                else: # correct option
                    if   WPN.weapon == RANGED:  g.player.arrows -= 1; att_value += rand(0..getBows(g.player) * 3)
                    elif WPN.weapon == FIREARM: g.player.ammo   -= 1; att_value += rand(0..getGuns(g.player) * 3) + g.player.pwr_tech
                    if att_value < 0: att_value = 0 # OG had it only for firearms (I dunno if it makes sense in any case, but...)
                    def_value = rand(-2..0)         # can actually be negative or cancelled
                    # arm_dmg should get used nevertheless
            of "7":
                if WPN.weapon != MAGIC: continue # loops back, being soft penalty (sp-5)
                else: # correct option
                    spell(g, att_value)
            of "8":
                specialInventory(g, att_value)
            of "9":
                fightInventory(g)
                att_value = 0                # no attack this turn
            of "heal", "kill": # cheats
                if   prompt == "heal": cheatBattleHeal(g)
                elif prompt == "kill": cheatBattleKill(g, ENHP)
                att_value = 0
            else: continue
        # after-attack-calculation feedback
        if att_value > 0: echo getKey(g, "game__combat_hit") & " " & $att_value & " " & getKey(g, "game__combat_dmg")
        else:             echo getKey(g, "game__combat_idle")
        waitForPlayer() # universal for all attack types

        ENHP -= att_value # actually dealing the damage on enemy
        if ENHP <= 0:
            return WIN

        # --- ENEMY PART OF TURN ---
        # in OG, 'rng' was a switch (bool), but since I don't want to make one bool in int tuple, thought
        # it can be multiplier - this mimics perfectly behaviour of OG system, but allows also for
        # additional bonus for enemy if needed
        var en_attack = ENEMIES[enemy].dmg + rand(0..ENEMIES[enemy].lvl * 2) * ENEMIES[enemy].rng - def_value
        if en_attack > 0: echo getKey(g, "game__combat_rec") & " " & $en_attack & " " & getKey(g, "game__combat_dmg")
        else:             echo getKey(g, "game__combat_miss"); en_attack = 0 # in case it's less than 0
        var init_arm        = g.player.armour_hp
        g.player.hp        -= en_attack
        g.player.armour_hp -= arm_dmg
        if init_arm > 0 and g.player.armour_hp <= 0: # recognises whether previously armour had health
            echo getKey(g, "game__combat_armbrk")
            discard deequip(g.player, aCHEST, destroy=true) # breaks the item too
        waitForPlayer()

        if g.player.hp <= 0:
            return DEATH

proc loot (g: Game, loot: var seq[string]) =
    while len(loot) > 0:
        for ix, it in loot.pairs():
            if not isSpecialItem(it):
                echo getOptionKey(g, "item__" & it, ix + 1)
            else: # countables
                let dit = debundleSpecialItem(it)
                echo getOptionKey(g, "item__" & $dit.kind, ix + 1) & ": " & $dit.amount
        echo getKey(g, "game__combat_loot")
        let prompt = readLine(stdin)
        if prompt in ["", "0"]: # ends looting (enter softly skips, 0 skips immediately)
            if len(loot) > 0 and prompt == "":
                echo getKey(g, "")
                if readLine(stdin) != "0": continue # goes back to looting if 0 is written
            break # ends looting unless above
        try:
            let p = parseInt(prompt)
            if p <= 0 or p > len(loot): continue
            else: # correct pick
                if not isSpecialItem(loot[p-1]):
                    addItemToInventory(g.player, loot[p-1])
                    loot.delete(p-1)
                else: # countables
                    let dit = debundleSpecialItem(loot[p-1])
                    case dit.kind:
                        of COIN:   g.player.money     += dit.amount
                        of LOCK:   g.player.lockpicks += dit.amount
                        of BULLET: g.player.ammo      += dit.amount
                        of ARROW:  g.player.arrows    += dit.amount
                    loot.delete(p-1)
        except ValueError: continue
    if len(loot) == 0:
        discard # prompt echo

proc combat* (g: Game, enemy: Enemy, crouch_available: bool = false): bool =
    # main worker / maintainer of combat, does more managing than actual combat
    # return is whether the person lives or not; death -> return false
    var LOOT = if enemy in LOOT_TABLE: LOOT_TABLE[enemy] else: @[] # var so it can be taken out of like chest
    var CROU = crouch_available                                    # this can change after failed attempt
    var MODE = 0
    while true:
        if MODE == 0: # -- CHOICE --
            clearScreen()
            echo getKey(g, "game__combat_choice")
            echo getOptionKey(g, "game__combat_direct", 1)
            if CROU:
                echo getOptionKey(g, "game__combat_sneak", 2)
            let prompt = readLine(stdin)
            case prompt:
                of "1": MODE = 1
                of "2":
                    if CROU:
                        MODE = 2
                else: continue
        # -- FIGHTERS --
        elif MODE == 1: # -- NORMAL FIGHT --
            case fight(g, enemy): # combat result
              of WIN:   MODE = 3
              of DEATH: MODE = 4
              # if ESCAPE is added here, MODE = 5 would return true, but didn't get access to LOOT
        elif MODE == 2: # -- SNEAK --
            let cr = crouch(g.player, ENEMIES[enemy].detect)
            if cr: # one-shot if succeed
                echo getKey(g, "game__combat_sneaksc")
                MODE = 3 # win
            else: # blocked option when failed
                echo getKey(g, "game__combat_sneakfl")
                CROU = false
                MODE = 0 # goes back to choice
            waitForPlayer()
        # -- RETURNERS --
        elif MODE == 3: # -- WIN --
            echo getKey(g, "game__combat_win")
            waitForPlayer()
            addExperience(g.player, ENEMIES[enemy].xp_gained)
            loot(g, LOOT)
            return true
        elif MODE == 4: # -- DEATH --
            return false

proc randomEncounter* (g: Game, enemy_list: seq[Enemy], chance: int): bool =
    # runs combat based on chance %; this variant allows for randomised enemies
    if rand(0..100) <= chance:
        let enemy = sample(enemy_list)
        echo getKey(g, "game__encounter") & " " & getKey(g, "creature__" & $enemy)
        return combat(g, enemy)

proc randomEncounter* (g: Game, enemy: Enemy, chance: int): bool =
    return randomEncounter(g, @[enemy], chance) # variant with one enemy

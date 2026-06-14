import system/iterators
import std/private/oscommon
import std/private/osdirs
import std/strformat
import std/strutils
import std/sequtils
import std/tables
import parsetoml
import player
import game

proc toTable (o: object): OrderedTable =
  for name, val in fieldPairs(o):
    result[name] = val
proc toStringedTable (o: object): string =
  for name, val in fieldPairs(o):
    let nnn = name
    let vvv = val
    result.add(fmt"{nnn} = {vvv}" & "\n")

proc listSaves* (): seq[string] =
    for f in walkDirs(fmt"saves/*"):
      result.add(f.replace("saves\\", ""))

proc saveExists* (nm: string): bool =
    return nm in listSaves()

proc saveGame* (g: Game) =
    let nm = getPlayerName(g.player) # used for pathing
    if not dirExists(fmt"saves/{nm}"):
      createDir(fmt"saves/{nm}")
    block MainFile:
        let mf = open(fmt"saves/{nm}/player.toml", fmWrite)
        mf.write(fmt"""
        gender   = "{$getGender(g.player)}"
        race     = "{$getRace(g.player)}"
        class    = "{$getClass(g.player)}"
        location = "{$g.location}"
        """.unindent())
        close(mf)
    block StatsFile:
        let sf = open(fmt"saves/{nm}/stats.toml", fmWrite)
        var vs = "" # global variables list
        for v in Variable.low..Variable.high:
          if checkVariable(g.player, v):
            vs.add($v & ",\n")
        sf.write(fmt"""
        level  = {getLevel(g.player)}
        xp     = {getExperience(g.player)}
        hp     = {g.player.hp}
        mp     = {g.player.mp}
        sp     = {g.player.sp}
        weight = {g.player.weight}
        poison = {getPoison(g.player)}
        global_variables = [
            {vs}]
        [attributes]
        {toStringedTable(getSvAttributes(g.player))}
        [skills]
        {toStringedTable(getSvSkills(g.player))}
        [powers]
        magic = {g.player.pwr_magic}
        tech  = {g.player.pwr_tech}
        conn  = {g.player.pwr_conn}
        chaos = {g.player.pwr_chaos}
        """.unindent())
        close(sf)
    block InventoryFile:
        let ef = open(fmt"saves/{nm}/inventory.toml", fmWrite)
        var ev = "" # inventory list
        for it in getInventory(g.player):
            ev.add(it & ",\n")
        ef.write(fmt"""
        bank      = {g.player.bank}
        money     = {g.player.money}
        ammo      = {g.player.ammo}
        arrows    = {g.player.arrows}
        lockpicks = {g.player.lockpicks}
        weapon    = {g.player.weapon}
        inventory = [
            {ev}]
        [armour]
        chest     = {g.player.armour.chest}
        """.unindent())
        close(ef)
    block QuestFile:
        let qf = open(fmt"saves/{nm}/quests.toml", fmWrite)
        var qs = "" # quests started list
        var qd = "" # quests done list
        var tm = "" # timers list
        for q in getActiveQuests(g.player):
            add(qs, $q & ",\n")
        for q in getFinishedQuests(g.player):
            add(qd, $q & ",\n")
        for t in Timer.low..Timer.high:
            add(tm, fmt"{t} = [{isTimerStarted(g.player, t)}, {getTimerCountDownValue(g.player, t)}]" & "\n")
        qf.write(fmt"""
        mq_progress = {getMainQuestProgress(g.player)}
        quests_started = [
            {qs}]
        quests_done = [
            {qd}]
        [timers]
        {tm}
        """.unindent())
        close(qf)

proc loadGame* (nm: string): Game =
    let pf = parseFile(fmt"saves/{nm}/player.toml")    # player file
    let sf = parseFile(fmt"saves/{nm}/stats.toml")     # stats file
    let ef = parseFile(fmt"saves/{nm}/inventory.toml") # inventory file
    let qf = parseFile(fmt"saves/{nm}/quests.toml")    # quests file
    result = newGame() # accomodating for `ref`
    # menu is overridden in `bsal.nim` after the load
    result.location = parseEnum[Location](pf["location"].getStr())
    # TODO: SET CHESTS
    # TODO: *no `attack` nor `defence`, it should also be changed in `player.nim`
    #       to be updated each `processStatistics` and not during equip because
    #       it makes no sense for this stat to be used differently (it's not used
    #       by combat bc then item properties are used!)
    # TODO: `armour_hp` as above - does it reset each time you take off armour?
    #        is it battle only thing? (resets after battle?) how to approach this?
    block PlayerBuilder:
        # stats
        result.player = newPlayer(name   = nm,
                                  gender = parseEnum[Gender](pf["gender"].getStr()),
                                  race   = parseEnum[Race](pf["race"].getStr()),
                                  class  = parseEnum[Class](pf["class"].getStr()))
        # setting further items is done after initialising player since setter procs
        # base upon `Player` object explicitly
        block SetAttributes:
            setStrength(result.player, getInt(sf["attributes"]["strength"]))
            setDexterity(result.player, getInt(sf["attributes"]["dexterity"]))
            setIntelligence(result.player, getInt(sf["attributes"]["intelligence"]))
            setEndurance(result.player, getInt(sf["attributes"]["endurance"]))
            setCharisma(result.player, getInt(sf["attributes"]["charisma"]))
        block SetSkills:
            setSwords(result.player, getInt(sf["skills"]["swords"]))
            setBows(result.player, getInt(sf["skills"]["bows"]))
            setGuns(result.player, getInt(sf["skills"]["guns"]))
            setSpellcasting(result.player, getInt(sf["skills"]["spellcasting"]))
            setConnection(result.player, getInt(sf["skills"]["connection"]))
            setTrade(result.player, getInt(sf["skills"]["trade"]))
            setRepair(result.player, getInt(sf["skills"]["repair"]))
            setHealing(result.player, getInt(sf["skills"]["healing"]))
            setLockpicking(result.player, getInt(sf["skills"]["lockpicking"]))
            setSmithing(result.player, getInt(sf["skills"]["smithing"]))
            setHerbalism(result.player, getInt(sf["skills"]["herbalism"]))
            setVehicleDrive(result.player, getInt(sf["skills"]["vehicle_drive"]))
            setTrapspotting(result.player, getInt(sf["skills"]["trapspotting"]))
            setSurvival(result.player, getInt(sf["skills"]["survival"]))
            setSneaking(result.player, getInt(sf["skills"]["sneaking"]))
        # since attrs/skills has changed, so did all the caps etc.
        block RecalculateStats:
            processStatistics(result.player)
            # processStatistics(result.player) <--- probably the only one needed? ensure
            # ^ this also results that saving means passing time, but I find it a funny "bug"/side-effect
            # setGenderModifiers(result)
            # setRaceModifiers(result)
            # setClassModifiers(result)
            # # defaults (base stats)
            # result.hp_max     = calculateMaxHealth(result)
            # result.mp_max     = calculateMaxMana(result)
            # result.sp_max     = SP_MAX
            # result.weight_max = calculateMaxWeight(result)
            # result.defence    = DEF_DEF
            # result.attack     = DEF_ATT
        block OtherStats:
            setSvLevel(result.player, getInt(sf["level"]))
            setSvExperience(result.player, getInt(sf["xp"])) # addExperience uses modifiers
            setSvPoison(result.player, getInt(sf["poison"]))
            result.player.weight = getInt(sf["weight"])
            result.player.hp     = getInt(sf["hp"])
            result.player.mp     = getInt(sf["mp"])
            result.player.sp     = getInt(sf["sp"])
            for tv in getElems(sf["global_variables"]):
                addVariable(result.player, parseEnum[Variable](tv.getStr()))
            result.player.pwr_magic = getInt(sf["powers"]["magic"])
            result.player.pwr_tech  = getInt(sf["powers"]["tech"])
            result.player.pwr_conn  = getInt(sf["powers"]["conn"])
            result.player.pwr_chaos = getInt(sf["powers"]["chaos"])
        block SetInventory:
            result.player.bank      = getInt(ef["bank"])
            result.player.money     = getInt(ef["money"])
            result.player.ammo      = getInt(ef["ammo"])
            result.player.arrows    = getInt(ef["arrows"])
            result.player.lockpicks = getInt(ef["lockpicks"])
            for ti in getElems(sf["inventory"]):
                addItemToInventory(result.player, ti.getStr())
            result.player.weapon = getStr(ef["weapon"])
            result.player.armour = (
                chest: getStr(ef["armour"]["chest"])
            )
        block SetQuests:
            setMainQuestProgress(result.player, getInt(qf["mq_progress"]))
            for q in getElems(qf["quests_started"]):
                pureAddQuest(result.player, parseEnum[Quest](q.getStr()))
            for q in getElems(qf["quests_done"]):
                pureAddQuestDone(result.player, parseEnum[Quest](q.getStr()))
            for t in getTable(qf["timers"]).keys():
                let tdata = getElems(qf["timers"][t])
                setTimer(result.player, parseEnum[Timer](t), getBool(tdata[0]), getInt(tdata[1]))

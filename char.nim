import std/strutils
import player
import game

proc characterStatistics* (g: Game) =
      echo getKey(g, "game__gui_chinit")
      echo "[" & getPlayerName(g.player) & "]"
      echo getKey(g, "gender__" & ($getGender(g.player)).toLowerAscii)
      echo getKey(g, "race__"   & ($getRace(g.player)).toLowerAscii)
      echo getKey(g, "class__"  & ($getClass(g.player)).toLowerAscii)
      echo getKey(g, "game__gui_level")  & ": " & $getLevel(g.player)
      echo getKey(g, "game__gui_xp")     & ": " & $getExperience(g.player) & " / " & $getMaxWeight(g.player)
      echo getKey(g, "game__gui_sp")     & ": " & $g.player.sp
      echo "{" & getKey(g, "game__gui_health") & ": " & $g.player.hp & " / " & $getMaxHealth(g.player) & " | " &
                 getKey(g, "game__gui_mana")   & ": " & $g.player.mp & " / " & $getMaxMana(g.player)   & " | " &
                 getKey(g, "game__gui_attack")  & ": " & $getAttack(g.player)  & " | " &
                 getKey(g, "game__gui_defence") & ": " & $getDefence(g.player) & "}" &
           # armor | todo: apparently there's [armor / maxarmor]?? is it like item resistance/durability?
           #         ...but then there's also `armor_hp` wtf
           "" # for now, so that the above not being filled don't break the string
           # magic defence (if it exists), from what I see as new line
      echo DIVSHORT
      echo getKey(g, "game__gui_strength")     & ": " & $getStrength(g.player)
      echo getKey(g, "game__gui_dexterity")    & ": " & $getDexterity(g.player)
      echo getKey(g, "game__gui_intelligence") & ": " & $getIntelligence(g.player)
      echo getKey(g, "game__gui_endurance")    & ": " & $getEndurance(g.player)
      echo getKey(g, "game__gui_charisma")     & ": " & $getCharisma(g.player)
      echo DIVSHORT
      echo getKey(g, "game__gui_swords")        & ": " & $getSwords(g.player)
      echo getKey(g, "game__gui_bows")          & ": " & $getBows(g.player)
      echo getKey(g, "game__gui_guns")          & ": " & $getGuns(g.player)
      echo getKey(g, "game__gui_spellcasting")  & ": " & $getSpellcasting(g.player)
      echo getKey(g, "game__gui_connection")    & ": " & $getConnection(g.player)
      echo getKey(g, "game__gui_trade")         & ": " & $getTrade(g.player)
      echo getKey(g, "game__gui_repair")        & ": " & $getRepair(g.player)
      echo getKey(g, "game__gui_healing")       & ": " & $getHealing(g.player)
      echo getKey(g, "game__gui_lockpicking")   & ": " & $getLockpicking(g.player)
      echo getKey(g, "game__gui_smithing")      & ": " & $getSmithing(g.player)
      echo getKey(g, "game__gui_herbalism")     & ": " & $getHerbalism(g.player)
      echo getKey(g, "game__gui_vehicle_drive") & ": " & $getVehicleDrive(g.player)
      echo getKey(g, "game__gui_trapspotting")  & ": " & $getTrapspotting(g.player)
      echo getKey(g, "game__gui_survival")      & ": " & $getSurvival(g.player)
      echo getKey(g, "game__gui_sneaking")      & ": " & $getSneaking(g.player)
      # skills
      waitForPlayer() # let player see statistics before they are moved to old menu
# basic_armor()
# print ("Twoja postać:","\n\n[",name,"]\n",gender,"\n",race,"\n",craft,"\n")
# print ("Poziom", level, "\n")
# print ("-Punkty doświadczenia:",xp,"/",xp_level,"-")
# print ("-Wypoczęcie:",sp,"-")
# print ("[HP",hp,"/",hp_level,"][Mana",mp,"/",mp_level,"][Atak",eq_attack,"][Obrona",eq_defence,"(",armor_hp,"%)]")
# if eq_mdefence > 0:
#   print ("[Obrona magiczna",eq_mdefence,"]")

      switchMenu(g, mDEFAULT)
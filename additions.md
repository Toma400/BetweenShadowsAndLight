# 1.2
- race changes
  - etts replaced by latoka to both accommodate lore more accurately and include more diverse build possibilities
  - latoka will have bonus to charisma as the only race in BRPGS 2.1, meaning their build
  - saves from 1.0-1.1 using ett race will still be able to play as ett race, but this option won't be available
    from character creation menu
- enemy changes
  - changed RNG for normal pirate to 1
- smithing changes
  - added smithing recipe for level 1: sickle
  - rapier can be smithed on level 2 instead of 1, and requires one more piece of iron
- chests' contents
  - decreased amount of gold found in warehouse chest to make it less OP
  - added gunpowder to warehouse chest to make it obtainable item
- QoL / UX
  - renamed `location/map` menu options to `activites/travel`, indicating better their use (and making it IoA parity)

# Possible todos
- if not available already: trading would improve trade skill, and trade skill would
  lower the prices? (soft version of it would be small xp gain which could be used for
  trading in levelup bonus)
- decrease level cap? (100 xp for second level is ridiculous)
- smithing recipes for level 2/3? maybe actually make level 1 get less items
- also make smith be able to train you in smithing (both for 0->1 and 1->2/3), maybe for
  plenty of money
- similarly, make repair *chance* depending on repair skill? otherwise it's useless
  skill; and make smithing and repair have chance to improve your skill after success
  - note: it may be that `repair` was meant just for vehicle-sque things, see `tut4`
    string that explains it.. definitely a shit to be more precise in BRPGS 3.0
- while the game actually tells you in tutorial alchemy skills can affect chances of you
  making potion, it doesn't do anything to actually gatekeep that - so if we were to add
  more potions, it'd make sense to make something that rolls against player's skill
- add `try to escape` option to fights, with `combat/fight` proc bool argument that says
  if we can do so
  - there could be two escapes - one before the fight (when you can choose sneaking) and
    one during battle; the before-fight option would have higher chance to avoid fight
  - though this escapability should be gated and/or have dedicated result (former option
    is easier) because e.g. if we escape wounded pirate in MQ, we would probably let
    captain be killed, which would have consequence for MQ
- make all GUI options work upon numbers, not writing down letters
- big health/mana potions, big health potion should also be weak antidote (level -1)?
- fishing? since `herring` is ultimately useless, you can't roast it nor get it
  and it would be nice way to gather food, very baedoorey as well
- second spell for staffs
  - conn should have `paralysis` because otherwise it makes little sense to use
    this staff, as you need a lot to do just to... heal yourself?
  - maybe conn could even have three spells, with one being small damage?
  - survey for staffs being achievable in game even
- some new books, this time pickable? maybe even one more magazine that would
  change over time
- addition of non-binary gender
- questing
  - Thieves Guild
    - TG follow-up quest to expand on changed lore & offer any questline-like experience
      that it was meant to have (Hrevir is our contact)
    - being able to enter warehouse no matter the time, just having additional
      check for skills (should count for both TG quest *and* reentering)
    - being able to report warehouse theft even after rejecting the offer
    - set the timer after you "leave" the warehouse when night comes, so that there
      can be some sort of penalty (but `echo` that so player knows)
    - chests in warehouse should also be locked?
    - redesign quest slightly so that warehouse entering is separate dialogue
      and maybe allow you to loot more than one chest
    - being able to be caught? for now the quest and getting into warehouse is very
      forgiving
    - set lock-after-burglary to 8, so that only guards attention is higher, but lock
      level remains the same - makes little sense to up its level here
- survey of all texts to improve their quality

# Loose ideas
- some sort of gambling game in tavern with simple mechanics?
- farm with ability to buy goat and milk/kill/sell it? (reference to D&D session lol)
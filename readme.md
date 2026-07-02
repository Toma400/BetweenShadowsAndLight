<img src="banner.png" width="100%"></img>

Between Shadows and Light was one of my first games
ever, created in 2018. It was meant to be open world text
RPG, letting you roam across places from my universe, Baedoor.

While buggy in so many levels, it was much more complex than
anything I created before, and let player experience a lot of
depth I envisioned it to have. That said, it being written
entirely in Polish it made little sense to showcase it.

I wanted to remake BSaL for a long time, but my first attempt
on it, called [Isle of Ansur](https://github.com/Toma400/The_Isle_of_Ansur)
became creature on its own and nowadays, it doesn't resemble BSaL
in nothing except being located in the same area.

### Remake
That's why I decided to start writing a remake - a proper, terminal
version, like the BSaL from eight years ago.
It is meant to preserve almost every of original's quirks, but
improve its code quality, make it crash-free and fix the more
important bugs. And, most importantly, provide English version, so
that more people can see how BSaL looked and felt.

### Roadmap
| Version | Features planned                                                                                         |
|:-------:|:---------------------------------------------------------------------------------------------------------|
|   1.0   | Exact features from original BSaL, fixing CTD issues and broken quests that weren't "buggy as a feature" |
|   1.1   | Fixing any bugs found in 1.0                                                                             |
|   1.2   | Expanding BSaL in a way that let you utilise more unused items, statistics, mechanics etc.               |
|   1.3   | Adding more translations provided by community                                                           |

Any updates past 1.3 are unlikely, but if new translation is added, it may be a reason
for me to make new version just to add it.

### Features
- A hand-crafted steampunk/fantasy world, Baedoor
- Four locations
- Twelve NPCs
- Two quests
- Two semi-quests
- A narrative-rich tutorial
- Various immersive systems (banking, reading, sleeping needs) alongside well-known ones,
  such as crafting (smithing, cooking, alchemy)
- Engaging turn-based combat

### Differences
- Added language support
- Disabled ormath shaman as somewhat difficult to implement class bringing no real value
- Adjusted race names to revised lore (human -> baedoorian, nord -> vindean, saphtri -> pahtri
  (due to description, but also fitting Ansur vicinity much more))
- Added gunpowder to registry, as an item only partially introduced in OG (not foundable
  however, it will be implemented in 1.2+)
- Added unique options to docked ship, since OG haven't made any explicit changes, resulting
  in NPCs behaving the same before and after MQ took place, being unaware of it entirely
- Minimal QoL additions (most notably in additional text guiding through GUI)
- Fixed bug allowing you to repeat magician quest, cheesing the reward
  - Quest is now doable only once, but gives you also experience points (in OG it didn't)
- Fixed merchant's selling you papyrus, as it was likely meant to be parchment
- Fixed normal attack using `swords` skill even if using firearm/ranged weapon
- Overhauled ranged combat so that not having ammo does not yield attack have zero effect,
  but use default fist damage (modeled after how standard attack does it for ranged weapons)
- Cheats slightly changed
  - You can't go back to abandoned island after going to Evros
  - Cheat allowing you to see game information was removed
  - Added some new cheats for combat
- Poisoning has levels that inflict stronger penalties (based on OG using `int` type for
  poisoning instead of bool)
  - To bring the point home, antidotes are also leveled
- Added herring cooking recipe, absent in OG despite herring having cooked variant
- Removed weird limitation for spell casting not being possible after level 3
- Slightly tweaked and expanded TG quest dialogue, introducing us to our hire who now
  has a name
  - Adjusted Hrevir dialogue to not indicate him being in (West) Baedoor, per new ATG
    lore and keeping scope to Ansur only
  - Raised TG quest experience reward to 20 due to the quest being fairly difficult
  - Made TG recommendation letter description, as it was lacking in OG
- Changed wheat gathering to be based on sickle in inventory instead of quest
  active - which technically results in the same behaviour, but can allow for
  additional activity in case further versions add buyable sickle
- Small changes to combat
  - Using explosives or scrolls limits your choice only to see relevant items, making
    it distinct from picking up inventory itself
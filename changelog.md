# 1.1
- made farming wheat possible also with sickle equipped

# Todo:
- not sure if having 0 ammo prompts any message to indicate you started using
  fists - if not, it should
- magic modifiers being used?
- various shortcuts being either initial letter or number for various menu items
- unifying some `back/cancel/leave/etc.`
- checking redundant keys in translation files
- TG quest
  - sneak/lock scenes happen immediately, w/o waitForPlayer() even
  - the same is with scout approaching us immediately after leaving warehouse
  - ...and we can't even tell him 'no', he takes silk from us right away
  - his dialogue could also be a bit more 'breaky'
- when reentering warehouse after breaking, it can prompt to us `lock was opened`
  despite not being able to sneak past guards (does lock count happen no matter
  the sneak success/failure?)
- `you are tired` message appeared during purchase - it'd be good to check when
  adding messages happen, and set smart resetter and/or improve placement of
  updates
- Heresur cheat? (see `Legacy` code, introduces OP character)
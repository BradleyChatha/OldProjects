# Overview

This is the D version of JPlatformer.

## Misc Notes

Lots of interesting stuff with this codebase.

First of all, `/Game.d/:593` is funny ;^)

`/ITile.d/` contains the `TileInteraction` class. It seems any events in the game (e.g. unlock a door) are stored inside this class so they can
later be undone (for example, resetting the level, or dying and undoing any progress since your last checkpoint). `/ITile.d/` in general is just a very
interesting file.

It seems all the tiles are fully functional, it's just that I never really made any levels for this version.

Anyway, onto the **meat** of what makes this version so interesting: The `/bin/Debug/Resources` folder.

All of the tiles in the game are defined by a dynamically loaded DLL file, which is generated in `/bin/Debug/Resources/Tiles/src`, which is actually
really cool! (And in C, for... some reason)

Tiles could be composed of multiple different actions to customise their behaviour, they even had variables that you could edit inside of the game's
debug mode!

To try this, load up the game and hit TAB to go into debug mode. Then finish the first level to go to the debug level. Hover your mouse over the turrets
and you can use your arrow keys to modify it's delay timer, which was defined inside of the external DLL.

In this debug level there's also the Debug tile, you can again use the arrow keys to select which variable to edit, and change its value.
The debug tile is set to output its variables to the console every time you touch it.

The other interesting thing about this project is, it seems the thing I was working on when I last touched this project was to also
create the entire GUI from an external DLL, similar to how tiles are done.

If you look into `/bin/Debug/Resources/GUI/src/` you can see the remains of this effort.

What's even more surprising is that this version of JPlatformer seems to actually have non-borked collision ;^)

Wow, I really wish I had gotten further with this one, it's a pretty interesting project.

## Controls

* Arrow keys to move

* TAB - Debug mode

* W - Place wall

* E - Place finish

* R - Place spike

* T - Place turret

* I - Place key

* O - Place door

* G - Place test tile

* Left click - Move player

* Right click - Delete tile

* Middle click - Place spawn

* S - Save level

* 1 to 4 - Change rotation of rotatable objects (turrets)

* 1 to 5 - Change colour of colourable objects (keys and doors)

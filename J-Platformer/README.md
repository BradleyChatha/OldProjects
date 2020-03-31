# Overview

JPlatformer was one of my first projects, and in fact my very first game project, back in 2013 when I was 14.

It was written in a now-ancient version of C#, using the now-defunct XNA framework.

This backup only contained a compiled version of the game, so via the magic of ILSpy I've provided a decompiled
version of the source code. The original code unfortunately is lost to time :(

## Music

In previous versions of JPlatformer the background music was a small loop I made in Garageband.

However *this* version of JPlatformer is the only surviving version that contains the background music an old friend of mine (Jak) made,
which was completely unexpected, and was definitely quite a hit to my heart <3

## Misc notes

This backup must've been incredibly close to the actual final codebase for the original JPlatformer, since it does contain support
for powerups - the feature I was last working on before I dropped the project for a while (there's been many JPlatformers >:3, but none as good as the original).

None of the levels spawn in any powerups, however the code suggests that they were fully functional... I wonder what my plan was for them.

I sort of remember that there was going to be a colour mechanic, which I never got around to. I think this is why there's a "Colourless" powerup.

For whatever reason, I decided to implement an incredibly basic memory manipulation guard for the player's score. This is what "Player.Ichi" is.
I probably named it "Ichi" because I was just starting to learn Japanese around that time as well, fricking weeb.

I personally love how massive the Main.cs function is. p.s. this is actually eerily similar to how Terraria's Main.cs is structured.

It's unfortunate that the level editor wasn't packed alongside this build.

There's an even older version of the original JPlatformer (the original original, so to speak) that had a smaller screen size, but was a lot more
complete at ~10 levels.

## Keybinds

* Arrow keys to move

* R - Restart

* S - Toggle music

* P - Hide static level objects (for some reason)

* F1 - Skip level (This is the only way to get past the final/test level)

## History (from what I can remember)

Way wayyyyyyyy back in 2013, I wanted to start modding Terraria. I had a bit of fun with it, but ultimately didn't get too far - *however* it did introduce
me to what XNA was.

So originally JPlatformer started life as a simple paint program, because my dumb 14 year old brain was starting to figure out very, very basic maths such as
how to center a rectangle at a certain point (e.g. your cursor).

I'll be damned if there's any trace of that program left, but it taught be quite a bit:

* How to use XNA at a basic level

* Dynamically changing your 'brush' with the mouse wheel

* Saving and loading a "level" (as that's effectively what it was)

Towards the end of the paint program's life, I was starting to wonder how I could use tiles to create an image, a.k.a a grid of images to make up another image.

14 year old me was crunching very hard to find the equation to save mankind: Tile(x, y) = (x / TileSize, y / TileSize)

"Huzzah!" I thought, "I'm a genius" I assumed. After writing a note into my iPad about this revelation, I promptly went to bed.

After testing my theory in the paint program and seeing success, I thought to myself that I could make a level editor from this logic.

Naturally this prompted the thought of what kind of game I could make that'd fit a grid-based level editor. I came to the conclusion of making a platformer.

Thus, my adventure begun of dodgy collisions, learning year 6 level maths (if even that), creating some very basic art for the game, etc.

God... I wish I was still as passionate, creative, and adventurous about programming as I used to be :/

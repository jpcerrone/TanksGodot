# TanksGodot - A Tanks game made in Godot inspired by Wii Play Tanks

Image

## Features
* Allign-then-rotate 8 directional tank movement
* Bouncing bullets
* Mines, can blast some destructible tiles
* All 9 enemy tank types from the Wii play version.
    * Brown Tank: Static, shoots randomly at the player
    * Grey Tank: First moving Tank
    * Teal Tank: Slow, but shoots fast bullets
    * Yellow Tank: Drops mines
    * Red Tank: Rapid fire bullets
    * Green Tank: Their fast bullets bounce twice before going in the player direction.
    * Purple Tank: Fast tank, rapid fire bullets
    * White Tank: Invisible. You can catch glimpses of it when it fires bullets or drops mines
    * Black Tank: Fast tank, fast bullets, rapid fire
* 22 levels. Easy way to create custom ones with a TileMap and drag and dropping tanks in the Godot editor

## Controls:
* WASD: Move
* Mouse: Aim
* Left Click: Shoot
* Right Click: Drop Mine
* ESC: Quit game

## Expanding
### Custom levels
If you'd like to create your own levels, right click on scenes/levels/Level.tscn and select "New Inherited Scene". You'll then have a blank level created.

By selecting the root (Level) node, you can place tiles for the walls. The "X" hotkey flips the tiles horizontally by default.

Enemy tanks can also be drag&dropped from the scenes/tanks/ folder. Make sure to add them as children of the root (Level) node.

Use Godot's Play Scene (F6) to play your custom level. If the level scene is placed on the scenes/levels/ it will be added to the main game's levels. These get loaded depending on their file name, so naming your level "Level023" will add it as the last level of the game.

### Custom Tanks
You can create custom tanks by adding new inherited scenes from any of the tank abstraction scenes (scenes/tanks/abstractions/).

All the tanks in the game were created by expanding either the StationaryTank or MovingTank scenes.

You can check out "Script Variables" in the Godot editor to set some properties for the new tank, like it's speed, bullet type, fire rate, how many mines it can place, etc.

### Debugging
Check out the scripts/Debug.gd file where you can enable some flags to debug either the enemy bullet's raycasts or their movement raycasts.

You can also set the starting level for the main game there.

The runGame and runLevel powershell scripts can be used to launch the game or a particular level from VSCode's console.

## Author
Juan Cerrone

If you like my work you can follow me here:
* https://www.youtube.com/user/jpcerrone (Music/Programming)
* https://www.instagram.com/juan.cerrone.pixel.art/ (Pixel Art)
* https://open.spotify.com/artist/6H2QtCjF5ANcG7PhiRWNCq?si=3t06lhQ2RVm1r3B7c1vHDA (Spotify)


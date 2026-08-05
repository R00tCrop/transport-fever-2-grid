# Grid

The mod "Grid" for the game "Transport Fever 2".

The mod adds a grid button to the main game menu. The button switches a measuring grid on and off
and opens a popup in which the grid can be configured while playing. The grid is drawn directly
onto the terrain, which makes it much easier to plan a town, to keep streets and buildings aligned
and to estimate distances without having to place something first.

## Structure

| File | Purpose |
| --- | --- |
| `mod.lua` | mod description and the settings that define the initial look of the grid |
| `strings.lua` | translations of the mod name and description |
| `res/config/game_script/grid_overlay.lua` | the game script: settings, save/load and the update loop |
| `res/config/style_sheet/grid_overlay.lua` | styles of the button and of the popup |
| `res/scripts/grid_overlay/menu.lua` | the button in the game menu and the settings popup |
| `res/scripts/grid_overlay/geometry.lua` | the polygons of the grid lines |
| `res/scripts/grid_overlay/anchor.lua` | the point on the map the grid is centred on |
| `res/scripts/grid_overlay/zones.lua` | drawing of flat geometry onto the terrain |
| `res/scripts/grid_overlay/config.lua` | the available values and their defaults |
| `res/scripts/grid_overlay/debugpanel.lua` | the panel that is shown at the debug log level |
| `res/scripts/grid_overlay/logging.lua` | logging with three levels |

## How it works

The game lets a script draw flat polygons onto the terrain (the same mechanism the campaign uses to
mark target areas). Every grid line is one such polygon: a very thin rectangle in world coordinates.
Because the polygons follow the ground they also work on slopes.

The lines are always placed at absolute multiples of the cell size, so a line with the index `i`
always sits at `i * cellSize` regardless of where the camera is. Panning the camera therefore never
makes the grid wobble; lines only appear and disappear at the border of the covered area.

Every `n`-th line (five by default) is drawn wider and with the full opacity. Counting cells and
reading distances works much better with these emphasised lines than with a uniform grid.

The grid only moves once the point it follows has left the inner part of the covered area. The point
itself is not perfectly stable (it comes from the camera, or from the last position under the mouse
if the game does not let a script read the camera), and a grid that reacts to every small change of
it flickers. With the hysteresis the grid stays where it is until it really has to move.

## Performance

* The grid covers a fixed number of cells around the camera instead of the whole map. The number of
  drawn polygons therefore only depends on the setting for the covered area, never on the map size.
* The grid is only recentred once the camera left the inner 35% of the covered area. As long as it
  does not, the update loop compares four numbers and returns; the polygons are reused.
* When the set does change, only the lines that actually appeared or disappeared are written to the
  engine, the remaining ones are left untouched.
* The camera is read every sixth frame, which is far more often than the grid can visibly change.
* Everything runs in the gui context of the game script. The mod does not touch the simulation at
  all, so it costs nothing while the game is running at high speed and it also works while the game
  is paused.

## Settings

The mod parameters define what a new game starts with. Everything can be changed while playing in
the popup that belongs to the grid button:

| Setting | Values |
| --- | --- |
| Cell size | 25, 50, 100, 200, 300 and 500 m |
| Colour | blue, white, amber and green |
| Opacity | 25%, 40%, 55%, 75% and 100% |
| Line width | thin (1.5 m), normal (3 m) and bold (5 m) |
| Emphasised lines | off, every 5th line and every 10th line |
| Covered radius | 400, 800, 1200 and 2000 m |

The settings that are chosen in the popup are stored in the savegame, so every game keeps its own
grid.

The covered radius is given in meters and does not depend on the cell size: a coarser grid covers
the same area with fewer lines. Only a very small cell size together with a very large radius runs
into the limit of 65 lines per axis, in which case the grid covers less than the chosen radius.

The log level of the mod parameters has three steps. `Errors` writes problems to the game log,
`Debug` additionally shows a small panel in game that tells which position the grid follows, how
often it was recentred and how many polygons it draws.

## Compatibility

The mod is purely visual. It can be added to and removed from an existing savegame at any time.

The grid follows the point the camera looks at. Should a version of the game not let a script read
the camera, the mod falls back to the last position the mouse pointed at, which keeps the grid
usable in exactly the situation it matters most: while building.

## Development

The Lua files can be checked without the game:

```sh
luac -p mod.lua strings.lua res/config/game_script/*.lua res/config/style_sheet/*.lua res/scripts/grid_overlay/*.lua
```

`test/harness.lua` simulates the parts of the game interface the mod uses (drawing zones, the
components of the user interface, the camera and the savegame), which makes it possible to run the
whole mod outside of the game:

```sh
lua test/test.lua
```

The tests cover the geometry of the grid, the button and the popup, every setting, the save/load
cycle including states written by older versions of the mod, the fallback that is used when the
camera cannot be read, and the case in which the game rebuilds its user interface while the mod is
running. The `test` directory is ignored by the game.

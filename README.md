# Grid

The mod "Grid" for the game "Transport Fever 2".

The mod adds a "Grid" button to the bar at the bottom of the game. The button switches a measuring
grid on and off and opens a popup in which the grid can be configured while playing. The grid is drawn directly
onto the terrain, which makes it much easier to plan a town, to keep streets and buildings aligned
and to estimate distances without having to place something first.

## Structure

| File | Purpose |
| --- | --- |
| `mod.lua` | mod description and the settings that define the initial look of the grid |
| `strings.lua` | every text of the mod in the 13 languages the game ships with |
| `res/config/game_script/grid_overlay.lua` | the game script: settings, save/load and the update loop |
| `res/config/style_sheet/grid_overlay.lua` | styles of the button and of the popup |
| `res/scripts/grid_overlay/menu.lua` | the button in the bar of the game and the settings popup |
| `res/scripts/grid_overlay/geometry.lua` | the polygons of the grid lines |
| `res/scripts/grid_overlay/anchor.lua` | the point on the map the grid is centred on |
| `res/scripts/grid_overlay/zones.lua` | drawing of flat geometry onto the terrain |
| `res/scripts/grid_overlay/config.lua` | the available values and their defaults |
| `res/scripts/grid_overlay/debugpanel.lua` | the panel that is shown at the debug log level |
| `res/scripts/grid_overlay/logging.lua` | logging with three levels |
| `image_00.tga` | the picture of the mod in the mod list of the game |
| `workshop_preview.jpg` | the picture of the mod on the Steam Workshop page |
| `*.svg` | the sources of both pictures |
| `workshop_description.txt` | the text of the Workshop page in the BBCode Steam expects |
| `RELEASE.md` | how the mod is published to the Steam Workshop |
| `LICENSE` | the licence of the mod |

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

## The button

The button is plain text that reads `Grid`. It is appended to the bar at the bottom of the game, the
one that shows the earnings and the number of transported passengers and goods, behind a divider of
the kind the bar already uses between its own numbers:

```lua
local bar = gui.boxLayout_get('gameInfo.layout')

bar:addItem(gui.component_create('gridOverlay.separator', 'VerticalLine'))
bar:addItem(gui.component_get('gridOverlay.button'))
```

Nothing about this is a fixed position. The button is not placed at coordinates and it is not hung
next to a particular element of the game — it is simply appended to a box layout, which lays its
items out one after the other. Several mods that do this therefore line up next to each other in the
order they happen to be loaded, and none of them has to know how many others are installed. It is
the same few lines the other script mods use, which is why the row stays correct in either
direction.

Everything about the look comes from the game: the label is an ordinary `TextView` inside an
ordinary `Button`, so it carries the font, the hover highlight, the click highlight and the sounds
of the rest of the bar. The only thing the mod adds is a little room to the left and to the right of
the word, so the highlight does not stick to the letters. While the grid is drawn the label is
painted in the accent colour of the game, which is how the game marks something that is switched on.

## The two contexts

A game script runs twice: once in the context that runs the simulation and writes the savegame, and
once in the context that owns the user interface and draws. The mod settings live in the second one,
which is why they are sent to the first one with a script event whenever they change.

The way back is `save` and `load`, and it is the part that is easy to get wrong: the game does not
only call them when a savegame is written or read, it uses them to hand the state of the simulation
to the drawing context **in every frame**. For that context `load` is not "a game was loaded", it is
a state update that never stops arriving. Anything it does has to be cheap and, above all, must
leave what is on screen alone — a `load` that removes the grid and lets the update loop build it
again a few frames later makes the grid flicker rather than stand still. The same applies to the
settings: a state update still describes the previous choice for the few frames a change of the
popup needs to travel to the other context, so the mod ignores those updates until its own change
has come back.

The grid is therefore only ever thrown away for a reason the mod can see, and it is never
recovered by clearing: writing a zone that is already there with the very same value cannot be
seen, while removing it and adding it again can. Should the game ever drop what the mod drew (it
does that when a savegame is loaded, which also rebuilds the bar and is how the mod notices),
every zone is simply written again. On top of that the mod rewrites all of its zones every few
seconds as a safety net.

## Performance

* The grid covers a fixed number of cells around the camera instead of the whole map. The number of
  drawn polygons therefore only depends on the settings, never on the map size: 41 lines per axis
  and 82 polygons with the defaults, 130 at the very most.
* The work the mod itself does is not measurable. In the state it is in almost all of the time it
  costs 1.65 us per frame for the state the game hands over plus 0.37 us every sixth frame to notice
  that nothing moved, which together is 0.01 % of one frame at 60 fps. Everything the grid costs is
  the engine drawing the polygons onto the terrain, which is why the cell size and the covered
  radius are the only two settings that matter for performance.
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

| Setting | Values | Default |
| --- | --- | --- |
| Cell size | 50, 100, 200, 400 and 800 m | 100 m |
| Colour | blue, white, amber and green | blue |
| Opacity | 25%, 50%, 75% and 100% | 75% |
| Line width | thin (3 m), normal (2 m) and bold (1 m) | thin |
| Emphasised lines | off, every 5th line and every 10th line | every 5th |
| Covered radius | 1000, 2000 and 4000 m | 2000 m |

The values and the defaults live in `res/scripts/grid_overlay/config.lua` and nowhere else: the mod
parameters and the popup both read them from there, so the two can never offer different values.

The line width is given in meters because the lines are flat geometry on the ground rather than
something drawn on screen. A narrow polygon merges into one crisp line and therefore reads as bold,
a wide one shows both of its edges and reads as thin, which is why the widths run the way they do.

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
running. They also check that every mod parameter offers the same default the mod falls back to
when the game hands no choice over. The `test` directory is ignored by the game.

The bar the tests build is the bar of a game without a single other mod: it holds exactly the items
the game itself puts there. The button is checked against that bar, against a bar in which another
mod has already placed a button of its own, and against a game that has no bar at all, which is what
tells that the mod stands on its own no matter what else is installed.

Both contexts of the game script are run side by side and the state is handed from one to the other
in every frame, exactly as the game does it, since that is what tells whether the grid really stands
still. The tests count how many zones are on the map after every single one of those frames: a grid
that is taken off the map and drawn again is a grid that flickers, no matter how it looks at the end
of a test.

## Pictures

`image_00.tga` and `workshop_preview.jpg` are drawn from the same geometry as the grid the mod
itself draws: thin lines every cell and a wider one every n-th. Both have an `.svg` next to them
that is the source of the picture rather than an export of it.

The `.tga` is what the game reads. It is 24 bit, uncompressed, image type 2 with a bottom-left
origin, which is the format the mods that ship with the game use; a `.tga` written with a top-left
origin ends up upside down.

## Licence

MIT, see [LICENSE](LICENSE). The mod may be used, changed and redistributed freely as long as the
copyright notice and the licence text are kept.

## Repository

<https://github.com/R00tCrop/transport-fever-2-grid>

## Credits

Written with Claude Opus 5 by Anthropic.

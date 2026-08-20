package.path = (os.getenv('MOD_DIR') or '.') .. '/test/?.lua;' .. package.path

local harness = require 'harness'

local failures = 0
local function check(condition, message)
  if condition then
    print('  ok   - ' .. message)
  else
    failures = failures + 1
    print('  FAIL - ' .. message)
  end
end

local function section(name)
  print('\n== ' .. name)
end

local function countKeys(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

-- the grid is only recalculated every few frames
local function frames(script, count)
  for _ = 1, count do script.guiUpdate() end
end

local function start(params)
  harness.reset()
  harness.freshSession()
  harness.setCameraAvailable(true)
  harness.loadMod(params)

  local script = harness.loadGameScript()
  script.load(nil, false)
  script.guiInit()

  return script
end

-- the game does not only call save and load when a savegame is written or read:
-- it also uses them to hand the state of the context that runs the simulation to
-- the context that draws, and it does that while the game is running. the setup
-- below therefore runs both contexts of the game script side by side and hands
-- the state over in every frame, which is what a running game really does
--
-- the events the user interface sends travel the other way and need a moment to
-- arrive, so the state that comes back is older than what the player just chose
local EVENT_LATENCY = 10

local function newGame(params)
  harness.reset()
  harness.freshSession()
  harness.setCameraAvailable(true)
  harness.loadMod(params)

  local running = {
    gui = harness.loadGameScript(),
    sim = harness.inGameContext(harness.loadGameScript),
    frame = 0,
    delivered = 0,
  }

  harness.inGameContext(running.sim.load, nil, false)
  running.gui.load(nil, false)
  running.gui.guiInit()

  return running
end

local function tick(running, count)
  for _ = 1, (count or 1) do
    running.frame = running.frame + 1

    while running.delivered < #harness.events do
      local event = harness.events[running.delivered + 1]

      event.frame = event.frame or running.frame

      if running.frame - event.frame < EVENT_LATENCY then break end

      running.delivered = running.delivered + 1
      harness.inGameContext(running.sim.handleEvent, 'gui', event.id, event.name, event.param)
    end

    running.gui.load(harness.inGameContext(running.sim.save), false)
    running.gui.guiUpdate()
  end
end

local function rebuildUserInterface()
  harness.components = {}
  harness.layouts = {}
  harness.windows = {}
  harness.createGameBar()
end

------------------------------------------------------------------------------
section('the mod parameters define the defaults')

harness.reset()
harness.loadMod({})
check(game.config.gridOverlay.defaults.cellSize == 100, 'the default cell size is 100 m')
check(game.config.gridOverlay.defaults.majorEvery == 5, 'every fifth line is emphasised by default')
check(game.config.gridOverlay.defaults.enabled == false, 'the grid starts switched off')

harness.reset()
harness.loadMod({ gridCellSize = 0, gridPalette = 2, gridOpacity = 4 })
check(game.config.gridOverlay.defaults.cellSize == 25, 'a chosen cell size is picked up')
check(game.config.gridOverlay.defaults.palette == 'amber', 'a chosen colour is picked up')
check(game.config.gridOverlay.defaults.opacity == 1.0, 'a chosen opacity is picked up')

------------------------------------------------------------------------------
section('the button is added to the bar of the game')

local script = start({})

check(harness.components['gridOverlay.button'] ~= nil, 'the button exists')
check(harness.components['gridOverlay.button.label'].text == 'Grid', 'the button is the word "Grid"')
check(harness.components['gridOverlay.button'].toolTip ~= nil, 'the button explains itself in a tooltip')

-- the bar the mod sees here is the one of a game without a single other mod: it
-- holds exactly what the game itself puts there
local barItems = harness.gameBar()
check(barItems[#barItems] == 'gridOverlay.button', 'the button is added behind the numbers of the game')
check(barItems[#barItems - 1] == 'gridOverlay.separator'
  and harness.components['gridOverlay.separator'].type == 'VerticalLine',
  'a divider of the game stands between the button and the numbers')
check(#barItems == #harness.VANILLA_BAR + 2,
  'the mod adds its divider and its button and nothing else')

check(harness.countZones() == 0, 'nothing is drawn while the grid is switched off')

------------------------------------------------------------------------------
section('switching the grid on and off')

harness.click(script, 'gridOverlay.button')
frames(script, 6)

check(harness.windows['gridOverlay.window'] ~= nil, 'the settings popup opens with the grid')

-- a radius of 800 m with a cell size of 100 m is the same as 17 lines per axis
check(harness.countZones() == 34, 'the grid consists of 17 lines per axis')

local vertical = harness.zonesWithPrefix('gridOverlay.v')
local horizontal = harness.zonesWithPrefix('gridOverlay.h')
check(countKeys(vertical) == 17 and countKeys(horizontal) == 17, 'both axes are drawn')

local sample = harness.zones['gridOverlay.v1']
check(sample ~= nil and #sample.polygon == 4, 'a line is a rectangle with four corners')
check(sample.draw == true, 'a line is marked as visible')
check(#sample.drawColor == 4, 'a line has a colour with an alpha value')

local minor = harness.zones['gridOverlay.v1']
local major = harness.zones['gridOverlay.v5']
local minorWidth = minor.polygon[2][1] - minor.polygon[1][1]
local majorWidth = major.polygon[2][1] - major.polygon[1][1]
check(majorWidth > minorWidth, 'every fifth line is wider')
check(major.drawColor[4] > minor.drawColor[4], 'every fifth line is drawn stronger')
check(math.abs(minor.polygon[1][1] + 1.5 - 100) < 1e-9, 'a line sits at an absolute multiple of the cell size')

harness.click(script, 'gridOverlay.button')
frames(script, 6)
check(harness.countZones() == 0, 'switching the grid off removes every line')
check(harness.windows['gridOverlay.window'] == nil, 'the popup closes with the grid')

------------------------------------------------------------------------------
section('the grid follows the camera without redrawing everything')

script = start({})
harness.click(script, 'gridOverlay.button')
frames(script, 6)

local drawn = harness.stats.setZone
harness.camera = { 5, 5 }
frames(script, 12)
check(harness.stats.setZone == drawn, 'a small movement does not redraw anything')

-- the grid only moves once the point it follows left the inner part of the
-- covered area; a grid that reacts to every small change flickers
harness.camera = { 250, 100 }
frames(script, 12)
check(harness.stats.setZone == drawn, 'the grid stays where it is while the camera moves inside it')

-- a position that jumps back and forth is exactly what the mouse delivers while
-- it moves over the map
for i = 1, 20 do
  harness.camera = { (i % 2 == 0) and 120 or -120, (i % 3 == 0) and 90 or -90 }
  frames(script, 12)
end
check(harness.stats.setZone == drawn, 'a position that jumps around does not make the grid flicker')

harness.camera = { 400, 0 }
frames(script, 12)
check(harness.stats.setZone > drawn, 'the grid is recentred once the camera moved far enough')
check(harness.stats.setZone - drawn <= 22, 'recentring only writes the lines that really moved')
check(harness.zones['gridOverlay.v12'] ~= nil and harness.zones['gridOverlay.v-8'] == nil,
  'the covered area moved with the camera')
check(harness.countZones() == 34, 'the number of drawn lines stays the same')

drawn = harness.stats.setZone
harness.camera = { 400, 400 }
frames(script, 12)
check(harness.stats.setZone - drawn <= 22, 'recentring on the other axis only touches the lines of that axis')

harness.camera = { 4000, -2500 }
frames(script, 12)
check(harness.countZones() == 34, 'the grid still consists of 17 lines per axis far away from the origin')
local far = harness.zones['gridOverlay.v40']
check(far ~= nil, 'the lines are still aligned to the world origin')

------------------------------------------------------------------------------
section('the settings can be changed while playing')

script = start({})
harness.click(script, 'gridOverlay.button')
frames(script, 6)

-- the third option of the first group is a cell size of 100 m, the fourth 200 m
check(harness.zones['gridOverlay.v8'] ~= nil and harness.zones['gridOverlay.v9'] == nil,
  'the grid covers the chosen radius of 800 m')

harness.click(script, 'gridOverlay.option.cell.4')
frames(script, 6)
check(harness.zones['gridOverlay.v4'] ~= nil and harness.zones['gridOverlay.v5'] == nil,
  'a larger cell size covers the very same area')
check(harness.countZones() == 18, 'a larger cell size only needs fewer lines for it')

local classes = harness.components['gridOverlay.option.cell.4'].classes
check(classes[2] == 'ug-grid-option-active', 'the chosen option is marked')
check(harness.components['gridOverlay.option.cell.3'].classes[2] == nil, 'the previous option is no longer marked')

harness.click(script, 'gridOverlay.option.palette.3')
frames(script, 6)
local coloured = harness.zones['gridOverlay.v0']
check(coloured.drawColor[1] == 1.0 and coloured.drawColor[3] == 0.25, 'the colour of the lines changes')

harness.click(script, 'gridOverlay.option.major.1')
frames(script, 6)
local first = harness.zones['gridOverlay.v0']
local second = harness.zones['gridOverlay.v1']
check(first.drawColor[4] == second.drawColor[4], 'the emphasis can be switched off')

------------------------------------------------------------------------------
section('the settings are stored in the savegame')

local saved = script.save()
check(saved.cellSize == 200 and saved.palette == 'amber' and saved.majorEvery == 0, 'the state contains the chosen settings')
check(saved.enabled == true, 'the state remembers that the grid is switched on')

local sent = harness.events[#harness.events]
check(sent ~= nil and sent.param.cellSize == 200, 'the settings are handed to the context that writes the savegame')

script = start({})
script.load({ version = 2, enabled = true, cellSize = 50, opacity = 0.75, lineWidth = 5.0, majorEvery = 10, radius = 400, palette = 'green' }, false)
frames(script, 6)
check(harness.countZones() == 2 * 17, 'a loaded state is used right away')
check(harness.zones['gridOverlay.v0'].drawColor[2] == 0.85, 'a loaded colour is used')

script = start({})
script.load({ version = 2, enabled = true, cellSize = 'nonsense', palette = 'pink' }, false)
frames(script, 6)
check(harness.countZones() == 34, 'a broken state falls back to the defaults')

------------------------------------------------------------------------------
section('loading a savegame while the game is running')

script = start({})
harness.click(script, 'gridOverlay.button')
frames(script, 6)
check(harness.countZones() == 34, 'the grid is drawn')

-- the game rebuilds its whole user interface for the loaded game and drops
-- everything a mod added to it
rebuildUserInterface()
harness.zones = {}

local loaded = harness.loadGameScript()
loaded.load({ version = 2, enabled = true, cellSize = 100, opacity = 0.55, lineWidth = 3.0, majorEvery = 5, radius = 800, palette = 'blue' }, false)
loaded.guiInit()
frames(loaded, 6)

check(harness.components['gridOverlay.button'] ~= nil, 'the button is created again')
check(harness.gameBar()[#harness.gameBar()] == 'gridOverlay.button', 'the button is attached again')
check(harness.countZones() == 34, 'the grid of the loaded game is drawn')

harness.click(loaded, 'gridOverlay.button')
frames(loaded, 6)
check(harness.countZones() == 0, 'the button of the loaded game works')

------------------------------------------------------------------------------
section('the grid stands still while the game hands its state over')

local running = newGame({})
harness.click(running.gui, 'gridOverlay.button')
tick(running, 12)
check(harness.countZones() == 34, 'the grid is drawn')

-- the state of the simulation arrives in the context that draws in every single
-- frame; a mod that treats every one of them as a freshly loaded game removes
-- its grid and builds it again a few frames later, which is what made the grid
-- flicker
local written, removed = harness.stats.setZone, harness.stats.removeZone
local lowest = harness.countZones()

for _ = 1, 120 do
  tick(running, 1)
  lowest = math.min(lowest, harness.countZones())
end

check(lowest == 34, 'no state update ever takes a line off the map')
check(harness.stats.removeZone == removed, 'nothing is removed while the state is handed over')
check(harness.stats.setZone == written, 'nothing is written again while nothing changes')

------------------------------------------------------------------------------
section('a choice from the popup survives the state that is still on its way')

running = newGame({})
harness.click(running.gui, 'gridOverlay.button')
tick(running, 12)
check(harness.countZones() == 34, 'the grid starts with a cell size of 100 m')

-- the state of the simulation still describes the previous cell size until the
-- event of the popup has arrived there; adopting it would let the grid fall
-- back to the old look for a moment
harness.click(running.gui, 'gridOverlay.option.cell.4')
tick(running, 6)
check(harness.countZones() == 18, 'the chosen cell size of 200 m is drawn right away')

local everWrong = false

for _ = 1, 40 do
  tick(running, 1)
  everWrong = everWrong or harness.countZones() ~= 18
end

check(not everWrong, 'the grid never falls back to the previous cell size')
check(harness.inGameContext(running.sim.save).cellSize == 200, 'the savegame ends up with the chosen cell size')

------------------------------------------------------------------------------
section('the grid comes back when the game drops what the mod drew')

running = newGame({})
harness.click(running.gui, 'gridOverlay.button')
tick(running, 12)
check(harness.countZones() == 34, 'the grid is drawn')

-- loading a savegame rebuilds the user interface of the game and takes the
-- zones of the game that was played before with it
harness.zones = {}
rebuildUserInterface()
tick(running, 12)

check(harness.components['gridOverlay.button'] ~= nil, 'the button is created again')
check(harness.countZones() == 34, 'the grid is written again')

-- and even without any of that the mod writes its zones again from time to time
harness.zones = {}
tick(running, 300)
check(harness.countZones() == 34, 'a grid that got lost silently comes back on its own')

------------------------------------------------------------------------------
section('the context that runs the simulation has no user interface')

-- the game script is loaded in both contexts, but only one of them may touch
-- the menu; starting a new game crashed because of this
harness.reset()
harness.freshSession()
harness.loadMod({})
harness.leaveGuiContext()

local simulation = harness.loadGameScript()

local ok, err = pcall(simulation.load, { version = 2, enabled = true, cellSize = 200 }, false)
check(ok, 'loading a savegame does not throw: ' .. tostring(err))

ok, err = pcall(simulation.load, nil, false)
check(ok, 'starting a new game does not throw: ' .. tostring(err))

local saved
ok, saved = pcall(simulation.save)
check(ok and saved.cellSize == 100, 'the settings of a new game are written to the savegame')

ok, err = pcall(simulation.handleEvent, 'gui', 'gridOverlay.settings', '', { enabled = true, cellSize = 200 })
check(ok, 'settings coming from the user interface do not throw: ' .. tostring(err))

ok, saved = pcall(simulation.save)
check(ok and saved.cellSize == 200, 'the settings of the user interface end up in the savegame')

------------------------------------------------------------------------------
section('the grid works without a camera the script may read')

script = start({})
harness.setCameraAvailable(false)
harness.entities[7] = { position = { 1000, -1000, 30 } }

harness.click(script, 'gridOverlay.button')
frames(script, 6)
check(harness.countZones() == 34, 'the grid is drawn around the origin')

script.guiHandleEvent('mainView', 'hover', 7)
frames(script, 40)
check(harness.zones['gridOverlay.v10'] ~= nil, 'the grid follows the last position on the map instead')

------------------------------------------------------------------------------
section('the mod survives a user interface that refuses to build the popup')

script = start({})

local createWindow = game.gui.window_create
game.gui.window_create = function () error('no windows today') end

check(pcall(harness.click, script, 'gridOverlay.button'), 'clicking the button does not throw')
frames(script, 6)
check(harness.countZones() == 34, 'the grid is drawn even without the popup')

game.gui.window_create = createWindow

------------------------------------------------------------------------------
section('the mod survives a game that refuses to draw zones')

script = start({})
game.interface.setZone = function () error('not supported') end
harness.click(script, 'gridOverlay.button')
frames(script, 12)
check(true, 'the update loop does not throw')

------------------------------------------------------------------------------
section('the button lines up with the buttons of other mods')

local function startWith(prepare)
  harness.reset()
  harness.freshSession()
  harness.setCameraAvailable(true)
  harness.loadMod({})

  prepare()

  local prepared = harness.loadGameScript()
  prepared.load(nil, false)
  prepared.guiInit()

  return prepared
end

-- a mod that was loaded earlier has already put its button into the bar; the
-- button of this mod is appended after it instead of taking a place of its own,
-- which is what makes the row work with any number of mods
script = startWith(function ()
  harness.components['otherMod.button'] = { id = 'otherMod.button', type = 'Button', classes = {} }
  harness.gameGui.boxLayout_addItem('gameInfo.layout', 'otherMod.button')
end)

local bar = harness.gameBar()
check(#bar == #harness.VANILLA_BAR + 3, 'the mod still adds no more than its divider and its button')
check(bar[#bar - 2] == 'otherMod.button', 'the button of the other mod stays where it is')
check(bar[#bar - 1] == 'gridOverlay.separator' and bar[#bar] == 'gridOverlay.button',
  'the button is appended behind it rather than placed at a fixed position')

------------------------------------------------------------------------------
section('the mod copes with a game that has no bar to add the button to')

script = startWith(function ()
  harness.components['gameInfo'] = nil
  harness.layouts['gameInfo.layout'] = nil
end)

frames(script, 300)

check(harness.components['gridOverlay.button'] ~= nil, 'the button is still created')
check(true, 'the update loop does not throw')

------------------------------------------------------------------------------
section('the mod does not add its button over and over again')

local creations = 0
local buttonCreate = harness.gameGui.button_create

-- a game that accepts a button but does not hand it back would make the mod
-- believe that its button is gone in every single frame
script = startWith(function ()
  harness.gameGui.button_create = function () creations = creations + 1 end
end)

frames(script, 300)
local afterAWhile = creations
frames(script, 300)
harness.gameGui.button_create = buttonCreate

check(harness.components['gridOverlay.button'] == nil, 'the button really is not there')
check(creations == afterAWhile, 'the mod gives up instead of creating a button in every frame')
check(afterAWhile <= 25, 'it gives up after a few attempts, not after hundreds')

------------------------------------------------------------------------------
print('')

if failures == 0 then
  print('all checks passed')
else
  print(failures .. ' check(s) failed')
  os.exit(1)
end

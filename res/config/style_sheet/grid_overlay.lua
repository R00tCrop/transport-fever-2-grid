-- styles of the button and of the popup of the grid; the values follow the ones
-- the game uses for its own menus so that the mod cannot be told apart from the
-- rest of the user interface
require 'tableutil'
local ssu = require 'stylesheetutil'

-- the accent colour of the game, used for everything that is currently active
local accent = { 70, 150, 255 }

local optionGroups = { 'cell', 'opacity', 'width', 'major', 'radius', 'palette' }

local function joinSelectors(pattern)
  local parts = {}

  for i = 1, #optionGroups do
    parts[i] = pattern:gsub('%%s', optionGroups[i])
  end

  return table.concat(parts, ', ')
end

function data()
  local result = {}

  local a = ssu.makeAdder(result)

  -- the icon of the button is a three by three grid of small squares
  a('GridIconCell', {
    size = { 10, 10 },
    minSize = { 10, 10 },
    backgroundColor = ssu.makeColor(255, 255, 255, 145),
  })

  a('#gridOverlay.icon.layout', {
    innerSpacing = { 0, 3 },
    gravity = { .5, .5 },
  })

  a([[#gridOverlay.icon.row1.layout,
    #gridOverlay.icon.row2.layout,
    #gridOverlay.icon.row3.layout]], {
    innerSpacing = { 3, 0 },
  })

  -- the button stands in the row of the main buttons of the game, so it has to
  -- be as large as they are; it is the icon that decides that, which is also
  -- how the buttons of the game and of the other mods are sized
  a('GridIcon', {
    size = { 50, 50 },
    minSize = { 50, 50 },
  })

  -- the same disk the game draws behind the bulldozer and its other main
  -- buttons; the values are the ones the game uses for BulldozerButton and
  -- ConstructionMenuIndicator, and the images are the ones of the game rather
  -- than copies, so the button cannot be told apart from its neighbours
  a('#gridOverlay.button', {
    backgroundImage1 = { fileName = 'ui/design/buttons/disk_big_behind.tga' },
    backgroundImage2 = { fileName = 'ui/design/buttons/disk_big_surface.tga' },
    borderImage = { fileName = 'ui/design/buttons/disk_big_contour.tga' },
    backgroundColor1 = ssu.makeColor(15, 35, 50, 90),
    backgroundColor2 = ssu.makeColor(15, 35, 50),
    borderColor = ssu.makeColor(255, 255, 255, 128),
  })

  a('#gridOverlay.button:hover', {
    backgroundColor1 = ssu.makeColor(183, 188, 193, 128),
    borderColor = ssu.makeColor(255, 255, 255),
  })

  a('#gridOverlay.button:active', {
    backgroundColor1 = ssu.makeColor(15, 35, 50, 90),
    backgroundColor2 = ssu.makeColor(110, 122, 132),
  })

  -- the button lights up while the grid is drawn; the game marks a button that
  -- is switched on by colouring the surface of its disk, so the mod does the
  -- same instead of putting a rectangle behind a round button
  a('#gridOverlay.button!ug-grid-on', {
    backgroundColor2 = ssu.makeColor(accent[1], accent[2], accent[3]),
    borderColor = ssu.makeColor(255, 255, 255, 200),
  })

  a('!ug-grid-on GridIconCell', {
    backgroundColor = ssu.makeColor(255, 255, 255, 255),
  })

  -- the popup uses the same width and the same frame as the windows of the
  -- data layers
  a('#gridOverlay.window', {
    size = { 300, -1 },
  })

  a('GridSettingsComp', {
    padding = { 10, 12, 12, 12 },
  })

  a('#gridOverlay.window.content.layout', {
    innerSpacing = { 0, 3 },
  })

  a(joinSelectors('#gridOverlay.label.%s'), {
    fontSize = 12,
    color = ssu.makeColor(170, 185, 200),
    padding = { 6, 0, 2, 0 },
    textTransform = 'UPPERCASE',
  })

  a(joinSelectors('#gridOverlay.row.%s.layout'), {
    innerSpacing = { 3, 0 },
  })

  a('!ug-grid-option', {
    backgroundColor = ssu.makeColor(255, 255, 255, 15),
    borderWidth = { 1, 1, 1, 1 },
    borderColor = ssu.makeColor(255, 255, 255, 25),
    transitionDuration = { .1 },
  })

  a('!ug-grid-option TextView', {
    fontSize = 13,
    padding = { 4, 6, 4, 6 },
    textAlignment = { .5, .5 },
    color = ssu.makeColor(220, 230, 240),
  })

  a('!ug-grid-option-active', {
    backgroundColor = ssu.makeColor(accent[1], accent[2], accent[3], 90),
    borderColor = ssu.makeColor(accent[1], accent[2], accent[3], 255),
  })

  a('!ug-grid-option-active TextView', {
    color = ssu.makeColor(255, 255, 255),
  })

  -- the panel that is shown while the log level is set to debug; it is a window
  -- without any decoration
  a('#gridOverlay.debug', {
    backgroundColor = ssu.makeColor(10, 20, 30, 220),
    blurRadius = 0,
  })

  a('#gridOverlay.debug Window::Title-bar', {
    visibility = 'none',
    minSize = { 0, 0 },
  })

  a('#gridOverlay.debug Window::Content', {
    padding = { 0, 0, 0, 0 },
  })

  a('GridDebugComp', {
    padding = { 6, 8, 6, 8 },
  })

  a('#gridOverlay.debug.text', {
    fontSize = 13,
    color = ssu.makeColor(140, 200, 255),
  })

  return result
end

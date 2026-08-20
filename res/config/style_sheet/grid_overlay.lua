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

  -- the button is plain text in the bar at the bottom of the game, exactly like
  -- the buttons of the other mods that live there; the game paints the hover and
  -- the click highlight behind it on its own, the label only asks for a little
  -- room to the left and to the right so that the highlight does not stick to
  -- the letters
  a('#gridOverlay.button.label', {
    padding = { 0, 6, 0, 6 },
  })

  -- the game marks what is currently switched on with its accent colour, which
  -- for a text button is the label rather than a background
  a('#gridOverlay.button.label!ug-grid-on', {
    color = ssu.makeColor(accent[1], accent[2], accent[3]),
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

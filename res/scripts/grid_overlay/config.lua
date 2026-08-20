-- all values that describe how the grid looks; the mod parameters only provide
-- the defaults, everything can be changed in game afterwards and is then stored
-- in the savegame
local config = {}

-- the cell sizes that can be picked in the popup; the sizes a town is planned
-- with are multiples of 100 m, the two smaller ones are there for detail work
config.CELL_SIZES = { 50, 100, 200, 400, 800 }

-- how strongly the grid is drawn on top of the terrain
config.OPACITIES = { 0.25, 0.50, 0.75, 1.00 }

-- width of a minor line in meters; the grid is drawn as flat geometry on the
-- ground, so the width has to be given in world units instead of pixels
--
-- a line that becomes thinner than a pixel on screen starts to shimmer, which
-- is why even the thinnest one is well above a meter
--
-- narrow polygon: edges merge into a crisp bold line; wide: edges apart, looks thin
config.LINE_WIDTHS = { 3.0, 2.0, 1.0 }

-- every n-th line is emphasised; zero disables the emphasis completely
config.MAJOR_EVERY = { 0, 5, 10 }

-- the radius in meters the grid covers around the point it follows; the covered
-- area does not depend on the cell size, so changing the cell size only changes
-- how fine the grid is
config.RADII = { 1000, 2000, 4000 }

-- the palettes use the accent colors of the game so that the grid never looks
-- like a foreign element on the map
config.PALETTES = {
  blue = { 0.27, 0.59, 1.00 },
  white = { 0.93, 0.96, 1.00 },
  amber = { 1.00, 0.72, 0.25 },
  green = { 0.45, 0.85, 0.50 },
}

config.PALETTE_ORDER = { 'blue', 'white', 'amber', 'green' }

-- hard upper limit for the number of drawn lines per axis; every line is a
-- separate zone of the game, so this is the main lever for the performance of
-- the mod
--
-- a small cell size together with a large radius runs into this limit, in which
-- case the grid covers less than the chosen radius
config.MAX_LINES_PER_AXIS = 65

-- the grid only moves once the point it follows has left the inner part of the
-- covered area; without this the grid would jump with every small change of
-- that point, which is very visible as flickering
config.ANCHOR_HYSTERESIS = 0.35

-- a major line is drawn wider and with the full opacity
config.MAJOR_WIDTH_FACTOR = 1.7
config.MINOR_ALPHA_FACTOR = 0.55

config.LOG_LEVELS = { 'OFF', 'ERROR', 'DEBUG' }

local BUILT_IN_DEFAULTS = {
  enabled = false,
  cellSize = 100,
  opacity = 0.75,
  lineWidth = 3.0,
  majorEvery = 5,
  radius = 2000,
  palette = 'blue',
  logLevel = 'ERROR',
}

local function isOneOf(values, value)
  for i = 1, #values do
    if values[i] == value then return true end
  end

  return false
end

-- the mod parameters are written to game.config by the runFn of the mod; they
-- are not available in every context, in which case the built in defaults are
-- used instead
local function readModDefaults()
  local ok, defaults = pcall(function ()
    return game.config.gridOverlay.defaults
  end)

  return ok and type(defaults) == 'table' and defaults or {}
end

function config.createSettings()
  local defaults = readModDefaults()
  local settings = {}

  for key, value in pairs(BUILT_IN_DEFAULTS) do
    settings[key] = value
  end

  for key, value in pairs(defaults) do
    if settings[key] ~= nil then settings[key] = value end
  end

  return config.normalize(settings)
end

-- makes sure that settings coming from a savegame (possibly written by another
-- version of the mod) can always be used
function config.normalize(settings)
  local normalized = {}

  for key, value in pairs(BUILT_IN_DEFAULTS) do
    normalized[key] = value
  end

  if type(settings) == 'table' then
    normalized.enabled = settings.enabled == true

    local cellSize = tonumber(settings.cellSize)
    if cellSize and isOneOf(config.CELL_SIZES, cellSize) then normalized.cellSize = cellSize end

    local opacity = tonumber(settings.opacity)
    if opacity and isOneOf(config.OPACITIES, opacity) then normalized.opacity = opacity end

    local lineWidth = tonumber(settings.lineWidth)
    if lineWidth and isOneOf(config.LINE_WIDTHS, lineWidth) then normalized.lineWidth = lineWidth end

    local majorEvery = tonumber(settings.majorEvery)
    if majorEvery and isOneOf(config.MAJOR_EVERY, majorEvery) then normalized.majorEvery = majorEvery end

    local radius = tonumber(settings.radius)
    if radius and isOneOf(config.RADII, radius) then normalized.radius = radius end

    if config.PALETTES[settings.palette] then normalized.palette = settings.palette end

    if isOneOf(config.LOG_LEVELS, settings.logLevel) then normalized.logLevel = settings.logLevel end
  end

  return normalized
end

function config.copySettings(settings)
  local copy = {}

  for key, value in pairs(settings) do
    copy[key] = value
  end

  return copy
end

function config.areEqual(a, b)
  for key in pairs(BUILT_IN_DEFAULTS) do
    if a[key] ~= b[key] then return false end
  end

  return true
end

-- returns the color of the minor and of the major lines for the given settings
function config.getColors(settings)
  local rgb = config.PALETTES[settings.palette] or config.PALETTES.blue

  return
    { rgb[1], rgb[2], rgb[3], settings.opacity * config.MINOR_ALPHA_FACTOR },
    { rgb[1], rgb[2], rgb[3], settings.opacity }
end

return config

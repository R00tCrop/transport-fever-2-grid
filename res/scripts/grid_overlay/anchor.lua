-- the grid is only drawn around a single point of the map instead of covering
-- everything, otherwise a large map would need thousands of zones
--
-- the point the grid follows is the position the camera looks at; the game does
-- not guarantee that a script can read the camera, so the accessor is looked up
-- once and the mod falls back to the last position it has seen on the map (from
-- a hovered object or from a building proposal) if there is none
local log = require 'grid_overlay/logging'

local anchor = {}

local MAX_COORDINATE = 1.0e6

local function isValid(x, y)
  if type(x) ~= 'number' or type(y) ~= 'number' then return false end
  if x ~= x or y ~= y then return false end

  return math.abs(x) < MAX_COORDINATE and math.abs(y) < MAX_COORDINATE
end

-- the candidates are tried in order until one of them returns a usable
-- position; every candidate is guarded because none of them is guaranteed to
-- exist in a given version of the game
local candidates = {
  function ()
    local c = game.gui.getCamera()
    return c[1], c[2]
  end,
  function ()
    local c = game.gui.getCamera()
    return c.x, c.y
  end,
  function ()
    local x, y = game.gui.getCamera()
    return x, y
  end,
  function ()
    local c = api.gui.util.getGameUI():getCamera()
    return c.x, c.y
  end,
}

local resolver
local sourceName = 'unknown'
local hasSearched = false
local fallbackX, fallbackY = 0, 0

local function search()
  hasSearched = true

  for i = 1, #candidates do
    local candidate = candidates[i]
    local ok, x, y = pcall(candidate)

    if ok and isValid(x, y) then
      resolver = candidate
      sourceName = 'camera ' .. i
      log.debug('the grid follows the camera (accessor ' .. i .. ')')
      return
    end
  end

  sourceName = 'mouse'
  log.debug('the camera position is not available, the grid follows the mouse instead')
end

-- remembers a position on the map; it is used as long as the camera cannot be
-- read directly
function anchor.setFallback(x, y)
  if not isValid(x, y) then return end

  fallbackX, fallbackY = x, y
end

function anchor.get()
  if not hasSearched then search() end

  if resolver then
    local ok, x, y = pcall(resolver)

    if ok and isValid(x, y) then return x, y end

    -- the accessor worked before but does not any more; from now on the mod
    -- uses the fallback
    resolver = nil
    sourceName = 'mouse'
    log.debug('the camera position is no longer available, the grid follows the mouse instead')
  end

  return fallbackX, fallbackY
end

-- true while the grid has to be kept up to date from mouse and proposal events
function anchor.needsFallback()
  return hasSearched and resolver == nil
end

-- where the position the grid follows comes from; only used for the debug panel
function anchor.getSourceName()
  return hasSearched and sourceName or 'not searched yet'
end

return anchor

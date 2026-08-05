-- thin wrapper around the zone interface of the game, which is the only way a
-- script can draw flat geometry onto the terrain; every zone is identified by a
-- key, so the painter only has to touch the zones that actually changed
local log = require 'grid_overlay/logging'

local zones = {}

local isAvailable = true

local painter = {}
painter.__index = painter

-- prefix keeps the keys of this mod separate from the keys used by missions and
-- by other mods
function zones.createPainter(prefix)
  return setmetatable({ prefix = prefix, applied = {}, stale = false }, painter)
end

local function setZone(key, zone)
  if not isAvailable then return false end

  local ok, err = pcall(game.interface.setZone, key, zone)

  if not ok then
    isAvailable = false
    log.error('the game refused to draw a zone, the overlay is disabled: ' .. tostring(err))
  end

  return ok
end

-- true if a shape does not have to be written to the engine again
local function isUnchanged(previous, shape)
  if previous == nil then return false end

  local a, b = previous.color, shape.color

  if a[1] ~= b[1] or a[2] ~= b[2] or a[3] ~= b[3] or a[4] ~= b[4] then return false end

  a, b = previous.polygon, shape.polygon

  if #a ~= #b then return false end

  for i = 1, #a do
    if a[i][1] ~= b[i][1] or a[i][2] ~= b[i][2] then return false end
  end

  return true
end

-- replaces everything the painter drew before with the given list of shapes;
-- shapes that did not change are left alone and shapes that are no longer part
-- of the list are removed, so a redraw only costs what really changed
--
-- shapes: array of { key = string, polygon = { { x, y }, ... }, color = { r, g, b, a } }
function painter:apply(shapes)
  local applied = self.applied
  local isStale = self.stale
  local next_ = {}

  for i = 1, #shapes do
    local shape = shapes[i]
    local key = self.prefix .. shape.key

    next_[key] = shape

    if isStale or not isUnchanged(applied[key], shape) then
      setZone(key, { polygon = shape.polygon, draw = true, drawColor = shape.color })
    end
  end

  for key in pairs(applied) do
    if next_[key] == nil then setZone(key, nil) end
  end

  self.applied = next_
  self.stale = false
end

-- forgets what the painter believes is on screen without removing anything, so
-- that the next apply writes every zone again
--
-- this is the only way to recover from a game that dropped what the mod drew
-- (loading a savegame does exactly that). it must never be done by clearing:
-- removing the zones and adding them again one frame later is precisely what
-- makes the grid flicker, while writing a zone that is already there with the
-- very same value cannot be seen at all.
function painter:markStale()
  self.stale = true
end

function painter:isStale()
  return self.stale
end

function painter:clear()
  self.stale = false

  if next(self.applied) == nil then return end

  for key in pairs(self.applied) do
    setZone(key, nil)
  end

  self.applied = {}
end

function painter:isEmpty()
  return next(self.applied) == nil
end

-- the overlay switches itself off permanently if the game does not accept
-- zones; this is only a safety net for unexpected game versions
function zones.isAvailable()
  return isAvailable
end

return zones

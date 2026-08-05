-- builds the polygons of the grid; the grid is always aligned to the world
-- origin, so the lines never move while the camera is panning, they only appear
-- and disappear at the border of the covered area
local config = require 'grid_overlay/config'

local geometry = {}

local floor = math.floor

-- number of lines that are drawn per axis for a radius in meters; the limit is
-- what keeps a fine grid from covering the whole map with thousands of lines
function geometry.getLinesPerAxis(cellSize, radius)
  local lines = floor(radius / cellSize) * 2 + 1

  return math.max(3, math.min(lines, config.MAX_LINES_PER_AXIS))
end

-- the range of line indices that has to be drawn around the given anchor; the
-- indices are absolute (a line with index i sits at i * cellSize), which is what
-- makes the grid stable while the camera moves: lines never move, they only
-- appear and disappear at the border of the covered area
function geometry.getRange(anchorX, anchorY, cellSize, radius)
  local half = floor(geometry.getLinesPerAxis(cellSize, radius) * 0.5)
  local i = floor(anchorX / cellSize + 0.5)
  local j = floor(anchorY / cellSize + 0.5)

  return { i0 = i - half, i1 = i + half, j0 = j - half, j1 = j + half }
end

function geometry.isSameRange(a, b)
  if a == nil or b == nil then return false end

  return a.i0 == b.i0 and a.i1 == b.i1 and a.j0 == b.j0 and a.j1 == b.j1
end

local function isMajor(index, majorEvery)
  return majorEvery > 0 and index % majorEvery == 0
end

-- both helpers return the corners of a rectangle in counter clockwise order
local function verticalQuad(x, y0, y1, width)
  local h = width * 0.5

  return { { x - h, y0 }, { x + h, y0 }, { x + h, y1 }, { x - h, y1 } }
end

local function horizontalQuad(y, x0, x1, width)
  local h = width * 0.5

  return { { x0, y - h }, { x1, y - h }, { x1, y + h }, { x0, y + h } }
end

-- creates the shapes for the whole grid; the result is handed to the zone
-- painter as it is
function geometry.buildShapes(range, settings)
  local cellSize = settings.cellSize
  local majorEvery = settings.majorEvery
  local minorColor, majorColor = config.getColors(settings)
  local minorWidth = settings.lineWidth
  local majorWidth = settings.lineWidth * config.MAJOR_WIDTH_FACTOR

  -- the lines are extended by half a cell so that the corners of the covered
  -- area look closed instead of frayed
  local x0 = (range.i0 - 0.5) * cellSize
  local x1 = (range.i1 + 0.5) * cellSize
  local y0 = (range.j0 - 0.5) * cellSize
  local y1 = (range.j1 + 0.5) * cellSize

  local shapes = {}
  local count = 0

  for i = range.i0, range.i1 do
    local major = isMajor(i, majorEvery)
    count = count + 1
    shapes[count] = {
      key = 'v' .. i,
      polygon = verticalQuad(i * cellSize, y0, y1, major and majorWidth or minorWidth),
      color = major and majorColor or minorColor,
    }
  end

  for j = range.j0, range.j1 do
    local major = isMajor(j, majorEvery)
    count = count + 1
    shapes[count] = {
      key = 'h' .. j,
      polygon = horizontalQuad(j * cellSize, x0, x1, major and majorWidth or minorWidth),
      color = major and majorColor or minorColor,
    }
  end

  return shapes
end

return geometry

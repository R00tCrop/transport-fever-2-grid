-- logging with three levels; the mod runs in every frame, so a message is only
-- built when the level it belongs to is enabled
local log = {}

local PREFIX = '[grid] '

local LEVELS = {
  OFF = 0,
  ERROR = 1,
  DEBUG = 2,
}

local level = LEVELS.ERROR

function log.setLevel(name)
  level = LEVELS[name] or LEVELS.ERROR
end

function log.isDebug()
  return level >= LEVELS.DEBUG
end

local function resolve(message)
  return tostring(type(message) == 'function' and message() or message)
end

function log.debug(message)
  if level >= LEVELS.DEBUG then print(PREFIX .. resolve(message)) end
end

function log.error(message)
  if level >= LEVELS.ERROR then print(PREFIX .. 'error: ' .. resolve(message)) end
end

return log

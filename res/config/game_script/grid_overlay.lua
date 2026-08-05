-- glue between the user interface, the settings and the drawing of the grid
--
-- everything that is visible runs in the gui context of the game script: it is
-- the only context that is updated every frame (and that keeps running while the
-- game is paused, which is when most players build), and it is also the context
-- that is allowed to talk to the user interface
--
-- the game context only keeps a copy of the settings so that they can be stored
-- in the savegame; it has neither game.gui nor api.gui, which is why nothing
-- that runs there may touch the menu
local anchor = require 'grid_overlay/anchor'
local config = require 'grid_overlay/config'
local debugpanel = require 'grid_overlay/debugpanel'
local geometry = require 'grid_overlay/geometry'
local log = require 'grid_overlay/logging'
local menu = require 'grid_overlay/menu'
local zones = require 'grid_overlay/zones'

-- version of the persisted settings; it is independent of the version of the
-- mod and only has to be increased when their structure changes
local STATE_VERSION = 1

local SETTINGS_EVENT_ID = 'gridOverlay.settings'

-- the camera is only read every n-th frame; the grid is a large static overlay,
-- so reacting a few milliseconds later is not noticeable but saves a lot of
-- calls into the engine
local ANCHOR_INTERVAL = 6

-- how often the position below the mouse may be looked up while the camera
-- itself cannot be read
local FALLBACK_INTERVAL = 30

local settings = config.createSettings()

-- runtime data of the gui context; it is intentionally not part of the saved
-- state and is rebuilt whenever a game is loaded
local runtime = {
  painter = nil,
  range = nil,
  drawnSettings = nil,
  frame = 0,
  lastFallbackFrame = -FALLBACK_INTERVAL,

  -- the position the grid is currently built around; it deliberately lags
  -- behind the position the mod is told to follow
  anchorX = nil,
  anchorY = nil,
  recentreCount = 0,
}

local function getPainter()
  if runtime.painter == nil then
    runtime.painter = zones.createPainter('gridOverlay.')
  end

  return runtime.painter
end

local function invalidate()
  runtime.range = nil
  runtime.drawnSettings = nil
end

-- sends the settings to the game context, which is the context that writes the
-- savegame
local function persist()
  pcall(game.interface.sendScriptEvent, SETTINGS_EVENT_ID, '', config.copySettings(settings))
end

local function applySettings(newSettings, shouldPersist)
  local normalized = config.normalize(newSettings)

  if config.areEqual(normalized, settings) then return end

  settings = normalized
  log.setLevel(settings.logLevel)

  invalidate()
  menu.setActive(settings.enabled)
  menu.updateSettings(settings)

  if shouldPersist then persist() end
end

local function setSetting(key, value)
  local newSettings = config.copySettings(settings)
  newSettings[key] = value

  applySettings(newSettings, true)
end

local function toggleGrid()
  setSetting('enabled', not settings.enabled)

  if settings.enabled then
    menu.openPopup(settings)
  else
    menu.closePopup()
  end
end

-- the button is created once and then only checked; loading a savegame rebuilds
-- the user interface of the game, which also removes everything a mod added to
-- it, so the button has to be created again in that case
local function ensureMenu()
  if menu.isReady() then return end

  local ok, err = pcall(menu.create, {
    onToggle = toggleGrid,
    onChange = setSetting,
  })

  if not ok then
    log.error('the game menu could not be extended: ' .. tostring(err))
    return
  end

  menu.setActive(settings.enabled)
  menu.updateSettings(settings)
end

-- keeps the point the grid is centred on up to date while the camera itself
-- cannot be read; the entity below the mouse is a good enough approximation and
-- is only looked up a few times per second
local function updateFallbackAnchor(entityId)
  if not anchor.needsFallback() then return end
  if entityId == nil or entityId < 0 then return end
  if runtime.frame - runtime.lastFallbackFrame < FALLBACK_INTERVAL then return end

  runtime.lastFallbackFrame = runtime.frame

  local ok, entity = pcall(game.interface.getEntity, entityId)

  if ok and entity and entity.position then
    anchor.setFallback(entity.position[1], entity.position[2])
  end
end

-- the grid only follows the camera once the camera has left the inner part of
-- the covered area
--
-- without this the grid is rebuilt for every small change of the position it
-- follows, and since the position below the mouse jumps from object to object
-- while the mouse moves, the whole grid ends up flickering
local function getStableAnchor()
  local x, y = anchor.get()

  if runtime.anchorX ~= nil then
    local dx, dy = x - runtime.anchorX, y - runtime.anchorY
    local threshold = settings.radius * config.ANCHOR_HYSTERESIS

    if dx * dx + dy * dy < threshold * threshold then
      return runtime.anchorX, runtime.anchorY
    end

    runtime.recentreCount = runtime.recentreCount + 1
  end

  runtime.anchorX, runtime.anchorY = x, y

  return x, y
end

local function updateGrid()
  local painter = getPainter()

  if not settings.enabled or not zones.isAvailable() then
    if not painter:isEmpty() then
      painter:clear()
      invalidate()
    end

    return
  end

  -- the range only changes when the grid is recentred, so the polygons are
  -- usually reused for thousands of frames
  local anchorX, anchorY = getStableAnchor()
  local range = geometry.getRange(anchorX, anchorY, settings.cellSize, settings.radius)

  if geometry.isSameRange(range, runtime.range) and runtime.drawnSettings == settings then return end

  runtime.range = range
  runtime.drawnSettings = settings

  painter:apply(geometry.buildShapes(range, settings))
end

local function updateDebugPanel()
  if not log.isDebug() then
    debugpanel.update(nil)
    return
  end

  local painter = getPainter()
  local lines = geometry.getLinesPerAxis(settings.cellSize, settings.radius)
  local zoneCount = 0

  for _ in pairs(painter.applied) do zoneCount = zoneCount + 1 end

  debugpanel.update({
    'GRID',
    'anchor: ' .. anchor.getSourceName()
      .. ' (' .. math.floor(runtime.anchorX or 0) .. ', ' .. math.floor(runtime.anchorY or 0) .. ')',
    'recentred: ' .. runtime.recentreCount .. ' time(s)',
    'cell: ' .. settings.cellSize .. ' m, radius: ' .. settings.radius .. ' m',
    'lines per axis: ' .. lines .. ' (limit ' .. config.MAX_LINES_PER_AXIS .. ')',
    'zones: ' .. zoneCount,
  })
end

function data()
  return {
    -- the gui context draws the grid and owns the user interface
    guiInit = function ()
      log.setLevel(settings.logLevel)
      ensureMenu()
    end,

    guiUpdate = function ()
      runtime.frame = runtime.frame + 1

      if runtime.frame % ANCHOR_INTERVAL ~= 0 then return end

      ensureMenu()
      updateGrid()
      updateDebugPanel()
    end,

    guiHandleEvent = function (id, name, param)
      if menu.handleEvent(id, name, param) then return end

      if id == 'gridOverlay.debug' and name == 'destroy' then
        debugpanel.forget()
      elseif id == 'mainView' and name == 'hover' then
        updateFallbackAnchor(param)
      end
    end,

    -- the game context only mirrors the settings so that they end up in the
    -- savegame
    handleEvent = function (src, id, name, param)
      if id == SETTINGS_EVENT_ID and type(param) == 'table' then
        settings = config.normalize(param)
      end
    end,

    save = function ()
      local state = config.copySettings(settings)
      state.version = STATE_VERSION

      return state
    end,

    load = function (state, reset)
      if reset or type(state) ~= 'table' then
        settings = config.createSettings()
      else
        settings = config.normalize(state)
      end

      log.setLevel(settings.logLevel)

      -- everything that was drawn belongs to the game that was played before
      if runtime.painter ~= nil then runtime.painter:clear() end

      runtime.anchorX, runtime.anchorY = nil, nil
      invalidate()
      menu.setActive(settings.enabled)
      menu.updateSettings(settings)
    end,
  }
end

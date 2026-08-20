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
local STATE_VERSION = 2

local SETTINGS_EVENT_ID = 'gridOverlay.settings'

-- the camera is only read every n-th frame; the grid is a large static overlay,
-- so reacting a few milliseconds later is not noticeable but saves a lot of
-- calls into the engine
local ANCHOR_INTERVAL = 6

-- how often the position below the mouse may be looked up while the camera
-- itself cannot be read
local FALLBACK_INTERVAL = 30

-- after how many passes of the update loop the mod writes all of its zones
-- again even though nothing changed; it is the safety net that brings the grid
-- back if the game ever drops what a script has drawn, and since nothing is
-- removed in the process it stays invisible when it was not needed
local REFRESH_EVERY = 50

local settings = config.createSettings()

-- runtime data of the gui context; it is intentionally not part of the saved
-- state and is rebuilt whenever a game is loaded
local runtime = {
  painter = nil,
  range = nil,
  drawnSettings = nil,
  frame = 0,
  updates = 0,
  lastFallbackFrame = -FALLBACK_INTERVAL,

  -- whether the button was part of the bar the last time it was checked; it
  -- disappearing means that the game rebuilt its user interface, which is also
  -- the moment everything the mod drew is gone
  menuReady = false,

  -- the settings the popup has just chosen: they are on screen already, but the
  -- context that owns the savegame has not been told about them yet
  pending = nil,

  -- the position the grid is currently built around; it deliberately lags
  -- behind the position the mod is told to follow
  anchorX = nil,
  anchorY = nil,
  recentreCount = 0,
}

-- the game script runs in two contexts and only one of them owns the user
-- interface and draws
local function isGuiContext()
  return game ~= nil and game.gui ~= nil and api ~= nil and api.gui ~= nil
end

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

  if shouldPersist then
    -- the choice is on screen now; every state that still describes the
    -- previous one has to be ignored until the change has travelled to the
    -- other context and back
    runtime.pending = config.copySettings(settings)
    persist()
  end
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
  if menu.isReady() then
    runtime.menuReady = true
    return
  end

  -- the button vanishing means that the game threw its user interface away,
  -- which it does when a savegame is loaded; everything the mod drew onto the
  -- terrain belongs to the game that was played before and has to be written
  -- again rather than trusted
  if runtime.menuReady then
    runtime.menuReady = false
    runtime.pending = nil
    runtime.anchorX, runtime.anchorY = nil, nil

    getPainter():markStale()
    invalidate()
  end

  local ok, err = pcall(menu.create, {
    onToggle = toggleGrid,
    onChange = setSetting,
  })

  if not ok then
    log.error('the bar of the game could not be extended: ' .. tostring(err))
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

  if not painter:isStale()
      and geometry.isSameRange(range, runtime.range)
      and runtime.drawnSettings == settings then
    return
  end

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

      runtime.updates = runtime.updates + 1

      if runtime.updates % REFRESH_EVERY == 0 then getPainter():markStale() end

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

    -- load is not only called when a savegame is loaded
    --
    -- the game also uses save and load to hand the state of the game context to
    -- the gui context, and it does that while the game is running, not only
    -- once: for the gui context load is a state update that arrives constantly.
    -- everything below therefore has to survive being called in every single
    -- frame, and above all it must not remove what is on screen: a load that
    -- clears the grid and lets the update loop build it again a few frames
    -- later is exactly what makes the grid flicker.
    load = function (state, reset)
      -- a state that is not a table (or a load that asks for a reset) never
      -- comes from the update above; it is a new game
      local isNewGame = reset or type(state) ~= 'table'
      local incoming = isNewGame and config.createSettings() or config.normalize(state)

      if not isGuiContext() then
        settings = incoming
        log.setLevel(settings.logLevel)

        return
      end

      if isNewGame then
        runtime.pending = nil
      elseif runtime.pending ~= nil then
        -- a setting that was just chosen in the popup needs a few frames until
        -- the game context knows about it; until then its state still describes
        -- the previous choice and adopting it would let the grid fall back to
        -- the old look for a moment
        if not config.areEqual(incoming, runtime.pending) then return end

        runtime.pending = nil
      end

      -- applySettings does nothing at all as long as the state says what the
      -- mod is already drawing, which is the normal case for a state update
      applySettings(incoming, false)
    end,
  }
end

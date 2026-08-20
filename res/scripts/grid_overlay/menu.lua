-- everything the player can see and click: the button in the bar at the bottom
-- of the game and the popup that holds the settings of the grid
--
-- the whole user interface is built with the same component types the game uses
-- for its own menus, so it inherits the look, the sounds and the hover effects
-- of the game
require 'gui'

local config = require 'grid_overlay/config'
local log = require 'grid_overlay/logging'

local menu = {}

local BUTTON_ID = 'gridOverlay.button'
local LABEL_ID = 'gridOverlay.button.label'
local SEPARATOR_ID = 'gridOverlay.separator'
local WINDOW_ID = 'gridOverlay.window'
local CONTENT_ID = 'gridOverlay.window.content'
local OPTION_PREFIX = 'gridOverlay.option.'

-- fallback size of the popup; it is only used if the game cannot report the
-- size of the window before it is placed
local FALLBACK_WINDOW_SIZE = { 300, 280 }
local WINDOW_MARGIN = 6

-- the bar at the bottom of the screen that carries the earnings and the number
-- of transported passengers and goods
--
-- this is where the text buttons of mods belong: they are appended to that bar
-- instead of being squeezed between the round main buttons of the game, which
-- is why every mod that does it this way lines up with the others, no matter
-- how many of them are installed and in which order they are loaded
local GAME_INFO_LAYOUT = 'gameInfo.layout'

-- the groups of the popup; every group maps to one setting and offers the
-- values that can be picked for it
local groups = {
  {
    key = 'cell',
    setting = 'cellSize',
    values = config.CELL_SIZES,
    label = function () return _('Cell size (m)') end,
    labels = { '50', '100', '200', '400', '800' },
  },
  {
    key = 'opacity',
    setting = 'opacity',
    values = config.OPACITIES,
    label = function () return _('Opacity') end,
    labels = { '25%', '50%', '75%', '100%' },
  },
  {
    key = 'width',
    setting = 'lineWidth',
    values = config.LINE_WIDTHS,
    label = function () return _('Line width') end,
    labels = function () return { _('Thin'), _('Normal'), _('Bold') } end,
  },
  {
    key = 'major',
    setting = 'majorEvery',
    values = config.MAJOR_EVERY,
    label = function () return _('Emphasised lines') end,
    labels = function () return { _('Off'), _('Every 5'), _('Every 10') } end,
  },
  {
    key = 'radius',
    setting = 'radius',
    values = config.RADII,
    label = function () return _('Covered radius (m)') end,
    labels = { '1000', '2000', '4000' },
  },
  {
    key = 'palette',
    setting = 'palette',
    values = config.PALETTE_ORDER,
    label = function () return _('Colour') end,
    labels = function () return { _('Blue'), _('White'), _('Amber'), _('Green') } end,
  },
}

-- the bar of the game is not always ready when a mod starts, so adding the
-- button is retried a few times before the mod gives up
local MAX_ATTACH_ATTEMPTS = 20

local state = {
  window = nil,
  settings = nil,
  onChange = nil,
  onToggle = nil,
  isAttached = false,
  attachAttempts = 0,
  createAttempts = 0,
  isBroken = false,
}

-- a game script runs in two contexts and only one of them owns the user
-- interface; everything the mod does in the other one (loading a savegame for
-- example) has to leave the menu alone
local function hasGui()
  return api ~= nil and api.gui ~= nil and game.gui ~= nil
end

local function exists(id)
  return hasGui() and api.gui.util.getById(id) ~= nil
end

-- the user interface of the game is rebuilt whenever a savegame is loaded,
-- which silently destroys everything a mod added to it; the mod therefore
-- always asks the game whether its components are still there instead of
-- remembering that it created them
function menu.exists()
  return exists(BUTTON_ID)
end

local function resolveLabels(group)
  return type(group.labels) == 'function' and group.labels() or group.labels
end

local function optionId(groupKey, index)
  return OPTION_PREFIX .. groupKey .. '.' .. index
end

-- true, false or nil if the game does not let the mod ask for the parent of a
-- component
local function isAttached()
  local ok, parent = pcall(function ()
    return api.gui.util.getById(BUTTON_ID):getParent()
  end)

  if not ok then return nil end

  return parent ~= nil
end

-- adds the button to the bar at the bottom of the game, behind a divider and
-- behind whatever the mods that were loaded before have put there
local function attachButton()
  local ok = pcall(function ()
    local bar = gui.boxLayout_get(GAME_INFO_LAYOUT)

    -- the divider is the one the bar already uses between its own numbers; it
    -- is only ever added once, so a second attempt cannot end up with two of
    -- them next to each other
    if not exists(SEPARATOR_ID) then
      bar:addItem(gui.component_create(SEPARATOR_ID, 'VerticalLine'))
    end

    bar:addItem(gui.component_get(BUTTON_ID))
  end)

  if not ok or isAttached() == false then return false end

  log.debug('added the button to the game bar')

  return true
end

-- true once the button exists and is part of the bar
function menu.isReady()
  return menu.exists() and state.isAttached
end

-- creates the button if it is not there (any more) and makes sure it is part of
-- the bar; calling this again is cheap and is what brings the button back after
-- the game rebuilt its user interface
function menu.create(callbacks)
  -- the callbacks always belong to the script instance that is running now
  state.onToggle = callbacks.onToggle
  state.onChange = callbacks.onChange

  if not hasGui() or state.isBroken then return end

  if not menu.exists() then
    -- a popup that belonged to a button that no longer exists is gone as well
    state.window = nil
    state.isAttached = false
    state.attachAttempts = 0
    state.createAttempts = state.createAttempts + 1

    local ok, err = pcall(function ()
      local button = gui.button_create(BUTTON_ID, gui.textView_create(LABEL_ID, _('Grid')))
      button:setToolTip(_('Switch the grid on and off and change how it looks'))
    end)

    -- the mod recognises a user interface that the game has rebuilt by its
    -- button being gone, so a game that does not hand a freshly created button
    -- back would make it create one in every frame for the rest of the session
    if not menu.exists() then
      if state.createAttempts >= MAX_ATTACH_ATTEMPTS then
        state.isBroken = true
        log.error('the button could not be created: ' .. tostring(ok and 'the game did not return it' or err))
      end

      return
    end

    state.createAttempts = 0
  end

  if state.isAttached or state.attachAttempts >= MAX_ATTACH_ATTEMPTS then return end

  state.attachAttempts = state.attachAttempts + 1
  state.isAttached = attachButton()

  if not state.isAttached and state.attachAttempts >= MAX_ATTACH_ATTEMPTS then
    log.error('the button could not be added to the game bar')
  end
end

-- the label shows whether the grid is currently drawn: the game marks what is
-- switched on with its accent colour
function menu.setActive(isActive)
  if not menu.exists() then return end

  pcall(function ()
    gui.component_get(LABEL_ID):setStyleClassList(isActive and { 'ug-grid-on' } or {})
  end)
end

local function markSelectedOptions()
  if state.window == nil or state.settings == nil then return end

  for i = 1, #groups do
    local group = groups[i]
    local current = state.settings[group.setting]

    for index = 1, #group.values do
      local isSelected = group.values[index] == current
      local classes = isSelected and { 'ug-grid-option', 'ug-grid-option-active' } or { 'ug-grid-option' }

      pcall(function ()
        gui.component_get(optionId(group.key, index)):setStyleClassList(classes)
      end)
    end
  end
end

local function createGroup(group, layout)
  local labels = resolveLabels(group)

  layout:addItem(gui.textView_create('gridOverlay.label.' .. group.key, group.label()))

  local rowLayout = gui.boxLayout_create('gridOverlay.row.' .. group.key .. '.layout', 'HORIZONTAL')

  for index = 1, #group.values do
    local id = optionId(group.key, index)
    local text = gui.textView_create(id .. '.text', (labels and labels[index]) or tostring(group.values[index]))

    rowLayout:addItem(gui.button_create(id, text))
  end

  local row = gui.component_create('gridOverlay.row.' .. group.key, 'GridOptionRow')
  row:setLayout(rowLayout)
  layout:addItem(row)
end

-- places the popup right above the button, or below it if the button ever ends
-- up in the upper half of the screen
local function positionWindow()
  local buttonRect = { 0, 0, 0, 0 }
  local viewRect = { 0, 0, 1920, 1080 }
  local size = FALLBACK_WINDOW_SIZE

  pcall(function () buttonRect = game.gui.getContentRect(BUTTON_ID) end)
  pcall(function () viewRect = game.gui.getContentRect('mainView') end)
  pcall(function ()
    local minimumSize = game.gui.calcMinimumSize(WINDOW_ID)
    if minimumSize and minimumSize[1] and minimumSize[1] > 0 then size = minimumSize end
  end)

  local x = buttonRect[1] + buttonRect[3] * 0.5 - size[1] * 0.5
  local y

  if buttonRect[2] < viewRect[4] * 0.5 then
    y = buttonRect[2] + buttonRect[4] + WINDOW_MARGIN
  else
    y = buttonRect[2] - size[2] - WINDOW_MARGIN
  end

  x = math.max(WINDOW_MARGIN, math.min(x, viewRect[3] - size[1] - WINDOW_MARGIN))
  y = math.max(WINDOW_MARGIN, math.min(y, viewRect[4] - size[2] - WINDOW_MARGIN))

  game.gui.window_setPosition(WINDOW_ID, math.floor(x), math.floor(y))
end

function menu.isPopupOpen()
  return state.window ~= nil and exists(WINDOW_ID)
end

local function buildPopup()
  local layout = gui.boxLayout_create(CONTENT_ID .. '.layout', 'VERTICAL')

  for i = 1, #groups do
    createGroup(groups[i], layout)
  end

  local content = gui.component_create(CONTENT_ID, 'GridSettingsComp')
  content:setLayout(layout)

  state.window = gui.window_create(WINDOW_ID, _('Grid'), content)

  -- the popup must never steal the focus, otherwise the keyboard shortcuts of
  -- the game stop working while it is open
  pcall(function ()
    local window = api.gui.util.getById(WINDOW_ID)
    window:setFocusable(false)
    window:setMovable(true)
  end)

  pcall(function ()
    gui.component_get(WINDOW_ID):setStyleClassList({ 'layers-window', 'ug-grid-window' })
  end)

  markSelectedOptions()
  pcall(positionWindow)
end

function menu.openPopup(settings)
  if not hasGui() or menu.isPopupOpen() then return end

  state.window = nil
  state.settings = settings

  -- a mod must never take the game down with it: if the popup cannot be built,
  -- the grid itself keeps working and the reason ends up in the log
  local ok, err = pcall(buildPopup)

  if not ok then
    state.window = nil
    log.error('the settings popup could not be opened: ' .. tostring(err))
  end
end

function menu.closePopup()
  local window = state.window
  state.window = nil

  if window == nil or not exists(WINDOW_ID) then return end

  pcall(function () window:close() end)
end

function menu.updateSettings(settings)
  state.settings = settings
  markSelectedOptions()
end

-- returns true if the event belonged to this mod and was handled
function menu.handleEvent(id, name, param)
  if id == BUTTON_ID and name == 'button.click' then
    if state.onToggle then state.onToggle() end
    return true
  end

  if id == WINDOW_ID and name == 'destroy' then
    state.window = nil
    return true
  end

  if name ~= 'button.click' or id:sub(1, #OPTION_PREFIX) ~= OPTION_PREFIX then return false end

  for i = 1, #groups do
    local group = groups[i]

    for index = 1, #group.values do
      if id == optionId(group.key, index) then
        if state.onChange then state.onChange(group.setting, group.values[index]) end
        return true
      end
    end
  end

  return false
end

return menu

-- a small panel that shows what the mod is doing right now
--
-- the game writes its log to a file that is not easy to reach, so the
-- information that is needed to find out why something does not work is shown
-- on screen instead; the panel only exists while the log level is set to debug
require 'gui'

local panel = {}

local WINDOW_ID = 'gridOverlay.debug'
local CONTENT_ID = 'gridOverlay.debug.content'
local TEXT_ID = 'gridOverlay.debug.text'

local POSITION = { 20, 120 }

local state = {
  window = nil,
  text = nil,
  failures = 0,
}

local MAX_FAILURES = 5

local function hasGui()
  return api ~= nil and api.gui ~= nil and game.gui ~= nil
end

local function isAlive()
  return state.window ~= nil and hasGui() and api.gui.util.getById(WINDOW_ID) ~= nil
end

local function create()
  local text = gui.textView_create(TEXT_ID, '')

  local layout = gui.boxLayout_create(CONTENT_ID .. '.layout', 'VERTICAL')
  layout:addItem(text)

  local content = gui.component_create(CONTENT_ID, 'GridDebugComp')
  content:setLayout(layout)

  state.window = gui.window_create(WINDOW_ID, '', content)
  state.window:setStyleClassList({ 'ug-grid-debug' })
  state.window:setTransparent(true)

  pcall(function ()
    local window = api.gui.util.getById(WINDOW_ID)
    window:setFocusable(false)
    window:setMovable(true)
  end)

  game.gui.window_setPosition(WINDOW_ID, POSITION[1], POSITION[2])
end

local function close()
  local window = state.window
  local wasAlive = isAlive()

  state.window = nil
  state.text = nil

  if wasAlive then window:close() end
end

-- lines: array of strings; passing nil removes the panel again
function panel.update(lines)
  if state.failures >= MAX_FAILURES then return end
  if not hasGui() then return end

  local ok, err = pcall(function ()
    if lines == nil then
      close()
      return
    end

    local text = table.concat(lines, '\n')

    if not isAlive() then
      state.window = nil
      state.text = nil
      create()
    end

    if state.text ~= text then
      state.text = text
      gui.textView_get(TEXT_ID):setText(text)
    end
  end)

  if ok then
    state.failures = 0
    return
  end

  state.failures = state.failures + 1
  state.window = nil
  state.text = nil

  if state.failures >= MAX_FAILURES then
    print('[grid] the debug panel could not be shown: ' .. tostring(err))
  end
end

-- called when the window was closed by the game itself
function panel.forget()
  state.window = nil
  state.text = nil
end

return panel

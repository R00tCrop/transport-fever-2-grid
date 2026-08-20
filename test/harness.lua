-- minimal simulation of the parts of the Transport Fever 2 API that the mod
-- uses, so the mod logic can be exercised outside of the game; run the tests
-- from the root of the mod with
--
--   lua test/test.lua
--
local MOD = os.getenv('MOD_DIR') or '.'

package.path = MOD .. '/test/?.lua;' .. MOD .. '/res/scripts/?.lua;' .. package.path

local harness = {}

harness.zones = {}
harness.components = {}
harness.layouts = {}
harness.windows = {}
harness.events = {}

harness.mouse = { 640, 360 }
harness.viewRect = { 0, 0, 1920, 1080 }

-- the position the camera looks at; setting it to nil simulates a game that
-- does not let a script read the camera
harness.camera = { 0, 0 }

harness.stats = {
  setZone = 0,
  removeZone = 0,
  getEntity = 0,
}

-- entities that can be hovered on the map, used for the fallback anchor
harness.entities = {}

local function assertComponent(id)
  if harness.components[id] == nil then
    error('there is no component with the id ' .. tostring(id))
  end
end

local function parentOf(id)
  for layoutId, layout in pairs(harness.layouts) do
    for i = 1, #layout.items do
      if layout.items[i] == id then return layout.owner or layoutId end
    end
  end

  return nil
end

local componentMetatable = { __index = {
  getParent = function (self)
    local parent = parentOf(self.id)

    return parent and setmetatable({ id = parent }, getmetatable(self)) or nil
  end,
  getLayout = function (self)
    local component = harness.components[self.id]
    local layoutId = component and component.layout

    if layoutId == nil then error('component ' .. self.id .. ' has no layout') end

    return {
      id = layoutId,
      addItem = function (_, child)
        harness.gameGui.boxLayout_addItem(layoutId, type(child) == 'table' and child.id or child)
      end,
    }
  end,
  -- the layouts of the game menu can be walked: an item of a layout is a
  -- component that carries a layout of its own, and the index is zero based
  getItem = function (self, index)
    local layout = harness.layouts[self.id]
    local childId = layout and layout.items[index + 1]

    if childId == nil then
      error('there is no item ' .. tostring(index) .. ' in ' .. tostring(self.id))
    end

    return setmetatable({ id = childId }, getmetatable(self))
  end,
  addItem = function (self, child)
    self:getLayout():addItem(child)
  end,
  setFocusable = function () end,
  setMovable = function () end,
} }

-- the main buttons of the game menu are grouped; the group with the index 2 is
-- the one that ends with the bulldozer and that mods add their buttons to
function harness.createGameMenu()
  harness.components['mainButtonsLayout'] = { id = 'mainButtonsLayout', type = 'Component', classes = {} }
  harness.layouts['mainButtonsLayout'] = { id = 'mainButtonsLayout', items = {}, owner = 'mainButtonsLayout' }

  for index = 0, 2 do
    local id = 'mainButtons.group' .. index

    harness.components[id] = { id = id, type = 'Component', classes = {}, layout = id .. '.layout' }
    harness.layouts[id .. '.layout'] = { id = id .. '.layout', items = {}, owner = id }
    harness.layouts['mainButtonsLayout'].items[index + 1] = id
  end
end

-- the group of the bulldozer, which is where the button of the mod belongs
function harness.bulldozerGroup()
  return harness.layouts['mainButtons.group2.layout'].items
end

harness.gameGui = {
  component_create = function (id, name)
    harness.components[id] = { id = id, type = name, classes = {} }
  end,
  component_setLayout = function (id, layoutId)
    assertComponent(id)
    harness.components[id].layout = layoutId
    if harness.layouts[layoutId] then harness.layouts[layoutId].owner = id end
  end,
  component_setToolTip = function (id, toolTip)
    assertComponent(id)
    harness.components[id].toolTip = toolTip
  end,
  component_setStyleClassList = function (id, list)
    assertComponent(id)
    harness.components[id].classes = list
  end,
  component_setTransparent = function (id, transparent)
    assertComponent(id)
    harness.components[id].transparent = transparent
  end,
  boxLayout_create = function (id, orientation)
    harness.layouts[id] = { id = id, orientation = orientation, items = {} }
  end,
  boxLayout_addItem = function (layoutId, childId)
    local layout = harness.layouts[layoutId]

    if layout == nil then error('there is no layout with the id ' .. tostring(layoutId)) end

    assertComponent(childId)
    layout.items[#layout.items + 1] = childId
  end,
  textView_create = function (id, text)
    harness.components[id] = { id = id, type = 'TextView', text = text, classes = {} }
  end,
  textView_setText = function (id, text)
    assertComponent(id)
    harness.components[id].text = text
  end,
  button_create = function (id, contentId)
    assertComponent(contentId)
    harness.components[id] = { id = id, type = 'Button', content = contentId, classes = {} }
  end,
  window_create = function (id, title, childId)
    assertComponent(childId)
    harness.components[id] = { id = id, type = 'Window', content = childId, classes = {} }
    harness.windows[id] = { id = id, title = title, position = { 0, 0 } }
  end,
  window_close = function (id)
    harness.windows[id] = nil
    harness.components[id] = nil
  end,
  window_setPosition = function (id, x, y)
    if harness.windows[id] == nil then error('there is no window with the id ' .. tostring(id)) end
    harness.windows[id].position = { x, y }
  end,
  getContentRect = function (id)
    if id == 'mainView' then return harness.viewRect end
    if harness.components[id] == nil then error('there is no component with the id ' .. tostring(id)) end

    return { 800, 4, 30, 30 }
  end,
  calcMinimumSize = function ()
    return { 300, 280 }
  end,
  getMousePos = function ()
    return harness.mouse
  end,
  isEditor = function () return false end,
}

function harness.reset()
  harness.zones = {}
  harness.components = {}
  harness.layouts = {}
  harness.windows = {}
  harness.events = {}
  harness.camera = { 0, 0 }
  harness.stats = { setZone = 0, removeZone = 0, getEntity = 0 }

  -- the part of the game menu the mod adds its button to
  harness.createGameMenu()

  _G.game = {
    config = {},
    interface = {
      setZone = function (key, zone)
        if zone == nil then
          harness.stats.removeZone = harness.stats.removeZone + 1
          harness.zones[key] = nil
          return
        end

        harness.stats.setZone = harness.stats.setZone + 1
        harness.zones[key] = zone
      end,
      getEntity = function (id)
        harness.stats.getEntity = harness.stats.getEntity + 1
        return harness.entities[id]
      end,
      sendScriptEvent = function (id, name, param)
        harness.events[#harness.events + 1] = { id = id, name = name, param = param }
      end,
    },
    gui = harness.gameGui,
  }

  _G.api = {
    gui = {
      util = {
        getById = function (id)
          if harness.components[id] == nil then return nil end

          return setmetatable({ id = id }, componentMetatable)
        end,
      },
    },
  }

  _G._ = function (text) return text end
  _G.getCurrentModId = function () return 1 end
end

-- makes game.gui.getCamera available or removes it again
function harness.setCameraAvailable(isAvailable)
  if isAvailable then
    harness.gameGui.getCamera = function ()
      if harness.camera == nil then error('no camera') end

      return { harness.camera[1], harness.camera[2], 100 }
    end
  else
    harness.gameGui.getCamera = nil
  end
end

-- a game script runs twice: once in the context that owns the user interface
-- and once in the context that runs the simulation and writes the savegame; the
-- second one has neither game.gui nor api.gui
function harness.leaveGuiContext()
  game.gui = nil
  api.gui = nil
end

-- calls a function as the context that runs the simulation, which is how the
-- two contexts of one game script can be simulated side by side
function harness.inGameContext(fn, ...)
  local gameGui, apiGui = game.gui, api.gui

  game.gui, api.gui = nil, nil

  local ok, result = pcall(fn, ...)

  game.gui, api.gui = gameGui, apiGui

  if not ok then error(result, 0) end

  return result
end

-- forgets every module of the mod, which is what starting the game again does
function harness.freshSession()
  for name in pairs(package.loaded) do
    if name == 'gui' or name:find('^grid_overlay') then package.loaded[name] = nil end
  end
end

function harness.loadMod(params)
  local chunk = assert(loadfile(MOD .. '/mod.lua'))
  chunk()

  local mod = data()
  mod.runFn({}, { [1] = params or {} })

  return mod
end

function harness.loadGameScript()
  local chunk = assert(loadfile(MOD .. '/res/config/game_script/grid_overlay.lua'))
  chunk()

  return data()
end

function harness.countZones()
  local count = 0

  for _ in pairs(harness.zones) do count = count + 1 end

  return count
end

function harness.zonesWithPrefix(prefix)
  local result = {}

  for key, zone in pairs(harness.zones) do
    if key:sub(1, #prefix) == prefix then result[key] = zone end
  end

  return result
end

function harness.click(script, id)
  script.guiHandleEvent(id, 'button.click', nil)
end

function harness.frames(script, count)
  for _ = 1, count do
    script.guiUpdate()
  end
end

return harness

-- stand in for the gui module of the game (res/scripts/gui.lua); it offers the
-- same wrappers and forwards everything to the stubbed game.gui interface
gui = {}

gui.buttoncallbacks = {}
gui.windowcallbacks = {}

local componentMetatable = { __index = {
  setLayout = function (self, layout) game.gui.component_setLayout(self.id, layout.id) end,
  setToolTip = function (self, toolTip) game.gui.component_setToolTip(self.id, toolTip) end,
  setStyleClassList = function (self, list) game.gui.component_setStyleClassList(self.id, list) end,
  setTransparent = function (self, transparent) game.gui.component_setTransparent(self.id, transparent) end,
} }

local windowMetatable = { __index = {
  close = function (self) game.gui.window_close(self.id) end,
  setTitle = function (self, title) game.gui.window_setTitle(self.id, title) end,
  onClose = function (self, fn) gui.windowcallbacks[self.id] = fn end,
} }

local boxLayoutMetatable = { __index = {
  addItem = function (self, child) game.gui.boxLayout_addItem(self.id, child.id) end,
} }

local textViewMetatable = { __index = {
  setText = function (self, text, width) game.gui.textView_setText(self.id, text, width) end,
} }

local buttonMetatable = { __index = {
  onClick = function (self, fn) gui.buttoncallbacks[self.id] = fn end,
} }

setmetatable(windowMetatable.__index, componentMetatable)
setmetatable(textViewMetatable.__index, componentMetatable)
setmetatable(buttonMetatable.__index, componentMetatable)

local function wrap(id, metatable)
  return setmetatable({ id = id }, metatable)
end

function gui.component_create(id, name)
  game.gui.component_create(id, name)
  return wrap(id, componentMetatable)
end

function gui.component_get(id)
  return wrap(id, componentMetatable)
end

function gui.boxLayout_create(id, orientation)
  game.gui.boxLayout_create(id, orientation)
  return wrap(id, boxLayoutMetatable)
end

function gui.boxLayout_get(id)
  return wrap(id, boxLayoutMetatable)
end

function gui.textView_create(id, text, width)
  game.gui.textView_create(id, text, width)
  return wrap(id, textViewMetatable)
end

function gui.textView_get(id)
  return wrap(id, textViewMetatable)
end

function gui.button_create(id, content)
  game.gui.button_create(id, content.id)
  return wrap(id, buttonMetatable)
end

function gui.button_get(id)
  return wrap(id, buttonMetatable)
end

function gui.window_create(id, title, child)
  game.gui.window_create(id, title, child.id)
  return wrap(id, windowMetatable)
end

function gui.window_get(id)
  return wrap(id, windowMetatable)
end

return gui

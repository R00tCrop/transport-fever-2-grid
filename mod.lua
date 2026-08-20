-- the mod parameters describe what a new game starts with; everything can be
-- changed while playing in the popup of the grid button and is then stored in
-- the savegame
--
-- the values and the defaults come from the config of the mod, so the options
-- offered here and the ones offered in the popup can never drift apart
local config = require 'grid_overlay/config'

-- every option is described once: the setting it belongs to, the values it can
-- take and the texts the game shows for it
--
-- the texts are functions because the translation function of the game is only
-- available while the mod is being loaded
local options = {
  {
    key = 'gridCellSize',
    setting = 'cellSize',
    values = config.CELL_SIZES,
    uiType = 'COMBOBOX',
    name = function () return _('Cell size') end,
    tooltip = function () return _('Size of a grid cell when a game is started; it can be changed at any time with the grid button at the bottom of the screen') end,
    labels = function () return { _('50 m'), _('100 m'), _('200 m'), _('400 m'), _('800 m') } end,
  },
  {
    key = 'gridOpacity',
    setting = 'opacity',
    values = config.OPACITIES,
    uiType = 'SLIDER',
    name = function () return _('Opacity') end,
    tooltip = function () return _('How strongly the grid is drawn on top of the terrain') end,
    labels = function () return { _('25%'), _('50%'), _('75%'), _('100%') } end,
  },
  {
    key = 'gridLineWidth',
    setting = 'lineWidth',
    values = config.LINE_WIDTHS,
    uiType = 'SLIDER',
    name = function () return _('Line width') end,
    tooltip = function () return _('Width of the grid lines; wider lines stay calm when the camera is zoomed out far, thinner ones can start to shimmer') end,
    labels = function () return { _('Thin'), _('Normal'), _('Bold') } end,
  },
  {
    key = 'gridMajorEvery',
    setting = 'majorEvery',
    values = config.MAJOR_EVERY,
    uiType = 'COMBOBOX',
    name = function () return _('Emphasised lines') end,
    tooltip = function () return _('Every n-th line is drawn wider and brighter, which makes it much easier to count cells') end,
    labels = function () return { _('Off'), _('Every 5 lines'), _('Every 10 lines') } end,
  },
  {
    key = 'gridRadius',
    setting = 'radius',
    values = config.RADII,
    uiType = 'COMBOBOX',
    name = function () return _('Covered radius') end,
    tooltip = function () return _('How far the grid reaches around the camera; a larger radius costs more performance and a small cell size cannot reach the largest radii') end,
    labels = function () return { _('1000 m'), _('2000 m'), _('4000 m') } end,
  },
  {
    key = 'gridPalette',
    setting = 'palette',
    values = config.PALETTE_ORDER,
    uiType = 'COMBOBOX',
    name = function () return _('Colour') end,
    tooltip = function () return _('Colour of the grid lines') end,
    labels = function () return { _('Blue'), _('White'), _('Amber'), _('Green') } end,
  },
  {
    key = 'gridLogLevel',
    setting = 'logLevel',
    values = config.LOG_LEVELS,
    uiType = 'COMBOBOX',
    name = function () return _('Log level') end,
    tooltip = function () return _('Errors are written to the game log; debug additionally shows a panel in game that tells what the mod is doing') end,
    labels = function () return { _('Off'), _('Errors'), _('Debug') } end,
  },
}

-- the game hands the selected option over as a zero based index, so the index
-- of the default value is what the game has to be told
local function defaultIndex(option)
  local default = config.DEFAULTS[option.setting]

  for i = 1, #option.values do
    if option.values[i] == default then return i - 1 end
  end

  return 0
end

-- the value behind the option the player picked, falling back to the default of
-- the mod if the game did not hand an index over or handed an unknown one over
local function valueOf(option, index)
  return option.values[(tonumber(index) or defaultIndex(option)) + 1]
    or config.DEFAULTS[option.setting]
end

function data()
  local params = {}

  for i = 1, #options do
    local option = options[i]

    params[i] = {
      key = option.key,
      name = option.name(),
      tooltip = option.tooltip(),
      values = option.labels(),
      uiType = option.uiType,
      defaultIndex = defaultIndex(option),
    }
  end

  return {
    info = {
      minorVersion = 3,
      severityAdd = 'NONE',
      severityRemove = 'NONE',
      name = _('Name'),
      description = _('Description'),
      tags = { 'Script Mod', 'Misc' },
      authors = {
        {
          name = 'MicroBrain',
          role = 'CREATOR',
        },
      },
      params = params,
    },
    runFn = function (settings, modParams)
      -- the parameters of a mod are stored per mod id; the id is not available
      -- in every context, in which case the default values are used
      local modId = type(getCurrentModId) == 'function' and getCurrentModId() or nil
      local chosen = (modParams or {})[modId] or {}

      -- a separate state container makes sure there are no conflicts with the
      -- settings of other mods
      game.config.gridOverlay = game.config.gridOverlay or {}

      -- these values are only the starting point of a new game; everything can
      -- be changed in game afterwards and is then stored in the savegame
      local defaults = {}

      for key, value in pairs(config.DEFAULTS) do
        defaults[key] = value
      end

      for i = 1, #options do
        local option = options[i]

        defaults[option.setting] = valueOf(option, chosen[option.key])
      end

      game.config.gridOverlay.defaults = defaults
    end,
  }
end

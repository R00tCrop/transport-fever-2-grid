-- the tables below are the values behind the options of the mod parameters; the
-- game passes the selected option as a zero based index, therefore all lookups
-- add one (the labels are created inside data() since the translation function
-- is only available while the mod is being loaded)
local CELL_SIZE_VALUES = { 25, 50, 100, 200, 300, 500 }
local OPACITY_VALUES = { 0.25, 0.40, 0.55, 0.75, 1.00 }
local LINE_WIDTH_VALUES = { 1.5, 3.0, 5.0 }
local MAJOR_EVERY_VALUES = { 0, 5, 10 }
local RADIUS_VALUES = { 400, 800, 1200, 2000 }
local PALETTE_VALUES = { 'blue', 'white', 'amber', 'green' }
local LOG_LEVEL_VALUES = { 'OFF', 'ERROR', 'DEBUG' }

local function optionValue(values, index, defaultIndex)
  local value = values[(tonumber(index) or defaultIndex) + 1]

  if value == nil then return values[defaultIndex + 1] end

  return value
end

function data()
  local minorVersion = 1

  local CELL_SIZE_LABELS = { _('25 m'), _('50 m'), _('100 m'), _('200 m'), _('300 m'), _('500 m') }
  local OPACITY_LABELS = { _('25%'), _('40%'), _('55%'), _('75%'), _('100%') }
  local LINE_WIDTH_LABELS = { _('Thin'), _('Normal'), _('Bold') }
  local MAJOR_EVERY_LABELS = { _('Off'), _('Every 5 lines'), _('Every 10 lines') }
  local RADIUS_LABELS = { _('400 m'), _('800 m'), _('1200 m'), _('2000 m') }
  local PALETTE_LABELS = { _('Blue'), _('White'), _('Amber'), _('Green') }
  local LOG_LEVEL_LABELS = { _('Off'), _('Errors'), _('Debug') }

  return {
    info = {
      minorVersion = minorVersion,
      severityAdd = 'NONE',
      severityRemove = 'NONE',
      name = _('Name'),
      description = _('Description'),
      tags = { 'Script Mod', 'Misc' },
      authors = {
        {
          name = 'MrWolfZ',
          role = 'CREATOR',
        },
      },
      params = {
        {
          key = 'gridCellSize',
          name = _('Cell size'),
          tooltip = _('Size of a grid cell when a game is started; it can be changed at any time with the grid button in the game menu'),
          values = CELL_SIZE_LABELS,
          uiType = 'COMBOBOX',
          defaultIndex = 2,
        },
        {
          key = 'gridPalette',
          name = _('Colour'),
          tooltip = _('Colour of the grid lines'),
          values = PALETTE_LABELS,
          uiType = 'COMBOBOX',
          defaultIndex = 0,
        },
        {
          key = 'gridOpacity',
          name = _('Opacity'),
          tooltip = _('How strongly the grid is drawn on top of the terrain'),
          values = OPACITY_LABELS,
          uiType = 'SLIDER',
          defaultIndex = 2,
        },
        {
          key = 'gridLineWidth',
          name = _('Line width'),
          tooltip = _('Width of the grid lines; wider lines stay calm when the camera is zoomed out far, thinner ones can start to shimmer'),
          values = LINE_WIDTH_LABELS,
          uiType = 'SLIDER',
          defaultIndex = 1,
        },
        {
          key = 'gridMajorEvery',
          name = _('Emphasised lines'),
          tooltip = _('Every n-th line is drawn wider and brighter, which makes it much easier to count cells'),
          values = MAJOR_EVERY_LABELS,
          uiType = 'COMBOBOX',
          defaultIndex = 1,
        },
        {
          key = 'gridRadius',
          name = _('Covered radius'),
          tooltip = _('How far the grid reaches around the camera; a larger radius costs more performance and a small cell size cannot reach the largest radii'),
          values = RADIUS_LABELS,
          uiType = 'COMBOBOX',
          defaultIndex = 1,
        },
        {
          key = 'gridLogLevel',
          name = _('Log level'),
          tooltip = _('Errors are written to the game log; debug additionally shows a panel in game that tells what the mod is doing'),
          values = LOG_LEVEL_LABELS,
          uiType = 'COMBOBOX',
          defaultIndex = 1,
        },
      },
    },
    runFn = function (settings, modParams)
      -- the parameters of a mod are stored per mod id; the id is not available
      -- in every context, in which case the default values are used
      local modId = type(getCurrentModId) == 'function' and getCurrentModId() or nil
      local params = (modParams or {})[modId] or {}

      -- create a separate config state container to ensure there are no conflicts
      game.config.gridOverlay = game.config.gridOverlay or {}

      -- these values are only the starting point of a new game; everything can
      -- be changed in game afterwards and is then stored in the savegame
      game.config.gridOverlay.defaults = {
        enabled = false,
        cellSize = optionValue(CELL_SIZE_VALUES, params['gridCellSize'], 2),
        opacity = optionValue(OPACITY_VALUES, params['gridOpacity'], 2),
        lineWidth = optionValue(LINE_WIDTH_VALUES, params['gridLineWidth'], 1),
        majorEvery = optionValue(MAJOR_EVERY_VALUES, params['gridMajorEvery'], 1),
        radius = optionValue(RADIUS_VALUES, params['gridRadius'], 1),
        palette = optionValue(PALETTE_VALUES, params['gridPalette'], 0),
        logLevel = optionValue(LOG_LEVEL_VALUES, params['gridLogLevel'], 1),
      }
    end,
  }
end

function data()
  return {
    en = {
      Name = 'Grid',
      Description = 'Adds a "Grid" button to the bar at the bottom of the game that draws a measuring grid onto the terrain.\n'
                 .. '\n'
                 .. 'The grid makes it much easier to plan a town, to keep buildings and streets aligned and to '
                 .. 'estimate distances without having to place a street first. Every n-th line is drawn wider and '
                 .. 'brighter so that cells can be counted at a glance.\n'
                 .. '\n'
                 .. 'Clicking the button switches the grid on and off and opens a small popup in which the cell '
                 .. 'size, the colour, the opacity, the line width, the emphasised lines and the covered area can be '
                 .. 'changed at any time. All settings are stored in the savegame.\n'
                 .. '\n'
                 .. 'The grid is drawn around the camera instead of covering the whole map, which keeps the number of '
                 .. 'drawn lines constant no matter how large the map is. The lines themselves are always aligned to '
                 .. 'the world origin, so they never move while the camera is panning.\n'
                 .. '\n'
                 .. 'This mod is purely visual. It can be added to and removed from an existing savegame at any time '
                 .. 'and it does not change anything in the game itself.',
    },
  }
end

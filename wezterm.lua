local wezterm = require 'wezterm'

local function get_appearance()
  if wezterm.gui then return wezterm.gui.get_appearance() end
  return 'Dark'
end

local function scheme_for(appearance)
  if appearance:find('Dark') then
    return 'Catppuccin Mocha'
  else
    return 'Catppuccin Latte'
  end
end

return {
  color_scheme = scheme_for(get_appearance()),
  enable_tab_bar = false,

  keys = {
    -- 🪓 Ctrl+Delete: delete next word (forward)
    {
      key = 'Delete',
      mods = 'CTRL',
      action = wezterm.action.SendString('\x1b[3;5~'),
    },
    -- 🪓 Ctrl+Backspace: delete previous word (backward)
    {
      key = 'Backspace',
      mods = 'CTRL',
      action = wezterm.action.SendString('\x17'),
    },
  },
}

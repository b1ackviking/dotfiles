local wezterm = require 'wezterm'
local config = {}

config.audible_bell = 'Disabled'
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 12.5
config.color_scheme = 'Vs Code Dark+ (Gogh)'
-- config.color_scheme = 'Gruvbox Dark (Gogh)'
config.window_background_opacity = 0.95
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.enable_tab_bar = false

local mux = wezterm.mux
wezterm.on('gui-startup', function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config

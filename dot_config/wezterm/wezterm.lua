local wezterm = require 'wezterm'
local config = {}

-- WA for https://github.com/wezterm/wezterm/issues/7750
config.enable_wayland = false

config.audible_bell = 'Disabled'
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 11
config.color_scheme = 'Vs Code Dark+ (Gogh)'
-- config.color_scheme = 'Gruvbox Dark (Gogh)'
config.window_background_opacity = 0.95
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.enable_tab_bar = false

wezterm.on('gui-startup', function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.default_prog = { 'pwsh.exe', '-NoLogo' }
end

return config

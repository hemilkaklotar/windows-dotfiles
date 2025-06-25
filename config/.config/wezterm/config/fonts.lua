local wezterm = require('wezterm')
local platform = require('utils.platform')

-- local font = 'Maple Mono SC NF'
local font_family = 'GeistMono Nerd Font Mono'
local font_size = platform.is_mac and 12 or 14

return {
   font = wezterm.font({
      family = font_family,
      weight = 'Regular',
   }),
   font_size = font_size,

   --ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
   freetype_load_target = 'HorizontalLcd', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
   freetype_render_target = 'Light', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}

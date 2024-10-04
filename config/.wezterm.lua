local wezterm = require("wezterm")
local act = wezterm.action

wezterm.on("update-right-status", function(window, pane)
	-- set the right status to the active workspace with name of current workspace
	window:set_right_status(window:active_workspace())
end)

-- Configuration object
local config = {}

-- General settings
config.audible_bell = "Disabled"
config.color_scheme = "Rosé Pine (Gogh)"
-- config.color_scheme = "Catppuccin Mocha"
config.font_size = 14
config.front_end = 'OpenGL'
config.freetype_load_target = 'Light'
config.freetype_load_flags = 'NO_HINTING'
config.freetype_render_target = 'HorizontalLcd'
config.detect_password_input = true
-- Window settings
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 20,
	right = 20,
	top = 10,
	bottom = 10,
}
-- config.enable_tab_bar = false -- Enable the tab bar
config.window_close_confirmation = "NeverPrompt"
-- config.window_background_opacity = 0.5
-- config.win32_system_backdrop = "Mica"
config.warn_about_missing_glyphs = false
-- Font settings
config.font = wezterm.font_with_fallback({
	"0xProto Nerd Font",
	"JetBrainsMono Nerd Font",
	"Noto Color Emoji",
})

local function file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

-- WSL domain settings
local wsl_domains = wezterm.default_wsl_domains()
for idx, dom in ipairs(wsl_domains) do
	if dom.name == "WSL:Ubuntu-24.04" then
		dom.default_prog = { "zsh" }
	end
end
config.wsl_domains = wsl_domains

local default_prog = nil
-- Default program settings
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	local useWslUbuntu = false
	if useWslUbuntu then
		config.default_domain = "WSL:Ubuntu-24.04"
	end
	local pwsh7_path = "C:\\Program Files\\PowerShell\\7\\pwsh.exe"
	if file_exists(pwsh7_path) then
		default_prog = { pwsh7_path, "-NoLogo" }
	else
		default_prog = { "powershell.exe", "-NoLogo" }
	end
else
	default_prog = { "/bin/zsh", "-l" }
end

config.default_prog = default_prog

-- Cursor settings
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 600
config.cursor_blink_ease_out = "Linear"

-- Keybindings
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.disable_default_key_bindings = true
config.keys = {
	-- Leader key actions
	{ key = "a", mods = "CTRL|LEADER", action = wezterm.action({ SendString = "\x01" }) },
	{ key = "-", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "\\", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
	{ key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
	{ key = "H", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
	{ key = "J", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
	{ key = "K", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
	{ key = "L", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
	{ key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
	{ key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
	{ key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
	{ key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
	{ key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
	{ key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
	{ key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
	{ key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
	{ key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },
	{ key = "&", mods = "LEADER|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
	{ key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },

	-- General actions
	{ key = "n", mods = "SHIFT|CTRL", action = "ToggleFullScreen" },
	{ key = "v", mods = "SHIFT|CTRL", action = wezterm.action.PasteFrom("Clipboard") },
	{ key = "c", mods = "SHIFT|CTRL", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "+", mods = "SHIFT|CTRL", action = "IncreaseFontSize" },
	{ key = "-", mods = "SHIFT|CTRL", action = "DecreaseFontSize" },
	{ key = "_", mods = "SHIFT|CTRL", action = "DecreaseFontSize" },
	{ key = "0", mods = "SHIFT|CTRL", action = "ResetFontSize" },

	-- Custom key mappings
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Next"),
	},

	-- Close current tab
	{ key = "w", mods = "CTRL", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
}

-- Launch menu
config.launch_menu = {
	{ label = "bash", args = { "bash", "-l" } },
	{ label = "zsh", args = { "zsh", "-l" } },
}

local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config)

bar.apply_to_config(
  config,
  {
    modules = {
      spotify = {
        enabled = true,
      },
    },
  }
)

local tabbar = config.colors.tab_bar

tabbar.background = "transparent"
tabbar.active_tab.bg_color = "#26233a"
tabbar.inactive_tab.bg_color = "transparent" 
tabbar.active_tab.fg_color = "#fff" 
-- Return the configuration to wezterm
return config

local wezterm = require("wezterm")
local act = wezterm.action

-- Function to set color scheme based on appearance
function Scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

-- Configuration object
local config = {}

-- General settings
config.audible_bell = "Disabled"
config.check_for_updates = false
config.color_scheme = Scheme_for_appearance(wezterm.gui.get_appearance())
config.inactive_pane_hsb = { hue = 1.0, saturation = 1.0, brightness = 1.0 }
config.font_size = 14.0
config.detect_password_input = true
-- Window settings
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 20,
	right = 20,
	top = 10,
	bottom = 10,
}
config.enable_tab_bar = false -- Enable the tab bar
config.window_close_confirmation = "NeverPrompt"
config.window_background_opacity = 0.5
config.win32_system_backdrop = "Mica"
config.warn_about_missing_glyphs = false
-- Font settings
config.font = wezterm.font_with_fallback({
	"CaskaydiaCove Nerd Font",
	"JetBrainsMono Nerd Font",
	"Noto Color Emoji",
})

-- WSL domain settings
local wsl_domains = wezterm.default_wsl_domains()
for idx, dom in ipairs(wsl_domains) do
	if dom.name == "WSL:Ubuntu-24.04" then
		dom.default_prog = { "zsh" }
	end
end
config.wsl_domains = wsl_domains

-- Default program settings
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "powershell", "-NoLogo" }
	config.default_domain = "WSL:Ubuntu-24.04"
else
	config.default_prog = { "/bin/zsh", "-l" }
end

-- Cursor settings
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 600
config.cursor_blink_ease_out = "Linear"

-- Keybindings
config.leader = { key = "z", mods = "CTRL" }
config.disable_default_key_bindings = true
config.keys = {
	-- Leader key actions
	{ key = "z", mods = "CTRL|LEADER", action = wezterm.action({ SendString = "\x01" }) },
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

-- Return the configuration to wezterm
return config

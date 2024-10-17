local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

config.audible_bell = "Disabled"
config.color_scheme = "Navy and Ivory (terminal.sexy)"
config.font_size = 14
config.front_end = "OpenGL"
config.freetype_load_target = "Light"
config.freetype_load_flags = "NO_HINTING"
config.freetype_render_target = "HorizontalLcd"
config.detect_password_input = true
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.warn_about_missing_glyphs = false
config.font = wezterm.font_with_fallback({
	"RobotoMono Nerd Font Mono",
	"0xProto Nerd Font Mono",
	"JetBrainsMono Nerd Font",
	"Noto Color Emoji",
})

wezterm.on("toggle-background", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if wezterm.GLOBAL.background_empty == true then
		overrides.background = {
			{
				source = {
					File = wezterm.GLOBAL.background,
				},
				repeat_x = "NoRepeat",
				vertical_align = "Bottom",
				hsb = { brightness = 0.05, hue = 1, saturation = 1 },
				opacity = 1,
			},
		}
		wezterm.GLOBAL.background_empty = false
	else
		wezterm.GLOBAL.background_empty = true
		overrides.background = {}
	end
	window:set_config_overrides(overrides)
end)

wezterm.on("toggle-opacity", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 1
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

config.window_background_opacity = 0.9

local function file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

local wsl_domains = wezterm.default_wsl_domains()
for idx, dom in ipairs(wsl_domains) do
	if dom.name == "WSL:Ubuntu-24.04" then
		dom.default_prog = { "zsh" }
	end
end
config.wsl_domains = wsl_domains

local default_prog = nil
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

config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 600
config.cursor_blink_ease_out = "Linear"

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.disable_default_key_bindings = true
config.keys = {
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
	{ key = "o", mods = "CTRL|META", action = wezterm.action.EmitEvent("toggle-opacity") },
	{ key = "m", mods = "CTRL|META", action = wezterm.action.EmitEvent("toggle-background") },
	{ key = "n", mods = "SHIFT|CTRL", action = "ToggleFullScreen" },
	{ key = "v", mods = "SHIFT|CTRL", action = wezterm.action.PasteFrom("Clipboard") },
	{ key = "c", mods = "SHIFT|CTRL", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "+", mods = "SHIFT|CTRL", action = "IncreaseFontSize" },
	{ key = "-", mods = "SHIFT|CTRL", action = "DecreaseFontSize" },
	{ key = "_", mods = "SHIFT|CTRL", action = "DecreaseFontSize" },
	{ key = "0", mods = "SHIFT|CTRL", action = "ResetFontSize" },
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Next"),
	},

	{ key = "w", mods = "CTRL", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
	{
		key = "y",
		mods = "CTRL|SHIFT",
		action = act.SwitchToWorkspace({
			name = "default",
		}),
	},
	{
		key = "u",
		mods = "CTRL|SHIFT",
		action = act.SwitchToWorkspace({
			name = "work",
			spawn = {
				args = { "top" },
			},
		}),
	},
	{ key = "v", mods = "LEADER", action = act.SwitchToWorkspace },
	{
		key = "w",
		mods = "LEADER",
		action = act.ShowLauncherArgs({
			flags = "FUZZY|WORKSPACES",
		}),
	},
}

config.launch_menu = {
	{ label = "bash", args = { "bash", "-l" } },
	{ label = "zsh", args = { "zsh", "-l" } },
}

local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config)

bar.apply_to_config(config, {
	modules = {
		spotify = {
			enabled = true,
		},
	},
})

local tabbar = config.colors.tab_bar

tabbar.background = "transparent"
tabbar.active_tab.bg_color = "#26233a"
tabbar.inactive_tab.bg_color = "transparent"
tabbar.active_tab.fg_color = "#fff"
return config

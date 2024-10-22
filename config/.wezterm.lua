local wezterm = require("wezterm")
local act = wezterm.action

-- Function to get the current hour for dynamic settings
local function get_current_hour()
  return os.date("*t").hour
end

-- Dynamic opacity based on the time of day
local function get_dynamic_opacity()
  local hour = get_current_hour()
  -- Set opacity to 0.25 during the night (8 PM to 6 AM), and 0.8 during the day
  if hour >= 20 or hour < 6 then
    return 0.25
  else
    return 0.8
  end
end

-- Color variables
local opacity = get_dynamic_opacity()
local transparent_bg = "rgba(35, 38, 52, " .. opacity .. ")"
local bg_color = "#1e1e2e"
local active_tab_color = "#cba6f7"
local inactive_tab_color = "#1e1e2e"
local status_bg_color = "#313244"
local icon_color = "#f38a99"
local right_corner_color = "#1e1e2e"

local config = wezterm.config_builder()

-- Font settings
config.font = wezterm.font_with_fallback({
  "RobotoMono Nerd Font",
  {
    family = "JetBrainsMono Nerd Font",
    weight = "Regular",
  },
  "Segoe UI Emoji",
})

config.font_size = 14

-- Window settings
config.initial_rows = 30
config.initial_cols = 100
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_background_opacity = opacity
config.window_close_confirmation = "NeverPrompt"
config.win32_system_backdrop = "Tabbed"
config.max_fps = 144
config.animation_fps = 60
config.cursor_blink_rate = 250
config.front_end = "OpenGL"

-- Colors
config.force_reverse_video_cursor = true
config.color_scheme = "Catppuccin Mocha"

-- Shell
config.default_prog = { "pwsh", "-NoLogo" }

-- Tabs
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.show_tab_index_in_tab_bar = false
config.use_fancy_tab_bar = false

wezterm.on("update-right-status", function(window, pane)
  local active_workspace = window:active_workspace()
  local time = wezterm.strftime("%I:%M %p")
  local icon = "󱑍"
  local workspace_icon = "󱑽"
  local right_corner = ""
  local left_corner = ""
  window:set_right_status(wezterm.format({
    { Foreground = { Color = bg_color } },
    { Text = left_corner },
    { Background = { Color = bg_color } },
    { Foreground = { Color = icon_color } },
    { Text = icon },
    { Foreground = { Color = active_tab_color } },
    { Text = " " .. time },
    { Background = { Color = transparent_bg } },
    { Foreground = { Color = bg_color } },
    { Text = right_corner },
    { Text = " " },
    { Foreground = { Color = bg_color } },
    { Text = left_corner },
    { Background = { Color = bg_color } },
    { Foreground = { Color = icon_color } },
    { Text = workspace_icon },
    { Foreground = { Color = active_tab_color } },
    { Text = " " .. active_workspace },
    { Background = { Color = transparent_bg } },
    { Foreground = { Color = bg_color } },
    { Text = right_corner },
    { Text = " " },
  }))
end)

-- Function to format tab title
local function format_tab_title(tab, max_width)
  local index = tostring(tab.tab_index + 1)
  local title = tab.tab_title
  if title and #title > 0 then
    title = wezterm.truncate_right(title, max_width - 2)
  else
    title = wezterm.truncate_right(tab.active_pane.title, max_width - 2)
  end

  local before_tag = ""
  local after_tag = ""
  local tab_title = " " .. index .. ": " .. title

  if tab.is_active then
    return {
      { Background = { Color = transparent_bg } },
      { Foreground = { Color = active_tab_color } },
      { Text = before_tag },
      { Background = { Color = active_tab_color } },
      { Foreground = { Color = bg_color } },
      { Text = tab_title },
      { Background = { Color = transparent_bg } },
      { Foreground = { Color = active_tab_color } },
      { Text = after_tag },
      { Text = " " },
    }
  else
    return {
      { Background = { Color = transparent_bg } },
      { Foreground = { Color = bg_color } },
      { Text = before_tag },
      { Background = { Color = bg_color } },
      { Foreground = { Color = active_tab_color } },
      { Text = tab_title },
      { Background = { Color = transparent_bg } },
      { Foreground = { Color = bg_color } },
      { Text = after_tag },
      { Text = " " },
    }
  end
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  return format_tab_title(tab, max_width)
end)

config.colors = {
  tab_bar = { background = transparent_bg },
}

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
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
config.mouse_bindings = {
	-- CMD-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "ALT",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}
return config

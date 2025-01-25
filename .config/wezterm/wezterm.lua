-- Colours from https://github.com/tokyo-night/tokyo-night-vscode-theme
local wezterm = require("wezterm")
local action = wezterm.action
local config = wezterm.config_builder()

config.color_scheme = "Tokyo Night Storm"

config.use_fancy_tab_bar = false
config.enable_scroll_bar = true
config.colors = { scrollbar_thumb = "#9aa5ce" }
config.command_palette_bg_color = "#343b58"
config.audible_bell = "Disabled"
-- config.window_background_opacity = 0.9
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

wezterm.on("format-window-title", function(tab)
	return "WezTerm - " .. tab.active_pane.title
end)

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		key = "v",
		mods = "LEADER",
		action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "s",
		mods = "LEADER",
		action = action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "w",
		mods = "LEADER|CTRL",
		action = action.SendKey({ key = "w", mods = "CTRL" }),
	},
}

return config

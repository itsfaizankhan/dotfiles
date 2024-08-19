-- Colours from https://github.com/tokyo-night/tokyo-night-vscode-theme
local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Tokyo Night Storm"

config.use_fancy_tab_bar = false
config.enable_scroll_bar = true
config.colors = { scrollbar_thumb = "#24283b" }
config.command_palette_bg_color = "#343b58"
config.window_background_opacity = 0.9
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

wezterm.on("format-window-title", function(tab)
	return tab.active_pane.title
end)

return config

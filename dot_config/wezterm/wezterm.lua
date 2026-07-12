local wezterm = require("wezterm")

config = wezterm.config_builder()

-- keys
local act = wezterm.action

config.keys = {
	-- rename tab
	{
		key = "e",
		mods = "CTRL|SHIFT",
		action = act.PromptInputLine({
			description = "Rename tab",
			action = wezterm.action_callback(function(window, pane, line)
				-- line is nil if they hit Esc, empty string if they hit Enter with no text
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- hide other apps (Cmd+Opt+H, mac only)
	{
		key = "h",
		mods = "CMD|OPT",
		action = wezterm.action_callback(function()
			wezterm.background_child_process({
				"/usr/bin/osascript",
				"-e",
				'tell application "System Events" to set visible of (every process whose visible is true and frontmost is false) to false',
			})
		end),
	},
}

-- ── appearance ─────────────────────────────────────────
config.color_scheme = "Catppuccin Mocha" -- try also: "Tokyo Night", "Kanagawa (Gogh)"
config.colors = {
	background = "#0a0a0a", -- override scheme bg toward true black
}

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 13.0
config.line_height = 1.1

-- window chrome: minimal
config.window_decorations = "RESIZE" -- no title bar, still resizable
config.window_padding = {
	left = 12,
	right = 12,
	top = 12,
	bottom = 8,
}
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false -- flat tab bar when tabs exist

-- subtle transparency + blur (delete these 2 lines for solid black)
config.window_background_opacity = 0.80
config.macos_window_background_blur = 20

-- ── behavior ───────────────────────────────────────────
config.scrollback_lines = 10000
config.audible_bell = "Disabled"
return config

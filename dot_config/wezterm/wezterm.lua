local wezterm = require("wezterm")

config = wezterm.config_builder()

-- keys
local act = wezterm.action

-- Catppuccin Mocha accents
local choices = {
	{ id = "#f38ba8", label = "Red" },
	{ id = "#fab387", label = "Peach" },
	{ id = "#f9e2af", label = "Yellow" },
	{ id = "#a6e3a1", label = "Green" },
	{ id = "#74c7ec", label = "Sapphire" },
	{ id = "#cba6f7", label = "Mauve" },
	{ id = "clear", label = "Clear" },
}

local function set_tab_color(tab_id, color)
	local t = wezterm.GLOBAL.tab_colors or {}
	t[tostring(tab_id)] = color
	wezterm.GLOBAL.tab_colors = t -- reassign; in-place nested mutation doesn't stick
end

wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
	local title = tab.tab_title
	if not title or #title == 0 then
		title = tab.active_pane.title
	end
	title = " " .. (tab.tab_index + 1) .. ": " .. title .. " "

	local bg = (wezterm.GLOBAL.tab_colors or {})[tostring(tab.tab_id)]
	if not bg then
		return title
	end

	return {
		{ Background = { Color = bg } },
		{ Foreground = { Color = "#1e1e2e" } },
		{ Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
		{ Text = title },
	}
end)

config.keys = {
	-- cmd+shift+k -> pick a color for the current tab
	{
		key = "k",
		mods = "SHIFT|CMD",
		action = act.InputSelector({
			title = "Tab color",
			choices = choices,
			action = wezterm.action_callback(function(window, pane, id, label)
				if not id then
					return
				end
				set_tab_color(window:active_tab():tab_id(), id ~= "clear" and id or nil)
			end),
		}),
	},

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
	{ key = "[", mods = "CMD", action = act.ActivatePaneDirection("Prev") },
	{ key = "]", mods = "CMD", action = act.ActivatePaneDirection("Next") },

	-- tabs (iTerm2: cmd+shift+[ / cmd+shift+])
	{ key = "{", mods = "SHIFT|CMD", action = act.ActivateTabRelative(-1) },
	{ key = "}", mods = "SHIFT|CMD", action = act.ActivateTabRelative(1) },
	{ key = "d", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "d", mods = "SHIFT|CMD", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "w", mods = "SHIFT|CMD", action = act.CloseCurrentTab({ confirm = true }) },
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
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false -- flat tab bar when tabs exist

-- subtle transparency + blur (delete these 2 lines for solid black)
config.window_background_opacity = 0.80
config.macos_window_background_blur = 20

-- ── behavior ───────────────────────────────────────────
config.scrollback_lines = 10000
config.audible_bell = "Disabled"
return config

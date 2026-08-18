local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- ------------------------------------------------------------
-- Look & feel
-- ------------------------------------------------------------
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 18
config.color_scheme = "Catppuccin Mocha"
config.window_padding = {
	left = 10,
	right = 10,
	top = 10,
	bottom = 10,
}
config.window_decorations = "TITLE | RESIZE"
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true
config.enable_scroll_bar = false
config.window_close_confirmation = "NeverPrompt"

-- ------------------------------------------------------------
-- Multiplexing: eigener mux-server-Prozess als unix domain,
-- damit Panes/Tabs optional über "wezterm connect unix"
-- persistieren können (tmux-artiges detach/attach).
-- Ohne manuellen Start bleibt das Verhalten normal.
-- ------------------------------------------------------------
config.unix_domains = { { name = "unix" } }

-- ------------------------------------------------------------
-- Leader: Ctrl+a
-- ------------------------------------------------------------
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	-- Splits
	{ key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Pane-Navigation, vim-keys
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

	-- Pane-Resize, Shift+vim-keys
	{ key = "H", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "J", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "K", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "L", mods = "LEADER|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },

	-- Pane zoomen/schließen
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

	-- Tabs
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Tab-Name:",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	-- Workspaces (= tmux sessions)
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{
		key = "s",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Neue Workspace:",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
				end
			end),
		}),
	},
	{
		key = "$",
		mods = "LEADER|SHIFT",
		action = act.PromptInputLine({
			description = "Workspace umbenennen:",
			action = wezterm.action_callback(function(_, _, line)
				if line then
					wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
				end
			end),
		}),
	},

	-- Copy-Mode & Quick-Select
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = " ", mods = "LEADER", action = act.QuickSelect },

	-- Git-Workflow: lazygit in einem Split daneben
	{
		key = "g",
		mods = "LEADER",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain", args = { "lazygit" } }),
	},

	-- Config neu laden
	{ key = "r", mods = "LEADER", action = act.ReloadConfiguration },
}

-- Workspace-Name rechts in der Tab-Leiste anzeigen
wezterm.on("update-right-status", function(window, _)
	window:set_right_status(wezterm.format({
		{ Text = " " .. window:active_workspace() .. " " },
	}))
end)

return config

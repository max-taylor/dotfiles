-- Pull in the wezterm API

local wezterm = require("wezterm") --[[@as Wezterm]]
-- Import our new module (put this near the top of your wezterm.lua)
local appearance = require("appearance")
local workspaces = require("workspaces")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = "Tokyo Night"

-- if appearance.is_dark() then
--     config.color_scheme = "Tokyo Night"
-- else
--     config.color_scheme = "Tokyo Night Day"
-- end

config.initial_cols = 120
config.initial_rows = 28

config.font_size = 16

config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })

config.native_macos_fullscreen_mode = true

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Slightly transparent and blurred background
config.window_background_opacity = 0.85
config.macos_window_background_blur = 30
-- Removes the title bar, leaving only the tab bar. Keeps
-- the ability to resize by dragging the window's edges.
-- On macOS, 'RESIZE|INTEGRATED_BUTTONS' also looks nice if
-- you want to keep the window controls visible and integrate
-- them into the tab bar.
config.window_decorations = "RESIZE"

-- Sets the font for the window frame (tab bar)
---@diagnostic disable-next-line: missing-fields
config.window_frame = {
	-- Berkeley Mono for me again, though an idea could be to try a
	-- serif font here instead of monospace for a nicer look?
	---@diagnostic disable-next-line: missing-fields
	font = wezterm.font({ family = "JetBrains Mono", weight = "Bold" }),
	font_size = 18,
	active_titlebar_bg = "#0e2236",
	inactive_titlebar_bg = "#0e2236",
}

-- Replace the old wezterm.on('update-status', ... function with this:

local function segments_for_right_status(window)
	return {
		window:active_workspace(),
		wezterm.hostname(),
	}
end

wezterm.on("update-status", function(window, _)
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	local segments = segments_for_right_status(window)

	local color_scheme = window:effective_config().resolved_palette
	-- Note the use of wezterm.color.parse here, this returns
	-- a Color object, which comes with functionality for lightening
	-- or darkening the colour (amongst other things).
	local bg = wezterm.color.parse(color_scheme.background)
	local fg = color_scheme.foreground

	-- Each powerline segment is going to be coloured progressively
	-- darker/lighter depending on whether we're on a dark/light colour
	-- scheme. Let's establish the "from" and "to" bounds of our gradient.
	local gradient_to, gradient_from = bg
	if appearance.is_dark() then
		gradient_from = gradient_to:lighten(0.2)
	else
		gradient_from = gradient_to:darken(0.2)
	end

	-- Yes, WezTerm supports creating gradients, because why not?! Although
	-- they'd usually be used for setting high fidelity gradients on your terminal's
	-- background, we'll use them here to give us a sample of the powerline segment
	-- colours we need.
	local gradient = wezterm.color.gradient(
		{
			orientation = "Horizontal",
			colors = { gradient_from, gradient_to },
		},
		#segments -- only gives us as many colours as we have segments.
	)

	-- We'll build up the elements to send to wezterm.format in this table.
	local elements = {}

	for i, seg in ipairs(segments) do
		local is_first = i == 1

		if is_first then
			table.insert(elements, { Background = { Color = "none" } })
		end
		table.insert(elements, { Foreground = { Color = gradient[i] } })
		table.insert(elements, { Text = SOLID_LEFT_ARROW })

		table.insert(elements, { Foreground = { Color = fg } })
		table.insert(elements, { Background = { Color = gradient[i] } })
		table.insert(elements, { Text = " " .. seg .. " " })
	end

	window:set_right_status(wezterm.format(elements))
end)

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	-- {
	--     key = "+",
	--     mods = "CTRL",
	--     action = wezterm.action_callback(function(window, pane)
	--         local overrides = window:get_config_overrides() or {}
	--         overrides.font_size = (overrides.font_size or 12.0) + 0.5
	--         window:set_config_overrides(overrides)
	--     end),
	-- },
	-- {
	--     key = "-",
	--     mods = "CTRL",
	--     action = wezterm.action_callback(function(window, pane)
	--         local overrides = window:get_config_overrides() or {}
	--         overrides.font_size = (overrides.font_size or 12.0) - 0.5
	--         window:set_config_overrides(overrides)
	--     end),
	-- },
	{
		key = "n",
		mods = "CTRL",
		action = workspaces.choose_workspace(),
	},
	{
		key = "c",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:perform_action(
						wezterm.action.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	{
		key = "r",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Enter new workspace name:",
			action = wezterm.action_callback(function(window, _, line)
				if line and line ~= "" then
					local mux = wezterm.mux
					local workspace = mux.get_active_workspace()
					mux.rename_workspace(workspace, line)
				end
			end),
		}),
	},

	{
		key = "k",
		mods = "CTRL|SHIFT|ALT|SUPER", -- Hyper key
		action = wezterm.action_callback(function(window, pane)
			local tab = pane:tab()
			local panes = tab:panes()

			-- If we have more than one pane, close the extra ones
			if #panes > 1 then
				for _, p in ipairs(panes) do
					if p:pane_id() ~= pane:pane_id() then
						p:send_text("exit\n")
					end
				end
			else
				-- Otherwise, split right and run claude code
				window:perform_action(
					wezterm.action.SplitHorizontal({
						domain = "CurrentPaneDomain",
						-- args = { "/Users/maxtaylor/.claude/local/claude" },
					}),
					pane
				)
			end
		end),
	},

	{
		key = "g",
		mods = "LEADER",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Cells = 80 },
			command = {
				args = { "/Users/maxtaylor/Documents/Code/gitscope/gitscope" },
			},
		}),
	},
	{
		key = "x",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	{
		key = "p",
		mods = "CTRL",
		action = wezterm.action.ActivateCommandPalette,
	},

	-- { key = "h", mods = "CTRL|SHIFT|ALT|SUPER", action = wezterm.action.ActivatePaneDirection("Left") },
	-- { key = "j", mods = "CTRL|SHIFT|ALT|SUPER", action = wezterm.action.ActivatePaneDirection("Down") },
	-- { key = "k", mods = "CTRL|SHIFT|ALT|SUPER", action = wezterm.action.ActivatePaneDirection("Up") },
	-- { key = "l", mods = "CTRL|SHIFT|ALT|SUPER", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "h", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "CTRL|SHIFT", action = wezterm.action.ActivatePaneDirection("Right") },
	-- { key = "q", mods = "CTRL", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
	{ key = "f", mods = "CTRL|CMD", action = wezterm.action.ToggleFullScreen },
}

config.colors = {
	split = "#00aaff",
	tab_bar = {
		active_tab = {
			bg_color = "#2a6090",
			fg_color = "#e0e8f0",
		},
		inactive_tab = {
			bg_color = "#183050",
			fg_color = "#7a9aba",
		},
		inactive_tab_hover = {
			bg_color = "#2a5070",
			fg_color = "#e0e8f0",
		},
		new_tab = {
			bg_color = "#0e2236",
			fg_color = "#7a9aba",
		},
		new_tab_hover = {
			bg_color = "#2a5070",
			fg_color = "#e0e8f0",
		},
	},
}

-- Finally, return the configuration to wezterm:
return config

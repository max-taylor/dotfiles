local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Aerospace workspace configuration
local space_icons_map = {
	terminal = "T",
	web = "W",
	obsidian = "󰏢",
	communication = "C",
	music = "M",
	bot = "B",
}

local named_workspaces = { "terminal", "web", "obsidian", "communication", "music", "bot" }

local spaces = {}
local space_brackets = {}

-- Mouse click handler for aerospace
local function mouse_click(env)
	local workspace_name = env.NAME
	sbar.exec("aerospace workspace " .. workspace_name)
end

-- Workspace selection handler for aerospace
local function space_selection(env)
	local workspace_name = env.NAME
	local selected = env.FOCUSED_WORKSPACE == workspace_name

	local space = spaces[workspace_name]
	local bracket = space_brackets[workspace_name]

	if space then
		space:set({
			icon = { highlight = selected },
			label = { highlight = selected },
			background = { border_color = selected and colors.black or colors.bg2 },
		})
	end

	if bracket then
		bracket:set({
			background = { border_color = selected and colors.grey or colors.bg2 },
		})
	end
end

-- Create workspace items
for _, workspace_name in ipairs(named_workspaces) do
	local icon = space_icons_map[workspace_name] or workspace_name

	local space = sbar.add("item", workspace_name, {
		icon = {
			string = icon,
			padding_left = 8,
			padding_right = 8,
			color = colors.white,
			highlight_color = colors.red,
			font = { family = settings.font.text, size = 15.0 },
		},
		label = {
			padding_right = 10,
			color = colors.grey,
			highlight_color = colors.white,
			font = "sketchybar-app-font:Regular:16.0",
			y_offset = -1,
		},
		padding_right = 1,
		padding_left = 1,
		background = {
			color = colors.bg1,
			border_width = 1,
			height = 26,
			border_color = colors.black,
		},
	})

	spaces[workspace_name] = space

	-- Single item bracket for space items to achieve double border on highlight
	local space_bracket = sbar.add("bracket", { space.name }, {
		background = {
			color = colors.transparent,
			border_color = colors.bg2,
			height = 28,
			border_width = 2,
		},
	})

	space_brackets[workspace_name] = space_bracket

	-- Subscribe to aerospace events
	space:subscribe("aerospace_workspace_change", space_selection)
	space:subscribe("mouse.clicked", mouse_click)
end

-- Window observer for showing apps in each workspace
local space_window_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

local spaces_indicator = sbar.add("item", {
	padding_left = -3,
	padding_right = 0,
	icon = {
		padding_left = 8,
		padding_right = 9,
		color = colors.grey,
		string = icons.switch.on,
	},
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		string = "Spaces",
		color = colors.bg1,
	},
	background = {
		color = colors.with_alpha(colors.grey, 0.0),
		border_color = colors.with_alpha(colors.bg1, 0.0),
	},
})

-- Note: aerospace doesn't have a direct equivalent to yabai's space_windows_change
-- This functionality would need a custom event script if you want to show apps per workspace
-- For now, labels are disabled in the workspace items (label.drawing = false above)

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
	local currently_on = spaces_indicator:query().icon.value == icons.switch.on
	spaces_indicator:set({
		icon = currently_on and icons.switch.off or icons.switch.on,
	})
end)

spaces_indicator:subscribe("mouse.entered", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 1.0 },
				border_color = { alpha = 1.0 },
			},
			icon = { color = colors.bg1 },
			label = { width = "dynamic" },
		})
	end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 0.0 },
				border_color = { alpha = 0.0 },
			},
			icon = { color = colors.grey },
			label = { width = 0 },
		})
	end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_menus_and_spaces")
end)

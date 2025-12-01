local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Aerospace workspace configuration
local space_icons_map = {
	terminal = "💾",
	web = "🕸️",
	obsidian = "🪨",
	communication = "🤝",
	music = "🎧",
	bot = "🤖",
}

local named_workspaces = { "terminal", "web", "obsidian", "communication", "music", "bot" }

local spaces = {}
local space_brackets = {}

-- Mouse click handler for aerospace
local function mouse_click(env)
	-- Extract workspace name from item name (remove _mX suffix if present)
	local workspace_name = env.NAME:match("^(.+)_m%d+$") or env.NAME
	sbar.exec("aerospace workspace " .. workspace_name)
end

-- Workspace selection handler for aerospace
local function space_selection(env)
	-- Extract workspace name from item name (remove _mX suffix)
	local workspace_name = env.NAME:match("^(.+)_m%d+$") or env.NAME
	local selected = env.FOCUSED_WORKSPACE == workspace_name

	local space = spaces[env.NAME]
	local bracket = space_brackets[env.NAME]

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

-- Function to get monitor workspaces and determine main display
local function get_monitor_workspaces()
	local monitor_workspaces = {}
	local monitor_list = {}

	-- Get all monitors with both aerospace and sketchybar IDs, and their workspaces
	local handle_monitors =
		io.popen("aerospace list-monitors --format '%{monitor-id}:%{monitor-appkit-nsscreen-screens-id}'")
	if not handle_monitors then
		return nil, {}
	end
	local monitors_output = handle_monitors:read("*a")
	handle_monitors:close()

	for monitor_line in monitors_output:gmatch("[^\r\n]+") do
		local aerospace_id, sketchybar_id = monitor_line:match("^(%d+):(%d+)")
		if aerospace_id and sketchybar_id then
			table.insert(monitor_list, sketchybar_id)

			local handle_ws = io.popen("aerospace list-workspaces --monitor " .. aerospace_id)
			if handle_ws then
				local workspaces = handle_ws:read("*a")
				handle_ws:close()

				monitor_workspaces[sketchybar_id] = {}
				for workspace in workspaces:gmatch("[^\r\n]+") do
					workspace = workspace:match("^%s*(.-)%s*$") -- trim
					table.insert(monitor_workspaces[sketchybar_id], workspace)
				end
			end
		end
	end

	-- Determine main display: if more than 1 monitor, use the second one; otherwise use the first
	local main_display_id
	if #monitor_list > 1 then
		main_display_id = monitor_list[2]
	else
		main_display_id = monitor_list[1]
	end

	return main_display_id, monitor_workspaces
end

-- Helper function to check if workspace is in named list
local function is_named_workspace(name)
	for _, named in ipairs(named_workspaces) do
		if named == name then
			return true
		end
	end
	return false
end

-- Helper function to update workspace app icons
local function update_workspace_apps(workspace_name)
	-- Find all items for this workspace across monitors
	for item_name, space in pairs(spaces) do
		local ws_name = item_name:match("^(.+)_m%d+$") or item_name
		if ws_name == workspace_name then
			-- Query aerospace for windows in this workspace
			local handle =
				io.popen("aerospace list-windows --workspace " .. workspace_name .. " --format '%{app-name}'")
			if handle then
				local output = handle:read("*a")
				handle:close()

				local icon_line = ""
				local apps_seen = {}
				local no_app = true

				for app in output:gmatch("[^\r\n]+") do
					app = app:match("^%s*(.-)%s*$") -- trim
					if app ~= "" and not apps_seen[app] then
						apps_seen[app] = true
						no_app = false
						local lookup = app_icons[app]
						local icon = ((lookup == nil) and app_icons["Default"] or lookup)
						icon_line = icon_line .. icon
					end
				end

				if no_app then
					icon_line = "—"
				end

				space:set({ label = icon_line })
			end
		end
	end
end

-- Helper function to create a space item
local function create_space_item(workspace_name, monitor_id)
	local icon = space_icons_map[workspace_name] or workspace_name
	local item_name = workspace_name .. "_m" .. monitor_id

	local space = sbar.add("item", item_name, {
		display = tonumber(monitor_id),
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

	spaces[item_name] = space

	-- Single item bracket for space items to achieve double border on highlight
	local space_bracket = sbar.add("bracket", { space.name }, {
		background = {
			color = colors.transparent,
			border_color = colors.bg2,
			height = 28,
			border_width = 2,
		},
	})

	space_brackets[item_name] = space_bracket

	-- Subscribe to aerospace events
	space:subscribe("aerospace_workspace_change", space_selection)
	space:subscribe("mouse.clicked", mouse_click)

	-- Initial app icon update
	update_workspace_apps(workspace_name)
end

-- Function to rebuild all workspace items
local function rebuild_workspaces()
	-- Remove all existing space items
	for item_name, _ in pairs(spaces) do
		sbar.remove(item_name)
	end
	spaces = {}
	space_brackets = {}

	-- Get fresh workspace data
	local main_display_id, monitor_workspaces = get_monitor_workspaces()

	-- Recreate space items
	for monitor_id, workspaces in pairs(monitor_workspaces) do
		if monitor_id == main_display_id then
			-- Main display: show named workspaces first
			for _, name in ipairs(named_workspaces) do
				create_space_item(name, monitor_id)
			end

			-- Then show additional workspaces not in named list
			for _, workspace_name in ipairs(workspaces) do
				if not is_named_workspace(workspace_name) then
					create_space_item(workspace_name, monitor_id)
				end
			end
		else
			-- Secondary displays: just show available workspaces
			for _, workspace_name in ipairs(workspaces) do
				create_space_item(workspace_name, monitor_id)
			end
		end
	end
end

-- Initial build
rebuild_workspaces()

-- Subscribe to workspace changes to rebuild and update app icons
sbar.subscribe("aerospace_workspace_change", function(env)
	-- Update app icons for all workspaces
	local seen_workspaces = {}
	for item_name, _ in pairs(spaces) do
		local ws_name = item_name:match("^(.+)_m%d+$") or item_name
		if not seen_workspaces[ws_name] then
			seen_workspaces[ws_name] = true
			update_workspace_apps(ws_name)
		end
	end
end)

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

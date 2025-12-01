local colors = require("colors")

local function mouse_click(env)
    -- Extract workspace name from item name (remove _mX suffix if present)
    local workspace_name = env.NAME:match("^(.+)_m%d+$") or env.NAME
    sbar.exec("aerospace workspace " .. workspace_name)
end

local function space_selection(env)
    -- Extract workspace name from item name (remove _mX suffix)
    local workspace_name = env.NAME:match("^(.+)_m%d+$") or env.NAME
    local selected = env.FOCUSED_WORKSPACE == workspace_name
    local color = selected and colors.white or colors.bg2

    sbar.set(env.NAME, {
        icon = { highlight = selected },
        label = { highlight = selected },
        background = { border_color = color },
    })
end

-- Space configurations - map workspace names to icons
local space_icons_map = {
    terminal = "",
    web = "",
    obsidian = "󰏢",
    communication = "",
    music = "",
    bot = "",
}

-- Hardcoded named workspaces for main display
local named_workspaces = { "terminal", "web", "obsidian", "communication", "music", "bot" }

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

-- Helper function to create a space item
local function create_space_item(workspace_name, monitor_id, spaces)
    local icon = space_icons_map[workspace_name] or workspace_name
    local item_name = workspace_name .. "_m" .. monitor_id

    local space = sbar.add("item", item_name, {
        display = tonumber(monitor_id),
        icon = {
            string = icon,
            padding_left = 10,
            padding_right = 10,
            color = colors.white,
            highlight_color = colors.red,
            font = "Hack Nerd Font:Bold:15.0",
        },
        padding_left = 2,
        padding_right = 2,
        label = {
            padding_right = 20,
            color = colors.grey,
            highlight_color = colors.white,
            font = "Hack Nerd Font:Bold:15.0",
            y_offset = -1,
            drawing = false,
        },
    })

    table.insert(spaces, space.name)
    space:subscribe("aerospace_workspace_change", space_selection)
    space:subscribe("mouse.clicked", mouse_click)
end

-- Create space items
local spaces = {}

-- Function to rebuild all workspace items
local function rebuild_workspaces()
    -- Remove all existing space items
    for _, space_name in ipairs(spaces) do
        sbar.remove(space_name)
    end
    spaces = {}

    -- Get fresh workspace data
    local main_display_id, monitor_workspaces = get_monitor_workspaces()

    -- Recreate space items
    for monitor_id, workspaces in pairs(monitor_workspaces) do
        if monitor_id == main_display_id then
            -- Main display: show named workspaces first
            for _, name in ipairs(named_workspaces) do
                create_space_item(name, monitor_id, spaces)
            end

            -- Then show additional workspaces not in named list
            for _, workspace_name in ipairs(workspaces) do
                if not is_named_workspace(workspace_name) then
                    create_space_item(workspace_name, monitor_id, spaces)
                end
            end
        else
            -- Secondary displays: just show available workspaces
            for _, workspace_name in ipairs(workspaces) do
                create_space_item(workspace_name, monitor_id, spaces)
            end
        end
    end

    -- Recreate bracket
    sbar.add("bracket", spaces, {
        background = { color = colors.bg1, border_color = colors.bg2 },
    })
end

-- Initial build
rebuild_workspaces()

-- Subscribe to workspace list changes
sbar.subscribe("aerospace_workspace_change", rebuild_workspaces)

local space_creator = sbar.add("item", {
    padding_left = 10,
    padding_right = 8,
    icon = {
        string = "􀆊",
        font = {
            style = "Heavy",
            size = 16.0,
        },
    },
    label = { drawing = false },
    associated_display = "active",
})

space_creator:subscribe("mouse.clicked", function(_)
    sbar.exec("yabai -m space --create")
end)

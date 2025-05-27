local wezterm = require("wezterm") --[[@as Wezterm]]
local module = {}

-- Default workspaces configuration
module.default_workspaces = {
    { name = "dotfiles", path = "~/dotfiles" },
}

local function get_open_workspaces()
    local workspaces = {}
    for _, workspace in ipairs(wezterm.mux.get_workspace_names()) do
        table.insert(workspaces, workspace)
    end
    return workspaces
end

local function get_all_workspaces()
    local all_workspaces = {}
    local open_workspaces = get_open_workspaces()

    -- Add open workspaces first
    for _, workspace in ipairs(open_workspaces) do
        table.insert(all_workspaces, {
            name = workspace,
            path = nil, -- Unknown path for open workspaces
            is_open = true,
        })
    end

    -- Add default workspaces that aren't already open
    for _, default_ws in ipairs(module.default_workspaces) do
        local already_open = false
        for _, open_ws in ipairs(open_workspaces) do
            if open_ws == default_ws.name then
                already_open = true
                break
            end
        end

        if not already_open then
            table.insert(all_workspaces, {
                name = default_ws.name,
                path = default_ws.path,
                is_open = false,
            })
        end
    end

    return all_workspaces
end

function module.choose_workspace()
    local choices = {}
    for _, value in ipairs(get_open_workspaces()) do
        table.insert(choices, { label = value })
    end

    return wezterm.action.InputSelector({
        title = "Workspaces",
        choices = choices,
        fuzzy = true,
        action = wezterm.action_callback(function(child_window, child_pane, id, label)
            if label then
                child_window:perform_action(
                    wezterm.action.SwitchToWorkspace({
                        name = label:match("([^/]+)$"),
                        spawn = {
                            cwd = label,
                        },
                    }),
                    child_pane
                )
            end
        end),
    })
end

-- function module.choose_workspace()
--     local choices = {}
--     for _, workspace in ipairs(get_all_workspaces()) do
--         local label = workspace.name
--         if workspace.path then
--             label = workspace.path -- Use path for switching
--         end
--
--         local display_label = workspace.name
--         if workspace.is_open then
--             display_label = workspace.name .. " (open)"
--         else
--             display_label = workspace.name .. " → " .. (workspace.path or "")
--         end
--
--         table.insert(choices, {
--             label = label,
--             display = display_label,
--         })
--     end
--
--     return wezterm.action.InputSelector({
--         title = "Workspaces",
--         choices = choices,
--         fuzzy = true,
--         action = wezterm.action_callback(function(child_window, child_pane, id, label)
--             if label then
--                 child_window:perform_action(
--                     wezterm.action.SwitchToWorkspace({
--                         name = label:match("([^/]+)$"),
--                         spawn = {
--                             cwd = label,
--                         },
--                     }),
--                     child_pane
--                 )
--             end
--         end),
--     })
-- end

return module

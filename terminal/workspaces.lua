local wezterm = require("wezterm") --[[@as Wezterm]]
local module = {}

function workspace_list()
    local active = wezterm.mux.get_active_workspace()
    local workspaces = wezterm.mux.get_workspace_names()

    local projects = {}

    for i, val in ipairs(workspaces) do
        local workspace_str = i .. ": " .. val
        if active == val then
            table.insert(projects, {
                label = "[" .. workspace_str .. "]",
                active = true,
            })
        else
            table.insert(projects, {
                label = " " .. workspace_str .. " ",
                active = false,
            })
        end
    end

    return projects
end

function module.choose_project()
    local choices = {}
    for _, value in ipairs(workspace_list()) do
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

return module

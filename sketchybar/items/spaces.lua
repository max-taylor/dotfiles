local colors = require("colors")

local function mouse_click(env)
    sbar.exec("aerospace workspace " .. env.NAME)
end

local function space_selection(env)
    local selected = env.FOCUSED_WORKSPACE == env.NAME
    local color = selected and colors.white or colors.bg2

    sbar.set(env.NAME, {
        icon = { highlight = selected },
        label = { highlight = selected },
        background = { border_color = color },
    })
end

-- Space configurations
local space_names = { "terminal", "web", "obsidian", "communication", "music", "bot" }
local space_icons = { "", "", "󰏢", "", "", "" }

local spaces = {}
for i, name in ipairs(space_names) do
    local space = sbar.add("item", name, {
        icon = {
            string = space_icons[i],
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

    spaces[i] = space.name
    space:subscribe("aerospace_workspace_change", space_selection)
    space:subscribe("mouse.clicked", mouse_click)
end

sbar.add("bracket", spaces, {
    background = { color = colors.bg1, border_color = colors.bg2 },
})

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

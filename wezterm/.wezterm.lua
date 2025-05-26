-- Pull in the wezterm API
local wezterm = require("wezterm")
-- Import our new module (put this near the top of your wezterm.lua)
local appearance = require("appearance")
local projects = require("projects")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Use it!
if appearance.is_dark() then
    config.color_scheme = "Tokyo Night"
else
    config.color_scheme = "Tokyo Night Day"
end

-- config.color_scheme = "Tokyo Night"

config.initial_cols = 120
config.initial_rows = 28

config.font_size = 13

config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })

config.native_macos_fullscreen_mode = true

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

-- Slightly transparent and blurred background
config.window_background_opacity = 0.9
config.macos_window_background_blur = 30
-- Removes the title bar, leaving only the tab bar. Keeps
-- the ability to resize by dragging the window's edges.
-- On macOS, 'RESIZE|INTEGRATED_BUTTONS' also looks nice if
-- you want to keep the window controls visible and integrate
-- them into the tab bar.
config.window_decorations = "RESIZE"
-- Sets the font for the window frame (tab bar)
config.window_frame = {
    -- Berkeley Mono for me again, though an idea could be to try a
    -- serif font here instead of monospace for a nicer look?
    font = wezterm.font({ family = "JetBrains Mono", weight = "Bold" }),
    font_size = 15,
}

wezterm.on("update-status", function(window)
    -- Grab the utf8 character for the "powerline" left facing
    -- solid arrow.
    local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

    -- Grab the current window's configuration, and from it the
    -- palette (this is the combination of your chosen colour scheme
    -- including any overrides).
    local color_scheme = window:effective_config().resolved_palette
    local bg = color_scheme.background
    local fg = color_scheme.foreground

    window:set_right_status(wezterm.format({
        -- First, we draw the arrow...
        { Background = { Color = "none" } },
        { Foreground = { Color = bg } },
        { Text = SOLID_LEFT_ARROW },
        -- Then we draw our text
        { Background = { Color = bg } },
        { Foreground = { Color = fg } },
        { Text = " " .. wezterm.hostname() .. " " },
    }))
end)

for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = "LEADER",
        action = wezterm.action_callback(function(window, pane)
            projects.switch_by_id(i, window, pane)
        end),
    })
end

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
    {
        key = "f",
        mods = "LEADER",
        action = projects.choose_project(),
    },
    -- { key = "h", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Left") },
    -- { key = "j", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Down") },
    -- { key = "k", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Up") },
    -- { key = "l", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Right") },
    -- { key = "q", mods = "CTRL", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
    { key = "f", mods = "CTRL|CMD", action = wezterm.action.ToggleFullScreen },
}

-- Finally, return the configuration to wezterm:
return config

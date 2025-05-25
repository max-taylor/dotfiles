local Input = require("nui.input") -- Function to log output directly to a file

-- local font_size_table = {
-- 	["11px, 16px"] = "3xs",
-- 	["12px, 16px"] = "2xs",
-- 	["13px, 18px"] = "xs",
-- 	["14px, 18px"] = "s",
-- 	["16px, 20px"] = "base",
-- 	["18px, 22px"] = "lg",
-- 	["18px, 24px"] = "xl",
-- 	["24px, 32px"] = "2xl",
-- 	["28px, 38px"] = "3xl",
-- 	["32px, 44px"] = "4xl",
-- 	["40px, 52px"] = "5xl",
-- }

local font_size_table = {
    [12] = "xs",
    [14] = "sm",
    [16] = "base",
    [18] = "lg",
    [20] = "xl",
    [24] = "2xl",
    [30] = "3xl",
    [36] = "4xl",
    [48] = "5xl",
    [60] = "6xl",
    [72] = "7xl",
    [96] = "8xl",
    [128] = "9xl",
}

-- local function find_closest_tailwind_label(px)
-- 	local sizes = {}
-- 	for size, _ in pairs(font_size_table) do
-- 		table.insert(sizes, size)
-- 	end
--
-- 	table.sort(sizes)
--
-- 	local last_size = sizes[1]
-- 	for _, size in ipairs(sizes) do
-- 		if px < size then
-- 			return font_size_table[last_size]
-- 		end
-- 		last_size = size
-- 	end
--
-- 	return font_size_table[last_size]
-- end

local font_weight_table = {
    ["100"] = "thin",
    ["200"] = "extralight",
    ["300"] = "light",
    ["400"] = "normal",
    ["500"] = "medium",
    ["600"] = "semibold",
    ["700"] = "bold",
    ["800"] = "extrabold",
    ["900"] = "black",
}

local tailwind_colors = {
    -- Slate
    ["slate-50"] = "#f8fafc",
    ["slate-100"] = "#f1f5f9",
    ["slate-200"] = "#e2e8f0",
    ["slate-300"] = "#cbd5e1",
    ["slate-400"] = "#94a3b8",
    ["slate-500"] = "#64748b",
    ["slate-600"] = "#475569",
    ["slate-700"] = "#334155",
    ["slate-800"] = "#1e293b",
    ["slate-900"] = "#0f172a",
    ["slate-950"] = "#020617",

    -- Gray
    ["gray-50"] = "#f9fafb",
    ["gray-100"] = "#f3f4f6",
    ["gray-200"] = "#e5e7eb",
    ["gray-300"] = "#d1d5db",
    ["gray-400"] = "#9ca3af",
    ["gray-500"] = "#6b7280",
    ["gray-600"] = "#4b5563",
    ["gray-700"] = "#374151",
    ["gray-800"] = "#1f2937",
    ["gray-900"] = "#111827",
    ["gray-950"] = "#030712",

    -- Zinc
    ["zinc-50"] = "#fafafa",
    ["zinc-100"] = "#f4f4f5",
    ["zinc-200"] = "#e4e4e7",
    ["zinc-300"] = "#d4d4d8",
    ["zinc-400"] = "#a1a1aa",
    ["zinc-500"] = "#71717a",
    ["zinc-600"] = "#52525b",
    ["zinc-700"] = "#3f3f46",
    ["zinc-800"] = "#27272a",
    ["zinc-900"] = "#18181b",
    ["zinc-950"] = "#09090b",

    -- Neutral
    ["neutral-50"] = "#fafafa",
    ["neutral-100"] = "#f5f5f5",
    ["neutral-200"] = "#e5e5e5",
    ["neutral-300"] = "#d4d4d4",
    ["neutral-400"] = "#a3a3a3",
    ["neutral-500"] = "#737373",
    ["neutral-600"] = "#525252",
    ["neutral-700"] = "#404040",
    ["neutral-800"] = "#262626",
    ["neutral-900"] = "#171717",
    ["neutral-950"] = "#0a0a0a",

    -- Stone
    ["stone-50"] = "#fafaf9",
    ["stone-100"] = "#f5f5f4",
    ["stone-200"] = "#e7e5e4",
    ["stone-300"] = "#d6d3d1",
    ["stone-400"] = "#a8a29e",
    ["stone-500"] = "#78716c",
    ["stone-600"] = "#57534e",
    ["stone-700"] = "#44403c",
    ["stone-800"] = "#292524",
    ["stone-900"] = "#1c1917",
    ["stone-950"] = "#0c0a09",

    -- Red
    ["red-50"] = "#fef2f2",
    ["red-100"] = "#fee2e2",
    ["red-200"] = "#fecaca",
    ["red-300"] = "#fca5a5",
    ["red-400"] = "#f87171",
    ["red-500"] = "#ef4444",
    ["red-600"] = "#dc2626",
    ["red-700"] = "#b91c1c",
    ["red-800"] = "#991b1b",
    ["red-900"] = "#7f1d1d",
    ["red-950"] = "#450a0a",

    -- Orange
    ["orange-50"] = "#fff7ed",
    ["orange-100"] = "#ffedd5",
    ["orange-200"] = "#fed7aa",
    ["orange-300"] = "#fdba74",
    ["orange-400"] = "#fb923c",
    ["orange-500"] = "#f97316",
    ["orange-600"] = "#ea580c",
    ["orange-700"] = "#c2410c",
    ["orange-800"] = "#9a3412",
    ["orange-900"] = "#7c2d12",
    ["orange-950"] = "#431407",

    -- Amber
    ["amber-50"] = "#fffbeb",
    ["amber-100"] = "#fef3c7",
    ["amber-200"] = "#fde68a",
    ["amber-300"] = "#fcd34d",
    ["amber-400"] = "#fbbf24",
    ["amber-500"] = "#f59e0b",
    ["amber-600"] = "#d97706",
    ["amber-700"] = "#b45309",
    ["amber-800"] = "#92400e",
    ["amber-900"] = "#78350f",
    ["amber-950"] = "#451a03",

    -- Yellow
    ["yellow-50"] = "#fefce8",
    ["yellow-100"] = "#fef9c3",
    ["yellow-200"] = "#fef08a",
    ["yellow-300"] = "#fde047",
    ["yellow-400"] = "#facc15",
    ["yellow-500"] = "#eab308",
    ["yellow-600"] = "#ca8a04",
    ["yellow-700"] = "#a16207",
    ["yellow-800"] = "#854d0e",
    ["yellow-900"] = "#713f12",
    ["yellow-950"] = "#422006",

    -- Lime
    ["lime-50"] = "#f7fee7",
    ["lime-100"] = "#ecfccb",
    ["lime-200"] = "#d9f99d",
    ["lime-300"] = "#bef264",
    ["lime-400"] = "#a3e635",
    ["lime-500"] = "#84cc16",
    ["lime-600"] = "#65a30d",
    ["lime-700"] = "#4d7c0f",
    ["lime-800"] = "#3f6212",
    ["lime-900"] = "#365314",
    ["lime-950"] = "#1a2e05",

    -- Green
    ["green-50"] = "#f0fdf4",
    ["green-100"] = "#dcfce7",
    ["green-200"] = "#bbf7d0",
    ["green-300"] = "#86efac",
    ["green-400"] = "#4ade80",
    ["green-500"] = "#22c55e",
    ["green-600"] = "#16a34a",
    ["green-700"] = "#15803d",
    ["green-800"] = "#166534",
    ["green-900"] = "#14532d",
    ["green-950"] = "#052e16",

    -- Emerald
    ["emerald-50"] = "#ecfdf5",
    ["emerald-100"] = "#d1fae5",
    ["emerald-200"] = "#a7f3d0",
    ["emerald-300"] = "#6ee7b7",
    ["emerald-400"] = "#34d399",
    ["emerald-500"] = "#10b981",
    ["emerald-600"] = "#059669",
    ["emerald-700"] = "#047857",
    ["emerald-800"] = "#065f46",
    ["emerald-900"] = "#064e3b",
    ["emerald-950"] = "#022c22",

    -- Teal
    ["teal-50"] = "#f0fdfa",
    ["teal-100"] = "#ccfbf1",
    ["teal-200"] = "#99f6e4",
    ["teal-300"] = "#5eead4",
    ["teal-400"] = "#2dd4bf",
    ["teal-500"] = "#14b8a6",
    ["teal-600"] = "#0d9488",
    ["teal-700"] = "#0f766e",
    ["teal-800"] = "#115e59",
    ["teal-900"] = "#134e4a",
    ["teal-950"] = "#042f2e",

    -- Cyan
    ["cyan-50"] = "#ecfeff",
    ["cyan-100"] = "#cffafe",
    ["cyan-200"] = "#a5f3fc",
    ["cyan-300"] = "#67e8f9",
    ["cyan-400"] = "#22d3ee",
    ["cyan-500"] = "#06b6d4",
    ["cyan-600"] = "#0891b2",
    ["cyan-700"] = "#0e7490",
    ["cyan-800"] = "#155e75",
    ["cyan-900"] = "#164e63",
    ["cyan-950"] = "#083344",

    -- Sky
    ["sky-50"] = "#f0f9ff",
    ["sky-100"] = "#e0f2fe",
    ["sky-200"] = "#bae6fd",
    ["sky-300"] = "#7dd3fc",
    ["sky-400"] = "#38bdf8",
    ["sky-500"] = "#0ea5e9",
    ["sky-600"] = "#0284c7",
    ["sky-700"] = "#0369a1",
    ["sky-800"] = "#075985",
    ["sky-900"] = "#0c4a6e",
    ["sky-950"] = "#082f49",

    -- Blue
    ["blue-50"] = "#eff6ff",
    ["blue-100"] = "#dbeafe",
    ["blue-200"] = "#bfdbfe",
    ["blue-300"] = "#93c5fd",
    ["blue-400"] = "#60a5fa",
    ["blue-500"] = "#3b82f6",
    ["blue-600"] = "#2563eb",
    ["blue-700"] = "#1d4ed8",
    ["blue-800"] = "#1e40af",
    ["blue-900"] = "#1e3a8a",
    ["blue-950"] = "#172554",

    -- Indigo
    ["indigo-50"] = "#eef2ff",
    ["indigo-100"] = "#e0e7ff",
    ["indigo-200"] = "#c7d2fe",
    ["indigo-300"] = "#a5b4fc",
    ["indigo-400"] = "#818cf8",
    ["indigo-500"] = "#6366f1",
    ["indigo-600"] = "#4f46e5",
    ["indigo-700"] = "#4338ca",
    ["indigo-800"] = "#3730a3",
    ["indigo-900"] = "#312e81",
    ["indigo-950"] = "#1e1b4b",

    -- Violet
    ["violet-50"] = "#f5f3ff",
    ["violet-100"] = "#ede9fe",
    ["violet-200"] = "#ddd6fe",
    ["violet-300"] = "#c4b5fd",
    ["violet-400"] = "#a78bfa",
    ["violet-500"] = "#8b5cf6",
    ["violet-600"] = "#7c3aed",
    ["violet-700"] = "#6d28d9",
    ["violet-800"] = "#5b21b6",
    ["violet-900"] = "#4c1d95",
    ["violet-950"] = "#2e1065",

    -- Purple
    ["purple-50"] = "#faf5ff",
    ["purple-100"] = "#f3e8ff",
    ["purple-200"] = "#e9d5ff",
    ["purple-300"] = "#d8b4fe",
    ["purple-400"] = "#c084fc",
    ["purple-500"] = "#a855f7",
    ["purple-600"] = "#9333ea",
    ["purple-700"] = "#7e22ce",
    ["purple-800"] = "#6b21a8",
    ["purple-900"] = "#581c87",
    ["purple-950"] = "#3b0764",

    -- Fuchsia
    ["fuchsia-50"] = "#fdf4ff",
    ["fuchsia-100"] = "#fae8ff",
    ["fuchsia-200"] = "#f5d0fe",
    ["fuchsia-300"] = "#f0abfc",
    ["fuchsia-400"] = "#e879f9",
    ["fuchsia-500"] = "#d946ef",
    ["fuchsia-600"] = "#c026d3",
    ["fuchsia-700"] = "#a21caf",
    ["fuchsia-800"] = "#86198f",
    ["fuchsia-900"] = "#701a75",
    ["fuchsia-950"] = "#4a044e",

    -- Pink
    ["pink-50"] = "#fdf2f8",
    ["pink-100"] = "#fce7f3",
    ["pink-200"] = "#fbcfe8",
    ["pink-300"] = "#f9a8d4",
    ["pink-400"] = "#f472b6",
    ["pink-500"] = "#ec4899",
    ["pink-600"] = "#db2777",
    ["pink-700"] = "#be185d",
    ["pink-800"] = "#9d174d",
    ["pink-900"] = "#831843",
    ["pink-950"] = "#500724",

    -- Rose
    ["rose-50"] = "#fff1f2",
    ["rose-100"] = "#ffe4e6",
    ["rose-200"] = "#fecdd3",
    ["rose-300"] = "#fda4af",
    ["rose-400"] = "#fb7185",
    ["rose-500"] = "#f43f5e",
    ["rose-600"] = "#e11d48",
    ["rose-700"] = "#be123c",
    ["rose-800"] = "#9f1239",
    ["rose-900"] = "#881337",
    ["rose-950"] = "#4c0519",
}

local function hex_to_rgb(hex)
    hex = hex:gsub("#", "")
    return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

local function color_distance(r1, g1, b1, r2, g2, b2)
    return math.sqrt((r2 - r1) ^ 2 + (g2 - g1) ^ 2 + (b2 - b1) ^ 2)
end

local function find_closest_tailwind_color(input_hex)
    local r1, g1, b1 = hex_to_rgb(input_hex)
    local closest_name = nil
    local closest_dist = math.huge

    for name, hex in pairs(tailwind_colors) do
        local r2, g2, b2 = hex_to_rgb(hex)
        local dist = color_distance(r1, g1, b1, r2, g2, b2)
        if dist < closest_dist then
            closest_dist = dist
            closest_name = name
        end
    end

    return closest_name
end

local function convert_value_to_rem(value)
    local value = tonumber(value)
    if not value then
        print("Value is not a number")
        return
    end

    local rem_value = value / 16
    return rem_value
end

local function strip_px_from_value(value)
    local stripped = value:gsub("px", "")

    return stripped
end

local function build_table_off_string(string_input)
    local kv_table = {}

    -- Split the input into lines and extract key-value pairs
    for line in string_input:gmatch("[^\r\n]+") do
        local key, value = line:match("^%s*(.-)%s*:%s*(.-)%s*;?$")
        if key and value then
            kv_table[key] = value
        end
    end

    return kv_table
end

local function build_div_tag(string_input)
    local kv_table = build_table_off_string(string_input)

    local font_size = kv_table["font-size"]
    -- local line_height = kv_table["line-height"]
    local class_name = ""

    if font_size then
        local font_size_number = tonumber(strip_px_from_value(font_size))
        local font_size_value = font_size_table[font_size_number]

        if not font_size_value then
            class_name = "text-[" .. font_size_number .. "px]"
        else
            class_name = "text-" .. font_size_value
        end

        -- if not font_size_value then
        -- 	local rem_font_size = convert_value_to_rem(strip_px_from_value(font_size))
        -- 	local rem_line_height = convert_value_to_rem(strip_px_from_value(line_height))
        --
        -- 	if not rem_font_size or not rem_line_height then
        -- 		print("Rem font size or line height are not numbers")
        -- 	else
        -- 		class_name = "text-[" .. rem_font_size .. "rem] leading-[" .. rem_line_height .. "rem]"
        -- 	end
        -- else
        -- 	class_name = "text-" .. font_size_value
        -- end
    end

    local font_weight = kv_table["font-weight"]
    if font_weight then
        local font_weight_value = font_weight_table[font_weight]
        if not font_weight_value then
            print("Font weight not found in table")
        else
            if font_weight_value ~= "normal" then
                class_name = class_name .. " font-" .. font_weight_value
            end
        end
    end

    local font_family = kv_table["font-family"]
    if font_family then
        local font_family_value = font_family:sub(1, 1):lower() .. font_family:sub(2)

        class_name = class_name .. " font-" .. font_family_value
    end

    local first_div_tag = '<div className="' .. class_name .. '">'
    local full_name = first_div_tag .. "</div>"

    return {
        full_name = full_name,
        class_name = class_name,
        first_div_tag = first_div_tag,
    }
end

local function get_text_color(string_input)
    local kv_table = build_table_off_string(string_input)

    local text_color = kv_table["background"]

    if not text_color then
        print("Text color not found")
    else
        local text_color_value = find_closest_tailwind_color(text_color)
        if not text_color_value then
            print("Text color not found in table")
        else
            return "text-" .. text_color_value
        end
    end
end

local M = {}

M.setup = function()
    vim.keymap.set("n", "<leader>ct", function()
        local clipboard_content = vim.fn.getreg("+")
        local div_tag = build_div_tag(clipboard_content)
        local full_name = div_tag.full_name
        local first_div_tag = div_tag.first_div_tag

        -- Write the class name to the previous buffer and cursor position
        vim.api.nvim_put({ full_name }, "l", true, true)

        -- Calculate cursor position
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        cursor_pos[1] = cursor_pos[1] - 1
        cursor_pos[2] = #first_div_tag + 1
        vim.api.nvim_win_set_cursor(0, cursor_pos)

        -- -- Enter insert mode after the text is written
        vim.schedule(function()
            vim.api.nvim_command("normal! i")
        end)
    end, { desc = "Toggle commit popup" })
    vim.keymap.set("n", "<leader>cc", function()
        local clipboard_content = vim.fn.getreg("+")
        local color_name = get_text_color(clipboard_content)

        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        row = row - 1 -- Lua is 1-indexed, API is 0-indexed

        vim.api.nvim_buf_set_text(0, row, col, row, col, { " " .. color_name })

        -- -- Write the class name to the previous buffer and cursor position
        -- vim.api.nvim_put({ color_name }, "l", true, true)
    end, { desc = "Toggle commit popup" })
end

return M

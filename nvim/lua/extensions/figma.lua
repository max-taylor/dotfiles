local Input = require("nui.input") -- Function to log output directly to a file

local font_size_table = {
	["11px, 16px"] = "3xs",
	["12px, 16px"] = "2xs",
	["13px, 18px"] = "xs",
	["14px, 18px"] = "s",
	["16px, 20px"] = "base",
	["18px, 22px"] = "lg",
	["18px, 24px"] = "xl",
	["24px, 32px"] = "2xl",
	["28px, 38px"] = "3xl",
	["32px, 44px"] = "4xl",
	["40px, 52px"] = "5xl",
}

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

local text_color_table = {
	["#232025"] = "gray-50",
	["#2A272C"] = "gray-150",
	["#353338"] = "gray-300",
	["#3f3f3f"] = "gray-350",
	["#747276"] = "gray-400",
	["#A2A1A3"] = "gray-600",
	["#E8E7E8"] = "gray-700",
}

local textFigmaInput = Input({
	position = "50%",
	size = {
		width = 80,
		height = 30,
	},
	border = {
		style = "single",
		text = {
			top = "Commit Message",
			top_align = "center",
		},
	},
	win_options = {
		winhighlight = "Normal:Normal,FloatBorder:Normal",
	},
}, {
	prompt = "> ",
	on_close = function()
		print("Input Closed!")
	end,
	on_submit = function(string_input)
		local kv_table = {}

		-- Split the input into lines and extract key-value pairs
		for line in string_input:gmatch("[^\r\n]+") do
			local key, value = line:match("^%s*(.-)%s*:%s*(.-)%s*;?$")
			if key and value then
				kv_table[key] = value
			end
		end

		local font_size = kv_table["font-size"]
		local line_height = kv_table["line-height"]
		local class_name = ""

		if not font_size or not line_height then
			print("Font size or line height not found")
		else
			local concatted_font_string = font_size .. ", " .. line_height
			local font_size_value = font_size_table[concatted_font_string]
			if not font_size_value then
				print("Font size not found in table")
			else
				class_name = "text-" .. font_size_value
			end
		end

		local font_weight = kv_table["font-weight"]
		if not font_weight then
			print("Font weight not found")
			return
		else
			local font_weight_value = font_weight_table[font_weight]
			if not font_weight_value then
				print("Font weight not found in table")
				return
			else
				class_name = class_name .. " font-" .. font_weight_value
			end
		end

		local first_div_tag = '<div className="' .. class_name .. '">'
		local full_name = first_div_tag .. "</div>"

		-- Write the class name to the previous buffer and cursor position
		vim.api.nvim_put({ full_name }, "l", true, true)

		-- Calculate cursor position
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		cursor_pos[1] = cursor_pos[1] - 1
		cursor_pos[2] = #first_div_tag + 1
		vim.api.nvim_win_set_cursor(0, cursor_pos)

		-- -- Enter insert mode after the text is written
		-- vim.api.nvim_command("startinsert")
		-- Enter insert mode after setting cursor position
		vim.schedule(function()
			vim.api.nvim_command("normal! i")
		end)
	end,
})

local M = {}

M.setup = function()
	vim.keymap.set("n", "<leader>ct", function()
		textFigmaInput:show()
		-- Enter normal mode
		vim.api.nvim_command("stopinsert")

		vim.keymap.set("n", "q", function()
			textFigmaInput:unmount()
		end, { desc = "Close commit popup", buffer = textFigmaInput.bufnr })

		-- -- Map Command-V to paste from the clipboard in insert mode
		-- vim.keymap.set("i", "<D-v>", function()
		-- 	print("called")
		-- end, { noremap = true, silent = true, buffer = textFigmaInput.bufnr })

		-- Map Command-V to paste from the clipboard in normal mode
		vim.keymap.set("n", "v", function()
			local clipboard_content = vim.fn.getreg("+")
			vim.api.nvim_put({ clipboard_content }, "c", true, true)
		end, { noremap = true, silent = true, buffer = textFigmaInput.bufnr })
	end, { desc = "Toggle commit popup" })
end

return M

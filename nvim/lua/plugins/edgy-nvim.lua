local function is_within_cwd(filepath)
	-- Get the current working directory
	local cwd = vim.fn.getcwd()
	-- Normalize the filepath
	local normalized_path = vim.fn.fnamemodify(filepath, ":p")
	-- Check if the normalized_path starts with the cwd
	return string.sub(normalized_path, 1, #cwd) == cwd
end

local function oldfilesOpen()
	-- Function to open the old files list
	-- local bufnr = vim.api.nvim_create_buf(false, true) -- Create a new buffer
	vim.api.nvim_command("enew") -- Open a new empty buffer
	local bufnr = vim.api.nvim_get_current_buf()
	local oldfiles = vim.v.oldfiles
	local results = {}

	for _, file in ipairs(oldfiles) do
		if is_within_cwd(file) then
			table.insert(results, file)
			vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { file })
		end

		if #results == 5 then
			break
		end
	end

	-- Set the buffer's file type to 'oldfiles' (for consistency)
	vim.bo[bufnr].filetype = "oldfiles"
	vim.bo[bufnr].buftype = "nofile"
	vim.bo[bufnr].swapfile = false
	vim.bo[bufnr].modifiable = false
	-- Add keybinding on enter to open the hovered file
	vim.keymap.set("n", "<CR>", function()
		local columnPosition = vim.api.nvim_win_get_cursor(0)[1]
		local filepath = results[columnPosition]
		vim.cmd("edit " .. vim.fn.fnameescape(filepath))

		-- vim.cmd("buffer " .. vim.fn.fnameescape(filepath))
		-- vim.bo.vim.api.nvim_win_set_buf(0, vim.api.nvim_get_current_buf())
		-- print(item)
		-- vim.api.nvim_command("edit " .. oldfiles[columnPosition])
	end, { noremap = true, silent = true, buffer = bufnr })
end

return {
	{
		"folke/edgy.nvim",
		event = "VeryLazy",
		init = function()
			local edgy = require("edgy")
			vim.opt.splitkeep = "screen"

			vim.keymap.set("n", "<leader>u", function()
				edgy.toggle("left")
			end, { desc = "Toggle sidebar" })

			vim.keymap.set("n", "<leader>ut", function()
				for _, file in ipairs(vim.v.oldfiles) do
					print(file)
				end
			end, { desc = "Toggle sidebar" })
		end,
		dependencies = {
			{
				"folke/trouble.nvim",
				keys = {
					{
						"<leader>ud",
						"<cmd>Trouble diagnostics toggle<cr>",
						desc = "Diagnostics (Trouble)",
					},
					{
						"<leader>us",
						"<cmd>Trouble symbols toggle<cr>",
						desc = "Symbols (Trouble)",
					},
					-- {
					-- 	"<leader>tl",
					-- 	"<cmd>Trouble loclist toggle<cr>",
					-- 	desc = "Location List (Trouble)",
					-- },
				},
				opts = {
					open_no_results = true,
				},
				init = function()
					vim.api.nvim_create_autocmd("BufReadPost", {
						pattern = "*",
						callback = function()
							require("trouble").refresh()
						end,
					})
				end,
			},
		},
		opts = {
			options = {
				left = {
					size = 50,
				},
			},
			animate = {
				enabled = false,
			},
			close_when_all_hidden = false,
			left = {
				{
					ft = "oldfiles",
					title = "Old Files",
					size = { height = 0.4 },
					pinned = true, -- Keep the view always shown in the edgebar
					open = oldfilesOpen,
					-- wo = {
					-- 	-- Window-specific options
					-- 	number = false, -- Disable line numbers
					-- 	relativenumber = false, -- Disable relative line numbers
					-- 	cursorline = true, -- Highlight the current line
					-- },
					filter = function(buf, win)
						return vim.bo[buf].filetype == "oldfiles"
					end,
				},
				-- { ft = "qf", title = "QuickFix" },
				{
					ft = "trouble",
					pinned = true,
					title = "Troubles",
					filter = function(_buf, win)
						return vim.w[win].trouble.mode == "loclist"
					end,
					open = "Trouble loclist focus=false filter.severity=vim.diagnostic.severity.ERROR",
					size = { height = 0.4 },
				},
				-- { ft = "help", pinned = true, title = "Location List", size = { height = 0.4 } },
				-- {
				-- 	ft = "trouble",
				-- 	pinned = true,
				-- 	title = "Sidebar",
				-- 	filter = function(_buf, win)
				-- 		return vim.w[win].trouble.mode == "symbols"
				-- 	end,
				-- 	open = "Trouble symbols position=left focus=false filter.buf=0",
				-- 	size = { height = 0.6 },
				-- },
				-- {
				-- 	ft = "markdown",
				-- 	title = "Old files",
				-- 	pinned = true,
				-- 	filter = function(buf)
				-- 		return vim.fn.getbufvar(buf, "&buftype") == ""
				-- 	end,
				-- },
				-- Show current files marks
				-- {
				-- 	ft = "vim",
				-- 	pinned = true,
				-- 	title = "Marks",
				-- 	filter = function(buf)
				-- 		return vim.fn.getbufvar(buf, "&buftype") == ""
				-- 	end,
				-- 	open = "marks",
				-- 	size = { height = 0.4 },
				-- },
			},
		},
	},
}

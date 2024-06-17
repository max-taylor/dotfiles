local function print_open_windows()
	-- Get the list of currently open windows
	local windows = vim.api.nvim_list_wins()

	-- Iterate over the list of windows
	for _, win in ipairs(windows) do
		-- Get the buffer associated with the window
		local buf = vim.api.nvim_win_get_buf(win)
		-- Get the name of the buffer
		local buf_name = vim.api.nvim_buf_get_name(buf)
		-- Get the window number
		local win_number = vim.fn.win_id2win(win)
		-- Print the window number and buffer name
		print(string.format("Window %d: %s", win_number, buf_name))
	end
end

local function is_within_cwd(filepath)
	-- Get the current working directory
	local cwd = vim.fn.getcwd()
	-- Normalize the filepath
	local normalized_path = vim.fn.fnamemodify(filepath, ":p")
	-- Check if the normalized_path starts with the cwd
	return string.sub(normalized_path, 1, #cwd) == cwd
end

local function get_buffer()
	-- Get all current buffers
	local buffers = vim.api.nvim_list_bufs()

	-- Iterate over each buffer and check its file type
	for _, buf in ipairs(buffers) do
		if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "oldfiles" then
			return buf -- Return the buffer number if file type is 'oldfiles'
		end
	end

	vim.api.nvim_command("enew") -- Open a new empty buffer
	return vim.api.nvim_get_current_buf()
end

local function oldfilesOpen()
	-- Function to open the old files list
	-- local bufnr = vim.api.nvim_create_buf(false, true) -- Create a new buffer
	local bufnr = get_buffer()
	print("found", bufnr)
	vim.api.nvim_set_current_buf(bufnr)

	local oldfiles = vim.v.oldfiles
	local results = {}

	for _, file in ipairs(oldfiles) do
		if is_within_cwd(file) then
			table.insert(results, file)
		end

		if #results == 5 then
			break
		end
	end

	vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, results)

	-- Set the buffer's file type to 'oldfiles' (for consistency)
	vim.bo[bufnr].filetype = "oldfiles"
	vim.bo[bufnr].buftype = "nofile"
	vim.bo[bufnr].swapfile = false
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
		end,
		dependencies = { "folke/trouble.nvim" },
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
					ft = "trouble",
					pinned = true,
					title = "Trouble qflist",
					filter = function(_buf, win)
						-- Check if valid win
						if vim.w[win] then
							return vim.w[win].trouble.mode == "qflist"
						end

						return false
					end,
					open = "Trouble qflist focus=false filter.severity=vim.diagnostic.severity.ERROR",
					size = { height = 0.4 },
				},
				-- {
				-- 	ft = "trouble",
				-- 	pinned = true,
				-- 	title = "Troubles",
				-- 	filter = function(_buf, win)
				-- 		return vim.w[win].trouble.mode == "loclist"
				-- 	end,
				-- 	open = "Trouble loclist focus=false filter.severity=vim.diagnostic.severity.ERROR",
				-- 	size = { height = 0.4 },
				-- },
				-- {
				-- 	ft = "oldfiles",
				-- 	title = "Old Files",
				-- 	size = { height = 0.4 },
				-- 	pinned = true, -- Keep the view always shown in the edgebar
				-- 	open = oldfilesOpen,
				-- 	-- wo = {
				-- 	-- 	-- Window-specific options
				-- 	-- 	number = false, -- Disable line numbers
				-- 	-- 	relativenumber = false, -- Disable relative line numbers
				-- 	-- 	cursorline = true, -- Highlight the current line
				-- 	-- },
				-- 	filter = function(buf, win)
				-- 		return vim.bo[buf].filetype == "oldfiles"
				-- 	end,
				-- },
				-- { ft = "loclist", title = "Loclist" },
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

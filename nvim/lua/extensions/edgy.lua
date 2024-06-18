local MAX_FILES = 10

local M = {}

local function is_within_cwd(filepath)
	-- Get the current working directory
	local cwd = vim.fn.getcwd()
	-- Normalize the filepath
	local normalized_path = vim.fn.fnamemodify(filepath, ":p")
	-- Check if the normalized_path starts with the cwd
	return string.sub(normalized_path, 1, #cwd) == cwd
end

local function get_valid_winnr()
	-- Get the list of currently open windows
	local windows = vim.api.nvim_list_wins()

	-- Iterate over the list of windows
	for _, win in ipairs(windows) do
		-- Get the buffer associated with the window
		local buf = vim.api.nvim_win_get_buf(win)
		-- Get the name of the buffer
		local buf_name = vim.api.nvim_buf_get_name(buf)
		-- If buf_name is not empty then return it
		if buf_name ~= "" then
			return win
		end
	end
	-- Create a new window
	-- vim.api.nvim_command("enew")
	-- return vim.api.nvim_get_current_win()
	--
	return nil
end

local function open_file(filepath)
	local winnr = get_valid_winnr()

	-- Set focus to winnr if there is a valid one
	if winnr then
		vim.api.nvim_set_current_win(winnr)
	end

	vim.cmd.edit(vim.fn.fnameescape(filepath))
end

M.get_bufnr = function()
	if not M.bufnr then
		vim.api.nvim_command("enew") -- Open a new empty buffer
		local bufnr = vim.api.nvim_get_current_buf()

		-- Set the buffer's file type to 'oldfiles' (for consistency)
		vim.bo[bufnr].filetype = "oldfiles"
		vim.bo[bufnr].buftype = "nofile"
		vim.bo[bufnr].swapfile = false

		M.bufnr = bufnr
	end

	return M.bufnr
end

M.load_oldfiles = function()
	local oldfiles = vim.v.oldfiles
	local results = {}

	for _, file in ipairs(oldfiles) do
		local file_stat = vim.loop.fs_stat(file)

		-- Inspired by Telescope oldfiles filtering: https://github.com/nvim-telescope/telescope.nvim/blob/c392f1b78eaaf870ca584bd698e78076ed301b26/lua/telescope/builtin/__internal.lua#L547
		if
			file_stat
			and file_stat.type == "file"
			and not vim.tbl_contains(results, file)
			and vim.fn.bufwinnr(file) == -1
			and is_within_cwd(file)
		then
			table.insert(results, file)
		end

		if #results == MAX_FILES then
			break
		end
	end

	M.results = results

	for idx, filepath in ipairs(M.results) do
		vim.keymap.set("n", "<leader>u" .. idx, function()
			open_file(filepath)
		end, { noremap = true, silent = true, desc = "Open oldfile at position " .. idx })
	end

	local shortened_results = {}
	-- Remove the cwd prefix from each file path
	-- and add it to the shortened_results list
	for _, file in ipairs(results) do
		table.insert(shortened_results, vim.fn.fnamemodify(file, ":~:."))
	end

	-- replace the buffer contents with the new results
	vim.api.nvim_buf_set_lines(M.get_bufnr(), 0, -1, false, shortened_results)
end

local function open()
	-- Get the buffer
	-- vim.api.nvim_set_current_buf(bufnr)

	-- -- Check if a window is already open for the buffer
	-- local existing_win = vim.fn.bufwinnr(bufnr)
	--
	-- if existing_win == -1 then
	-- 	vim.api.nvim_open_win(bufnr, true, {
	-- 		relative = "editor",
	-- 		width = 50,
	-- 		height = 10,
	-- 		row = 1,
	-- 		col = 1,
	-- 		style = "minimal",
	-- 		border = "single",
	-- 	})
	-- end

	M.load_oldfiles()

	-- Auto command to update the list of oldfiles

	vim.api.nvim_create_autocmd({ "bufenter" }, {
		desc = "Update oldfiles sidebar auto command",
		group = vim.api.nvim_create_augroup("oldfiles_sidebar", { clear = true }),
		callback = function()
			print("Updating oldfiles")
			M.load_oldfiles()
		end,
	})

	-- Add keybinding on enter to open the hovered file
	vim.keymap.set("n", "<CR>", function()
		local columnPosition = vim.api.nvim_win_get_cursor(0)[1]
		local filepath = M.results[columnPosition]

		open_file(filepath)
	end, { noremap = true, silent = true, buffer = M.get_bufnr() })
end

M.setup = function()
	return {
		ft = "oldfiles",
		title = "Old Files",
		size = { height = 0.4 },
		pinned = true, -- Keep the view always shown in the edgebar
		open = open,
		wo = {
			-- Window-specific options
			relativenumber = false, -- Disable relative line numbers
			-- cursorline = true, -- Highlight the current line
		},
		filter = function(buf, win)
			return buf == M.bufnr
		end,
	}
end

M.focus = function()
	local existing_win = vim.fn.bufwinnr(M.bufnr)

	if existing_win ~= -1 then
		vim.api.nvim_set_current_win(existing_win)
	end
end

return M

local M = {}

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
	-- -- Create a new window
	-- vim.api.nvim_command("enew")
	--
	-- return vim.api.nvim_get_current_win()
	return nil
end

local function is_within_cwd(filepath)
	-- Get the current working directory
	local cwd = vim.fn.getcwd()
	-- Normalize the filepath
	local normalized_path = vim.fn.fnamemodify(filepath, ":p")
	-- Check if the normalized_path starts with the cwd
	return string.sub(normalized_path, 1, #cwd) == cwd
end

-- local function get_buffer()
-- 	-- Get all current buffers
-- 	local buffers = vim.api.nvim_list_bufs()
--
-- 	-- Iterate over each buffer and check its file type
-- 	for _, buf in ipairs(buffers) do
-- 		if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == "oldfiles" then
-- 			return buf -- Return the buffer number if file type is 'oldfiles'
-- 		end
-- 	end
--
-- 	vim.api.nvim_command("enew") -- Open a new empty buffer
-- 	return vim.api.nvim_get_current_buf()
-- end

local function get_or_set_buffer()
	if not M.buffer then
		vim.api.nvim_command("enew") -- Open a new empty buffer
		local bufnr = vim.api.nvim_get_current_buf()
		print("Buffer number")
		print(bufnr)
		-- Set the buffer's file type to 'oldfiles' (for consistency)
		vim.bo[bufnr].filetype = "oldfiles"
		vim.bo[bufnr].buftype = "nofile"
		vim.bo[bufnr].swapfile = false

		M.buffer = bufnr
	end

	return M.buffer
end

local function build_file_contents(bufnr)
	if M.results then
		return
	end

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

	M.results = results
	vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, results)
end

local function oldfilesOpen()
	-- Function to open the old files list
	-- local bufnr = vim.api.nvim_create_buf(false, true) -- Create a new buffer
	-- print_open_windows()
	local bufnr = get_or_set_buffer()
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

	build_file_contents(bufnr)

	-- Add keybinding on enter to open the hovered file
	vim.keymap.set("n", "<CR>", function()
		local columnPosition = vim.api.nvim_win_get_cursor(0)[1]
		local filepath = M.results[columnPosition]
		local winnr = get_valid_winnr()

		-- Set focus to winnr if there is a valid one
		if winnr then
			vim.api.nvim_set_current_win(winnr)
		end

		vim.cmd.edit(vim.fn.fnameescape(filepath))
	end, { noremap = true, silent = true, buffer = bufnr })
end

M.setup = function()
	return {
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
			return buf == M.buffer
		end,
	}
end

M.focus = function()
	local existing_win = vim.fn.bufwinnr(M.buffer)

	if existing_win ~= -1 then
		vim.api.nvim_set_current_win(existing_win)
	end
end

return M

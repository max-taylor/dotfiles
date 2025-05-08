local MAX_FILES = 7
local FILE_TYPE = "oldfiles"

local window_opts = {
	-- Window-specific options
	relativenumber = false, -- Disable relative line numbers
	winhighlight = "",
	-- cursorline = true, -- Highlight the current line
}

-- PURE functions
local function is_within_cwd(filepath)
	-- Get the current working directory
	local cwd = vim.fn.getcwd()
	-- Normalize the filepath
	local normalized_path = vim.fn.fnamemodify(filepath, ":p")
	-- Check if the normalized_path starts with the cwd
	return string.sub(normalized_path, 1, #cwd) == cwd
end

local function create_window(bufnr)
	print("Creating window", bufnr)
	return vim.api.nvim_open_win(bufnr, false, {
		relative = "editor",
		width = 1,
		height = 1,
		col = 0,
		row = 0,
	})
end

local function get_valid_winnr()
	local function is_valid_window(win)
		local buf = vim.api.nvim_win_get_buf(win)
		local buf_name = vim.api.nvim_buf_get_name(buf)
		local buftype = vim.bo[buf].buftype

		return buf_name ~= "" and buftype ~= "nofile"
	end

	-- Check the current winnr, useful if using the shortcut
	local winnr = vim.fn.win_getid()

	if is_valid_window(winnr) then
		return winnr
	end

	-- Get the list of currently open windows
	local windows = vim.api.nvim_list_wins()

	-- Iterate over the list of windows
	for _, win in ipairs(windows) do
		if is_valid_window(win) then
			return win
		end
	end

	print("No valid window found, creating a new one")
	return create_window(0)
end

local function open_file(filepath)
	local winnr = get_valid_winnr()

	vim.api.nvim_set_current_win(winnr)
	vim.cmd.edit(vim.fn.fnameescape(filepath))
end

local function format_filepath(filepath)
	local relative_path = vim.fn.fnamemodify(filepath, ":~:.")
	-- Match the pattern to split the path into the filename and directory path
	local dir, filename = relative_path:match("^(.-)([^/]-([^%.]+))$")
	-- Remove the trailing slash from the directory if it exists
	if dir:sub(-1) == "/" then
		dir = dir:sub(1, -2)
	end

	-- Return the formatted string based on whether dir is empty or not
	if dir == "" then
		return filename
	else
		return filename .. " - " .. dir
	end
end

-- Inspired by Telescope oldfiles filtering: https://github.com/nvim-telescope/telescope.nvim/blob/c392f1b78eaaf870ca584bd698e78076ed301b26/lua/telescope/builtin/__internal.lua#L547
local function validate_filepath(results, file)
	local file_stat = vim.loop.fs_stat(file)

	if
		file_stat
		and file_stat.type == "file"
		and not vim.tbl_contains(results, file)
		and vim.fn.bufwinnr(file) == -1
		and is_within_cwd(file)
	then
		return true
	end

	return false
end

local function get_oldfiles()
	local oldfiles = vim.v.oldfiles
	local results = {}

	-- local open_buffers = vim.api.nvim_list_bufs()
	-- Get detailed information about all buffers
	local buffers_info = vim.fn.getbufinfo()

	-- Sort buffers by last accessed time in descending order
	table.sort(buffers_info, function(a, b)
		return a.lastused > b.lastused
	end)

	for _, buf in ipairs(buffers_info) do
		local file = vim.api.nvim_buf_get_name(buf.bufnr)
		if #results == MAX_FILES then
			break
		end

		if validate_filepath(results, file) then
			table.insert(results, file)
		end
	end

	for _, file in ipairs(oldfiles) do
		if #results == MAX_FILES then
			break
		end

		if validate_filepath(results, file) then
			table.insert(results, file)
		end
	end

	return results
end

-- Module
local M = {}

M.get_bufnr = function()
	if not M.bufnr then
		vim.api.nvim_command("enew") -- Open a new empty buffer
		local bufnr = vim.api.nvim_get_current_buf()

		-- Set the buffer's file type to 'oldfiles' (for consistency)
		vim.bo[bufnr].filetype = FILE_TYPE
		vim.bo[bufnr].buftype = "nofile"
		vim.bo[bufnr].swapfile = false

		-- Get the buffer
		-- vim.api.nvim_set_current_buf(bufnr)

		M.bufnr = bufnr
	end

	-- Check if a window is already open for the buffer
	local existing_win = vim.fn.bufwinnr(M.bufnr)

	if existing_win == -1 then
		create_window(M.bufnr)
	end

	return M.bufnr
end

M.load_oldfiles = function()
	M.results = get_oldfiles()

	-- TODO: Move this into M.open and have it run only once
	for idx, filepath in ipairs(M.results) do
		vim.keymap.set("n", "<leader>u" .. idx, function()
			open_file(filepath)
		end, { noremap = true, silent = true, desc = "Open oldfile at position " .. idx })
	end

	local shortened_results = {}
	-- Remove the cwd prefix from each file path
	-- and add it to the shortened_results list
	for _, file in ipairs(M.results) do
		table.insert(shortened_results, format_filepath(file))
	end

	-- replace the buffer contents with the new results
	vim.api.nvim_buf_set_lines(M.get_bufnr(), 0, -1, false, shortened_results)
end

M.open = function()
	M.load_oldfiles()

	-- Auto command to update the list of oldfiles
	vim.api.nvim_create_autocmd({ "bufenter" }, {
		desc = "Update oldfiles sidebar auto command",
		group = vim.api.nvim_create_augroup("oldfiles_sidebar", { clear = true }),
		callback = function()
			-- Only call update if the buffer is open
			if vim.fn.bufwinnr(M.bufnr) ~= -1 then
				M.load_oldfiles()
			end
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
		ft = FILE_TYPE,
		title = "Old Files",
		size = { height = 0.4 },
		pinned = true, -- Keep the view always shown in the edgebar
		open = M.open,
		wo = window_opts,
		filter = function(buf)
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

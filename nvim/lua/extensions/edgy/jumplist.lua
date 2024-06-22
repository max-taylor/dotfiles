local M = {}

local FILE_TYPE = "jumplist"

local NUM_FILES = 5

local function get_files(jumplist, direction, last_jump_idx)
	local results = {}
	local current_idx = last_jump_idx
	if direction == "next" then
		current_idx = current_idx + 1
	else
		current_idx = current_idx - 1
	end

	while current_idx < #jumplist + 1 and current_idx > 0 and #results < NUM_FILES do
		print("Current idx", current_idx, "last_jump_idx", last_jump_idx, "jumplist length", #jumplist)

		local jump = jumplist[current_idx]

		local file = vim.fn.bufname(jump.bufnr)
		print("file", file)

		if direction == "next" then
			current_idx = current_idx + 1
		else
			current_idx = current_idx - 1
		end

		table.insert(results, file)
	end

	return results
end

M.get_bufnr = function()
	if not M.bufnr then
		vim.api.nvim_command("enew") -- Open a new empty buffer
		local bufnr = vim.api.nvim_get_current_buf()

		-- Set the buffer's file type to 'oldfiles' (for consistency)
		vim.bo[bufnr].filetype = FILE_TYPE
		vim.bo[bufnr].buftype = "nofile"
		vim.bo[bufnr].swapfile = false

		M.bufnr = bufnr
	end

	-- Check if a window is already open for the buffer
	local existing_win = vim.fn.bufwinnr(M.bufnr)

	if existing_win == -1 then
		vim.api.nvim_open_win(M.bufnr, false, {
			relative = "editor",
			width = 1,
			height = 1,
			col = 0,
			row = 0,
			-- style = "minimal",
		})
	end

	return M.bufnr
end

M.update = function()
	-- Get the current jumplist
	-- TODO: Need to detect the main window and get the jumplist from there, when we navigate from code windows to nvim-tree or whatever we need to remember what was the previous legit buffer and associated winId, so the content is correct
	local jumplist = vim.fn.getjumplist()
	print("Jumplist", #jumplist[1], "last jump", jumplist[2])

	local last_jump_idx = jumplist[2]

	local forward_files = get_files(jumplist[1], "next", last_jump_idx)
	local backward_files = get_files(jumplist[1], "prev", last_jump_idx)

	-- for idx, jump in ipairs(jumplist[1]) do
	-- 	local file = vim.api.nvim_buf_get_name(jump.bufnr)
	--
	-- 	print("Jump ", jump.lnum, "file", file)
	-- end

	-- Get the buffer number
	local bufnr = M.get_bufnr()

	-- replace the buffer contents with the forward files first and then the backward files
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, forward_files)
	vim.api.nvim_buf_set_lines(bufnr, #forward_files, #forward_files, false, { "Current file" })
	vim.api.nvim_buf_set_lines(bufnr, #forward_files + 1, -1, false, backward_files)
end

local function open()
	print("Opening jumplist")
	-- When it opens it selects the left most window valid code window and stores the window id as the "last valid" window id
	-- When a new buffer is entered check if its a valid code window
	M.update()

	vim.api.nvim_create_autocmd({ "bufenter" }, {
		desc = "Update oldfiles sidebar auto command",
		group = vim.api.nvim_create_augroup("oldfiles_sidebar", { clear = true }),
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			local buftype = vim.bo[bufnr].buftype
			print("BufEnter", bufnr, buftype)
			if buftype == "" then
				-- It's a valid code window
				-- Update the jumplist
				M.update()
			end
		end,
	})
end

M.setup = function()
	return {
		ft = FILE_TYPE,
		title = "Jump list",
		size = { height = 0.4 },
		pinned = true, -- Keep the view always shown in the edgebar
		open = open,
		wo = {
			-- Window-specific options
			relativenumber = false, -- Disable relative line numbers
			-- cursorline = true, -- Highlight the current line
		},
		filter = function(buf)
			return buf == M.bufnr
		end,
	}
end

return M

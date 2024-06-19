local M = {}

local FILE_TYPE = "jumplist"

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

	return M.bufnr
end

M.update = function()
	-- Get the current jumplist
	-- TODO: Need to detect the main window and get the jumplist from there, when we navigate from code windows to nvim-tree or whatever we need to remember what was the previous legit buffer and associated winId, so the content is correct
	local jumplist = vim.fn.getjumplist()

	local last_jump = jumplist[2]
	print("Last", last_jump)
	for idx, jump in ipairs(jumplist[1]) do
		local file = vim.api.nvim_buf_get_name(jump.bufnr)

		print("Jump ", jump.lnum, "file", file)
	end

	-- Get the buffer number
	local bufnr = M.get_bufnr()
	-- vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, jumplist)
end

local function open()
	M.update()
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

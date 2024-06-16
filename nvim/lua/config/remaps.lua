vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- exit terminal mode in the builtin terminal with a shortcut
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "exit terminal mode" })

-- keybinds to make split navigation easier.
--  use ctrl+<hjkl> to switch between windows
--
--  see `:help wincmd` for a list of all window commands
-- vim.keymap.set('n', '<c-h>', '<c-w><c-h>', { desc = 'move focus to the left window' })
-- vim.keymap.set('n', '<c-l>', '<c-w><c-l>', { desc = 'move focus to the right window' })
-- vim.keymap.set('n', '<c-j>', '<c-w><c-j>', { desc = 'move focus to the lower window' })
-- vim.keymap.set('n', '<c-k>', '<c-w><c-k>', { desc = 'move focus to the upper window' })
--
local function navigate_wrap(direction)
	-- Get the current window's ID
	local cur_win = vim.api.nvim_get_current_win()

	-- Try moving in the specified direction
	vim.cmd("wincmd " .. direction)

	-- -- Log all the open windows
	-- local windows = vim.api.nvim_list_wins()
	-- print(vim.inspect(windows))
	-- -- Find the left most window
	-- local left_most_win = windows[1]
	-- for _, win in ipairs(windows) do
	-- 	if vim.api.nvim_win_get_config(win).relative == "" then
	-- 		left_most_win = win
	-- 		break
	-- 	end
	-- end

	-- -- If the current window hasn't changed, we're at the edge and need to wrap
	-- if cur_win == vim.api.nvim_get_current_win() then
	-- 	-- Move to the farthest window in the opposite direction
	-- 	local opposite_directions = { h = "l", j = "k", k = "j", l = "h" }
	-- 	vim.cmd("wincmd " .. opposite_directions[direction])
	-- end
end

-- local function navigate_wrap(direction)
--   -- This function attempts to move to the nvim-tree window if it exists
--   -- and is in the direction of navigation wrap. Otherwise, it wraps the navigation.
--   local cur_win = vim.api.nvim_get_current_win()
--   local windows = vim.api.nvim_list_wins()
--
--   -- Attempt normal navigation
--   vim.cmd('wincmd ' .. direction)
--   if cur_win == vim.api.nvim_get_current_win() then
--     -- Determine if nvim-tree is open and its window ID
--     local nvim_tree_win = nil
--     for _, win in ipairs(windows) do
--       local buf = vim.api.nvim_win_get_buf(win)
--       local buftype = vim.api.nvim_buf_get_option(buf, 'filetype')
--       if buftype == 'NvimTree' then
--         nvim_tree_win = win
--         break
--       end
--     end
--
--     -- Navigation logic considering nvim-tree
--     if nvim_tree_win and direction == 'h' then
--       vim.api.nvim_set_current_win(nvim_tree_win)
--     elseif nvim_tree_win and direction == 'l' then
--       -- If moving right and nvim-tree is open, do nothing special
--       -- This is because wrapping to nvim-tree which typically is at the left doesn't make sense
--     else
--       -- If nvim-tree is not relevant to the direction, do normal wrap
--       local opposite_directions = { h = 'l', j = 'k', k = 'j', l = 'h' }
--       vim.cmd('wincmd ' .. opposite_directions[direction])
--     end
--   end
-- end

-- Set up the keybindings with the custom navigation function
vim.keymap.set("n", "<C-h>", function()
	navigate_wrap("h")
end, { desc = "Move focus to the left window (wrap)" })
vim.keymap.set("n", "<C-l>", function()
	navigate_wrap("l")
end, { desc = "Move focus to the right window (wrap)" })
vim.keymap.set("n", "<C-j>", function()
	navigate_wrap("j")
end, { desc = "Move focus to the lower window (wrap)" })
vim.keymap.set("n", "<C-k>", function()
	navigate_wrap("k")
end, { desc = "Move focus to the upper window (wrap)" })

-- Rebind <Tab> in insert mode to accept copilot suggestions if available
vim.keymap.set("i", "<C-l>", function()
	if require("copilot.suggestion").is_visible() then
		require("copilot.suggestion").accept()
	end
end, {
	silent = true,
})

-- Modify save keybinds
-- Rebind save to <C-s> in normal and insert mode
vim.keymap.set("n", "<C-s>", ":update<cr>")
-- <C-o> exits insert mode temporarily to execute a single normal mode command in this case saving
-- Also exiting insert mode here
vim.keymap.set("i", "<C-s>", "<C-O>:update<cr><Esc>")

-- Rebind quit window to <C-q>
vim.keymap.set("n", "<C-q>", "<C-w>q")

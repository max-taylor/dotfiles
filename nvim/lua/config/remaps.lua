vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- exit terminal mode in the builtin terminal with a shortcut
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "exit terminal mode" })

local function navigate_wrap(direction)
	vim.cmd("wincmd " .. direction)
end

-- Keybinds to make split navigation easier.
--  use ctrl+<hjkl> to switch between windows
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

-- Diagnostic keymaps
vim.keymap.set("n", "xk", vim.diagnostic.goto_prev, { desc = "Goto previous diagnostic message" })
vim.keymap.set("n", "xj", vim.diagnostic.goto_next, { desc = "Goto next diagnostic message" })
vim.keymap.set("n", "xh", vim.lsp.buf.code_action, { desc = "Show code actions" })
vim.keymap.set("n", "xl", function()
	vim.diagnostic.goto_next()
	vim.lsp.buf.code_action()
end, { desc = "Goto Next [L]ocation with show code actions" })
vim.keymap.set("n", "xm", vim.diagnostic.open_float, { desc = "show diagnostic [e]rror messages" })

vim.keymap.set("n", "xq", vim.diagnostic.setloclist, { desc = "Open diagnostic loclist" })
-- Add the TSC keymaps
vim.keymap.set("n", "xr", ":TSC<CR>", { desc = "TSC Run" })

-- Diagnostic keymaps
vim.keymap.set("n", "xk", vim.diagnostic.goto_prev, { desc = "Goto previous diagnostic message" })
vim.keymap.set("n", "xj", vim.diagnostic.goto_next, { desc = "Goto next diagnostic message" })
vim.keymap.set("n", "xq", vim.diagnostic.setloclist, { desc = "Open diagnostic loclist" })
vim.keymap.set("n", "xh", vim.lsp.buf.code_action, { desc = "Show code actions" })
vim.keymap.set("n", "xl", function()
	vim.diagnostic.goto_next()
	vim.lsp.buf.code_action()
end, { desc = "Goto Next [L]ocation with show code actions" })
vim.keymap.set("n", "xm", vim.diagnostic.open_float, { desc = "show diagnostic [e]rror messages" })

-- Add the TSC keymaps
vim.keymap.set("n", "xr", ":TSC<CR>", { desc = "TSC Run" })

return {
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"<leader>uf",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Trouble Quickfix toggle",
			},
			-- {
			-- 	"<leader>us",
			-- 	"<cmd>Trouble loclist toggle<cr>",
			-- 	desc = "Trouble Loclist toggle",
			-- },
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
	{
		"dmmulroy/tsc.nvim",
		init = function()
			require("tsc").setup({
				use_trouble_qflist = true,
				-- auto_start_watch_mode = true,
				auto_open_qflist = false,
				-- flags = { watch = true },
				enable_progress_notifications = true,
			})
		end,
	},
}

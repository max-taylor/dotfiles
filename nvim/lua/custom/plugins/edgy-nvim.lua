return {
	-- {
	-- 	"folke/edgy.nvim",
	-- 	event = "VeryLazy",
	-- 	init = function()
	-- 		vim.opt.laststatus = 3
	-- 		vim.opt.splitkeep = "screen"
	-- 	end,
	-- 	keys = {
	-- 		{
	-- 			"<leader>ue",
	-- 			function()
	-- 				require("edgy").open()
	-- 			end,
	-- 			desc = "Edgy Toggle",
	-- 		},
	-- 		{
	-- 			"<leader>uE",
	-- 			function()
	-- 				require("edgy").select()
	-- 			end,
	-- 			desc = "Edgy Select Window",
	-- 		},
	-- 	},
	-- 	opts = {
	-- 		bottom = {
	-- 			{
	-- 				ft = "toggleterm",
	-- 				size = { height = 1 },
	-- 				-- exclude floating windows
	-- 				filter = function(buf, win)
	-- 					return vim.api.nvim_win_get_config(win).relative == ""
	-- 				end,
	-- 			},
	-- 			-- { ft = "qf", title = "QuickFix" },
	-- 			-- {
	-- 			-- 	ft = "help",
	-- 			-- 	size = { height = 20 },
	-- 			-- 	-- only show help buffers
	-- 			-- 	filter = function(buf)
	-- 			-- 		return vim.bo[buf].buftype == "help"
	-- 			-- 	end,
	-- 			-- },
	-- 		},
	-- 		left = {
	-- 			{ ft = "qf", title = "QuickFix" },
	-- 			-- {
	-- 			-- 	ft = "Outline",
	-- 			-- 	pinned = true,
	-- 			-- 	open = "SymbolsOutlineOpen",
	-- 			-- },
	-- 		},
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
		dependencies = {
			{
				"folke/trouble.nvim",
				keys = {
					{
						"<leader>tm",
						"<cmd>Trouble diagnostics toggle<cr>",
						desc = "Diagnostics (Trouble)",
					},
					{
						"<leader>ts",
						"<cmd>Trouble symbols toggle<cr>",
						desc = "Symbols (Trouble)",
					},
					{
						"<leader>tl",
						"<cmd>Trouble loclist toggle<cr>",
						desc = "Location List (Trouble)",
					},
				},
				opts = {}, -- for default options, refer to the configuration section for custom setup.
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
			close_when_all_hidden = true,
			left = {

				-- Neo-tree filesystem always takes half the screen height
				{
					ft = "trouble",
					pinned = true,
					title = "Sidebar",
					filter = function(_buf, win)
						return vim.w[win].trouble.mode == "symbols"
					end,
					open = "Trouble symbols position=left focus=false filter.buf=0",
					size = { height = 0.6 },
				},
				{
					ft = "trouble",
					pinned = true,
					title = "Troubles",
					filter = function(_buf, win)
						return vim.w[win].trouble.mode == "diagnostics"
					end,
					open = "Trouble diagnostics focus=false filter.severity=vim.diagnostic.severity.ERROR",
					size = { height = 0.4 },
				},
			},
		},
	},
}

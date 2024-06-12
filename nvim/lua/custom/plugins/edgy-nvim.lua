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
		dependencies = {
			{
				"folke/trouble.nvim",
				keys = {
					{
						"<leader>ud",
						"<cmd>Trouble diagnostics toggle<cr>",
						desc = "Diagnostics (Trouble)",
					},
					{
						"<leader>us",
						"<cmd>Trouble symbols toggle<cr>",
						desc = "Symbols (Trouble)",
					},
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
		},
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
					title = "Troubles",
					filter = function(_buf, win)
						return vim.w[win].trouble.mode == "diagnostics"
					end,
					open = "Trouble diagnostics focus=false filter.severity=vim.diagnostic.severity.ERROR",
					size = { height = 0.4 },
				},
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

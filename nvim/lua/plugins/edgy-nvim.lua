local lualine_extensions = require("extensions.lualine")

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

			-- vim.keymap.set("n", "<leader>uo", function()
			-- 	lualine_extensions.focus()
			-- end, { desc = "Toggle sidebar" })
		end,
		dependencies = { "folke/trouble.nvim" },
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
					title = "Trouble qflist",
					filter = function(_buf, win)
						-- Check if valid win
						if vim.w[win] then
							return vim.w[win].trouble.mode == "qflist"
						end

						return false
					end,
					open = "Trouble qflist focus=false filter.severity=vim.diagnostic.severity.ERROR",
					size = { height = 0.4 },
				},
				-- {
				-- 	ft = "trouble",
				-- 	pinned = true,
				-- 	title = "Troubles",
				-- 	filter = function(_buf, win)
				-- 		return vim.w[win].trouble.mode == "loclist"
				-- 	end,
				-- 	open = "Trouble loclist focus=false filter.severity=vim.diagnostic.severity.ERROR",
				-- 	size = { height = 0.4 },
				-- },
				-- lualine_extensions.setup(),
				-- { ft = "loclist", title = "Loclist" },
				-- { ft = "help", pinned = true, title = "Location List", size = { height = 0.4 } },
				-- {
				-- 	ft = "trouble",
				-- 	pinned = true,
				-- 	title = "Sidebar",
				-- 	filter = function(_buf, win)
				-- 		return vim.w[win].trouble.mode == "symbols"
				-- 	end,
				-- 	open = "Trouble symbols position=left focus=false filter.buf=0",
				-- 	size = { height = 0.6 },
				-- },
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

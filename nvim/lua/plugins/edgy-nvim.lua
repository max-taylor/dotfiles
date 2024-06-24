local oldfiles_edgy = require("extensions.edgy.oldfiles")
local jumplist_edgy = require("extensions.edgy.jumplist")

return {
	{
		"folke/edgy.nvim",
		event = "VeryLazy",
		init = function()
			local edgy = require("edgy")
			vim.opt.splitkeep = "screen"

			vim.keymap.set("n", "<leader>ut", function()
				edgy.toggle("left")
			end, { desc = "[T]oggle edgy" })

			vim.keymap.set("n", "<leader>us", function()
				edgy.select("left")
			end, { desc = "[S]elect edgy view" })

			-- Remove background for EdgyNormal
			-- Set highlight groups without a background color
			-- vim.api.nvim_set_hl(0, "EdgyWinBar", { guibg = "NONE", guifg = "#D8DEE9" })
			-- vim.api.nvim_set_hl(0, "EdgyWinBarNC", { guibg = "NONE", guifg = "#D8DEE9" })
			-- vim.api.nvim_set_hl(0, "EdgyNormal", { guibg = "NONE", guifg = "#D8DEE9" })

			-- vim.keymap.set("n", "<leader>uo", function()
			-- 	edgy.select("left", "Old files")
			-- end, { desc = "Focus oldfiles" })
		end,
		dependencies = { "folke/trouble.nvim" },
		opts = {
			options = {
				left = {
					size = 40,
				},
			},
			wo = {
				winbar = false,
			},
			animate = {
				enabled = false,
			},
			close_when_all_hidden = false,
			left = {
				-- oldfiles_edgy.setup(),
				-- jumplist_edgy.setup(),
				{
					ft = "trouble",
					pinned = true,
					title = "Trouble qflist",
					filter = function(_buf, win)
						-- Check if the window exists and if trouble exists on it
						if vim.w[win] and vim.w[win].trouble then
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

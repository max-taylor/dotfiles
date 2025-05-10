return {
	-- {
	-- 	"sainnhe/everforest",
	-- 	init = function()
	-- 		-- vim.g.everforest_background = "soft"
	-- 		-- vim.g.everforest_better_performance = 1
	-- 		-- vim.g.everforest_enable_italic = 1
	-- 		-- vim.g.everforest_diagnostic_virtual_text = "colored"
	-- 		-- vim.g.everforest_diagnostic_virtual_text = "none"
	-- 		vim.cmd.colorscheme("everforest")
	-- 		vim.g.everforest_background = "hard"
	-- 	end,
	-- },
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		init = function()
			-- vim.cmd.colorscheme("tokyonight-day")
			vim.cmd.colorscheme("tokyonight")

			vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#BE90D4", bold = true })

			-- LineNr and CursorLineNr colors
			vim.api.nvim_set_hl(0, "LineNr", { fg = "#89CFF0" })
			-- vim.api.nvim_set_hl(0, "LineNr", { fg = "#4a2969" })
			-- vim.api.nvim_set_hl(0, "LineNr", { fg = "white" })
			-- vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#CE8CF8" })

			-- Set the StatusLine highlight for horizontal split line
			-- vim.api.nvim_set_hl(0, "StatusLine", { fg = "#89CFF0" })

			vim.opt.fillchars = {
				horiz = "━",
				horizup = "┻",
				horizdown = "┳",
				vert = "┃",
				vertleft = "┫",
				vertright = "┣",
				verthoriz = "╋",
			}
			vim.opt.laststatus = 3
		end,
	},
}

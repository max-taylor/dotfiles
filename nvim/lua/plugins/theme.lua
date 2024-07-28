local function set_window_theme()
	-- vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#89CFF0", bold = true })
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
end

return {
	-- Ordering is important here so that this color scheme is loaded last, noice.nvim overrides the color scheme to default
	-- {
	-- 	"rebelot/kanagawa.nvim",
	-- 	priority = 1000,
	-- 	init = function()
	-- 		vim.cmd.colorscheme("kanagawa")
	--
	-- 		set_window_theme()
	-- 	end,
	-- },
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		-- opts = {
		-- 	-- transparent = true,
		-- 	on_highlights = function(hl, colors)
		-- 		hl.LineNr = {
		-- 			fg = colors.yellow,
		-- 		}
		-- 		hl.CursorLineNr = {
		-- 			fg = colors.orange,
		-- 		}
		-- 	end,
		-- },
		init = function()
			-- require("tokyonight").setup({
			-- 	on_highlights = function(hl, colors)
			-- 		hl.LineNr = {
			-- 			fg = colors.yellow,
			-- 		}
			-- 		hl.CursorLineNr = {
			-- 			fg = colors.orange,
			-- 		}
			-- 	end,
			-- })
			vim.cmd.colorscheme("tokyonight")

			set_window_theme()
		end,
		-- config = function()
		-- 	require("tokyonight").setup({
		-- 		on_highlights = function(hl, colors)
		-- 			hl.LineNr = {
		-- 				fg = colors.yellow,
		-- 			}
		-- 			hl.CursorLineNr = {
		-- 				fg = colors.orange,
		-- 			}
		-- 		end,
		-- 	})
		-- 	vim.cmd.colorscheme("tokyonight")
		-- end,
	},
}

return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/noice.nvim" },
	config = function()
		-- Calling setup manually as we need to require noice after its loaded
		require("lualine").setup({
			-- options = {
			-- 	disabled_filetypes = { "NvimTree", "trouble", "oldfiles" },
			-- },
			sections = {
				lualine_a = {
					"mode",
				},
				lualine_b = { "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = {
					{
						require("noice").api.statusline.mode.get,
						cond = require("noice").api.statusline.mode.has,
						color = { fg = "#ff9e64" },
					},
				},
				lualine_y = { "filetype" },
				lualine_z = { "branch" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = { "diff", "diagnostics" },
				lualine_c = { "filename" },
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}

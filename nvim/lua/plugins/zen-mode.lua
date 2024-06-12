return {
	{
		"folke/zen-mode.nvim",
		opts = {
			window = {
				backdrop = 0,
				height = 1,
			},
		},
		keys = {
			{
				"<leader>z",
				"<cmd>ZenMode<cr>",
				desc = "Zen Mode",
			},
		},
	},
}

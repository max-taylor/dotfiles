return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = function()
		-- Speeds up notifications
		require("notify").setup({
			timeout = 2000,
			stages = "static",
		})

		require("noice").setup({
			routes = {
				{
					-- Hides the savefile message
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					opts = { skip = true },
				},
			},
		})
	end,
}

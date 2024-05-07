return {
	{
		"MunifTanjim/nui.nvim",
		config = function()
			require("custom.extensions.git").setup()
		end,
	},
	{
		dir = "~/Documents/Code/Neovim/plugin/",
		name = "task-manager",
		dependencies = { "MunifTanjim/nui.nvim", "rxi/json.lua", "kikito/middleclass" },
		config = function()
			require("task-manager").setup()
		end,
	},
}

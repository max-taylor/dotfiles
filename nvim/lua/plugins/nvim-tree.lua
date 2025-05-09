return {
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			update_focused_file = {
				enable = true,
			},
			view = {
				relativenumber = true,
				number = true,
				width = 40,
				side = "left",
			},
			filters = {
				dotfiles = false,
			},
		},
		config = function(_, opts)
			require("nvim-tree").setup(opts)

			vim.keymap.set("n", "<leader>f", ":NvimTreeToggle<CR>", { silent = true })
		end,
	},
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-tree.lua",
		},
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
}

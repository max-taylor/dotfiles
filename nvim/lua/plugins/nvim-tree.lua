return {
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			vim.keymap.set("n", "<leader>f", ":NvimTreeToggle<CR>", { silent = true })
			require("nvim-tree").setup({
				update_focused_file = {
					enable = true,
				},
				view = {
					relativenumber = true,
					number = true,
					width = 60,
					side = "left",
				},
				filters = {
					dotfiles = false,
				},
			})
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

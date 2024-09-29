return {
	{
		"Pocco81/auto-save.nvim",
		opts = {
			trigger_events = { "InsertLeave" },
			write_all_buffers = true,
			debounce_delay = 150,
			execution_message = nil,
		},
	},
	{
		"rainbowhxch/accelerated-jk.nvim",
		config = function()
			-- Key mappings to use the accelerated-jk plugin
			vim.api.nvim_set_keymap("n", "j", "<Plug>(accelerated_jk_gj)", {})
			vim.api.nvim_set_keymap("n", "k", "<Plug>(accelerated_jk_gk)", {})
		end,
	},
	{
		"rainbowhxch/beacon.nvim",
	},
}

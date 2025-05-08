return {
	{
		"Pocco81/auto-save.nvim",
		opts = {
			execution_message = {
				message = function()
					-- Disable the message
					return ""
				end,
			},
			trigger_events = { "InsertLeave" },
			write_all_buffers = true,
			debounce_delay = 300,
		},
	},
}

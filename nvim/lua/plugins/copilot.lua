return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		enabled = true,
		config = function()
			require("copilot").setup({
				suggestion = {
					auto_trigger = true,
					keymap = { accept = false, prev = "<M-[>", next = "<M-]>", dismiss = "<C-]>" },
				},
			})
		end,
	},
}

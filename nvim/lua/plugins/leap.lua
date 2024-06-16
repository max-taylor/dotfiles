return {
	{
		"ggandor/leap.nvim",
		enabled = true,
		-- keys = {
		-- 	{ "s", mode = { "n", "x", "o" }, desc = "Leap" },
		-- 	-- { 'S', mode = { 'n', 'x', 'o' }, desc = 'Leap Backward to' },
		-- 	{ "gs", mode = { "n", "x", "o" }, desc = "Leap from Windows" },
		-- },
		config = function(_, opts)
			local leap = require("leap")
			for k, v in pairs(opts) do
				leap.opts[k] = v
			end

			-- vim.keymap.del({ "n", "x", "o" }, "x")
			-- vim.keymap.del("n", "S")
			-- 	-- leap.add_default_mappings(true)
			vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
			vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-from-window)")
		end,
	},
}

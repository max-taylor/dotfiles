return {
    {
        "ggandor/leap.nvim",
        enabled = true,
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

            -- Sets the text color when leaping to the Comment text color
            vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
        end,
    },
}

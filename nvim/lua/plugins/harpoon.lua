local function v_file(index)
    return function()
        require("harpoon.ui").nav_file(index)
    end
end

local harpoon_config = {
    {
        "ThePrimeagen/harpoon",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            {
                "<leader>hl",
                function()
                    require("harpoon.ui").toggle_quick_menu()
                end,
                desc = "[H]arpoon [L]ist",
            },
            {
                "<leader>ha",
                function()
                    require("harpoon.mark").add_file()
                end,
                desc = "[H]arpoon [A]dd file",
            },
        },
        config = function()
            require("telescope").load_extension("harpoon")

            require("harpoon").setup({})
        end,
    },
}

-- Dynamically add shortcuts for navigating to files 1 through 9
for i = 1, 9 do
    table.insert(harpoon_config[1].keys, {
        string.format("<leader>h%d", i),
        v_file(i),
        desc = string.format("[H]arpoon to file [%d]", i),
    })
end

return harpoon_config

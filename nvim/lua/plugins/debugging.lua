return {
    {
        "folke/trouble.nvim",
        enabled = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            {
                "<leader>uf",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Trouble Quickfix toggle",
            },
            -- {
            -- 	"<leader>us",
            -- 	"<cmd>Trouble loclist toggle<cr>",
            -- 	desc = "Trouble Loclist toggle",
            -- },
            -- {
            -- 	"<leader>tl",
            -- 	"<cmd>Trouble loclist toggle<cr>",
            -- 	desc = "Location List (Trouble)",
            -- },
        },
        opts = {
            open_no_results = true,
        },
        init = function()
            vim.api.nvim_create_autocmd("BufReadPost", {
                pattern = "*",
                callback = function()
                    require("trouble").refresh()
                end,
            })
        end,
    },
    {
        "dmmulroy/tsc.nvim",
        init = function()
            require("tsc").setup({
                use_trouble_qflist = true,
                -- auto_start_watch_mode = true,
                auto_open_qflist = false,
                -- flags = { watch = true },
                enable_progress_notifications = true,
                run_as_monorepo = true,
            })
        end,
    },
}

return {
    -- { "mason-org/mason.nvim", "mason-org/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
    -- {
    -- 	"mason-org/mason-lspconfig.nvim",
    -- 	enabled = false,
    -- 	event = "BufReadPost",
    -- 	dependencies = {
    -- 		"mason-org/mason.nvim",
    -- 		"neovim/nvim-lspconfig",
    -- 	},
    -- 	opts = {
    -- 		ensure_installed = {
    -- 			-- "lua_ls",
    -- 			"ts_ls",
    -- 			"jsonls",
    -- 			"eslint",
    -- 			-- "tailwindcss",
    -- 			"astro",
    -- 		},
    -- 		automatic_installation = true,
    -- 	},
    -- 	config = function(_, opts)
    -- 		require("mason").setup()
    -- 		require("mason-lspconfig").setup(opts)
    -- 		-- require("nvim-lspconfig").setup()
    -- 	end,
    -- },
    { -- Autoformat
        "stevearc/conform.nvim",
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. You can add additional
                -- languages here or re-enable it for the disabled ones.
                local disable_filetypes = { c = true, cpp = true }
                return {
                    timeout_ms = 500,
                    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                }
            end,
            formatters_by_ft = {
                lua = { "stylua" },
                -- Conform can also run multiple formatters sequentially
                -- python = { "isort", "black" },
                --
                -- You can use a sub-list to tell conform to run *until* a formatter
                -- is found.
                javascript = { "prettierd" },
                typescript = { "prettierd" },
                typescriptreact = { "prettierd" },
                javascriptreact = { "prettierd" },
            },
            formatters = {
                stylua = {
                    -- TODO: It probably would be better to create a `stylua.toml` file in the root, but leaving it for now
                    prepend_args = function(self, ctx)
                        return { "--indent-width", 4, "--indent-type", "Spaces" }
                    end,
                },
            },
        },
    },
    { -- Autocompletion
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                "L3MON4D3/LuaSnip",
                build = (function()
                    -- Build Step is needed for regex support in snippets.
                    -- This step is not supported in many windows environments.
                    -- Remove the below condition to re-enable on windows.
                    if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
                dependencies = {
                    -- `friendly-snippets` contains a variety of premade snippets.
                    --    See the README about individual language/framework/plugin snippets:
                    --    https://github.com/rafamadriz/friendly-snippets
                    -- {
                    --   'rafamadriz/friendly-snippets',
                    --   config = function()
                    --     require('luasnip.loaders.from_vscode').lazy_load()
                    --   end,
                    -- },
                },
            },
            "saadparwaiz1/cmp_luasnip",

            -- Adds other completion capabilities.
            --  nvim-cmp does not ship with all sources by default. They are split
            --  into multiple repos for maintenance purposes.
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
        },
        config = function()
            -- See `:help cmp`
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            luasnip.config.setup({})

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = { completeopt = "menu,menuone,noinsert" },

                -- For an understanding of why these mappings were
                -- chosen, you will need to read `:help ins-completion`
                --
                -- No, but seriously. Please read `:help ins-completion`, it is really good!
                mapping = cmp.mapping.preset.insert({
                    -- Select the [n]ext item
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    -- Select the [p]revious item
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    -- Select the [s]elect item
                    ["<Tab>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    }),

                    -- Scroll the documentation window [b]ack / [f]orward
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),

                    -- Accept ([y]es) the completion.
                    --  This will auto-import if your LSP supports it.
                    --  This will expand snippets if the LSP sent a snippet.
                    -- ['<C-y>'] = cmp.mapping.confirm { select = true },

                    -- Manually trigger a completion from nvim-cmp.
                    --  Generally you don't need this, because nvim-cmp will display
                    --  completions whenever it has completion options available.
                    ["<C-Space>"] = cmp.mapping.complete({}),

                    -- Think of <c-l> as moving to the right of your snippet expansion.
                    --  So if you have a snippet that's like:
                    --  function $name($args)
                    --    $body
                    --  end
                    --
                    -- <c-l> will move you to the right of each of the expansion locations.
                    -- <c-h> is similar, except moving you backwards.
                    --  ['<C-l>'] = cmp.mapping(function()
                    --    if luasnip.expand_or_locally_jumpable() then
                    --      luasnip.expand_or_jump()
                    --    end
                    --  end, { 'i', 's' }),
                    --  ['<C-h>'] = cmp.mapping(function()
                    --    if luasnip.locally_jumpable(-1) then
                    --      luasnip.jump(-1)
                    --    end
                    --  end, { 'i', 's' }),

                    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
                }),
                sources = {
                    { name = "lazydev" },
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                },
            })
        end,
    },
    { -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Automatically install LSPs and related tools to stdpath for Neovim
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- Useful status updates for LSP.
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { "j-hui/fidget.nvim", opts = {} },

            {
                "folke/lazydev.nvim",
                ft = "lua", -- only load on lua files
                dependencies = {
                    { "justinsgithub/wezterm-types", lazy = true },
                    { "Bilal2453/luvit-meta", lazy = true },
                },
                opts = {
                    library = {
                        { path = "wezterm-types", mods = { "wezterm" } },
                        -- See the configuration section for more details
                        -- Load luvit types when the `vim.uv` word is found
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
        },
        config = function()
            --  This function gets run when an LSP attaches to a particular buffer.
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                    map("gv", function()
                        require("telescope.builtin").lsp_definitions({ jump_type = "vsplit" })
                    end, "[G]oto [D]efinition (vsplit)")

                    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

                    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

                    map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

                    map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

                    map(
                        "<leader>ws",
                        require("telescope.builtin").lsp_dynamic_workspace_symbols,
                        "[W]orkspace [S]ymbols"
                    )

                    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

                    -- vim.keymap.set("n", "K", function()
                    -- 	print("NEW DOC")
                    -- 	vim.lsp.buf.hover({ border = "single", max_height = 100, max_width = 120 })
                    -- end, { buffer = event.buf, desc = "LSP: Hover Documentation" })

                    map("K", function()
                        -- TODO: Not working
                        vim.lsp.buf.hover({ border = "single", max_height = 25, max_width = 120 })
                    end, "Hover Documentation")

                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                    -- The following two autocommands are used to highlight references of the
                    -- word under your cursor when your cursor rests there for a little while.
                    --    See `:help CursorHold` for information about when this is executed
                    --
                    -- When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            -- LSP servers and clients are able to communicate to each other what features they support.
            --  By default, Neovim doesn't support everything that is in the LSP specification.
            --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
            --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            local servers = {
                -- clangd = {},

                lua_ls = {
                    -- cmd = {...},
                    -- filetypes = { ...},
                    -- capabilities = {},
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                            runtime = {
                                version = "LuaJIT",
                                -- path = path,
                                -- path = {},
                            },
                            codeLens = {
                                enable = true,
                            },
                            workspace = {
                                -- Make the server aware of Neovim runtime files
                                library = {
                                    vim.api.nvim_get_runtime_file("", true),
                                    -- [vim.fn.expand '~/.local/share/nvim/lazy/plenary.nvim'] = true,
                                    -- TODO: Update this to calculate the base path
                                    "/Users/maxtaylor/.local/share/nvim/lazy/middleclass",
                                    "/Users/maxtaylor/.local/share/nvim/lazy/nui.nvim/lua/nui",
                                    "/Users/maxtaylor/.local/share/nvim/lazy/plenary.nvim/lua/plenary",
                                    "/Users/maxtaylor/.local/share/nvim/lazy/telescope.nvim/lua/telescope",
                                },

                                -- [vim.fn.expand '$VIMRUNTIME/lua'] = true,
                                -- -- Add the path to plenary.nvim here. Ensure the path is correctly expanded:
                                -- [vim.fn.expand '~/.local/share/nvim/lazy/plenary.nvim'] = true,
                            },
                            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                            -- diagnostics = { disable = { 'missing-fields' } },
                        },
                    },
                },
            }

            --  You can press `g?` for help in this menu.
            require("mason").setup()

            -- You can add other tools here that you want Mason to install
            -- for you, so that they are available from within Neovim.
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "stylua", -- Used to format Lua code
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "ts_ls", -- TypeScript LSP
                },
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        print("Server name:", server_name)
                        -- This handles overriding only values explicitly passed
                        -- by the server configuration above. Useful when disabling
                        -- certain features of an LSP (for example, turning off formatting for tsserver)
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },
}

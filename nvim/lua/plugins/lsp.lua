return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- Apply these keymaps to all LSP servers
      ["*"] = {
        keys = {
          {
            "gv",
            function()
              require("telescope.builtin").lsp_definitions({ jump_type = "vsplit" })
            end,
            desc = "Goto Definition (vsplit)",
          },
        },
      },
    },
  },
}

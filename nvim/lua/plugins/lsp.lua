return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      -- Apply these keymaps to all LSP servers
      ["*"] = {
        keys = {
          {
            "gv",
            function()
              vim.cmd("vsplit")
              vim.lsp.buf.definition()
            end,
            desc = "Goto Definition (vsplit)",
          },
        },
      },
    },
  },
}

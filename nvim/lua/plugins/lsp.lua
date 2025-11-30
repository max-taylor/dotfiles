return {
  "neovim/nvim-lspconfig",
  init = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()

    -- Disable LazyVim's default rename binding
    keys[#keys + 1] = { "<leader>cr", false }

    -- Add custom keybindings
    keys[#keys + 1] = { "<leader>rn", vim.lsp.buf.rename, desc = "Rename" }
    keys[#keys + 1] = {
      "gv",
      function()
        require("telescope.builtin").lsp_definitions({ jump_type = "vsplit" })
      end,
      desc = "Goto Definition (vsplit)",
    }
  end,
}

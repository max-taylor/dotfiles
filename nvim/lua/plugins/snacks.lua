return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        recent = {
          filter = {
            cwd = true,
          },
        },
      },
    },
  },
  keys = {
    -- Override LazyVim keymaps to use cwd explicitly
    {
      "<leader><leader>",
      function()
        Snacks.picker.files({ cwd = vim.fn.getcwd() })
      end,
      desc = "Find Files (cwd)",
    },
    {
      "<leader>sg",
      function()
        Snacks.picker.grep({ cwd = vim.fn.getcwd() })
      end,
      desc = "Grep (cwd)",
    },
  },
}

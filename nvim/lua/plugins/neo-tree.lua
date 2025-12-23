return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    {
      "<leader>fe",
      function()
        require("neo-tree.command").execute({ dir = vim.uv.cwd() })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
    {
      "<leader>fE",
      function()
        require("neo-tree.command").execute({ dir = LazyVim.root() })
      end,
      desc = "Explorer NeoTree (root dir)",
    },
  },
}

return {
  {
    "akinsho/toggleterm.nvim",
    lazy = false,
    version = "*",
    opts = {
      shade_filetypes = {},
      shade_terminals = true,
      insert_mappings = true,
      persist_size = true,
      size = function(term)
        if term.direction == "horizontal" then
          return 20
        elseif term.direction == "vertical" then
          return 40
        end
      end,
      direction = "vertical",
      start_in_insert = true,
      on_open = function(term)
        vim.cmd("startinsert")
        vim.keymap.set(
          { "t", "n" },
          "<Esc>",
          "<C-\\><C-n> :ToggleTerm<CR>",
          { desc = "Exit terminal mode", buffer = term.bufnr }
        )
      end,
    },
    keys = {
      { "<leader>t", ":ToggleTerm<CR>", desc = "Open terminal" },
    },
  },
}

return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      vim.keymap.set('n', '<leader>t', ':ToggleTerm<CR>', { silent = true })
      -- Rebind to close the terminal on <Esc> in terminal mode
      vim.keymap.set('t', '<Esc>', '<C-\\><C-n> :ToggleTerm<CR>', { desc = 'Exit terminal mode' })

      require('toggleterm').setup {
        shade_filetypes = {},
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = 'float',
      }
    end,
  },
}

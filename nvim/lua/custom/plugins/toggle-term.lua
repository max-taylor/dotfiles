return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      vim.keymap.set('n', '<leader>t', ':ToggleTerm<CR>', { silent = true })

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

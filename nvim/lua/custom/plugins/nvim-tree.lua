return {
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      vim.keymap.set('n', '<leader>f', ':NvimTreeToggle<CR>', { silent = true })
      require('nvim-tree').setup {
        update_focused_file = {
          enable = true,
        },
        view = {
          relativenumber = true,
          number = true,
          width = 40,
        },
      }
    end,
  },
}

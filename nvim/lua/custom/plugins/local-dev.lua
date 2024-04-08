return {
  {
    'nvim-lua/plenary.nvim',
  },
  {
    dir = '~/Documents/Code/Neovim/plugin/',
    name = 'task-manager',
    config = function()
      require('task-manager').setup()
    end,
  },
}

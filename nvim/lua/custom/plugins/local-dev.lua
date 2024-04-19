return {
  {
    dir = '~/Documents/Code/Neovim/plugin/',
    name = 'task-manager',
    dependencies = { 'MunifTanjim/nui.nvim', 'kikito/middleclass' },
    config = function()
      require('task-manager').setup()
    end,
  },
}

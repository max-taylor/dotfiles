return {
  -- the opts function can also be used to change the default opts:
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    -- Plugin not booting correctly unless explicitly calling setup method
    config = function()
      require('lualine').setup()
    end,
  },
}

return {
  -- the opts function can also be used to change the default opts:
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    -- Plugin not booting correctly unless explicitly calling setup method
    config = function()
      require('lualine').setup {
        options = {
          -- theme = 'molokai',
          sections = {
            lualine_a = { 'mode' },
            lualine_b = {},
            -- lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { 'filename' },
            -- lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_x = {},
            lualine_y = { 'progress' },
            lualine_z = { 'location' },
          },
        },
      }
    end,
  },
}

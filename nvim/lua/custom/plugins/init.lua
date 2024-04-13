-- Custom plugins configuration

return {
  -- Ordering is important here so that this color scheme is loaded last, noice.nvim overrides the color scheme to default
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'kanagawa'
      vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#89CFF0', bold = true })
      vim.api.nvim_set_hl(0, 'LineNr', { fg = '#89CFF0' })
      -- vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#CE8CF8' })
      vim.opt.fillchars = {
        horiz = '━',
        horizup = '┻',
        horizdown = '┳',
        vert = '┃',
        vertleft = '┫',
        vertright = '┣',
        verthoriz = '╋',
      }
      vim.opt.laststatus = 3
    end,
  },
}

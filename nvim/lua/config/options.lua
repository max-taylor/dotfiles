-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = false -- Disable format on save
vim.opt.swapfile = false -- Disable swap files
vim.opt.autoread = true -- Re-read files changed outside Neovim

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  command = 'checktime',
  desc = 'Auto-reload buffers when files change on disk',
})
vim.opt.wrap = true
vim.opt.linebreak = true -- Wrap at word boundaries

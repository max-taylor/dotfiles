-- Rebind <Tab> in insert mode to accept copilot suggestions if available
vim.keymap.set('i', '<C-l>', function()
  if require('copilot.suggestion').is_visible() then
    require('copilot.suggestion').accept()
  end
end, {
  silent = true,
})

-- Rebind save to <C-s> in normal and insert mode
vim.keymap.set('n', '<C-s>', ':update<cr>')
-- <C-o> exits insert mode temporarily to execute a single normal mode command in this case saving
-- Also exiting insert mode here
vim.keymap.set('i', '<C-s>', '<C-O>:update<cr><Esc>')

-- Rebind quit window to <C-q>
vim.keymap.set('n', '<C-q>', '<C-w>q')
-- Not working
-- vim.keymap.set('i', '<C-q>', '<C-w>q')
--

-- vim.keymap.set('n', '<C-q>', '<C-a>o', { noremap = true })
-- vim.keymap.set('n', '<C-f>', '<cmd>!tmux send-keys C-a o<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<C-f>', '<C-a>o', { noremap = true, silent = true })
-- vim.keymap.set('n', '<C-f>', function()
--   vim.cmd 'silent !tmux send-keys C-a o'
-- end, { noremap = true, silent = true })

return {}

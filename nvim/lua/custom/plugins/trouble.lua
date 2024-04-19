-- Diagnostic keymaps
vim.keymap.set('n', 'qk', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', 'qj', vim.diagnostic.goto_next, { desc = 'go to next [d]iagnostic message' })
-- me commente:d
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'show diagnostic [e]rror messages' })
vim.keymap.set('n', 'qq', vim.diagnostic.setloclist, { desc = 'open diagnostic [q]uickfix list' })

vim.keymap.set('n', 'qw', function()
  require('trouble').toggle 'workspace_diagnostics'
end)
vim.keymap.set('n', '<leader>qd', function()
  require('trouble').toggle 'document_diagnostics'
end)

-- vim.keymap.set('n', '<leader>xx', function()
--   require('trouble').toggle()
-- end)
-- vim.keymap.set('n', '<leader>xq', function()
--   require('trouble').toggle 'quickfix'
-- end)
-- vim.keymap.set('n', '<leader>xl', function()
--   require('trouble').toggle 'loclist'
-- end)
-- vim.keymap.set('n', 'gR', function()
--   require('trouble').toggle 'lsp_references'
-- end)

return {
  'folke/trouble.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
}

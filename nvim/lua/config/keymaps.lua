-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Disable default LazyVim keybindings that conflict
vim.keymap.del("n", "<leader>wd") -- We're using Ctrl+q instead

-- Quit window with Ctrl+q (instead of <leader>wd)
vim.keymap.set("n", "<C-q>", "<C-w>q", { desc = "Quit window" })

-- Custom diagnostic navigation (x prefix)
vim.keymap.set("n", "xj", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "xk", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "xh", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "xl", function()
  vim.diagnostic.goto_next()
  vim.lsp.buf.code_action()
end, { desc = "Next diagnostic + code action" })
vim.keymap.set("n", "xm", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "xq", vim.diagnostic.setloclist, { desc = "Diagnostic loclist" })

-- Additional next error/warning bindings
vim.keymap.set("n", "xe", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next error" })
vim.keymap.set("n", "xE", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Previous error" })
vim.keymap.set("n", "xw", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
end, { desc = "Next warning" })
vim.keymap.set("n", "xW", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
end, { desc = "Previous warning" })

-- Copy line reference for sharing
vim.keymap.set("n", "xc", function()
  local file = vim.fn.expand("%")
  local line = vim.fn.line(".")
  local ref = string.format("%s#L%d", file, line)
  vim.fn.setreg("+", ref)
  vim.notify("File path and position copied to clipboard", vim.log.levels.INFO)
end, { desc = "Copy line reference" })

-- Copy diagnostics for Claude Code
vim.keymap.set("n", "xd", function()
  local file = vim.fn.expand("%")
  local line = vim.fn.line(".")
  local diagnostics = vim.diagnostic.get(0, { lnum = line - 1 })

  if #diagnostics == 0 then
    vim.notify("No diagnostics on current line", vim.log.levels.INFO)
    return
  end

  local diagnostic_text = {}
  table.insert(diagnostic_text, "Investigate and resolve the following issue:")
  table.insert(diagnostic_text, "")
  table.insert(diagnostic_text, string.format("File: %s:%d", file, line))
  table.insert(diagnostic_text, "")
  table.insert(diagnostic_text, "Diagnostics:")

  for _, diagnostic in ipairs(diagnostics) do
    local severity = vim.diagnostic.severity[diagnostic.severity]
    table.insert(diagnostic_text, string.format("- %s: %s", severity, diagnostic.message))
  end

  local result = table.concat(diagnostic_text, "\n")
  vim.fn.setreg("+", result)
  vim.notify("Diagnostics copied to clipboard", vim.log.levels.INFO)
end, { desc = "Copy diagnostics for Claude" })

-- Run previous terminal command
vim.keymap.set("n", "xx", function()
  require("toggleterm").exec("!!\n", 1)
end, { desc = "Run previous terminal command" })

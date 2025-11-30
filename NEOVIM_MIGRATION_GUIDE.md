# Neovim Migration Guide: Kickstart → LazyVim

This document outlines the key differences between your custom Kickstart-based Neovim configuration and the fresh LazyVim installation, to facilitate migration of your customizations.

## Table of Contents
1. [Architecture Differences](#architecture-differences)
2. [Keybinding Comparison](#keybinding-comparison)
3. [Plugin Comparison](#plugin-comparison)
4. [Unique Features in Kickstart Config](#unique-features-in-kickstart-config)
5. [Unique Features in LazyVim](#unique-features-in-lazyvim)
6. [Migration Steps](#migration-steps)

---

## Architecture Differences

### File Structure

**Your Kickstart Config** (`/home/maxtaylor/Documents/Code/dotfiles/nvim/`)
```
nvim/
├── init.lua                    # Entry point, loads config & lazy.nvim
├── lua/
│   ├── config/
│   │   ├── init.lua           # Loads remaps & settings
│   │   ├── settings.lua       # Core vim options & autocmds
│   │   └── remaps.lua         # Custom keybindings
│   ├── plugins/               # Individual plugin configs (27 files)
│   └── extensions/
│       └── health.lua
```

**LazyVim Config** (`~/.config/nvim/`)
```
nvim/
├── init.lua                    # Minimal entry point
├── lua/
│   ├── config/
│   │   ├── lazy.lua           # LazyVim bootstrap & setup
│   │   ├── options.lua        # Override LazyVim options
│   │   ├── keymaps.lua        # Override LazyVim keymaps
│   │   └── autocmds.lua       # Override LazyVim autocmds
│   └── plugins/               # Override/extend LazyVim plugins
│       └── example.lua        # Example configurations
```

### Key Architectural Differences

1. **Configuration Inheritance**:
   - **Kickstart**: Builds from scratch, you define everything
   - **LazyVim**: Inherits from `LazyVim/LazyVim` base, you override/extend

2. **Plugin Management**:
   - **Kickstart**: Directly imports plugins via `{ import = "plugins" }`
   - **LazyVim**: Imports LazyVim base first, then your customizations
   ```lua
   spec = {
     { "LazyVim/LazyVim", import = "lazyvim.plugins" },
     { import = "plugins" },
   }
   ```

3. **Configuration Philosophy**:
   - **Kickstart**: Explicit configuration of every plugin
   - **LazyVim**: Sensible defaults with override mechanisms

---

## Keybinding Comparison

### Core Navigation & Editing

| Action | Your Kickstart | LazyVim | Notes |
|--------|----------------|---------|-------|
| **Save file** | `Ctrl+s` (normal & insert) | `Ctrl+s` (all modes) | ✅ Same |
| **Quit window** | `Ctrl+q` | `<leader>wd` | ⚠️ Different |
| **Clear search** | `Esc` | `Esc` | ✅ Same |
| **Exit terminal** | `Esc Esc` | `Esc` | ⚠️ Different |
| **Window navigation** | Not set | `Ctrl+h/j/k/l` | ⚠️ LazyVim adds this |
| **Line movement** | Not set | `Alt+j/k` | ⚠️ LazyVim adds this |
ME: use ctrl+q for quit window

### Diagnostics & Code Actions

| Action | Your Kickstart | LazyVim | Notes |
|--------|----------------|---------|-------|
| **Next diagnostic** | `xj` | `]d` | ⚠️ Different prefix |
| **Previous diagnostic** | `xk` | `[d` | ⚠️ Different prefix |
| **Code action** | `xh` | (via LSP in LazyVim) | ⚠️ Different |
| **Next + code action** | `xl` | Not available | ❌ Unique to yours |
| **Show diagnostics** | `xm` | `<leader>cd` | ⚠️ Different |
| **Diagnostic loclist** | `xq` | `<leader>xl` | ⚠️ Different |
| **Next error** | Not set | `]e` | ✅ LazyVim adds |
| **Next warning** | Not set | `]w` | ✅ LazyVim adds |
ME: Use my key bindings, but add some for next error and next warning that makes sense

### LSP Keybindingsn

| Action | Your Kickstart | LazyVim | File Reference |
|--------|----------------|---------|----------------|
| **Go to definition** | `gd` | `gd` | `nvim/lua/plugins/lsp.lua:212` |
| **Go to def (vsplit)** | `gv` | Not available | `nvim/lua/plugins/lsp.lua:213-215` ❌ |
| **Go to references** | `gr` | `gr` | `nvim/lua/plugins/lsp.lua:217` |
| **Go to implementation** | `gI` | `gI` | `nvim/lua/plugins/lsp.lua:219` |
| **Type definition** | `<leader>D` | `gy` | ⚠️ Different |
| **Document symbols** | `<leader>ds` | `<leader>cs` | ⚠️ Different prefix |
| **Workspace symbols** | `<leader>ws` | `<leader>ss` | ⚠️ Different prefix |
| **Rename** | `<leader>rn` | `<leader>cr` | ⚠️ Different |
| **Hover docs** | `K` | `K` | `nvim/lua/plugins/lsp.lua:238-241` |
| **Format** | Auto on save | `<leader>cf` | ⚠️ Different behavior |
ME: add vsplit to lazvim. 
Use kickstarts rename keybinding

### Telescope

| Action | Your Kickstart | LazyVim | File Reference |
|--------|----------------|---------|----------------|
| **Find files** | `<leader>sf` | `<leader>ff` or `<leader><space>` | `nvim/lua/plugins/telescope.lua:63` |
| **Live grep** | `<leader>sg` | `<leader>/` or `<leader>sg` | `nvim/lua/plugins/telescope.lua:66` |
| **Old files** | `<leader>so` | `<leader>fr` | `nvim/lua/plugins/telescope.lua:79` |
| **Buffers** | `<leader><leader>` | `<leader>fb` or `<leader>,` | `nvim/lua/plugins/telescope.lua:71` |
| **Help tags** | `<leader>sh` | `<leader>sh` | `nvim/lua/plugins/telescope.lua:61` |
| **Current buffer search** | `<leader>/` | `<leader>/` | `nvim/lua/plugins/telescope.lua:73-78` |
| **Search in open files** | `<leader>s/` | Similar via `/` | `nvim/lua/plugins/telescope.lua:83-88` |
ME: use kickstarts keybindings

### Custom Keybindings (Your Config)

| Action | Key | File Reference | In LazyVim? |
|--------|-----|----------------|-------------|
| **Copy line reference** | `xc` | `nvim/lua/config/remaps.lua:55-59` | ❌ No |
| **Copy diagnostics for Claude** | `xd` | `nvim/lua/config/remaps.lua:62-86` | ❌ No |
| **Run previous terminal cmd** | `xx` | `nvim/lua/config/remaps.lua:43-45` | ❌ No |
| **TSC run** | `xr` | `nvim/lua/config/remaps.lua:41` | ❌ No |
| **Copilot accept** | `Ctrl+l` (insert) | `nvim/lua/config/remaps.lua:11-17` | ⚠️ Different |
ME: Add all these to lazyvim. Except tsc run and copilot accept

### Plugin-Specific Keybindings

#### Harpoon (Your Config)
| Action | Key | File |
|--------|-----|------|
| **Toggle menu** | `<leader>hl` | `nvim/lua/plugins/harpoon.lua:13-18` |
| **Add file** | `<leader>ha` | `nvim/lua/plugins/harpoon.lua:19-25` |
| **Navigate to file 1-9** | `<leader>h1` through `<leader>h9` | `nvim/lua/plugins/harpoon.lua:36-42` |

#### Git (Your Config)
| Action | Key | File |
|--------|-----|------|
| **LazyGit** | `<leader>n` | `nvim/lua/plugins/git.lua:31` |

LazyVim Git keybindings:
- `<leader>gg` - LazyGit (root)
- `<leader>gG` - LazyGit (cwd)
- `<leader>gb` - Git blame
- `<leader>gL` - Git log

#### Other Plugins
| Plugin | Key | Action | File |
|--------|-----|--------|------|
| **NvimTree** | `<leader>f` | Toggle tree | `nvim/lua/plugins/file-tree.lua:22` |
| **ToggleTerm** | `<leader>t` | Toggle terminal | `nvim/lua/plugins/toggle-term.lua:30` |
| **ToggleTerm (in term)** | `Esc` | Close terminal | `nvim/lua/plugins/toggle-term.lua:24-27` |
| **Leap** | `s` | Leap forward | `nvim/lua/plugins/leap.lua:14` |
| **Leap** | `S` | Leap from window | `nvim/lua/plugins/leap.lua:15` |
| **Quicker** | `>` | Expand quickfix | `nvim/lua/plugins/quicker.lua:13-18` |
| **Quicker** | `<` | Collapse quickfix | `nvim/lua/plugins/quicker.lua:19-25` |

ME: neo-tree should open with <leader>f and whatever terminal provider is being used should be opened with <leader>t


---

## Plugin Comparison

### Plugins in Both Configs

| Plugin | Your Config | LazyVim | Notes |
|--------|-------------|---------|-------|
| **lazy.nvim** | ✅ | ✅ | Plugin manager |
| **telescope.nvim** | ✅ Custom config | ✅ Default | Your config has custom mappings & sortr |
| **nvim-lspconfig** | ✅ | ✅ | LSP configuration |
| **mason.nvim** | ✅ | ✅ | LSP installer |
| **nvim-cmp** | ✅ | ✅ | Autocompletion |
| **LuaSnip** | ✅ | ✅ | Snippet engine |
| **conform.nvim** | ✅ | ✅ | Formatting (stylua, prettierd) |
| **nvim-treesitter** | ✅ | ✅ | Syntax highlighting |
| **gitsigns.nvim** | ✅ | ✅ | Git decorations |
| **which-key.nvim** | ✅ | ✅ | Keybinding hints |
| **lualine.nvim** | ✅ Custom | ✅ Default | Your config integrates with noice |
| **tokyonight.nvim** | ✅ (disabled) | ✅ | Theme (you use tokyodark) |
| **catppuccin** | ✅ (disabled) | ✅ | Theme |

### Plugins Unique to Your Kickstart Config

| Plugin | Purpose | File | Migration Notes |
|--------|---------|------|-----------------|
| **copilot.lua** | AI code completion | `nvim/lua/plugins/ai.lua:3-15` | LazyVim has Copilot in extras |
| **avante.nvim** | AI assistant (disabled) | `nvim/lua/plugins/ai.lua:16-63` | Optional, currently disabled |
| **auto-save.nvim** | Auto-save on InsertLeave | `nvim/lua/plugins/auto-save.lua` | Not in LazyVim, need to add |
| **alpha-nvim** | Dashboard with ASCII art | `nvim/lua/plugins/dashboard.lua` | LazyVim uses dashboard.nvim |
| **harpoon** | Quick file navigation | `nvim/lua/plugins/harpoon.lua` | Not in LazyVim, need to add |
| **nvim-tree.lua** | File explorer | `nvim/lua/plugins/file-tree.lua` | LazyVim uses neo-tree |
| **lsp-file-operations** | LSP file ops for nvim-tree | `nvim/lua/plugins/file-tree.lua:25-34` | Dependency of nvim-tree |
| **leap.nvim** | Fast motion/jump plugin | `nvim/lua/plugins/leap.lua` | LazyVim uses flash.nvim |
| **lazygit.nvim** | LazyGit integration | `nvim/lua/plugins/git.lua:14-33` | LazyVim includes this |
| **toggleterm.nvim** | Terminal management | `nvim/lua/plugins/toggle-term.lua` | LazyVim has built-in terminal |
| **noice.nvim** | Better UI for messages | `nvim/lua/plugins/noice.lua` | LazyVim includes this |
| **nvim-notify** | Notification manager | `nvim/lua/plugins/noice.lua:6` | LazyVim includes this |
| **marks.nvim** | Enhanced marks | `nvim/lua/plugins/marks.nvim` | Not in LazyVim, need to add |
| **mini.nvim** | Mini plugins collection | `nvim/lua/plugins/mini.lua` | Partial overlap with LazyVim |
| **quicker.nvim** | Better quickfix | `nvim/lua/plugins/quicker.lua` | Not in LazyVim, need to add |
| **todo-comments.nvim** | Highlight TODO comments | `nvim/lua/plugins/todo-comments.lua` | LazyVim includes this |
| **tokyodark.nvim** | Your active theme | `nvim/lua/plugins/theme.lua:24-32` | Not in LazyVim, need to add |
| **fidget.nvim** | LSP progress UI | `nvim/lua/plugins/lsp.lua:184` | LazyVim may include |
| **lazydev.nvim** | Lua dev for Neovim | `nvim/lua/plugins/lsp.lua:186-201` | For Lua LSP completion |

### Plugins Unique to LazyVim

| Feature | LazyVim Default | Your Config Alternative |
|---------|-----------------|-------------------------|
| **File explorer** | neo-tree.nvim | nvim-tree.lua |
| **Motion/Jump** | flash.nvim | leap.nvim |
| **Dashboard** | dashboard.nvim | alpha-nvim |
| **Indent guides** | indent-blankline.nvim | Not configured |
| **Buffer management** | bufferline.nvim | Not configured |
| **Trouble.nvim** | Diagnostics list | Not configured |
| **Persistence** | Session management | Not configured |
| **Dressing.nvim** | Better vim.ui | Not configured |
| **Todo-comments** | Highlight TODOs | ✅ You have this |
| **Mini.indentscope** | Indent scope animation | Not configured |
| **nvim-spectre** | Search/replace UI | Not configured |

---

## Unique Features in Kickstart Config

### 1. Custom Diagnostic Navigation System (`x` prefix)
**File**: `nvim/lua/config/remaps.lua:30-45`

Your "x" prefix keybindings for diagnostics are unique and efficient:
- `xj` / `xk` - Next/previous diagnostic
- `xh` - Code action
- `xl` - Next diagnostic + code action
- `xm` - Show diagnostic float
- `xq` - Diagnostic loclist
- `xr` - Run TSC
- `xx` - Repeat last terminal command
- `xc` - Copy file:line reference
- `xd` - Copy diagnostic for Claude Code

**Migration**: Create in `~/.config/nvim/lua/config/keymaps.lua`

### 2. Telescope Custom Configuration
**File**: `nvim/lua/plugins/telescope.lua:45-46`

```lua
find_command = { "rg", "--files", "--sortr=modified" }
```
Sorts files by modification time (most recent first).

**Migration**: Override telescope config in LazyVim
ME: Leave this alone

### 3. Auto-Save on InsertLeave
**File**: `nvim/lua/plugins/auto-save.lua`

Automatically saves files when leaving insert mode with 600ms debounce.

**Migration**: Add plugin to LazyVim
ME: Yes we do want this

### 4. Harpoon Integration
**File**: `nvim/lua/plugins/harpoon.lua`

Quick file navigation with `<leader>h1` through `<leader>h9`.

**Migration**: Add plugin to LazyVim
ME: ignore this

### 5. Custom LSP Settings
**File**: `nvim/lua/plugins/lsp.lua:275-312`

- Lua LSP with custom library paths for plugins
- WezTerm types integration
- Custom completion behavior
ME: Ignore this

### 6. Conform.nvim Custom Formatters
**File**: `nvim/lua/plugins/lsp.lua:54-61`

```lua
formatters = {
  stylua = {
    prepend_args = function(self, ctx)
      return { "--indent-width", 4, "--indent-type", "Spaces" }
    end,
  },
}
```

**Migration**: Override conform config in LazyVim
ME: ignore this

### 7. Custom Settings
**File**: `nvim/lua/config/settings.lua`

- Auto-reload files on focus/buffer change (lines 69-78)
- Custom Move filetype commentstring (lines 92-95)
- Disabled swapfile (line 73)
ME: ignore this

### 8. NvimTree Configuration
**File**: `nvim/lua/plugins/file-tree.lua`

- Relative line numbers in tree
- 40 character width
- Auto-update focused file

ME: We are using neo-tree and should be opened via <leader>f

### 9. ToggleTerm Configuration
**File**: `nvim/lua/plugins/toggle-term.lua`

- Vertical terminal (40 chars wide)
- Auto-enter insert mode
- Custom escape behavior

ME: Add this

### 10. Lualine + Noice Integration
**File**: `nvim/lua/plugins/lualine.lua:17-22`

Shows Noice mode status in lualine.
ME: ignore this

---

## Unique Features in LazyVim

### 1. Window Management Keybindings
LazyVim provides comprehensive window management:
- `Ctrl+h/j/k/l` - Navigate windows
- `Ctrl+Up/Down/Left/Right` - Resize windows
- `<leader>-` / `<leader>|` - Split windows
- `<leader>wd` - Delete window

### 2. Line Movement with Alt
- `Alt+j` / `Alt+k` - Move lines up/down in all modes

### 3. Buffer Navigation
- `Shift+h` / `Shift+l` - Previous/next buffer
- `[b` / `]b` - Previous/next buffer
- `<leader>bd` - Delete buffer
- `<leader>bo` - Delete other buffers

### 4. UI Toggles
Extensive toggle system with `<leader>u` prefix:
- And many more...
- `<leader>uf` - Toggle formatting
- `<leader>us` - Toggle spelling
- `<leader>uw` - Toggle wrap
- `<leader>ul` - Toggle line numbers
- `<leader>uc` - Toggle conceal

### 5. Git Integration
More comprehensive git keybindings:
- `<leader>gg` - LazyGit (root)
- `<leader>gG` - LazyGit (cwd)
- `<leader>gb` - Git blame
- `<leader>gL` - Git log
- `<leader>gf` - Git file history

### 6. Tab Management
- `<leader><Tab>l` - Last tab
- `<leader><Tab>o` - Close other tabs
- `<leader><Tab>f` - First tab
- `<leader><Tab><Tab>` - New tab

### 7. Plugin Extras System
LazyVim has an "extras" system for optional plugins:
```lua
{ import = "lazyvim.plugins.extras.lang.typescript" }
{ import = "lazyvim.plugins.extras.coding.copilot" }
```

Browse extras with `:LazyExtras`

### 8. Better Default Options
- `scrolloff = 4` (vs your 10)
- `updatetime = 200ms` (vs your 250ms)
- `timeoutlen = 300ms` (vs your 300ms - same)
- Global statusline by default

### 9. Flash.nvim vs Leap
LazyVim uses flash.nvim for enhanced search/motion with:
- Multi-mode support
- Treesitter integration
- Remote operations

### 10. Session Management
LazyVim includes persistence.nvim for session management.

---

## Migration Steps

Based on your preferences, here's your customized migration plan. You'll be using LazyVim as the base and adding only your essential customizations.

### Step 1: Backup Current LazyVim Config
```bash
cp -r ~/.config/nvim ~/.config/nvim.backup
```

### Step 2: Enable LazyVim Extras
Edit `~/.config/nvim/lua/config/lazy.lua` and add these extras to the spec:

```lua
require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "lazyvim.plugins.extras.coding.copilot" },  -- Add Copilot support
    { import = "lazyvim.plugins.extras.lang.typescript" }, -- If using TypeScript
    { import = "plugins" },
  },
  -- ... rest of config
})
```

### Step 3: Add Auto-Save Plugin
Create `~/.config/nvim/lua/plugins/auto-save.lua`:

```lua
return {
  {
    "Pocco81/auto-save.nvim",
    opts = {
      execution_message = {
        message = function()
          return "" -- Disable the message
        end,
      },
      trigger_events = { "InsertLeave" },
      write_all_buffers = true,
      debounce_delay = 600,
    },
  },
}
```

### Step 4: Add ToggleTerm Plugin
Create `~/.config/nvim/lua/plugins/toggle-term.lua`:

```lua
return {
  {
    "akinsho/toggleterm.nvim",
    lazy = false,
    version = "*",
    opts = {
      shade_filetypes = {},
      shade_terminals = true,
      insert_mappings = true,
      persist_size = true,
      size = function(term)
        if term.direction == "horizontal" then
          return 20
        elseif term.direction == "vertical" then
          return 40
        end
      end,
      direction = "vertical",
      start_in_insert = true,
      on_open = function(term)
        vim.cmd("startinsert")
        vim.keymap.set(
          { "t", "n" },
          "<Esc>",
          "<C-\\><C-n> :ToggleTerm<CR>",
          { desc = "Exit terminal mode", buffer = term.bufnr }
        )
      end,
    },
    keys = {
      { "<leader>t", ":ToggleTerm<CR>", desc = "Open terminal" }
    },
  },
}
```

### Step 5: Configure Neo-tree Keybinding
Create `~/.config/nvim/lua/plugins/neo-tree.lua`:

```lua
return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    { "<leader>f", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
  },
}
```

### Step 6: Add Custom Keybindings
Create/edit `~/.config/nvim/lua/config/keymaps.lua` and add your custom keybindings:

```lua
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
```

### Step 7: Override LSP Keybindings
Create `~/.config/nvim/lua/plugins/lsp.lua`:

```lua
return {
  "neovim/nvim-lspconfig",
  init = function()
    local keys = require("lazyvim.plugins.lsp.keymaps").get()

    -- Disable LazyVim's default rename binding
    keys[#keys + 1] = { "<leader>cr", false }

    -- Add custom keybindings
    keys[#keys + 1] = { "<leader>rn", vim.lsp.buf.rename, desc = "Rename" }
    keys[#keys + 1] = {
      "gv",
      function()
        require("telescope.builtin").lsp_definitions({ jump_type = "vsplit" })
      end,
      desc = "Goto Definition (vsplit)"
    }
  end,
}
```

### Step 8: Configure Telescope Keybindings
Create `~/.config/nvim/lua/plugins/telescope.lua`:

```lua
return {
  "nvim-telescope/telescope.nvim",
  keys = {
    -- Disable some default LazyVim bindings
    { "<leader>ff", false },
    { "<leader><space>", false },
    { "<leader>fb", false },
    { "<leader>,", false },
    { "<leader>fr", false },

    -- Add your custom Telescope bindings
    { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
    { "<leader>so", "<cmd>Telescope oldfiles<cr>", desc = "Old Files" },
    { "<leader><leader>", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
    { "<leader>ss", "<cmd>Telescope builtin<cr>", desc = "Select Telescope" },
    { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Word" },
    { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
    { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume" },
    {
      "<leader>/",
      "<cmd>Telescope current_buffer_fuzzy_find<cr>",
      desc = "Search in buffer"
    },
    {
      "<leader>s/",
      function()
        require("telescope.builtin").live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end,
      desc = "Search in Open Files",
    },
    {
      "<leader>sn",
      function()
        require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Search Neovim files",
    },
  },
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<esc>"] = require("telescope.actions").close,
          ["<C-j>"] = require("telescope.actions").move_selection_next,
          ["<C-k>"] = require("telescope.actions").move_selection_previous,
        },
        n = {
          ["<esc>"] = require("telescope.actions").close,
          ["<C-j>"] = require("telescope.actions").move_selection_next,
          ["<C-k>"] = require("telescope.actions").move_selection_previous,
        },
      },
    },
  },
}
```

### Step 9: Test Your Configuration
1. Launch LazyVim: `nvim`
2. Install plugins: `:Lazy sync`
3. Check for errors: `:checkhealth`
4. Test your custom keybindings:
   - `<leader>f` - Toggle neo-tree
   - `<leader>t` - Toggle terminal
   - `Ctrl+q` - Quit window
   - `xj` / `xk` - Navigate diagnostics
   - `xc` - Copy line reference
   - `xd` - Copy diagnostics
   - `xx` - Repeat terminal command
   - `<leader>rn` - Rename symbol
   - `gv` - Go to definition in vsplit
   - Telescope: `<leader>sf`, `<leader>sg`, etc.
5. Verify auto-save works (make a change and leave insert mode)
6. Test Copilot with `:Copilot enable`

### Step 10: Clean Up (Optional)
Once everything is working, you can remove the backup:
```bash
rm -rf ~/.config/nvim.backup
```

---

## Quick Reference: Your Migration

### Files to Create in `~/.config/nvim/`:

| File | Purpose | Status |
|------|---------|--------|
| `lua/config/keymaps.lua` | Custom keybindings (x prefix, Ctrl+q, etc.) | ✅ Create |
| `lua/plugins/auto-save.lua` | Auto-save on InsertLeave | ✅ Create |
| `lua/plugins/toggle-term.lua` | Terminal with `<leader>t` | ✅ Create |
| `lua/plugins/neo-tree.lua` | Override neo-tree keybinding to `<leader>f` | ✅ Create |
| `lua/plugins/lsp.lua` | Custom LSP keybindings (`gv`, `<leader>rn`) | ✅ Create |
| `lua/plugins/telescope.lua` | Telescope keybindings (Kickstart style) | ✅ Create |
| `lua/config/lazy.lua` | Add Copilot & TypeScript extras | ✅ Edit |

### What You're NOT Migrating (Using LazyVim Defaults):

- ❌ Harpoon - Using LazyVim's buffer navigation instead
- ❌ Marks.nvim - Using LazyVim defaults
- ❌ Quicker.nvim - Using LazyVim defaults
- ❌ Tokyodark theme - Using LazyVim's tokyonight/catppuccin
- ❌ Custom LSP settings - Using LazyVim defaults
- ❌ Custom Conform formatters - Using LazyVim defaults
- ❌ Telescope sort by modified - Using LazyVim defaults
- ❌ Nvim-tree - Using neo-tree instead
- ❌ Leap.nvim - Using flash.nvim instead
- ❌ Alpha-nvim dashboard - Using LazyVim's dashboard

---

## Summary of Your Migration

### What You're Keeping from Kickstart:

1. **Custom Diagnostic Navigation** (`x` prefix):
   - `xj` / `xk` - Next/prev diagnostic
   - `xh` - Code action
   - `xl` - Next diagnostic + code action
   - `xm` - Show diagnostic
   - `xq` - Diagnostic loclist
   - `xe` / `xE` - Next/prev error
   - `xw` / `xW` - Next/prev warning

2. **Claude Code Integration**:
   - `xc` - Copy line reference
   - `xd` - Copy diagnostics for Claude

3. **Terminal Workflow**:
   - `xx` - Repeat last terminal command
   - `<leader>t` - Toggle terminal (toggleterm)

4. **Custom LSP Keybindings**:
   - `gv` - Go to definition in vsplit
   - `<leader>rn` - Rename (instead of `<leader>cr`)

5. **Telescope Keybindings** (Kickstart style):
   - `<leader>sf` - Find files
   - `<leader>sg` - Live grep
   - `<leader>so` - Old files
   - `<leader><leader>` - Buffers
   - And all other `<leader>s*` bindings

6. **Other Keybindings**:
   - `Ctrl+q` - Quit window
   - `<leader>f` - Toggle neo-tree
   - `<leader>t` - Toggle terminal

7. **Plugins**:
   - Auto-save on InsertLeave
   - ToggleTerm (vertical terminal)
   - Copilot (via LazyVim extras)

### What You're Gaining from LazyVim:

1. **Better Window/Buffer Management**:
   - `Ctrl+h/j/k/l` - Navigate windows
   - `Alt+j/k` - Move lines
   - `Shift+h/l` - Navigate buffers
   - `Ctrl+arrows` - Resize windows

2. **Comprehensive UI Toggles** (`<leader>u*`)

3. **Flash.nvim** for enhanced motion/search

4. **Neo-tree** instead of nvim-tree

5. **Built-in Plugins**:
   - Trouble.nvim for diagnostics
   - Bufferline for buffer tabs
   - Persistence for session management
   - And many more LazyVim defaults

6. **Easier Plugin Management** via `:LazyExtras`

### Your Final Setup:
- **Base**: LazyVim with all defaults
- **File Explorer**: Neo-tree (`<leader>f`)
- **Terminal**: ToggleTerm (`<leader>t`)
- **Motion**: Flash.nvim (LazyVim default)
- **Dashboard**: LazyVim default
- **Theme**: LazyVim default (tokyonight/catppuccin)
- **Custom**: Your `x` prefix diagnostics, Claude integration, Telescope keybindings

---

## Additional Resources

- LazyVim Documentation: https://www.lazyvim.org
- LazyVim Keybindings: https://www.lazyvim.org/keymaps
- LazyVim Plugins: https://www.lazyvim.org/plugins
- Your kickstart config: `/home/maxtaylor/Documents/Code/dotfiles/nvim/`
- LazyVim config: `~/.config/nvim/`

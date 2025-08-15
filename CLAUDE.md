# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Setup and Installation

This is a personal dotfiles repository for configuring development tools. To install:

```bash
./setup.sh
```

The setup script creates symlinks for all configurations to their expected locations in the home directory.

## Architecture Overview

### Neovim Configuration
- **Base**: Built on kickstart.nvim with modular plugin architecture
- **Plugin Management**: Uses Lazy.nvim for plugin management
- **Structure**:
  - `nvim/init.lua` - Main entry point, loads config and plugins
  - `nvim/lua/config/` - Core configuration (settings, remaps, commands)
  - `nvim/lua/plugins/` - Individual plugin configurations as separate files
- **LSP Setup**: Uses Mason for LSP server management with lua_ls and ts_ls configured
- **Key Features**: Telescope for fuzzy finding, conform.nvim for formatting, comprehensive LSP configuration

### Terminal Configuration (WezTerm)
- **Main Config**: `terminal/wezterm.lua` with modular imports
- **Workspace Management**: Custom workspace system in `terminal/workspaces.lua`
- **Key Bindings**:
  - `Ctrl+n` - Choose workspace
  - `Leader+c` - Create new workspace
  - `Leader+r` - Rename workspace
  - `Ctrl+p` - Command palette

### Configuration Structure
- **Git**: `.gitconfig` symlinked from `git/`
- **Zsh**: `.zshrc` symlinked from `zsh/`
- **Tmux**: `.tmux.conf` symlinked from `tmux/` with TPM plugin manager
- **Keyboard**: Corne keyboard layout in `keyboard/corne.vil`

## Development Commands

### Setup and Installation
- Initial setup: `./setup.sh` - Creates symlinks for all configurations
- Symlinks bash scripts to `/usr/local/bin/` for global access

### Workflow Scripts (Available globally after setup)
- `claude-feature "task description"` - Create feature branch with git worktree and start Claude Code
  - Options: `-b` (base branch), `-n` (no Claude), `-c` (Claude args), `-p` (branch prefix)
  - Creates worktree in parent directory with naming pattern: `repo-name-branch-name`
  - Generates `.claude-prompt.md` with task context and implementation guide
- `restart-claude` - Kill and restart Claude Code process
- `delete_node_modules` - Recursively find and delete node_modules directories
- `kill_port <port>` - Kill process running on specified port

### Neovim
- Launch with: `nvim`
- Plugin management: `:Lazy` (view/update plugins)
- LSP management: `:Mason` (install language servers)
- Dependencies: Requires `git`, `make`, `ripgrep`, and a Nerd Font

### Configuration Updates
- Modify files in this repo, changes are reflected immediately via symlinks
- Re-run `./setup.sh` if adding new configuration files

## Key Customizations

### Neovim Keybindings
- `Ctrl+s` - Save file (normal and insert mode)
- `Ctrl+q` - Close window
- `x{j,k,h,l}` - Diagnostic navigation and code actions
- `Ctrl+l` - Accept Copilot suggestions (insert mode)

### Plugin Highlights
- **Telescope**: File finding with ripgrep integration, sorted by modification time
- **LSP**: Comprehensive setup with formatting, completion, and diagnostics
- **Auto-save**: Configured for automatic file saving
- **Conform**: Code formatting with stylua (Lua) and prettierd (JS/TS)

### WezTerm Features
- Tokyo Night color scheme with opacity and blur
- Dynamic status bar with workspace, time, and hostname
- Custom workspace management system
- Leader key: `Ctrl+a`

## File Organization
- Keep plugin configurations in separate files under `nvim/lua/plugins/`
- Configuration modules in `nvim/lua/config/`
- Terminal modules in `terminal/`
- Use existing patterns when adding new configurations
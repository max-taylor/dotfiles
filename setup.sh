#!/bin/bash

# Set envvar for dotfiles dir
export DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# # Install oh-my-zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
ln -sf $DOTFILES/zsh/.zshrc $HOME/.zshrc

# Git
ln -sf $DOTFILES/git/.gitconfig $HOME/.gitconfig

# Symlink with no extension
for script in "$DOTFILES/bash/"*; do
  name="$(basename "$script" .zsh)" # strip .zsh
  target="/usr/local/bin/$name"
  ln -snf "$script" "$target"
  chmod +x "$script"
done

# # MacOS applications
# if [[ $OSTYPE == "darwin"* ]]; then
#   . "$DOTFILES/install/brew-cask.sh"
# fi

# Claude Code config
# Symlink from ~/.config/.claude to ~/.claude (where Claude Code expects it)
CLAUDE_SOURCE="$DOTFILES/.claude"
CLAUDE_TARGET="$HOME/.claude"

mkdir -p "$CLAUDE_TARGET"

# Symlink claude.md -> CLAUDE.md (Claude expects uppercase)
ln -sf "$CLAUDE_SOURCE/claude.md" "$CLAUDE_TARGET/CLAUDE.md"

# Symlink commands directory
ln -snf "$CLAUDE_SOURCE/commands" "$CLAUDE_TARGET/commands"

# Symlink settings files
ln -sf "$CLAUDE_SOURCE/settings.json" "$CLAUDE_TARGET/settings.json"
ln -sf "$CLAUDE_SOURCE/settings.local.json" "$CLAUDE_TARGET/settings.local.json"

#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
BIN_DIR="$(brew --prefix 2>/dev/null || echo /usr/local)/bin"

mkdir -p "$CONFIG_HOME" "$BIN_DIR"

# Symlinks src -> dest, backing up any real (non-symlink) file/dir at dest first.
link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.bak.$(date +%Y%m%d%H%M%S)"
    echo "backed up existing $dest"
  fi
  ln -snf "$src" "$dest"
}

# # Install oh-my-zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Dotfiles -> $HOME
link "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"
link "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
link "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"

# App configs -> $XDG_CONFIG_HOME (~/.config)
for dir in nvim karabiner aerospace opencode ghostty; do
  [ -d "$DOTFILES/$dir" ] && link "$DOTFILES/$dir" "$CONFIG_HOME/$dir"
done

# Bash scripts -> bin dir, symlinked with .zsh extension stripped
for script in "$DOTFILES/bash/"*; do
  name="$(basename "$script" .zsh)"
  chmod +x "$script"
  link "$script" "$BIN_DIR/$name"
done

# # MacOS applications
# if [[ $OSTYPE == "darwin"* ]]; then
#   . "$DOTFILES/install/brew-cask.sh"
# fi

# Claude Code config
CLAUDE_TARGET="$HOME/.claude"
mkdir -p "$CLAUDE_TARGET"

# claude.md -> CLAUDE.md (Claude expects uppercase)
link "$DOTFILES/.claude/claude.md" "$CLAUDE_TARGET/CLAUDE.md"
link "$DOTFILES/.claude/rules" "$CLAUDE_TARGET/rules"
link "$DOTFILES/.claude/settings.local.json" "$CLAUDE_TARGET/settings.local.json"

mkdir -p "$CLAUDE_TARGET/skills"
for skill in "$DOTFILES/.claude/skills/"*/; do
  name="$(basename "$skill")"
  link "$skill" "$CLAUDE_TARGET/skills/$name"
done

echo "done"

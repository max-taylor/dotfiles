#!/bin/bash

# Set envvar for dotfiles dir
export DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# # Install oh-my-zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
ln -sf $DOTFILES/zsh/.zshrc $HOME/.zshrc

ln -sf $DOTFILES/aerospace/aerospace.toml $HOME/.aerospace.toml

# Git
ln -sf $DOTFILES/git/.gitconfig $HOME/.gitconfig

# Symlink with no extension
for script in "$DOTFILES/bash/"*; do
  name="$(basename "$script" .zsh)"  # strip .zsh
  target="/usr/local/bin/$name"
  ln -snf "$script" "$target"
  chmod +x "$script"
done

# Claude
mkdir -p $HOME/.claude/commands
for file in "$DOTFILES/claude/commands/"*; do
  ln -snf "$file" "$HOME/.claude/commands/$(basename "$file")"
done

# # MacOS applications
# if [[ $OSTYPE == "darwin"* ]]; then
#   . "$DOTFILES/install/brew-cask.sh"
# fi

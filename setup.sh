#!/bin/bash

# Set envvar for dotfiles dir
export DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Kitty
# rm -rf $HOME/.config/kitty
# mkdir -p $HOME/.config/kitty
# ln -snf $DOTFILES/kitty/* $HOME/.config/kitty

# TODO: Symlink the entire directory so we can create local files
rm -rf $HOME/.config/wezterm
# ln -snf $DOTFILES/wezterm/* $HOME/.config/wezterm
mkdir -p $HOME/.config/wezterm
# Symlink the wezterm config file
ln -snf $DOTFILES/wezterm/* $HOME/.config/wezterm
# ln -sf $DOTFILES/wezterm/.wezterm.lua $HOME/.wezterm.lua

# ZSH

# # Install oh-my-zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
ln -sf $DOTFILES/zsh/.zshrc $HOME/.zshrc

# Tmux
# Detect if already installed and skip installing tpm if so
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
ln -sf $DOTFILES/tmux/.tmux.conf $HOME/.tmux.conf

# Git
ln -sf $DOTFILES/git/.gitconfig $HOME/.gitconfig

# Nvim
rm -rf $HOME/.config/nvim
mkdir -p $HOME/.config/nvim
ln -snf $DOTFILES/nvim/* $HOME/.config/nvim

# # MacOS applications
# if [[ $OSTYPE == "darwin"* ]]; then
#   . "$DOTFILES/install/brew-cask.sh"
# fi

#!/bin/bash

# Set envvar for dotfiles dir
export DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

rm -rf $HOME/.config/wezterm
mkdir -p $HOME/.config/wezterm
# ln -snf $DOTFILES/terminal $HOME/.config/wezterm
# ln -snf $DOTFILES/terminal/.wezterm.lua ~/.config/wezterm/wezterm.lua

for file in "$DOTFILES/terminal"/*; do
  ln -snf "$file" "$HOME/.config/wezterm/$(basename "$file")"
done

# ln -snf $DOTFILES/terminal/* $HOME/.config/wezterm
# ln -snf $DOTFILES/terminal/.wezterm.lua ~/.config/wezterm/wezterm.lua


# Symlink the wezterm config file
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

# Symlink with no extension
for script in "$DOTFILES/bash/"*; do
  name="$(basename "$script" .zsh)"  # strip .zsh
  target="/usr/local/bin/$name"
  ln -snf "$script" "$target"
  chmod +x "$script"
done



# # MacOS applications
# if [[ $OSTYPE == "darwin"* ]]; then
#   . "$DOTFILES/install/brew-cask.sh"
# fi

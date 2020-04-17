#! /usr/bin/env bash

DOTPATH=${DOTPATH:-$HOME/.dotfiles}

# XDG Base Directory
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# create symlink for dotfiles
if [[ -f  $HOME/.zshrc ]]; then
  mv $HOME/.zshrc $HOME/.zshrc.$(date +'%Y%m%d%H%M%S').backup
fi 
ln -s $DOTPATH/zsh/.zshrc $HOME/.zshrc

# directories
link_dirs=(zsh)
for dir in "${link_dirs[@]}"; do
  if [ -d "$XDG_CONFIG_HOME/$dir" ]; then
    mv $XDG_CONFIG_HOME/$dir $XDG_CONFIG_HOME/$dir.$(date +'%Y%m%d%H%M%S').backup
  fi
  ln -snf $DOTPATH/$dir $XDG_CONFIG_HOME/$dir
done

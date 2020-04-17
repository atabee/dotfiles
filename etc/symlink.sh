#! /usr/bin/env bash

DOTPATH=${DOTPATH:-$HOME/.dotfiles}

# create symlink for dotfiles
if [[ -f  $HOME/.zshrc ]]; then
  mv $HOME/.zshrc $HOME/.zshrc.$(date +'%Y%m%d%H%M%S').backup
fi 
ln -s $DOTPATH/zsh/.zshrc $HOME/.zshrc

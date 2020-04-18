#! /usr/bin/env bash

# Path settings
DOTPATH=${DOTPATH:-$HOME/.dotfiles}

# load environment
source $DOTPATH/etc/env.sh

# create symlink for dotfiles
println "create symlink for dotfiles..."
if [ ! -e $HOME/.zshrc ]; then
  println "create symlink for zshrc..."
  ln -s $DOTPATH/zsh/.zshrc $HOME/.zshrc
fi

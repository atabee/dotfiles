#! /usr/bin/env bash

# Path settings
DOTPATH=${DOTPATH:-$HOME/.dotfiles}
BACKUP=${BACKUP:-$HOME/.backup}

# load environment
source $DOTPATH/etc/env.sh

if [ ! -d $BACKUP ]; then
  println "create backup folder..."
  mkdir -p $BACKUP
fi

# create symlink for dotfiles
println "create symlink for dotfiles..."

println "create symlink for zsh..."
if [ -e $HOME/.zshenv ]; then
  cp $HOME/.zshenv $BACKUP/.zshenv.$(date +%Y%m%d)
fi
ln -fs $DOTPATH/zsh/.zshenv $HOME/.zshenv

if [ -e $HOME/.zprofile ]; then
  cp $HOME/.zshenv $BACKUP/.zprofile.$(date +%Y%m%d)
fi
ln -fs $DOTPATH/zsh/.zprofile $HOME/.zprofile

println "create symlink for git..."
if [ -e $HOME/.gitconfig ]; then
  cp $HOME/.gitconfig $BACKUP/.gitconfig.$(date +%Y%m%d)
fi
ln -fs $DOTPATH/git/.gitconfig $HOME/.gitconfig

println "create symlink for tmux..."
if [ -e $HOME/.tmux.conf ]; then
  cp $HOME/.tmux.conf $BACKUP/.tmux.conf.$(date +%Y%m%d)
fi
ln -fs $DOTPATH/tmux/.tmux.conf $HOME/.tmux.conf

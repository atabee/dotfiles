#! /usr/bin/env zsh

DOTPATH=${DOTPATH:-$HOME/.dotfiles}

# zsh home directory
export ZDOTDIR=$DOTPATH/zsh

if [[ -s "${ZDOTDIR}/init.zsh" ]]; then
  source "${ZDOTDIR}/init.zsh"
fi

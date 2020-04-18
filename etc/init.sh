#! /usr/bin/env bash

# Path settings
DOTPATH=${DOTPATH:-$HOME/.dotfiles}
REPO=TanakaGeruge/dotfiles

# load environment
source $DOTPATH/etc/env.sh

# install tools
println "Install git..."
install_git

println "Install fzf..."
install_fzf

# Download dotfiles
if [ ! -d "$DOTPATH" ]; then
  println "Downloading dotfiles..."
  git clone --recursive "https://github.com/$REPO" "$DOTPATH"
fi

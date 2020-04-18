#! /usr/bin/env bash

# Path settings
DOTPATH=${DOTPATH:-$HOME/.dotfiles}

# load environment
source $DOTPATH/etc/env.sh

# install tools
println "Install fzf..."
install_fzf

#! /usr/bin/env bash

# Path settings
DOTPATH=${DOTPATH:-$HOME/.dotfiles}

# load environment
source $DOTPATH/etc/env.sh

# install fonts
println "Install fonts..."
$DOTPATH/res/common/fonts/install.sh

# install tools
println "Install fzf..."
install_fzf

println "Install go..."
install_go

println "Install ghq..."
install_ghq

println "Install other software..."
install_other

#! /usr/bin/env bash

# Path settings
DOTPATH=${DOTPATH:-$HOME/.dotfiles}

# load environment
source $DOTPATH/etc/env.sh

# install fonts
println "Install fonts..."
$DOTPATH/res/common/fonts/install.sh

# install tools
println "Install visual studio code..."
install_vcode

println "Install fzf..."
install_fzf

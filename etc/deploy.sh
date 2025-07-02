#! /usr/bin/env bash

echo "Deploy dotfiles..."

# Path settings
DOTPATH=${DOTPATH:-"$HOME"/.dotfiles}
BACKUP=${BACKUP:-"$HOME"/.backup}

# load environment
# shellcheck source=/dev/null
source "$DOTPATH"/etc/env.sh

if [ ! -d "$BACKUP" ]; then
  println "create backup folder..."
  mkdir -p "$BACKUP"
fi

# create symlink for dotfiles
println "create symlink for dotfiles..."

println "create symlink for zsh..."
if [ -e "$HOME"/.zshenv ]; then
  cp "$HOME"/.zshenv "$BACKUP"/.zshenv."$(date +%Y%m%d)"
fi
ln -fs "$DOTPATH"/zsh/.zshenv "$HOME"/.zshenv

if [ -e "$HOME"/.zprofile ]; then
  cp "$HOME"/.zshenv "$BACKUP"/.zprofile."$(date +%Y%m%d)"
fi
ln -fs "$DOTPATH"/zsh/.zprofile "$HOME"/.zprofile

println "setup git configuration..."
if [ ! -e "$HOME"/.gitconfig ]; then
  println "Creating .gitconfig from template..."
  cp "$DOTPATH"/git/.gitconfig.template "$HOME"/.gitconfig
  println "Please edit git/.gitconfig.local with your user information"
  println "See git/README.md for setup instructions"
else
  println "Git configuration already exists, skipping..."
fi

println "create symlink for vim..."
if [ -e "$HOME"/.vimrc ]; then
  cp "$HOME"/.vimrc "$BACKUP"/.vimrc."$(date +%Y%m%d)"
fi
ln -fs "$DOTPATH"/vim/.vimrc "$HOME"/.vimrc

println "create symlink for rye..."
if [ -e "$HOME"/.rye/config.toml ]; then
  cp "$HOME"/.rye/config.toml "$BACKUP"/config.toml."$(date +%Y%m%d)"
fi
ln -fs "$DOTPATH"/rye/config.toml "$HOME"/.rye/config.toml

println "create symlink for ghostty..."
if [ -e "$HOME"/.config/ghostty/config ]; then
  cp "$HOME"/.config/ghostty/config "$BACKUP"/.config/ghostty/config."$(date +%Y%m%d)"
fi
mkdir -p "$HOME"/.config/ghostty
ln -fs "$DOTPATH"/ghostty/config "$HOME"/.config/ghostty/config

println "create symlink for tmux..."
if [ -e "$HOME"/.tmux.conf ]; then
  cp "$HOME"/.tmux.conf "$BACKUP"/.tmux.conf."$(date +%Y%m%d)"
fi
ln -fs "$DOTPATH"/tmux/.tmux.conf "$HOME"/.tmux.conf

# Set ZDOTDIR
export DOTPATH=${DOTPATH:-$HOME/.dotfiles}
export ZDOTDIR=${ZDOTDIR:-$DOTPATH/zsh}

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

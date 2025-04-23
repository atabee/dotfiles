# zsh history
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=10000
export SAVEHIST=100000

# XDG Base Directory Specification
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share
export XDG_STATE_HOME=~/.local/state

# Java
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# gradle
if (($ + commands[gradle])); then
  export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
fi

# fzf
if (($ + commands[fzf])); then
  export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
  export FZF_COMPLETION_OPTS='+c -x'

  # Use ag instead of the default find command for listing candidates.
  # - The first argument to the function is the base path to start traversal
  # - Note that ag only lists files not directories
  # - See the source code (completion.{bash,zsh}) for the details.
  _fzf_compgen_path() {
    ag -g "" "$1"
  }
fi

# flutter fvm
export PATH="$PATH:$HOME/fvm/default/bin"

# go
export GOPATH=$HOME/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="${GOPATH}/bin:${GOROOT}/bin:$PATH"

# Node volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Ruby rbenv
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl)"
export RBENV_ROOT="$HOME/.rbenv"
eval "$(rbenv init -)"

# Python Rye
source "$HOME/.rye/env"

# Python tcl-tk
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"

# Rust cargo
. $HOME/.cargo/env

# bin files
export PATH="$DOTPATH/bin:${PATH:+${PATH}:}"

# trash
if type trash >/dev/null 2>&1; then
  alias rm='trash -F'
fi

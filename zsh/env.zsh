# XDG Base Directory Specification
export XDG_CONFIG_HOME=~/.config
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.share

# bin files
PATH="${PATH:+${PATH}:}$DOTPATH/bin"

# docker
#export DOCKER_BUILDKIT=1

# bundle
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"

# gradle
if (( $+commands[gradle] )); then
  export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
fi

# httpie
#if (( $+commands[http] )); then
#  export HTTPIE_CONFIG_DIR="$XDG_CONFIG_HOME/httpie"
#fi

# ipython/juniper
#export IPYTHONDIR="$XDG_CONFIG_HOME/jupyter"
#export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"

# nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
#[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# npm
#export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# Python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Python tcl-tk
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"

# Ruby
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
export RBENV_ROOT="$HOME/.rbenv"
export PATH="$RBENV_ROOT/shims:$PATH"
eval "$(rbenv init -)"

# Ruby Gem
export GEM_HOME="$XDG_DATA_HOME/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
export PATH="$GEM_HOME/bin:$PATH"

# openssl
#export PATH=/usr/local/opt/openssl@1.1/bin:$PATH

# krew
#export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# pipenv
#if (( $+commands[pipenv] )); then
#  export PIPENV_VENV_IN_PROJECT=1
#fi

# fzf
if (( $+commands[fzf] )); then
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

# Golang
if (( $+commands[go] )); then
  export GOROOT=/usr/local/opt/go/libexec
  export GOPATH=$HOME
  export GO111MODULE=on
  PATH=$PATH:$GOROOT/bin:$GOPATH/bin
fi

# ghq
export GHQ_ROOT=$GOPATH/src

# history
export HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
export HISTSIZE=10000
export SAVEHIST=100000

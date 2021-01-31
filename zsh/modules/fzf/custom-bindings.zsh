if (( $+commands[ghq] )); then
  function _fast_move_git_repo() {
    local dir
    dir=$(ghq list >/dev/null | fzf --reverse +m) && cd $(ghq root)/$dir
    zle accept-line
  }

  zle -N _fast_move_git_repo
  bindkey '^m' _fast_move_git_repo
fi

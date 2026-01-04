{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    # Default options (from env.zsh)
    defaultOptions = [
      "--height 40%"
      "--reverse"
      "--border"
    ];

    # Use ag for file search if available
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
    fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
  };

  # Custom fzf keybindings and functions in Zsh
  programs.zsh.initContent = lib.mkAfter ''
    # fzf completion options
    export FZF_COMPLETION_OPTS='+c -x'

    # Use ag for path completion if available
    _fzf_compgen_path() {
      ${pkgs.silver-searcher}/bin/ag -g "" "$1"
    }

    # Custom fzf + ghq binding (Ctrl+])
    if command -v ghq &> /dev/null; then
      function _fast_move_git_repo() {
        local dir
        dir=$(ghq list | fzf --reverse +m) && cd $(ghq root)/$dir
        zle reset-prompt
      }
      zle -N _fast_move_git_repo
      bindkey '^]' _fast_move_git_repo
    fi
  '';
}

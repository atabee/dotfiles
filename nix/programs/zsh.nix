{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;

    # History configuration (from env.zsh)
    history = {
      path = "${config.home.homeDirectory}/.zsh_history";
      size = 10000;
      save = 100000;
    };

    # Session variables (from env.zsh)
    sessionVariables = {
      # XDG Base Directory (already set in home.nix, but can override here)
      HISTFILE = "${config.home.homeDirectory}/.zsh_history";

      # DOTPATH for custom scripts
      DOTPATH = "${config.home.homeDirectory}/.dotfiles";
    };

    # Zsh options (from options.zsh)
    initExtra = ''
      # Japanese filename support
      setopt print_eight_bit

      # Disable beep
      setopt no_beep

      # Disable flow control
      setopt no_flow_control

      # Enable comments in interactive shell
      setopt interactive_comments

      # Share history between sessions
      setopt share_history

      # Remove extra spaces from history
      setopt hist_reduce_blanks

      # Auto-remove extra commas for smooth input
      setopt auto_param_keys

      # Enable brace expansion (e.g., mkdir {1-3})
      setopt brace_ccl

      # Complete from cursor position
      setopt complete_in_word

      # Extended glob patterns
      setopt extended_glob

      # Completion configuration
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      zstyle ':completion:*' ignore-parents parent pwd ..
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "${config.xdg.cacheHome}/zsh/compcache"

      # Source local config if exists
      [ -f ${config.xdg.configHome}/zsh/local.zsh ] && source ${config.xdg.configHome}/zsh/local.zsh

      # Source custom functions
      if [ -d ${config.xdg.configHome}/zsh/functions ]; then
        for func in ${config.xdg.configHome}/zsh/functions/*; do
          [ -f "$func" ] && source "$func"
        done
      fi
    '';

    # Shell aliases
    shellAliases = {
      # Will be populated as needed
    };

    # Zsh plugins (replacing Prezto)
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.zsh-history-substring-search;
        file = "share/zsh-history-substring-search/zsh-history-substring-search.zsh";
      }
    ];

    # Powerlevel10k instant prompt
    initExtraBeforeCompInit = ''
      # Enable Powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Load Powerlevel10k configuration
      [[ -f ${config.xdg.configHome}/zsh/.p10k.zsh ]] && source ${config.xdg.configHome}/zsh/.p10k.zsh
    '';

    # Enable completion
    enableCompletion = true;
  };
}

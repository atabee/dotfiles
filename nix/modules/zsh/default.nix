{
  config,
  pkgs,
  lib,
  profile ? "personal",
  ...
}:

{
  programs.zsh = {
    enable = true;

    # Use XDG config directory for Zsh dotfiles
    dotDir = "${config.xdg.configHome}/zsh";

    # History configuration (from env.zsh)
    history = {
      path = "${config.home.homeDirectory}/.zsh_history";
      size = 10000;
      save = 100000;
    };

    # Session variables
    sessionVariables = {
      # XDG Base Directory (already set in home.nix, but can override here)
      HISTFILE = "${config.home.homeDirectory}/.zsh_history";
    };

    # Zsh initialization content (replaces initExtra and initExtraBeforeCompInit)
    initContent = lib.mkMerge [
      # Content before compinit (lib.mkOrder 550)
      # Personal profile: Powerlevel10k instant prompt
      # Work profile: Custom vcs_info prompt setup
      (lib.mkOrder 550 (
        if profile == "personal" then ''
          # Enable Powerlevel10k instant prompt
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi

          # Load Powerlevel10k configuration
          [[ -f ${config.xdg.configHome}/zsh/p10k.zsh ]] && source ${config.xdg.configHome}/zsh/p10k.zsh
        '' else ''
          # Work profile: Custom prompt with vcs_info
          autoload -Uz vcs_info add-zsh-hook

          # vcs_info configuration
          zstyle ':vcs_info:*' enable git
          zstyle ':vcs_info:*' check-for-changes true
          zstyle ':vcs_info:*' stagedstr '%F{10}+%f'
          zstyle ':vcs_info:*' unstagedstr '%F{11}*%f'
          zstyle ':vcs_info:git:*' formats '%F{10}%b%f%c%u'
          zstyle ':vcs_info:git:*' actionformats '%F{10}%b%f|%F{9}%a%f%c%u'

          # Function to get ahead/behind count
          function _git_ahead_behind() {
              local ahead behind
              ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null)
              behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null)
              local result=""
              [[ $ahead -gt 0 ]] && result+="%F{10}↑''${ahead}%f"
              [[ $behind -gt 0 ]] && result+="%F{9}↓''${behind}%f"
              echo $result
          }

          # Function to check for untracked files
          function _git_untracked() {
              if git status --porcelain 2>/dev/null | grep -q '^??'; then
                  echo '%F{11}?%f'
              fi
          }

          # precmd hook for vcs_info
          function precmd_vcs_info() {
              vcs_info
              if [[ -n ''${vcs_info_msg_0_} ]]; then
                  local git_status="''${vcs_info_msg_0_}"
                  git_status+="$(_git_untracked)"
                  git_status+="$(_git_ahead_behind)"
                  WORK_GIT_STATUS=" %F{8}git:%f''${git_status}"
              else
                  WORK_GIT_STATUS=""
              fi
          }
          add-zsh-hook precmd precmd_vcs_info

          # Prompt configuration
          setopt PROMPT_SUBST
          PROMPT=$'\n%F{12}%~%f''${WORK_GIT_STATUS}\n%(?.%F{10}.%F{9})>%f '
          RPROMPT='%F{8}%*%f'
        ''
      ))

      # Content after compinit (default order)
      ''
        # Emacs keybindings (explicitly set regardless of $EDITOR)
        bindkey -e

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
      ''
    ];

    # Shell aliases (Prezto-style ls aliases using eza)
    shellAliases = lib.mkMerge [
      # Common aliases for all platforms
      {
        # ls aliases using eza (modern ls replacement)
        ls = "eza --icons --git";
        l = "eza -1 --icons"; # One column
        la = "eza -lah --icons --git"; # All files, long format
        ll = "eza -lh --icons --git"; # Long format
        lt = "eza -lh --icons --git -snew"; # Sort by modified time
        lr = "eza -lhR --icons --git"; # Recursive
        tree = "eza --tree --icons"; # Tree view

        # Safety aliases
        rm = "trash-put"; # Use trash instead of rm

        # Other common aliases
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
      }

      # macOS-specific aliases (dynamic architecture detection)
      # uname -m returns "arm64" on Apple Silicon, "x86_64" on Intel
      (lib.mkIf pkgs.stdenv.isDarwin {
        nixup-p = "sudo darwin-rebuild switch --flake ~/.dotfiles\\#personal-$(arch=$(uname -m); [ \"$arch\" = \"arm64\" ] && echo aarch64 || echo $arch)-darwin --impure";
        nixup-w = "sudo darwin-rebuild switch --flake ~/.dotfiles\\#work-$(arch=$(uname -m); [ \"$arch\" = \"arm64\" ] && echo aarch64 || echo $arch)-darwin --impure";
      })

      # Linux-specific aliases
      (lib.mkIf pkgs.stdenv.isLinux {
        nixup-p = "home-manager switch --flake ~/.dotfiles\\#personal-$(uname -m)-linux --impure";
        nixup-w = "home-manager switch --flake ~/.dotfiles\\#work-$(uname -m)-linux --impure";
      })
    ];

    # Zsh plugins (replacing Prezto)
    # Personal profile: includes Powerlevel10k
    # Work profile: common plugins only (no Powerlevel10k)
    plugins =
      let
        commonPlugins = [
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
        p10kPlugin = [
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
        ];
      in
      if profile == "personal" then p10kPlugin ++ commonPlugins else commonPlugins;

    # Enable completion
    enableCompletion = true;

    # Skip insecure directories check (common with Nix-managed completion paths)
    completionInit = "autoload -U compinit && compinit -u";
  };
}

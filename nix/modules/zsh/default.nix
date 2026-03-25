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
      size = 100000;
      save = 100000;
      share = true;
      append = true;
    };

    # Session variables
    sessionVariables = {
    };

    # Zsh initialization content (replaces initExtra and initExtraBeforeCompInit)
    initContent = lib.mkMerge [
      # Content before compinit (lib.mkOrder 550)
      # Powerlevel10k instant prompt
      (lib.mkOrder 550 ''
        # Enable Powerlevel10k instant prompt
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi

        # Load Powerlevel10k configuration
        [[ -f ${config.xdg.configHome}/zsh/p10k.zsh ]] && source ${config.xdg.configHome}/zsh/p10k.zsh
      '')

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

        # jenv (Java version manager)
        export PATH="$HOME/.jenv/bin:$PATH"
        eval "$(jenv init -)"

        # git-wt (git worktree helper)
        eval "$(git wt --init zsh)"

        ${lib.optionalString (profile == "work") ''
          # Copilot CLI (work profile only)
          # Claude Codeのdeny設定に合わせたツール制限:
          #   - shell: sudo, rm, git resetなどを禁止
          #   - ファイルパターン単位の制限(.env, secret, keyなど)は
          #     Copilot CLIの仕様上サポートされないため適用不可
          copilot() {
            HISTFILE=/dev/null command copilot \
              --allow-all-tools \
              --deny-tool='shell(sudo)' \
              --deny-tool='shell(rm)' \
              --deny-tool='shell(dd)' \
              --deny-tool='shell(diskutil)' \
              --deny-tool='shell(mkfs)' \
              --deny-tool='shell(shutdown)' \
              --deny-tool='shell(reboot)' \
              --deny-tool='shell(kill)' \
              --deny-tool='shell(killall)' \
              --deny-tool='shell(launchctl)' \
              --deny-tool='shell(git reset)' \
              --deny-tool='shell(git clean)' \
              --deny-tool='shell(nc)' \
              "$@"
          }
        ''}

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
    # Powerlevel10k + common plugins
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
      p10kPlugin ++ commonPlugins;

    # Enable completion
    enableCompletion = true;

    # Skip insecure directories check (common with Nix-managed completion paths)
    completionInit = "autoload -U compinit && compinit -u";
  };
}

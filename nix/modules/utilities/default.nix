{ pkgs, lib, ... }:

{
  # Collection of small utilities and tools
  home.packages = with pkgs; [
    # File and directory utilities
    fd # fast find alternative
    tree # Directory tree visualization
    trash-cli # Safe rm replacement
    lv # Powerful file viewer

    # Data processing
    jq # JSON processor

    # Download tools
    aria2 # Multi-protocol download utility

    # Search tools
    silver-searcher # ag - code search tool (used by fzf)

    # Git tools
    ghq # Git repository organizer

    # Development tools
    uv # Fast Python package installer

    # Nix formatting
    nixfmt
  ];

  # Shell integration for utilities
  programs.zsh.initContent = lib.mkAfter ''
    # Python uv shell completion
    if command -v uv &> /dev/null; then
      eval "$(${pkgs.uv}/bin/uv generate-shell-completion zsh)"
    fi

    # Add local bin to PATH (for uv and other tools)
    export PATH="$HOME/.local/bin:$PATH"
  '';
}

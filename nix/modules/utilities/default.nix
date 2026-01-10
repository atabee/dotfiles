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

    # Nix formatting
    nixfmt
  ];

}

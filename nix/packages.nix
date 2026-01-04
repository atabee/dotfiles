{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Core tools (from etc/init.sh)
    fzf
    go
    ghq
    lv

    # Development version managers
    mise             # Polyglot runtime manager (formerly rtx)

    # Rust toolchain
    rustup

    # Python tools
    uv               # Fast Python package installer

    # Git tools
    git
    git-lfs
    delta            # Better git diff

    # Search and find tools
    ripgrep          # rg - fast grep alternative
    silver-searcher  # ag - code search tool (used by fzf)
    fd               # fast find alternative

    # File utilities
    trash-cli        # Safe rm replacement

    # Other useful tools
    bat              # cat with syntax highlighting
    eza              # modern ls replacement
  ];

  # Note: jenv is not available in nixpkgs.
  # If you need Java version management, consider using mise or asdf-vm with Java plugins,
  # or manage Java versions through Nix itself.
}

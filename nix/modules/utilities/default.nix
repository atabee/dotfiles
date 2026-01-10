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

  # bat - cat with syntax highlighting
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      pager = "less -FR";
    };
  };

  # delta - better git diff
  programs.delta = {
    enable = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = true;
    };
  };

  # eza - modern ls replacement
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };

  # gh - GitHub CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };

  # ripgrep - fast grep alternative
  programs.ripgrep = {
    enable = true;
    arguments = [
      "--max-columns=150"
      "--max-columns-preview"
      "--glob=!.git/*"
      "--smart-case"
    ];
  };

  # Shell aliases
  home.shellAliases = {
    cat = "bat";
  };
}

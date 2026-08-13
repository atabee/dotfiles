{
  pkgs,
  lib,
  ...
}:

let
  ghSettings = {
    git_protocol = "ssh";
    prompt = "enabled";
  };
  yamlFormat = pkgs.formats.yaml { };
in

{
  # Collection of small utilities and tools
  home.packages = with pkgs; [
    # File and directory utilities
    fd # fast find alternative
    tree # Directory tree visualization
    trash-cli # Safe rm replacement

    # Data processing
    jq # JSON processor

    # Search tools
    silver-searcher # ag - code search tool (used by fzf)

    # Git tools
    ghq # Git repository organizer

    # Nix formatting
    nixfmt

    # AWS CLI
    awscli2
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
  programs.gh = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    settings = ghSettings;
  };

  # macOSではシステムパッケージのghを使い、設定ファイルだけを管理する
  xdg.configFile."gh/config.yml" = lib.mkIf pkgs.stdenv.isDarwin {
    source = yamlFormat.generate "gh-config.yml" ({ version = "1"; } // ghSettings);
  };

  # programs.ghを使わないmacOSでも既存のcredential helper設定を維持する
  programs.git.settings.credential = lib.mkIf pkgs.stdenv.isDarwin {
    "https://github.com".helper = [
      ""
      "!gh auth git-credential"
    ];
    "https://gist.github.com".helper = [
      ""
      "!gh auth git-credential"
    ];
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
}

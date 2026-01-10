{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Import module configurations
  imports = [
    # Platform-specific configurations
    ./platform/darwin.nix

    # Core programs
    ./modules/zsh
    ./modules/fzf
    ./modules/git
    ./modules/ghostty

    # Development tools
    ./modules/bat
    ./modules/delta
    ./modules/eza
    ./modules/gh
    ./modules/go
    ./modules/node
    ./modules/python
    ./modules/ripgrep
    ./modules/ruby
    ./modules/rustup

    # Utilities
    ./modules/utilities

    # Mobile development (optional - remove if not needed)
    # ./modules/mobile-dev
  ];

  # Dynamic user configuration (requires --impure flag)
  # This allows the same config to work on different machines without hardcoding usernames
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  # Home Manager version
  home.stateVersion = "24.05";

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # XDG Base Directory
  xdg.enable = true;

  # File management - deploy configuration files
  home.file = {
    # Powerlevel10k configuration
    ".config/zsh/p10k.zsh".source = ./modules/zsh/p10k.zsh;

    # Custom Zsh functions
    ".config/zsh/functions".source = ./modules/zsh/functions;

    # Local Zsh configuration template
    # Users should copy this to ~/.config/zsh/local.zsh and customize
    ".config/zsh/local.zsh.template".source = ./modules/zsh/local.zsh.template;
  };
}

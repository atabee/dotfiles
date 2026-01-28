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
    ./modules/tmux

    # Development tools
    ./modules/direnv
    ./modules/mise
    ./modules/go
    ./modules/node
    ./modules/python
    ./modules/ruby
    ./modules/rustup

    # Utilities
    ./modules/utilities

    # Mobile development
    ./modules/mobile-dev
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

  # Nix configuration (enables Flakes for official Nix installer)
  # Intel Mac uses official Nix which requires explicit experimental-features
  # Apple Silicon uses Determinate Nix which has this pre-enabled
  xdg.configFile."nix/nix.conf" = lib.mkIf (pkgs.stdenv.hostPlatform.system == "x86_64-darwin") {
    text = ''
      experimental-features = nix-command flakes
    '';
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    PAGER = "bat";
    LANG = "ja_JP.UTF-8";
  };

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

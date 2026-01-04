{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Import module configurations
  imports = [
    ./packages.nix
    ./programs/zsh.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/ghostty.nix
    ./modules/env-vars.nix
    # Note: Platform-specific modules (darwin.nix, linux.nix) are integrated into env-vars.nix
    # using runtime platform detection to avoid Nix evaluation issues
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
    ".config/zsh/.p10k.zsh".source = ../config/zsh/.p10k.zsh;

    # Custom Zsh functions
    ".config/zsh/functions".source = ../config/zsh/functions;

    # Local Zsh configuration template
    # Users should copy this to ~/.config/zsh/local.zsh and customize
    ".config/zsh/local.zsh.template".source = ../config/zsh/local.zsh.template;

    # ZDOTDIR configuration for Zsh
    ".zshenv".text = ''
      export DOTPATH=''${DOTPATH:-$HOME/.dotfiles}
      export ZDOTDIR=''${ZDOTDIR:-$HOME/.config/zsh}
    '';
  };
}

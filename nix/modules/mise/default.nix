{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    mise # Polyglot runtime manager (formerly rtx)
  ];

  # Mise shell activation for Zsh
  programs.zsh.initContent = lib.mkAfter ''
    # mise (polyglot version manager)
    if command -v mise &> /dev/null; then
      eval "$(${pkgs.mise}/bin/mise activate zsh)"
    fi
  '';

  # Users can create ~/.config/mise/config.toml for configuration
}

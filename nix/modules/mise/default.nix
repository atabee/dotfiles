{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Install mise package
  home.packages = with pkgs; [
    mise
  ];

  # Zsh integration
  programs.zsh = {
    initContent = ''
      # Initialize mise (polyglot runtime manager)
      if command -v mise &> /dev/null; then
        eval "$(mise activate zsh)"
      fi
    '';
  };
}

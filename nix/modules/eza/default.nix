{ pkgs, ... }:

{
  home.packages = with pkgs; [
    eza # Modern ls replacement
  ];

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };
}

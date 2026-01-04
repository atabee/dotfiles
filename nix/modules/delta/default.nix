{ pkgs, ... }:

{
  home.packages = with pkgs; [
    delta # Better git diff
  ];

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = true;
    };
  };
}

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat # cat with syntax highlighting
  ];

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      pager = "less -FR";
    };
  };

  home.shellAliases = {
    cat = "bat";
  };
}

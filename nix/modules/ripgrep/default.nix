{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep # rg - fast grep alternative
  ];

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

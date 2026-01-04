{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gh # GitHub CLI
  ];

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
  };
}

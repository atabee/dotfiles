{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    git
    git-lfs
  ];

  programs.git = {
    enable = true;

    # Common Git configuration (from .gitconfig.template)
    settings = {
      core = {
        editor = "vim -c \"set fenc=utf-8\"";
        autocrlf = "input";
      };

      pull = {
        rebase = false;
      };

      ghq = {
        root = [
          "~/go/src"
          "~/src"
        ];
      };

      filter.lfs = {
        required = true;
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
      };

      # Include local user-specific configuration
      # Users should create ~/.config/git/.gitconfig.local with their user info
      include = {
        path = "~/.config/git/.gitconfig.local";
      };
    };
  };

  # Deploy local git config template
  home.file.".config/git/.gitconfig.local.template".source = ./gitconfig.local.template;

  # Note: Users should manually copy the template to ~/.config/git/.gitconfig.local and customize
}

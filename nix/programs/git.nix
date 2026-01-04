{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;

    # Common Git configuration (from .gitconfig.template)
    extraConfig = {
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
      # Users should create ~/.dotfiles/git/.gitconfig.local with their user info
      include = {
        path = "~/.dotfiles/git/.gitconfig.local";
      };
    };
  };

  # Note: Template file is available at ~/.dotfiles/config/git/.gitconfig.local.template
  # Users should manually copy it to ~/.dotfiles/git/.gitconfig.local and customize
}

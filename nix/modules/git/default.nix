{
  pkgs,
  ...
}:

{
  programs.git = {
    enable = true;

    # macOSではnix-darwinのenvironment.systemPackagesから提供する
    package = if pkgs.stdenv.isDarwin then null else pkgs.git;

    lfs = {
      enable = true;
      package = if pkgs.stdenv.isDarwin then null else pkgs.git-lfs;
    };

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

      alias = {
        show-graph = "log --graph --decorate --abbrev-commit --format=format:'%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset)%C(yellow)%d%C(reset)\n  %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
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

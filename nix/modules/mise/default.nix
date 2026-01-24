{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Configure mise with Home Manager
  programs.mise = {
    enable = true;

    # Global tool versions and settings
    globalConfig = {
      tools = {
        ruby = "3.2.10";
      };

      settings = {
        experimental = true;
      };
    };
  };

  # Auto-install tools on activation
  home.activation.miseInstall = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Add mise to PATH
    export PATH="${pkgs.mise}/bin:$PATH"

    if command -v mise &> /dev/null; then
      $DRY_RUN_CMD mise install --yes
    fi
  '';
}

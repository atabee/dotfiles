{ config, pkgs, lib, ... }:

{
  # Linux-specific configuration
  # Only activated when running on Linux
  config = lib.mkIf pkgs.stdenv.isLinux {
    # Linux/WSL2-specific packages
    home.packages = with pkgs; [
      xsel  # Clipboard support (used by copy.zsh function)
    ];

    # Linux-specific environment variables
    programs.zsh.sessionVariables = {
      # Add Linux-specific variables here if needed
    };
  };
}

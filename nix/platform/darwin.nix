{ config, pkgs, lib, ... }:

{
  # macOS-specific configuration
  # Only activated when running on macOS (Darwin)
  config = lib.mkIf pkgs.stdenv.isDarwin {
    # macOS-specific environment variables (from Darwin.zsh)
    programs.zsh.sessionVariables = {
      # Android SDK
      ANDROID_HOME = "${config.home.homeDirectory}/Library/Android/sdk";
      NDK_HOME = "${config.home.homeDirectory}/Library/Android/sdk/ndk/26.1.10909125";
    };
  };
}

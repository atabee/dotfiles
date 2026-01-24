{ pkgs, lib, config, ... }:

{
  # Ruby is managed by mise
  # CocoaPods is installed via Nix (macOS only)

  home.packages = lib.optionals pkgs.stdenv.isDarwin [
    pkgs.cocoapods
  ];

  home.sessionVariables = {
    # Configure gem installation path
    GEM_HOME = "${config.home.homeDirectory}/.gem";
    GEM_PATH = "${config.home.homeDirectory}/.gem";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.gem/bin"
  ];
}

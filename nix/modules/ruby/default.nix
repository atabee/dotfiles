{ pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [
    ruby_3_4 # Ruby programming language
  ] ++ lib.optionals stdenv.isDarwin [
    cocoapods # iOS dependency manager (macOS only)
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

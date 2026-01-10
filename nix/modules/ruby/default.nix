{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    ruby_3_4 # Ruby programming language
    cocoapods # iOS dependency manager
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

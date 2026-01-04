{ config, pkgs, lib, ... }:

{
  # Ghostty terminal configuration
  # Since Home Manager doesn't have a native Ghostty module yet,
  # we manage the config file directly

  home.file.".config/ghostty/config".source = ../../ghostty/config;
}

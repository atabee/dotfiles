{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pnpm
  ];

  xdg.configFile."pnpm/rc".text = ''
    minimum-release-age=1440
    block-exotic-subdeps=true
  '';
}

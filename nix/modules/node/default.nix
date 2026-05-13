{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pnpm
  ];

  xdg.configFile."pnpm/rc".text = ''
    minimum-release-age=10080
    block-exotic-subdeps=true
  '';
}

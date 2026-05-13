{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pnpm
  ];

  xdg.configFile."pnpm/config.yaml".text = ''
    minimumReleaseAge: 1440
    blockExoticSubdeps: true
    onlyBuiltDependencies: []
  '';
}

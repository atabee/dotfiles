{
  description = "Cross-machine dotfiles with Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      # Helper function to create Home Manager configuration for a system
      mkHomeConfiguration =
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [ ./nix/home.nix ];
        };
    in
    {
      homeConfigurations = {
        # macOS Intel
        "x86_64-darwin" = mkHomeConfiguration "x86_64-darwin";

        # macOS Apple Silicon
        "aarch64-darwin" = mkHomeConfiguration "aarch64-darwin";

        # Linux x86_64
        "x86_64-linux" = mkHomeConfiguration "x86_64-linux";

        # Linux ARM64
        "aarch64-linux" = mkHomeConfiguration "aarch64-linux";
      };
    };
}

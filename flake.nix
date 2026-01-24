{
  description = "Cross-machine dotfiles with Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-darwin,
      nix-homebrew,
      ...
    }:
    let
      # Helper function to create Home Manager configuration for a system
      mkHomeConfiguration =
        system: profile:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            # Enable unfree packages (needed for some development tools)
            config.allowUnfree = true;
            # Apple Silicon specific optimizations
            config.allowUnsupportedSystem = false;
          };
          modules = [
            ./nix/home-manager.nix
            { _module.args = { inherit profile; }; }
          ];
        };

      # Helper function to create nix-darwin configuration
      mkDarwinConfiguration =
        system: profile:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit profile; };
          modules = [
            # Home Manager integration
            home-manager.darwinModules.home-manager
            (
              let
                sudoUser = builtins.getEnv "SUDO_USER";
                currentUser = builtins.getEnv "USER";
                username = if sudoUser != "" then sudoUser else currentUser;
              in
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                # Backup file extension for conflicting files
                home-manager.backupFileExtension = "backup";
                home-manager.users.${username} = { pkgs, lib, ... }: {
                  imports = [ ./nix/home-manager.nix ];
                  home.username = lib.mkForce username;
                  home.homeDirectory = lib.mkForce "/Users/${username}";
                  home.stateVersion = "24.05";
                };
                home-manager.extraSpecialArgs = { inherit profile; };
              }
            )
            # Homebrew management
            nix-homebrew.darwinModules.nix-homebrew
            {
              # System version (set once, never change)
              system.stateVersion = 6;

              # Primary user for system activation
              # Use SUDO_USER when running with sudo, otherwise fall back to USER
              system.primaryUser =
                let
                  sudoUser = builtins.getEnv "SUDO_USER";
                  currentUser = builtins.getEnv "USER";
                in
                  if sudoUser != "" then sudoUser else currentUser;

              # Disable nix-darwin's Nix management when using Determinate Nix
              # Determinate Nix uses its own daemon that conflicts with nix-darwin
              nix.enable = false;

              # Homebrew configuration
              nix-homebrew = {
                enable = true;
                enableRosetta = true; # Enable Rosetta 2 for x86_64 compatibility
                user =
                  let
                    sudoUser = builtins.getEnv "SUDO_USER";
                    currentUser = builtins.getEnv "USER";
                  in
                    if sudoUser != "" then sudoUser else currentUser;
                autoMigrate = true; # Auto-migrate existing Homebrew installations
              };
            }
            ./nix/modules/homebrew
          ];
        };
    in
    {
      homeConfigurations = {
        # macOS Apple Silicon (backward compatibility - defaults to personal)
        "aarch64-darwin" = mkHomeConfiguration "aarch64-darwin" "personal";
        # Alias for uname -m compatibility
        "arm64-darwin" = mkHomeConfiguration "aarch64-darwin" "personal";

        # Linux x86_64 (backward compatibility - defaults to personal)
        "x86_64-linux" = mkHomeConfiguration "x86_64-linux" "personal";

        # Linux ARM64 (backward compatibility - defaults to personal)
        "aarch64-linux" = mkHomeConfiguration "aarch64-linux" "personal";
        # Alias for uname -m compatibility
        "arm64-linux" = mkHomeConfiguration "aarch64-linux" "personal";

        # Personal configurations (explicit)
        "personal-aarch64-darwin" = mkHomeConfiguration "aarch64-darwin" "personal";
        "personal-x86_64-linux" = mkHomeConfiguration "x86_64-linux" "personal";
        "personal-aarch64-linux" = mkHomeConfiguration "aarch64-linux" "personal";

        # Work configurations
        "work-aarch64-darwin" = mkHomeConfiguration "aarch64-darwin" "work";
        "work-x86_64-linux" = mkHomeConfiguration "x86_64-linux" "work";
        "work-aarch64-linux" = mkHomeConfiguration "aarch64-linux" "work";
      };

      # nix-darwin configuration for macOS (Apple Silicon only)
      darwinConfigurations = {
        # Backward compatibility - defaults to personal
        "aarch64-darwin" = mkDarwinConfiguration "aarch64-darwin" "personal";

        # Personal configuration (explicit)
        "personal-aarch64-darwin" = mkDarwinConfiguration "aarch64-darwin" "personal";

        # Work configuration
        "work-aarch64-darwin" = mkDarwinConfiguration "aarch64-darwin" "work";
      };
    };
}

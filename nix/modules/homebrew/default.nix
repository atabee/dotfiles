{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Homebrew configuration for macOS
  # Manages packages, casks, and taps declaratively
  homebrew = {
    enable = true;

    # Auto-update Homebrew and upgrade packages
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap"; # Remove all cached downloads and old versions
    };

    # Global Homebrew settings
    global = {
      brewfile = true;
    };

    # Homebrew taps
    # Note: homebrew/bundle, homebrew/cask, and homebrew/core are no longer needed
    # as they are now built-in to Homebrew
    taps = [
      # Add any third-party taps you need here
    ];

    # Homebrew packages (CLI tools)
    brews = [
      # Development tools
      "jenv" # Java version manager

      # Other tools that may not be available via Nix
      # Add any other brews you need here
    ];

    # Homebrew casks (GUI applications)
    casks = [
      # Development tools
      "ghostty"
      "visual-studio-code"
      "android-studio"
      "swiftformat-for-xcode"
      "claude-code"
      "claude" # Claude Desktop
      "font-monaspace"

      # Browsers
      "google-chrome"

      # Productivity
      "raycast"
      "1password"
      "notion"

      # Utilities
      "rectangle" # Window management
      "the-unarchiver" # Archive utility
      "tailscale" # VPN/mesh networking

      # Add any other casks you need here
    ];

    # Mac App Store applications
    # Use `mas search <app name>` to find app IDs
    masApps = {
      # Example:
      # "Xcode" = 497799835;
      # "Slack" = 803453959;
    };
  };
}

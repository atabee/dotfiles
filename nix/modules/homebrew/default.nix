{
  config,
  pkgs,
  lib,
  profile ? "personal",
  ...
}:

let
  # Common casks for both personal and work
  commonCasks = [
    # Development tools
    "ghostty"
    "iterm2"
    "visual-studio-code"
    "android-studio"
    "temurin@11"
    "temurin@17"
    "xcodes-app"
    "swiftformat-for-xcode"
    "claude-code"
    "claude" # Claude Desktop
    "font-monaspace"

    # Browsers
    "google-chrome"

    # Productivity
    "raycast"

    # Utilities
    "rectangle" # Window management
    "the-unarchiver" # Archive utility
    "google-japanese-ime" # Japanese input method
  ];

  # Personal-only casks (forbidden for work)
  personalCasks = [
    "1password"
    "notion"
    "tailscale-app" # VPN/mesh networking
  ];

  # Work-only casks (can be extended in the future)
  workCasks = [
    # Add work-specific applications here if needed
  ];

  # Select casks based on profile
  selectedCasks = commonCasks
    ++ lib.optionals (profile == "personal") personalCasks
    ++ lib.optionals (profile == "work") workCasks;

  # Common brews for both personal and work
  commonBrews = [
    # Development tools
    "jenv" # Java version manager

    # Git tools
    "k1LoW/tap/git-wt" # Git worktree manager
  ];

  # Work-only brews
  workBrews = [
    "copilot-cli" # GitHub Copilot CLI
  ];

  # Select brews based on profile
  selectedBrews = commonBrews
    ++ lib.optionals (profile == "work") workBrews;
in

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
      "k1LoW/tap" # For git-wt
      # Add any third-party taps you need here
    ];

    # Homebrew packages (CLI tools)
    # Automatically filtered based on profile (personal/work)
    brews = selectedBrews;

    # Homebrew casks (GUI applications)
    # Automatically filtered based on profile (personal/work)
    casks = selectedCasks;

    # Mac App Store applications
    # Use `mas search <app name>` to find app IDs
    masApps = {
      # Example:
      # "Xcode" = 497799835;
      # "Slack" = 803453959;
    };
  };
}

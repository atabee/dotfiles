{ config, pkgs, lib, ... }:

{
  # Environment variables for various tools (from env.zsh)
  programs.zsh.sessionVariables = {
    # Go environment
    GOPATH = "${config.home.homeDirectory}/go";
    # GOROOT is automatically set by Nix's go package

    # Gradle
    GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";

    # Android SDK (macOS - will be set but only used on macOS)
    ANDROID_HOME = "${config.home.homeDirectory}/Library/Android/sdk";
    NDK_HOME = "${config.home.homeDirectory}/Library/Android/sdk/ndk/26.1.10909125";

    # Add custom bin directory to PATH
    PATH = "$DOTPATH/bin:$PATH";
  };

  # Tool initialization and activation
  programs.zsh.initContent = lib.mkAfter ''
    # mise (polyglot version manager)
    if command -v mise &> /dev/null; then
      eval "$(${pkgs.mise}/bin/mise activate zsh)"
    fi

    # Note: jenv is not available in nixpkgs
    # If you need Java version management, use mise or manage via Nix
    # Example: Add to ~/.config/zsh/local.zsh if jenv is installed manually:
    #   export PATH="$HOME/.jenv/bin:$PATH"
    #   eval "$(jenv init -)"

    # Python uv shell completion
    if command -v uv &> /dev/null; then
      eval "$(${pkgs.uv}/bin/uv generate-shell-completion zsh)"
    fi

    # Rust cargo environment
    if [ -f "$HOME/.cargo/env" ]; then
      source "$HOME/.cargo/env"
    fi

    # trash-cli: replace rm with trash
    if command -v trash &> /dev/null; then
      alias rm='trash -F'
    fi

    # Flutter fvm (if installed manually)
    if [ -d "$HOME/fvm/default/bin" ]; then
      export PATH="$PATH:$HOME/fvm/default/bin"
    fi

    # Add local bin to PATH (for uv and other tools)
    export PATH="$HOME/.local/bin:$PATH"

    # Platform-specific PATH additions
    if [[ "$(uname)" == "Darwin" ]]; then
      # macOS-specific
      # Android SDK tools
      if [ -d "$ANDROID_HOME" ]; then
        export PATH="$ANDROID_HOME/platform-tools:$PATH"
        export PATH="$ANDROID_HOME/tools:$PATH"
      fi

      # Dart pub cache
      if [ -d "$HOME/.pub-cache/bin" ]; then
        export PATH="$HOME/.pub-cache/bin:$PATH"
      fi
    elif [[ "$(uname)" == "Linux" ]]; then
      # Linux-specific
      # WSL-specific detection
      if grep -qi microsoft /proc/version 2>/dev/null; then
        # Running under WSL
        # Add WSL-specific configurations here
      fi
    fi

    # Go PATH (common for both platforms)
    export PATH="''${GOPATH}/bin:$PATH"
  '';
}

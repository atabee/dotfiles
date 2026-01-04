{ config, lib, ... }:

{
  # モバイル開発環境設定（Android/Flutter/Gradle）
  # このモジュールはオプションです。使用しない場合はhome-manager.nixから削除してください。

  programs.zsh.sessionVariables = {
    # Gradle
    GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";

    # Android SDK (macOS)
    ANDROID_HOME = "${config.home.homeDirectory}/Library/Android/sdk";
    NDK_HOME = "${config.home.homeDirectory}/Library/Android/sdk/ndk/26.1.10909125";
  };

  programs.zsh.initContent = lib.mkAfter ''
    # Flutter fvm (if installed manually)
    if [ -d "$HOME/fvm/default/bin" ]; then
      export PATH="$PATH:$HOME/fvm/default/bin"
    fi

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
    fi
  '';
}

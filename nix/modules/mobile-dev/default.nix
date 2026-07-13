{
  config,
  lib,
  pkgs,
  ...
}:

let
  androidSdkHome =
    if pkgs.stdenv.isDarwin then
      "${config.home.homeDirectory}/Library/Android/sdk"
    else
      "${config.home.homeDirectory}/Android/Sdk";
in
{
  home.packages = with pkgs; [
    fvm # Flutter Version Manager
  ];
  # モバイル開発環境設定（Android/Flutter/Gradle）

  programs.zsh.sessionVariables = {
    # Gradle
    GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";

    # Android SDK（Windows側のSDKとは分離して管理する）
    ANDROID_HOME = androidSdkHome;
    NDK_HOME = "${androidSdkHome}/ndk/26.1.10909125";
  };

  programs.zsh.initContent = lib.mkAfter ''
    # Flutter fvm (if installed manually)
    if [ -d "$HOME/fvm/default/bin" ]; then
      export PATH="$PATH:$HOME/fvm/default/bin"
    fi

    # Android SDK tools
    if [ -d "$ANDROID_HOME/platform-tools" ]; then
      export PATH="$ANDROID_HOME/platform-tools:$PATH"
    fi

    if [[ "$(uname)" == "Darwin" ]]; then
      # Dart pub cache
      if [ -d "$HOME/.pub-cache/bin" ]; then
        export PATH="$HOME/.pub-cache/bin:$PATH"
      fi
    fi
  '';
}

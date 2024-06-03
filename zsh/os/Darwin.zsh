# Android
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"
export PATH="$HOME/Library/Android/sdk/tools:$PATH"
if (( $+commands[android] )); then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export NDK_HOME=$ANDROID_HOME/ndk/26.1.10909125
fi

# dart
export PATH="$HOME/.pub-cache/bin:$PATH"

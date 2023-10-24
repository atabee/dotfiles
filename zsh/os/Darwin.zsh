# Android
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"
export PATH="$HOME/Library/Android/sdk/tools:$PATH"
if (( $+commands[android] )); then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
fi

# dart
export PATH="$HOME/.pub-cache/bin:$PATH"

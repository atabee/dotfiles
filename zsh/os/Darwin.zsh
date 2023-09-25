# Android
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"
export PATH="$HOME/Library/Android/sdk/tools:$PATH"
if (( $+commands[android] )); then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
fi

# java
export JAVA_HOME=/Applications/"Android Studio.app"/Contents/jbr/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# dart
export PATH="$HOME/.pub-cache/bin:$PATH"

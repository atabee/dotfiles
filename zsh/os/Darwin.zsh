if (( $+commands[brew] )); then
  # brew docterでpyenvのpathがエラーが出るので
  alias brew="env PATH=${PATH/\/Users\/${USER}\/\.pyenv\/shims:/} brew"

  function update() {
    brew update
    brew upgrade
    brew cask upgrade
    brew cleanup
  }
fi

# java
if (( $+commands[java] )); then
  export JAVA_HOME=$(/usr/libexec/java_home -v 11)
  PATH=$JAVA_HOME/bin:$PATH
fi

# Android
export PATH=~/Library/Android/sdk/platform-tools:$PATH
export PATH=~/Library/Android/sdk/tools:$PATH
if (( $+commands[android] )); then
  export ANDROID_HOME=~/Library/Android/sdk
fi


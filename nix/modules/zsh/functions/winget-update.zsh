# Windows側のWinGet構成をWSLから適用する
_winget_configure() {
  local config_file="$1"

  if (( ! $+commands[winget.exe] )); then
    print -u2 "winget.exe が見つかりません。Windows App Installerを更新してください。"
    return 1
  fi

  winget.exe configure --file \
    "$(wslpath -w "$HOME/.dotfiles/.config/$config_file")" \
    --accept-configuration-agreements
}

wingetup-p() {
  _winget_configure configuration.winget &&
    _winget_configure configuration-personal.winget
}

wingetup-w() {
  _winget_configure configuration.winget
}

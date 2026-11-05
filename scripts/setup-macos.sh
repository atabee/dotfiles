#!/usr/bin/env bash
# nix-darwinで設定していたTouch ID・tmux対応・Rosettaを引き継ぐ。
set -euo pipefail
if [ "$(uname -s)" != Darwin ]; then
  echo 'macOS専用のスクリプトです。' >&2
  exit 1
fi
brew_prefix=$(brew --prefix)
pam_module="$brew_prefix/opt/pam-reattach/lib/pam/pam_reattach.so"
if [ ! -f "$pam_module" ]; then
  echo '先にdotfiles installでpam-reattachをインストールしてください。' >&2
  exit 1
fi
if [ "${1:-}" = --print ]; then
  printf 'auth       optional       %s\nauth       sufficient     pam_tid.so\n' "$pam_module"
  exit 0
fi
if [ "$#" -ne 0 ]; then
  echo '使い方: bash scripts/setup-macos.sh [--print]' >&2
  exit 2
fi

# 元のPAM設定を一度だけ退避する。リンク先へ書かず、通常ファイルに置き換える。
sudo /bin/sh -s -- "$pam_module" <<'SETUP'
set -eu
target=/etc/pam.d/sudo_local
if [ -e "$target" ] && [ ! -e /etc/pam.d/sudo_local.before-dotfiles ]; then
  cp -L "$target" /etc/pam.d/sudo_local.before-dotfiles
fi
temporary=$(mktemp /etc/pam.d/sudo_local.dotfiles.XXXXXX)
trap 'rm -f "$temporary"' EXIT HUP INT TERM
printf '# dotfiles: Touch ID / tmux\nauth       optional       %s\nauth       sufficient     pam_tid.so\n' "$1" > "$temporary"
if [ -f "$target" ]; then
  # 上の2モジュール以外に設定されている認証方法は残す。
  awk '!/pam_reattach\.so/ && !/pam_tid\.so/ && !/^# dotfiles: Touch ID/' "$target" >> "$temporary"
fi
chmod 644 "$temporary"
chown root:wheel "$temporary"
mv -f "$temporary" "$target"
SETUP

if [ "$(uname -m)" = arm64 ] && ! /usr/bin/pgrep -q oahd \
  && ! /usr/sbin/pkgutil --pkg-info com.apple.pkg.RosettaUpdateAuto >/dev/null 2>&1; then
  sudo /usr/sbin/softwareupdate --install-rosetta --agree-to-license
fi
echo 'Touch IDとRosettaの設定を反映しました。'

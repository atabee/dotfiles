#!/usr/bin/env bash
# macOSまたはUbuntuに、管理ツールを導入して設定を適用する。
set -euo pipefail
repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
export PATH="$HOME/.local/bin:$PATH"
case "${1:-}" in
  ''|--prepare) ;;
  *) echo '使い方: bash scripts/bootstrap.sh [--prepare]' >&2; exit 2 ;;
esac

case "$(uname -s)" in
  Darwin)
    if ! command -v brew >/dev/null 2>&1; then
      for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        if [ -x "$candidate" ]; then
          eval "$("$candidate" shellenv)"
          break
        fi
      done
    fi
    if ! command -v brew >/dev/null 2>&1; then
      echo 'READMEに従ってHomebrewをインストールしてから再実行してください。' >&2
      exit 1
    fi
    eval "$(brew shellenv)"
    brew install chezmoi
    ;;
  Linux)
    if [ ! -r /etc/os-release ]; then echo 'Ubuntuが必要です。' >&2; exit 1; fi
    # shellcheck disable=SC1091
    . /etc/os-release
    if [ "${ID:-}" != ubuntu ] || [ "${VERSION_ID%%.*}" -lt 24 ]; then
      echo 'Ubuntu 24.04以降（WSL2を含む）が必要です。' >&2
      exit 1
    fi
    case "$(uname -m)" in
      x86_64|aarch64|arm64) ;;
      *) echo '対応アーキテクチャはx86_64とARM64です。' >&2; exit 1 ;;
    esac
    sudo apt-get update
    sudo apt-get install --yes ca-certificates curl git zsh
    temporary=$(mktemp -d)
    trap 'rm -rf "$temporary"' EXIT
    mkdir -p "$HOME/.local/bin"
    if [ ! -x "$HOME/.local/bin/mise" ]; then
      curl --fail --location --silent --show-error https://mise.run --output "$temporary/mise.sh"
      MISE_INSTALL_PATH="$HOME/.local/bin/mise" sh "$temporary/mise.sh"
    fi
    if [ ! -x "$HOME/.local/bin/chezmoi" ]; then
      curl --fail --location --silent --show-error https://get.chezmoi.io --output "$temporary/chezmoi.sh"
      sh "$temporary/chezmoi.sh" -b "$HOME/.local/bin"
    fi
    ;;
  *) echo '対応OSはmacOSまたはUbuntuです。' >&2; exit 1 ;;
esac

if [ "${1:-}" = --prepare ]; then
  echo '管理ツールを用意しました。設定反映は行っていません。'
  exit 0
fi

chezmoi --source "$repo_dir" init
chezmoi --source "$repo_dir" diff
echo '設定反映とパッケージの導入・更新・未使用miseバージョン整理を実行します。'
chezmoi --source "$repo_dir" apply
echo '設定を反映しました。exec zsh -lでシェルを読み直してください。'

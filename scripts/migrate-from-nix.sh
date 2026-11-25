#!/usr/bin/env bash
# Home Managerの管理リンクだけを退避する。Nix本体・SDK・個人設定は削除しない。
set -euo pipefail
repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
mode=${1:---dry-run}
case "$mode" in
  --dry-run|--apply) ;;
  *) echo '使い方: bash scripts/migrate-from-nix.sh [--dry-run|--apply]' >&2; exit 2 ;;
esac
if ! command -v chezmoi >/dev/null 2>&1; then
  echo '先にbash scripts/bootstrap.sh --prepareでchezmoiを導入し、PATHを確認してください。' >&2
  exit 1
fi
backup_dir="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/nix-backup-$(date +%Y%m%d-%H%M%S)-$$"

backup_link() {
  local relative=$1 target="$HOME/$1" link
  [ -L "$target" ] || return 0
  link=$(readlink "$target")
  case "$link" in
    /nix/store/*|/etc/profiles/per-user/*|/nix/var/nix/profiles/*)
      printf '%s -> %s\n' "$target" "$backup_dir/$relative"
      if [ "$mode" = --apply ]; then
        mkdir -p "$backup_dir/$(dirname "$relative")"
        # 元リンクを維持し、内容も保存する。過去のNix世代がなくなっても復元可能。
        if [ -e "$target" ]; then
          cp -RL "$target" "$backup_dir/$relative.contents"
        fi
        mv "$target" "$backup_dir/$relative"
      fi
      ;;
  esac
}

# 親ディレクトリがリンクの場合は子より先に退避する。
managed=$(chezmoi --source "$repo_dir" managed --path-style relative)
while IFS= read -r relative; do
  [ -n "$relative" ] && backup_link "$relative"
done <<< "$managed"

# 新構成では不要になるHome Manager固有のリンク。
for relative in \
  .zshrc .zprofile .zlogin .zlogout .profile .bashrc .bash_profile \
  .config/zsh/.zlogin .config/zsh/.zlogout \
  .config/zsh/plugins/powerlevel10k \
  .config/zsh/plugins/zsh-syntax-highlighting \
  .config/zsh/plugins/zsh-autosuggestions \
  .config/zsh/plugins/zsh-history-substring-search \
  .config/direnv/lib/hm-nix-direnv.sh \
  .config/nix/nix.conf \
  .config/environment.d/10-home-manager.conf; do
  backup_link "$relative"
done
if [ "$mode" = --dry-run ]; then
  echo '確認後、--applyを付けて実行すると表示したリンクを退避します。'
else
  echo "退避先: $backup_dir"
  echo '続けてbash scripts/bootstrap.shを実行してください。'
fi

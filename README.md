# dotfiles

個人用dotfiles設定（Nix + Home Managerベース）

## インストール方法

### Nixベース（推奨）

```bash
# 1. Nixをインストール（未インストールの場合）
sh <(curl -L https://nixos.org/nix/install) --daemon

# 2. Flakes機能を有効化
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf

# 3. dotfilesをクローンして適用
git clone https://github.com/atabee/dotfiles ~/.dotfiles && \
cd ~/.dotfiles && \
nix run home-manager/master -- switch --flake ".#$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')" --impure
```

詳細は [nix/README.md](nix/README.md) を参照してください。

### レガシーインストール（非推奨）

```bash
# 注意: このインストール方法は非推奨です。Nixベースのインストールを推奨します。
curl -L raw.githubusercontent.com/atabee/dotfiles/main/install | bash
```

## 対応プラットフォーム

- macOS (Intel/Apple Silicon)
- Linux (x86_64/ARM64)
- WSL2

## ドキュメント

- **インストールガイド**: [nix/README.md](nix/README.md)
- **移行ガイド**: [nix/MIGRATION.md](nix/MIGRATION.md)
- **詳細な計画**: [.claude/plans/clever-beaming-quokka.md](.claude/plans/clever-beaming-quokka.md)

## 主な機能

- ✅ 宣言的なパッケージ管理（Nix）
- ✅ クロスプラットフォーム対応
- ✅ ユーザー名のハードコーディングなし
- ✅ センシティブデータの分離
- ✅ 簡単なロールバック機能
- ✅ Zsh + Powerlevel10k
- ✅ fzf統合
- ✅ Git、Ghostty設定管理

## 構成

```
nix/                # Nix設定ファイル
├── home.nix        # メイン設定
├── packages.nix    # パッケージ一覧
├── programs/       # プログラム別設定
└── modules/        # カスタムモジュール

config/             # ネイティブ設定ファイル
├── zsh/           # Zsh設定（.p10k.zsh等）
└── git/           # Gitローカル設定テンプレート

etc/                # レガシースクリプト（非推奨）
```

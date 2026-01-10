# dotfiles

個人用dotfiles設定（Nix + Home Manager + nix-darwin）

## 対応プラットフォーム

- macOS (Apple Silicon)
- Linux (x86_64/ARM64)
- WSL2

## インストール方法

### 前提条件: Nixのインストール

このdotfilesを使用する前に、Nixをインストールする必要があります。

**推奨**: [Determinate Systems](https://docs.determinate.systems/)の公式ドキュメントに従ってNixをインストールしてください。Determinate Nixは Flakes 機能が自動的に有効化され、並列評価、遅延ツリー、macOS用のネイティブLinuxビルダーなどの機能強化が含まれています。

> **公式ドキュメント**: <https://docs.determinate.systems/>

**注意**: このdotfilesはDeterminate Nix用に設定されています（`nix.enable = false`）。Determinate Nixは独自のデーモンでNixを管理するため、nix-darwinのNix管理機能は無効化されています。

### macOS (Apple Silicon)

Nixをインストール後、以下の手順でdotfilesを適用します:

#### 1. dotfilesのクローン

```bash
git clone https://github.com/atabee/dotfiles ~/.dotfiles
cd ~/.dotfiles
```

#### 2. 既存の設定ファイルをバックアップ（初回のみ）

nix-darwinは`/etc`内のファイルを管理するため、既存のファイルをバックアップします:

```bash
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin
```

**注意**: すでにnix-darwinをインストール済みの場合、この手順はスキップできます。

#### 3. nix-darwinのインストール（すべての設定を一括適用）

```bash
sudo nix run nix-darwin -- switch --flake '.#aarch64-darwin' --impure
```

**注意**:

- `--impure`フラグは環境変数（`SUDO_USER`など）を読み取るために必要です
- このコマンド一回で、nix-darwin（システム設定 + Homebrew）とHome Manager（ユーザー環境）の両方が適用されます

このコマンドが成功すると、`darwin-rebuild`コマンドが使えるようになります。

#### 4. Rosetta 2のインストール（オプション）

Intel向けのHomebrewパッケージを使用する場合、Rosetta 2が必要です:

```bash
softwareupdate --install-rosetta
```

その後、設定を再適用:

```bash
cd ~/.dotfiles
sudo darwin-rebuild switch --flake '.#aarch64-darwin' --impure
```

### Linux

LinuxではHome Managerのみを使用します（nix-darwinはmacOS専用）。

Nixをインストール後、以下の手順でdotfilesを適用します:

```bash
# dotfilesをクローンして適用
git clone https://github.com/atabee/dotfiles ~/.dotfiles
cd ~/.dotfiles
nix run home-manager/master -- switch --flake ".#$(uname -m)-linux" --impure
```

このコマンドで、ユーザー環境設定（パッケージ、シェル設定、Git設定など）が適用されます。

## 設定の更新

### macOS

設定ファイルを変更した後は、以下のコマンドで全ての設定を反映できます:

```bash
cd ~/.dotfiles
sudo darwin-rebuild switch --flake '.#aarch64-darwin' --impure
```

このコマンド一回で以下の設定が全て適用されます:

- システム設定（nix-darwin）
- Homebrewパッケージ
- ユーザー環境設定（Home Manager）
- シェル設定、Git設定など

### Linux

Linuxではnix-darwinは使用せず、Home Managerのみで管理します:

```bash
cd ~/.dotfiles
home-manager switch --flake ".#$(uname -m)-linux" --impure
```

**注意**: Linuxではシステムレベルの設定管理（nix-darwin相当）は含まれません。Home Managerのユーザー環境設定のみが適用されます。

## パッケージの更新

flake inputs（nixpkgs、home-managerなど）を最新版に更新:

```bash
cd ~/.dotfiles
nix flake update
```

その後、設定を再適用:

- **macOS**: `sudo darwin-rebuild switch --flake '.#aarch64-darwin' --impure`
- **Linux**: `home-manager switch --flake ".#$(uname -m)-linux" --impure`

## ロールバック

Home Managerは設定の世代を保持しています。問題が発生した場合、以前の世代に戻すことができます:

```bash
# 世代のリストを表示
home-manager generations

# 特定の世代をアクティブ化
/nix/store/XXXXX-home-manager-generation/activate
```

## ローカルカスタマイゼーション

### Git設定

個人情報は`~/.config/git/.gitconfig.local`に設定してください:

```ini
[user]
    name = Your Name
    email = your.email@example.com

[credential]
    helper = osxkeychain  # macOS の場合
```

テンプレートファイルが`~/.config/git/.gitconfig.local.template`に配置されるので、これをコピーして編集してください:

```bash
cp ~/.config/git/.gitconfig.local.template ~/.config/git/.gitconfig.local
```

このファイルはgitで追跡されず、マシンごとに異なる設定を保持できます。

### Zsh設定

マシン固有のZsh設定は`~/.config/zsh/local.zsh`に記述できます:

```zsh
# マシン固有の環境変数
export SOME_LOCAL_VAR="value"

# マシン固有のエイリアス
alias local-command='...'
```

このファイルはHome Managerによって読み込まれますが、gitで追跡されません。

## Homebrewパッケージ管理（macOS）

nix-darwinを使用してHomebrewパッケージを宣言的に管理します。設定は`nix/modules/homebrew/default.nix`にあります。

### 現在インストールされているパッケージ

#### Brews（CLIツール）

- `jenv` - Java version manager

#### Casks（GUIアプリケーション）

- **開発ツール**: ghostty, visual-studio-code, android-studio, swiftformat-for-xcode, claude-code, claude
- **フォント**: font-monaspace
- **ブラウザ**: google-chrome
- **生産性**: raycast, 1password, notion
- **ユーティリティ**: rectangle（ウィンドウ管理）, the-unarchiver（アーカイブ）, tailscale（VPN）

### パッケージの追加方法

1. `nix/modules/homebrew/default.nix`を編集
2. `brews`リスト（CLIツール）または`casks`リスト（GUIアプリ）に追加
3. 設定を適用: `sudo darwin-rebuild switch --flake '~/.dotfiles#aarch64-darwin' --impure`

### Homebrew設定の特徴

- `autoUpdate = true`: 設定適用時にHomebrewを自動更新
- `upgrade = true`: インストール済みパッケージを自動アップグレード
- `cleanup = "zap"`: キャッシュと古いバージョンを自動削除

## 主な機能

- ✅ 宣言的なパッケージ管理（Nix + Homebrew）
- ✅ クロスプラットフォーム対応
- ✅ macOSシステム設定の宣言的管理（nix-darwin）
- ✅ ユーザー名のハードコーディングなし
- ✅ センシティブデータの分離
- ✅ 簡単なロールバック機能
- ✅ Zsh + Powerlevel10k
- ✅ fzf統合
- ✅ Git、Ghostty設定管理
- ✅ プログラムごとにフォルダで整理

## 主なツール

- **gh**: GitHub CLI - リポジトリやissueの管理
- **aria2**: マルチプロトコルダウンローダー
- **tree**: ディレクトリツリー可視化
- **jq**: JSONプロセッサ

## 構成

```
nix/
├── home-manager.nix    # Home Manager メイン設定
├── flake.nix           # Flake設定（エントリーポイント）
├── modules/            # カスタムモジュール
│   ├── homebrew/      # Homebrew設定（macOS）
│   ├── git/           # Git設定（テンプレート含む）
│   ├── nodejs/        # Node.js設定
│   ├── ruby/          # Ruby設定
│   ├── zsh/           # Zsh設定
│   ├── fzf/           # fzf設定
│   ├── ghostty/       # Ghostty設定
│   ├── bat/           # bat設定
│   ├── delta/         # delta設定
│   ├── eza/           # eza設定
│   ├── gh/            # GitHub CLI設定
│   ├── go/            # Go設定
│   ├── ripgrep/       # ripgrep設定
│   └── rustup/        # Rust設定
└── platform/           # プラットフォーム固有設定
    ├── darwin.nix     # macOS設定
    └── linux.nix      # Linux設定
```

各モジュールの詳細は、各ディレクトリのREADME.mdを参照してください。

## トラブルシューティング

### darwin-rebuild が見つからない

初回インストール時は`sudo nix run nix-darwin -- switch --flake '.#aarch64-darwin' --impure`を実行してください。

### primary user does not exist エラー

`--impure`フラグを付けて実行してください（環境変数の読み取りに必要）。

### Unexpected files in /etc エラー

インストール手順のステップ2を参照してください。既存ファイルのバックアップが必要です。

## 参考リンク

- [Determinate Systems](https://docs.determinate.systems/) - Nixのインストールと使い方
- [nix-darwin](https://github.com/nix-darwin/nix-darwin) - macOS システム設定管理
- [Home Manager](https://github.com/nix-community/home-manager) - ユーザー環境設定管理
- [nix-homebrew](https://github.com/zhaofengli-wip/nix-homebrew) - Homebrew統合
- [移行ガイド](nix/MIGRATION.md) - 既存環境からの移行手順

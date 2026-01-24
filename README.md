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

### 簡単な更新方法（推奨）

設定適用後、以下のエイリアスが使用可能になります:

```bash
# 個人用マシン
nixup-p

# 業務用マシン
nixup-w
```

### macOS（フルコマンド）

設定ファイルを変更した後は、以下のコマンドで全ての設定を反映できます:

```bash
cd ~/.dotfiles
# 個人用マシン（デフォルト、後方互換性維持）
sudo darwin-rebuild switch --flake '.#aarch64-darwin' --impure
# または明示的に
sudo darwin-rebuild switch --flake '.#personal-aarch64-darwin' --impure

# 業務用マシン
sudo darwin-rebuild switch --flake '.#work-aarch64-darwin' --impure
```

このコマンド一回で以下の設定が全て適用されます:

- システム設定（nix-darwin）
- Homebrewパッケージ（プロファイルに応じてフィルタリング）
- ユーザー環境設定（Home Manager）
- シェル設定、Git設定など

### Linux（フルコマンド）

Linuxではnix-darwinは使用せず、Home Managerのみで管理します:

```bash
cd ~/.dotfiles
# 個人用マシン（デフォルト、後方互換性維持）
home-manager switch --flake ".#$(uname -m)-linux" --impure
# または明示的に
home-manager switch --flake ".#personal-$(uname -m)-linux" --impure

# 業務用マシン
home-manager switch --flake ".#work-$(uname -m)-linux" --impure
```

**注意**: Linuxではシステムレベルの設定管理（nix-darwin相当）は含まれません。Home Managerのユーザー環境設定のみが適用されます。

## パッケージの更新

flake inputs（nixpkgs、home-managerなど）を最新版に更新:

```bash
cd ~/.dotfiles
nix flake update
```

その後、設定を再適用:

```bash
# 簡単な方法
nixup-p  # 個人用
nixup-w  # 業務用

# またはフルコマンド
# macOS: sudo darwin-rebuild switch --flake '.#personal-aarch64-darwin' --impure
# Linux: home-manager switch --flake ".#personal-$(uname -m)-linux" --impure
```

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

## プロファイルシステム（個人用/業務用）

このdotfilesは個人用マシンと業務用マシンで異なるパッケージセットを使用できる**プロファイルシステム**を実装しています。

### プロファイルの種類

- **個人用（personal）**: 全てのパッケージをインストール
- **業務用（work）**: 業務で使用禁止のソフトウェアを除外

### 業務用で除外されるパッケージ（macOS）

- `1password` - パスワードマネージャー
- `notion` - ノートアプリ
- `tailscale-app` - VPN/メッシュネットワーク

### 使い分け方法

初回インストール時、または設定更新時にプロファイルを指定:

```bash
# 個人用マシン
nixup-p  # または sudo darwin-rebuild switch --flake '.#personal-aarch64-darwin' --impure

# 業務用マシン
nixup-w  # または sudo darwin-rebuild switch --flake '.#work-aarch64-darwin' --impure
```

**後方互換性**: 既存の`.#aarch64-darwin`は個人用プロファイルをデフォルトとします。

## Homebrewパッケージ管理（macOS）

nix-darwinを使用してHomebrewパッケージを宣言的に管理します。設定は`nix/modules/homebrew/default.nix`にあります。

### 現在インストールされているパッケージ

#### Brews（CLIツール）

- `jenv` - Java version manager
- `k1LoW/tap/git-wt` - Git worktree manager

#### Casks（GUIアプリケーション）

**全プロファイル共通:**
- **開発ツール**: ghostty, iterm2, visual-studio-code, android-studio, xcodes-app, swiftformat-for-xcode, claude-code, claude
- **フォント**: font-monaspace
- **ブラウザ**: google-chrome
- **生産性**: raycast
- **ユーティリティ**: rectangle（ウィンドウ管理）, the-unarchiver（アーカイブ）, google-japanese-ime

**個人用プロファイルのみ:**
- **生産性**: 1password, notion
- **ネットワーク**: tailscale-app

### パッケージの追加方法

1. `nix/modules/homebrew/default.nix`を編集
2. パッケージの種類に応じて追加:
   - `brews`: CLIツール
   - `commonCasks`: 全プロファイル共通のGUIアプリ
   - `personalCasks`: 個人用のみのGUIアプリ
   - `workCasks`: 業務用のみのGUIアプリ
3. 設定を適用: `nixup-p` または `nixup-w`

### Homebrew設定の特徴

- `autoUpdate = true`: 設定適用時にHomebrewを自動更新
- `upgrade = true`: インストール済みパッケージを自動アップグレード
- `cleanup = "zap"`: キャッシュと古いバージョンを自動削除
- **プロファイルベースのフィルタリング**: 業務用マシンでは禁止ソフトウェアを自動除外

## 主な機能

- ✅ 宣言的なパッケージ管理（Nix + Homebrew）
- ✅ クロスプラットフォーム対応
- ✅ macOSシステム設定の宣言的管理（nix-darwin）
- ✅ **個人用/業務用プロファイルシステム**（禁止ソフトウェアの自動除外）
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
│   ├── fzf/           # fzf設定
│   ├── git/           # Git設定（テンプレート含む）
│   ├── ghostty/       # Ghostty設定
│   ├── zsh/           # Zsh設定
│   ├── go/            # Go設定
│   ├── nodejs/        # Node.js設定
│   ├── python/        # Python設定（uv）
│   ├── ruby/          # Ruby設定
│   ├── rustup/        # Rust設定
│   └── utilities/     # CLIツール集（bat, delta, eza, gh, ripgrep等）
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

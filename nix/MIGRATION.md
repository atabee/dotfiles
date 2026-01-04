# 移行ガイド: Homebrew + Prezto → Nix + Home Manager

このガイドでは、従来のHomebrewベースのdotfilesから新しいNixベースのセットアップへの移行方法を説明します。

## クイック移行

### 既存ユーザー向け

既に旧dotfilesを使用している場合：

1. **現在の設定をバックアップ**
   ```bash
   # 旧deploy.shは自動でバックアップを作成しますが、念のため
   cp ~/.zshrc ~/.zshrc.backup
   cp ~/.gitconfig ~/.gitconfig.backup
   ```

2. **ローカル設定ファイルを作成**
   ```bash
   # Git設定（必須）
   cp ~/.dotfiles/config/git/.gitconfig.local.template ~/.dotfiles/git/.gitconfig.local
   # ユーザー情報を編集
   vim ~/.dotfiles/git/.gitconfig.local

   # Zshローカル設定（オプション）
   cp ~/.config/zsh/local.zsh.template ~/.config/zsh/local.zsh
   ```

3. **Nix設定を適用**
   ```bash
   cd ~/.dotfiles
   nix run home-manager/master -- switch --flake ".#$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')" --impure
   ```

4. **新しいシェルを起動**
   ```bash
   exec zsh
   ```

### 新規ユーザー向け

`nix/README.md`のインストール手順に従ってください。

## 変更点

### パッケージ管理

**以前（Homebrew）:**
- パッケージは`etc/init.sh`で定義
- `brew install`でインストール

**現在（Nix）:**
- パッケージは`nix/packages.nix`で定義
- Home Managerで宣言的にインストール

### Zsh設定

**以前（Prezto）:**
- フレームワーク: Prezto（gitサブモジュール）
- 設定ファイル: `zsh/.zshrc`, `zsh/init.zsh`, `zsh/env.zsh`, `zsh/options.zsh`
- プラグインはPreztoで管理

**現在（Nix）:**
- フレームワーク: なし（Nixで直接管理）
- 設定ファイル: `nix/programs/zsh.nix`
- プラグインはHome Managerで管理

**保持されるもの:**
- Powerlevel10k設定（`.p10k.zsh`）
- カスタム関数（`functions/`）
- ローカルオーバーライド（`local.zsh`）

### Dotfilesデプロイ

**以前:**
- スクリプト: `etc/deploy.sh`
- 方法: 手動でシンボリックリンク作成

**現在:**
- 管理: Home Manager
- 方法: `nix/home.nix`で宣言的にファイル管理

## 設定ファイルの場所

### Nix設定

```
nix/
├── home.nix              # メイン設定
├── packages.nix          # パッケージ一覧
├── programs/
│   ├── zsh.nix          # Zsh設定
│   ├── fzf.nix          # fzf設定
│   ├── git.nix          # Git設定
│   └── ghostty.nix      # Ghostty設定
├── modules/
│   └── env-vars.nix     # 環境変数・ツール統合
└── platform/
    ├── darwin.nix       # macOS固有（未使用 - env-vars.nixに統合）
    └── linux.nix        # Linux固有（未使用 - env-vars.nixに統合）
```

### ローカル設定（Gitで管理しない）

- `~/.dotfiles/git/.gitconfig.local` - Gitユーザー情報
- `~/.config/zsh/local.zsh` - マシン固有のZsh設定

## 日常操作

### パッケージの追加

**以前:**
```bash
brew install package-name
# 手動でBrewfileに追加
```

**現在:**
```nix
# nix/packages.nixを編集
home.packages = with pkgs; [
  package-name
];
```
```bash
home-manager switch --flake ~/.dotfiles#$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]') --impure
```

### パッケージの更新

**以前:**
```bash
brew update
brew upgrade
```

**現在:**
```bash
cd ~/.dotfiles
nix flake update
home-manager switch --flake ".#$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]')" --impure
```

### Zsh設定の変更

**以前:**
- `zsh/.zshrc`, `zsh/env.zsh`などを編集
- 変更はすぐに反映（シンボリックリンク）

**現在:**
- `nix/programs/zsh.nix`または`nix/modules/env-vars.nix`を編集
- 変更を適用:
  ```bash
  home-manager switch --flake ~/.dotfiles#$(uname -m)-$(uname -s | tr '[:upper:]' '[:lower:]') --impure
  ```

## ロールバック

問題が発生した場合：

### Home Managerのロールバック

```bash
# 世代一覧を表示
home-manager generations

# 前の世代にロールバック
/nix/store/XXXXX-home-manager-generation/activate
```

### レガシーセットアップに戻す

```bash
# レガシースクリプトはまだ利用可能
cd ~/.dotfiles
source etc/deploy.sh
```

## トラブルシューティング

### 問題: パッケージが見つからない

**症状:** 必要なパッケージがnixpkgsにない

**解決策:**
1. パッケージを検索: https://search.nixos.org/packages
2. 見つからない場合、手動でインストールし`~/.config/zsh/local.zsh`に追加:
   ```zsh
   export PATH="/path/to/manual/install/bin:$PATH"
   ```

### 問題: Zshプラグインが読み込まれない

**症状:** シンタックスハイライトなどが動作しない

**解決策:**
1. `home-manager switch`が正常に完了したか確認
2. 新しいシェルを起動: `exec zsh`
3. プラグインがNixストアにあるか確認:
   ```bash
   ls -la ~/.nix-profile/share/zsh*
   ```

### 問題: Git設定が見つからない

**症状:** Gitがユーザー設定を見つけられない

**解決策:**
`~/.dotfiles/git/.gitconfig.local`を作成:
```bash
cp ~/.dotfiles/config/git/.gitconfig.local.template ~/.dotfiles/git/.gitconfig.local
# 情報を編集
```

## レガシーファイル（非推奨）

以下のファイルは非推奨ですが、参照用に保持されています：

- `install` - レガシーインストーラー（Nixインストールを使用）
- `etc/init.sh` - レガシーパッケージインストーラー（`nix/packages.nix`を使用）
- `etc/deploy.sh` - レガシーデプロイスクリプト（Home Managerを使用）
- `zsh/.zprezto/` - Preztoサブモジュール（`nix/programs/zsh.nix`を使用）

## 新セットアップの利点

1. **再現性**: 環境全体がコードで定義
2. **アトミック更新**: 変更が一括適用
3. **ロールバック**: 以前の設定に簡単に戻せる
4. **クロスプラットフォーム**: macOSとLinuxで同じ設定
5. **手動ステップ不要**: インストールスクリプトの実行不要
6. **バージョン管理**: すべての変更がGitで追跡
7. **宣言的**: 何がインストール・設定されているか明確

## ヘルプ

- **Nixドキュメント**: https://nixos.org/manual/nix/stable/
- **Home Managerドキュメント**: https://nix-community.github.io/home-manager/
- **dotfiles計画**: `.claude/plans/clever-beaming-quokka.md`

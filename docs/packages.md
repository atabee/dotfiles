# パッケージ一覧

macOSの導入対象は`home/dot_config/dotfiles/Brewfile`、Ubuntuのapt導入対象は
`apt-packages.tmpl`、Ubuntuの追加miseツールは`mise-tools.ubuntu.tmpl`に記載します。
設定の反映・更新・削除は[README](../README.md#パッケージの更新)を参照してください。

## 共通ツール

| 用途・コマンド | macOS | Ubuntu / WSL2 |
| --- | --- | --- |
| 設定ファイル管理 | Homebrew `chezmoi` | 公式chezmoiバイナリ |
| バージョン管理 | Homebrew `mise` | 公式miseバイナリ |
| シェル | Homebrew `bash` / `zsh` | apt `bash` / `zsh` |
| Git・大きなファイル | Homebrew `git` / `git-lfs` | apt `git` / `git-lfs` |
| GitHub CLI | Homebrew `gh` | mise `gh` |
| 通信・SSH・署名 | Homebrew `curl` / `openssh` / `gnupg` | apt `curl` / `openssh-client` / `gnupg` |
| 対話的な選択 | Homebrew `fzf` | mise `fzf` |
| ファイル検索 | Homebrew `fd` | mise `fd`（`fdfind`への改名なし） |
| コード検索 | Homebrew `the_silver_searcher` | apt `silversearcher-ag`（どちらも`ag`） |
| 一覧表示・ゴミ箱 | Homebrew `tree` / `trash-cli` | apt `tree` / `trash-cli` |
| ファイル一覧 | Homebrew `eza` | mise `github:eza-community/eza` |
| JSON処理 | Homebrew `jq` | apt `jq` |
| ファイル表示 | Homebrew `bat` | mise `bat`（`batcat`への改名なし） |
| テキスト検索 | Homebrew `ripgrep` | mise `ripgrep`（`rg`） |
| リポジトリ整理 | Homebrew `ghq` | mise `ghq` |
| 差分表示 | Homebrew `git-delta` | mise `delta` |
| Nixのコード整形 | Homebrew `nixfmt` | x86_64はmise `github:NixOS/nixfmt`、ARM64はHackageからビルド |
| AWS CLI v2 | Homebrew `awscli` | mise `aws-cli` |
| プロジェクト環境 | Homebrew `direnv` | apt `direnv` |
| Go・pnpm・uv | Homebrew `go` / `pnpm` / `uv` | mise `go` / `pnpm` / `uv` |
| Rust toolchain管理 | Homebrew `rustup` | Rustup公式インストーラー |
| Flutter SDK管理 | Homebrew `fvm` | mise `github:leoafarias/fvm` |
| ターミナルのセッション | Homebrew `tmux` | apt `tmux` |
| GitのTUI | Homebrew `lazygit` | mise `lazygit` |

nix-direnv 3.1.0は[上流スクリプト](../vendor/nix-direnv/README.md)を同梱し、chezmoiで配置します。
Ubuntuではaptでビルド・展開・TLS通信に必要な`build-essential`、`unzip`、`xz-utils`、
`ca-certificates`、日本語ロケール用の`locales`、検証用の`python3`も導入します。

Ubuntu ARM64のnixfmtは、GHCupで新しいGHC・Cabalを取得してビルドします。
GHCup本体はmise、ビルドに必要なライブラリはaptで導入します。
コンパイラ・キャッシュ・生成したバイナリは`$XDG_DATA_HOME/dotfiles/`以下に配置します。

## 共通のmise宣言

| 指定 | 用途 |
| --- | --- |
| `node@24` | Node.js 24系 |
| `pinact@latest` | GitHub Actionsの参照バージョン固定 |
| `firebase@latest` | Firebase CLI |

`home/dot_config/dotfiles/mise-tools`で管理します。
端末固有の追加は`mise use --global <tool>@<version>`で行います。
Rubyも必要なバージョンをmiseで導入できます。

## Zshプラグイン

| プラグイン | macOS | Ubuntu / WSL2 |
| --- | --- | --- |
| Powerlevel10k | Homebrew `powerlevel10k` | `romkatv/powerlevel10k`のGitリポジトリ |
| Syntax highlighting | Homebrew `zsh-syntax-highlighting` | 同名のaptパッケージ |
| Autosuggestions | Homebrew `zsh-autosuggestions` | 同名のaptパッケージ |
| History substring search | Homebrew `zsh-history-substring-search` | `zsh-users/zsh-history-substring-search`のGitリポジトリ |

UbuntuのGit管理プラグインは`$XDG_DATA_HOME/zsh/plugins/`以下に配置し、
`dotfiles update plugins`で更新します。設定ファイルの`p10k.zsh`とは別のものです。

## macOS専用CLI

| formula | 用途 |
| --- | --- |
| `jenv` | Javaのバージョン選択 |
| `xcodegen` | Xcodeプロジェクトの生成 |
| `xcodes` | Xcodeの導入・切り替え |
| `cocoapods` | iOS / macOSプロジェクトの依存管理 |
| `herdr`、`hunk` | 開発ワークスペースと差分の確認 |
| `pam-reattach` | tmux内のsudoでTouch IDを利用 |
| `microsoft/apm/apm` | Microsoft APM |
| `k1LoW/tap/git-wt` | Git worktree管理 |

tapは`k1LoW/tap`と`microsoft/apm`を使用します。
APMとgit-wtはBrewfileで`trusted: true`を指定します。
Herdrには`edmundmiller/herdr-plugin-hunk`を追加し、差分表示を連携します。

## macOSのアプリ・JDK・フォント

| 用途 | cask |
| --- | --- |
| ターミナル・エディタ | `ghostty`、`iterm2`、`visual-studio-code`、`zed` |
| モバイル開発 | `android-studio`、`temurin@11`、`temurin@17`、`xcodes-app`、`swiftformat-for-xcode` |
| AI開発・アシスタント | `claude-code`、`claude`、`copilot-cli`、`chatgpt`、`codex`、`codex-app` |
| フォント | `font-monaspace`、`font-moralerspace` |
| ブラウザ・作業支援 | `google-chrome`、`raycast`、`rectangle`、`notion` |
| ユーティリティ | `the-unarchiver`、`google-japanese-ime`、`1password` |
| ネットワーク | `tailscale-app` |

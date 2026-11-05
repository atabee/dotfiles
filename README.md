# dotfiles

シェル・開発ツール・アプリケーションをまとめて管理する、モバイルアプリ開発向けのdotfilesです。
設定ファイルはchezmoi、ツールはOSに応じてHomebrew・apt・miseで導入します。

## 対応環境

- macOS（Apple Silicon / Intel）
- Ubuntu 24.04以降（x86_64 / ARM64）
- WSL2上のUbuntu 24.04以降

## 管理の分担

| 対象 | macOS | Ubuntu / WSL2 |
| --- | --- | --- |
| 設定ファイル | chezmoi | chezmoi |
| シェル・基盤CLI | Homebrew | apt |
| Node.js 24・pinact・Firebase CLI | mise | mise |
| fzf・fd・bat・delta・eza・ripgrep・gh・ghq・lazygit | Homebrew | mise |
| Go・pnpm・uv・FVM・AWS CLI v2 | Homebrew | mise |
| chezmoi・mise本体 | Homebrew | 公式のバイナリインストーラー |
| rustup本体 | Homebrew | 公式のインストーラー |
| Zshプラグイン | Homebrew | apt / 上流Gitリポジトリ |
| GUIアプリ・フォント・Temurin・CocoaPods | Homebrew | 自動導入の対象外 |

Flutter SDKはFVM、Pythonはuv、Rust toolchainはrustupで管理します。
macOSのJava選択にはjenv、Xcodeの導入にはXcodesを使います。
各ツールの用途は[パッケージ一覧](docs/packages.md)、環境変数・キーバインドは
[設定の詳細](docs/configuration.md)を参照してください。

## 初回セットアップ

Home Managerやnix-darwinから移す場合は、先に[移行ガイド](docs/migration.md)を参照してください。
新しい端末では、使用するOSの準備から始めます。

### 1. OSの準備

#### macOS

[Homebrew公式](https://brew.sh/)の手順でHomebrewをインストールします。
Command Line ToolsまたはXcodeも用意してください。

```bash
# Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"

# Intel Macの場合はこちら
eval "$(/usr/local/bin/brew shellenv)"
```

既存のHomebrewがある場合はそのまま使えます。
Intel MacではHomebrewのサポート状況によってソースビルドが必要な場合があります。

#### Ubuntu / WSL2

Ubuntuの通常ユーザーで実行します。sudoを利用でき、標準のmain / universeリポジトリが
有効になっていることを確認してください。

```bash
sudo apt-get update
sudo apt-get install --yes ca-certificates curl git
```

Ubuntuでは、セットアップスクリプトがchezmoiとmiseを`~/.local/bin`に導入します。
Homebrewのインストールは不要です。

### 2. クローンして適用する

以降は両OSで共通です。

```bash
git clone https://github.com/atabee/dotfiles ~/.dotfiles
cd ~/.dotfiles
bash scripts/bootstrap.sh
```

スクリプトは次の順に処理します。

1. OSを確認し、chezmoiとmiseを使用できる状態にする。
2. このリポジトリをchezmoiの管理元として登録する。
3. 設定の差分を表示し、適用する。
4. Homebrewまたはaptでパッケージを導入・更新する。
5. miseの共通ツールと、Ubuntu用の開発CLIを導入する。
6. プラグインなどの追加設定と、未使用のmiseバージョンの整理を行う。

macOSではBrewfileにないパッケージの整理も行います。詳しくは「日常の設定反映」を参照してください。
Ubuntuではaptの導入・更新にsudoを使います。設定ファイルの配置とmiseの操作は通常ユーザーで行います。
bootstrap全体をsudoで実行しないでください。

Ubuntu ARM64ではnixfmtをソースからビルドします。初回はビルド用のGHC・Cabalも
取得するため、他のCLIより時間とディスク容量を使います。

管理ツールだけを準備し、まだ設定を反映しない場合は次を使います。

```bash
bash scripts/bootstrap.sh --prepare
```

### 3. シェル・ローカル設定

Zshをログインシェルにしていない場合は変更します。

```bash
# macOS
chsh -s /bin/zsh

# Ubuntu / WSL2
chsh -s /usr/bin/zsh
```

WSL2でターミナルの起動コマンドに別のシェルを指定している場合は、その設定も確認します。
Ubuntuで日本語ロケールが未生成の場合は、`sudo locale-gen ja_JP.UTF-8`を実行してください。

端末固有のファイルがまだない場合だけ、テンプレートをコピーして編集します。

```bash
cp ~/.config/git/.gitconfig.local.template ~/.config/git/.gitconfig.local
cp ~/.config/zsh/local.zsh.template ~/.config/zsh/local.zsh
exec zsh -l
```

Gitの名前・メールアドレス、SDKの場所などを設定してください。
これらの実ファイルはchezmoiで上書きしません。秘密情報をリポジトリに追加しないでください。

### 4. macOSのシステム設定

Touch IDによるsudo認証、tmux内の認証対応（pam-reattach）、Rosetta 2を設定します。

```bash
bash scripts/setup-macos.sh --print   # 反映するPAMの2行を確認
bash scripts/setup-macos.sh           # sudoを使って適用
```

PAMの既存設定は`/etc/pam.d/sudo_local.before-dotfiles`へ初回だけ保存します。
Touch ID / pam-reattach以外の既存の認証設定は保持します。
通常の`chezmoi apply`では、このシステム設定は変更しません。

## 日常の設定反映

```bash
cd ~/.dotfiles
git pull --ff-only
chezmoi diff
chezmoi apply
exec zsh -l
```

`dotup`は`chezmoi apply`の短縮形です。取得と反映をまとめる場合は`chezmoi update`も使えます。
`chezmoi apply`は設定反映後に`dotfiles sync`を実行します。

| 処理 | macOS | Ubuntu / WSL2 |
| --- | --- | --- |
| 基盤パッケージ | Homebrewの情報更新・Brewfileの導入と更新 | aptの情報更新・apt-packagesの導入と更新 |
| 開発CLI | mise-toolsを宣言・導入 | mise-toolsとmise-tools.ubuntuを宣言・導入 |
| 追加処理 | HerdrのHunkプラグインを未導入時に追加 | Rustupを未導入時に追加、Git管理のZshプラグインを更新、ARM64のnixfmtをビルド |
| 整理 | mise prune、Brewfile宣言外のパッケージをzap | mise prune |

**macOSではBrewfileにない手動導入パッケージやcaskの関連データが削除対象になります。**
残したいパッケージは適用前にBrewfileへ追加してください。
Ubuntuでは、apt-packagesにないという理由でOSのパッケージを削除しません。

miseの`node@24`や`@latest`の解決時には新しいバージョンが導入される場合があります。
端末で手動追加したグローバルツールの宣言は保持します。

設定だけを反映してパッケージ操作を省く場合は、スクリプトを除外します。

```bash
chezmoi diff --exclude scripts
chezmoi apply --exclude scripts
```

不足パッケージだけを追加したい場合は`dotfiles install`を使います。
Homebrew / aptの既存パッケージは更新対象から外しますが、依存関係として必要な更新や、
miseの指定バージョンの解決・導入は行います。

## パッケージの更新

### 更新コマンドの選び方

```bash
dotfiles update              # 使用OSの管理対象とmiseツールを更新
dotfiles update system       # macOSはHomebrew、Ubuntuはaptの管理対象のみ
dotfiles update mise         # グローバルmiseツールのみ
```

UbuntuではGit管理のZshプラグインと、ARM64のnixfmtも`dotfiles update`に含めます。
この操作ではGitの設定取得、Rust toolchain、Python、各プロジェクトのFlutter SDK、
Android SDK、Xcodeは更新しません。それぞれの更新方法は後述します。

miseの操作はホームディレクトリで行い、プロジェクトの`mise.toml`を変更しません。
`node = "24"`は24系の範囲で更新し、`--bump`は付けません。
グローバルに追加したRubyなども、その指定範囲で更新対象になります。

### macOS: Homebrewの確認と更新

```bash
brew update                         # パッケージ情報を取得。まだパッケージは更新しない
brew outdated                       # 更新候補を表示
dotfiles update brew                # Brewfileのパッケージを更新

# 特定のものだけ更新
brew upgrade git gh fzf
brew upgrade --cask android-studio

# 管理ツール本体もHomebrewから更新
brew upgrade chezmoi mise
```

`brew upgrade`だけを実行すると、Brewfile以外に手動で導入したものも更新対象になります。
アプリが自分で更新するcaskや`version :latest`のcaskは、通常の更新対象から外れる場合があります。
それらも含めたい場合は、たとえば`brew upgrade --cask --greedy android-studio`を明示的に使います。
アプリを更新する前に終了してください。

### Ubuntu / WSL2: aptと管理ツール本体の更新

```bash
sudo apt-get update                 # パッケージ情報を取得
apt list --upgradable                # OS全体の更新候補を表示
dotfiles update apt                 # apt-packagesに書いたものを導入・更新

# aptの特定パッケージだけ更新
sudo apt-get install --only-upgrade git git-lfs tmux

# 公式インストーラーで導入したchezmoi・mise・rustup本体を更新
dotfiles update bootstrap
```

`dotfiles update apt`はOS全体の一括更新ではありません。
Ubuntu全体の更新は、通常のOS運用として`sudo apt-get upgrade`などで行ってください。
管理ツール本体は、個別にも更新できます。

```bash
~/.local/bin/mise self-update --yes
~/.local/bin/chezmoi upgrade
rustup self update
```

ZshのGit管理プラグインだけを更新する場合は`dotfiles update plugins`を使います。
自分で編集したプラグインに変更が競合すると更新を停止します。変更を確認してから再実行してください。

### mise: 更新候補・特定CLI・既定バージョン

```bash
cd ~
mise outdated
mise upgrade --dry-run
mise upgrade node
mise upgrade pinact firebase

# Ubuntuでmise管理するCLIの例
mise upgrade gh fzf fd bat delta go pnpm uv aws-cli
mise upgrade github:leoafarias/fvm
mise upgrade github:eza-community/eza
```

Ubuntu x86_64のnixfmtは`mise upgrade github:NixOS/nixfmt`で更新します。
ARM64では`dotfiles update nixfmt`でビルドし直します。

共通のバージョン指定は`home/dot_config/dotfiles/mise-tools`を編集します。
Ubuntu用CLIは`home/dot_config/dotfiles/mise-tools.ubuntu.tmpl`を編集します。
`node@24`のメジャーバージョンを変更したり、`latest`を特定バージョンへ固定したりした後、
`chezmoi apply`で他の端末にも共有できます。

端末だけに追加する場合は`mise use --global ruby@<version>`などを使います。
`<version>`は必要なバージョンに置き換えてください。
グローバル設定`~/.config/mise/config.toml`は書き込み可能な実ファイルとして保持します。
共通宣言に含まれるツールの指定は適用時に反映されるので、共有する変更は管理元へ記載してください。

### Rust・Python・Flutterの更新

管理ツール本体と、そのツールで導入するSDKは別々に更新します。

```bash
# Rust toolchain
rustup check
rustup update
# 初回のtoolchain導入
rustup default stable

# Python（uv本体はmacOSならbrew upgrade uv、Ubuntuならmise upgrade uv）
uv python list
uv python install <version>
# uv toolで導入したCLIの更新
uv tool upgrade --all

# Flutter（FVM本体はmacOSならbrew upgrade fvm、Ubuntuならmise upgrade github:leoafarias/fvm）
fvm releases
fvm install <version>
cd /path/to/flutter-project
fvm use <version>
fvm flutter doctor
```

`rust-toolchain.toml`、`.python-version`、`.fvmrc`などの指定変更は各プロジェクトで判断し、
動作確認と合わせてコミットしてください。UbuntuのRustup導入時にはtoolchainを自動選択しません。

### Android・Java・Xcodeの更新

macOSのアプリ・JDK・CocoaPodsは、次のようにHomebrewで更新します。

```bash
brew upgrade --cask android-studio temurin@11 temurin@17 xcodes-app
brew upgrade xcodes cocoapods
jenv versions
```

Xcode本体・SimulatorはXcodesアプリ、または`xcodes list` / `xcodes install <version>`を使います。
Android SDK・NDK・EmulatorはAndroid StudioのSDK Manager、または`sdkmanager`で管理します。
UbuntuのAndroid Studioは公式配布から別途導入してください。

```bash
"$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" --list
"$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" --update
```

`latest`ディレクトリはAndroid StudioでCommand-line Toolsを導入すると利用できます。
`ANDROID_HOME`は`~/Library/Android/sdk`、`NDK_HOME`はその下の`ndk/26.1.10909125`です。
Ubuntuなどで導入先が異なる場合は`local.zsh`で上書きしてください。
SDK Managerで別のNDKを追加しても、この指定は自動変更しません。
Android StudioのGradle JDKはCLIで使うJavaと合わせてください。

### Herdrのプラグイン更新（macOS）

```bash
brew upgrade herdr hunk
herdr plugin update
herdr server reload-config
```

HerdrとClaude Codeの設定は初回だけ配置する実ファイルです。
アプリが保存した変更は再適用で上書きしません。[設定の詳細](docs/configuration.md)も参照してください。

### 不要パッケージ・古いバージョンの整理

```bash
dotfiles cleanup             # 削除候補だけ表示
dotfiles cleanup --force     # 表示した候補を削除
```

- macOS: Brewfileの宣言外パッケージをzapで削除し、Homebrewのキャッシュを整理します。
- Ubuntu: `apt-get --simulate autoremove`で候補を表示し、実行時は`apt-get autoremove`と`clean`を使います。
- 共通: miseが未使用と判断したバージョンを整理します。

**Ubuntuのautoremove候補はOS全体の自動導入パッケージを含みます。**
必要なものが候補に入っていないか、実行前に確認してください。
macOSのzapはcaskの関連設定・データも対象にします。
プロジェクトで必要なmise設定は先に読み込み、`mise prune --dry-run`の候補も確認します。

キャッシュだけの整理は、macOSなら`brew cleanup`、Ubuntuなら`sudo apt-get clean`です。
Flutter SDKは`fvm remove <version>`、Rust toolchainは`rustup toolchain uninstall <toolchain>`で個別に削除します。

## パッケージ・設定の追加と削除

| 対象 | 編集する管理元 |
| --- | --- |
| macOSのパッケージ・アプリ | `home/dot_config/dotfiles/Brewfile` |
| Ubuntuのaptパッケージ | `home/dot_config/dotfiles/apt-packages.tmpl` |
| 共通のmiseツール | `home/dot_config/dotfiles/mise-tools` |
| Ubuntu用miseツール | `home/dot_config/dotfiles/mise-tools.ubuntu.tmpl` |
| 設定ファイル | `home/`以下の対応するファイル |

変更後は`chezmoi diff`で確認して`chezmoi apply`します。
Brewfileから削除したパッケージは適用時の整理対象になります。
apt-packagesから削除したパッケージは自動削除しないので、不要なら`sudo apt-get remove <package>`で削除します。
miseの宣言を外す場合は、管理元とグローバル設定から指定を外してからprune候補を確認します。

端末側の管理対象ファイルを編集した場合は、必要に応じて`chezmoi re-add <path>`で管理元へ取り込みます。
設定を戻す場合はGitで対象の変更を戻して適用します。パッケージのバージョンはGitの状態だけでは戻りません。

## 個別プロジェクトでNixを使う

Nixを別途インストールし、プロジェクトの`.envrc`から読み込みます。

```bash
cd /path/to/nix-project
printf 'use flake\n' > .envrc
# shell.nixを使う場合は代わりに use nix
direnv allow
```

同梱のnix-direnvが評価結果をキャッシュします。
更新方法は[同梱元の説明](vendor/nix-direnv/README.md)を参照してください。

## 構成

```text
.chezmoiroot                  # 設定元をhome/に指定
home/
  .chezmoi.toml.tmpl           # 端末側のchezmoi設定
  .chezmoiignore              # OSごとの配布対象
  .chezmoitemplates/           # 共通テンプレート
  dot_zshenv                  # ~/.zshenv
  dot_config/
    dotfiles/                 # OS判定・Brewfile・apt・miseの一覧
    zsh/                      # シェル・Powerlevel10k・関数
    git/                      # Git設定・ローカル設定テンプレート
    direnv/                   # プロジェクト環境
    ...
  dot_local/bin/              # dotfilesコマンド・deltaラッパー
  dot_claude/                 # Claude Code設定
scripts/                      # 初期導入・移行・macOSシステム設定
docs/                         # 設定・パッケージ一覧・移行ガイド
assets/iterm2/                # iTerm2設定（参照用）
vendor/nix-direnv/            # 同梱スクリプトの出典・ライセンス
tests/                        # 一時ホームでの検証
```

`dot_`は配置先の`.`、`executable_`は実行可能ファイル、`create_`は未作成時だけ配置するファイル、
`.tmpl`はテンプレートです。`home/`以外のファイルはホームへ配布しません。

## トラブルシューティング

### 更新しても古いコマンドが実行される

```bash
type -a git mise node pnpm delta
mise current
exec zsh -l
```

`local.zsh`のPATHや、別の導入方法の実行ファイルが先に選ばれていないか確認します。
Ubuntuでは`~/.local/bin`とmiseの実行ファイルを使用します。

### Ubuntuでaptのパッケージが見つからない

Ubuntu 24.04以降を使っていることと、main / universeの設定を確認してください。
universeが無効な環境では、次の手順で有効化できます。

```bash
sudo apt-get install --yes software-properties-common
sudo add-apt-repository universe
sudo apt-get update
```

### 既存の設定ファイルと競合する

`chezmoi diff`で差分を確認し、残したい内容を退避または管理元に取り込みます。
Home Managerのリンクがある場合は[移行ガイド](docs/migration.md)を参照してください。

### nix-direnvでBashのバージョンエラーが出る

macOSではHomebrew版Bash、Ubuntuでは`/bin/bash`を指定しています。
`~/.config/direnv/direnv.toml`の`bash_path`と実行ファイルを確認してください。

### UbuntuでmacOS向けのテーマやコピー操作が動かない

Ghosttyのテーマパス、tmuxの`pbcopy`、Android SDKのパスはmacOS向けです。
これらをUbuntuで使う場合は、導入先やクリップボードコマンドに合わせて調整してください。

## 検証

Python 3・chezmoi・Zshが使える環境で実行します。
一時ホームとコマンドの代替実装を使い、実際のパッケージ導入やシステム設定の変更は行いません。

```bash
python3 -m unittest discover -s tests -v
```

## 参考

- [chezmoi](https://www.chezmoi.io/)
- [Homebrew Bundle](https://docs.brew.sh/Brew-Bundle-and-Brewfile)
- [Ubuntuのパッケージ管理](https://ubuntu.com/server/docs/how-to/software/package-management/)
- [mise](https://mise.jdx.dev/)
- [FVM](https://fvm.app/)
- [direnv](https://direnv.net/)

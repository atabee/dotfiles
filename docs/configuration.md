# 設定の詳細

## ファイル

設定の管理元は`home/`です。`.chezmoiroot`によって、このディレクトリだけが
ホームディレクトリへの配布対象になります。設定は書き込み可能な通常ファイルとして配置します。

| 管理元 | 配置先 | 機能 |
| --- | --- | --- |
| `home/dot_zshenv` | `~/.zshenv` | XDGのZsh設定を読み込む入口 |
| `home/dot_config/zsh/` | `~/.config/zsh/` | シェル設定・テーマ・関数 |
| `home/dot_config/git/` | `~/.config/git/` | 共通Git設定・ローカル設定テンプレート |
| `home/dot_config/ghostty/config` | `~/.config/ghostty/config` | テーマ・フォント・ウィンドウ設定 |
| `home/dot_config/tmux/tmux.conf` | `~/.config/tmux/tmux.conf` | tmuxのキーバインド・外観 |
| `home/dot_config/lazygit/config.yml` | `~/.config/lazygit/config.yml` | side by side diff・delta連携 |
| `home/dot_config/delta/config` | `~/.config/delta/config` | deltaラッパーの共通オプション |
| `home/dot_config/{bat,ripgrep,gh,hunk,pnpm}/` | 各`~/.config/` | CLIの設定 |
| `home/dot_config/dotfiles/` | `~/.config/dotfiles/` | OS判定・Brewfile・apt・miseのツール一覧 |
| `home/dot_local/bin/` | `~/.local/bin/` | `dotfiles`コマンド・`delta`ラッパー |
| `home/dot_local/bin/executable_pod` | `~/.local/bin/pod`（macOS） | CocoaPodsのGem環境を分離 |
| `home/dot_claude/` | `~/.claude/` | Claude Codeの初期設定・statusline |
| `home/dot_config/herdr/create_config.toml` | `~/.config/herdr/config.toml` | Herdrの初期設定 |

## Zsh・fzf

Zshは`~/.zshenv`から`~/.config/zsh/`の設定を読み込みます。
`~/.config/zsh/local.zsh`には端末固有の環境変数・エイリアスを記述できます。

- Powerlevel10k instant prompt、syntax highlighting、autosuggestions、history substring search。
- 履歴は`~/.zsh_history`に100,000件保存。複数シェルで共有・追記し、重複と先頭空白のコマンドを除外。
- Emacsキーバインド、日本語表示、補完キャッシュ、大小文字を区別しない補完。
- `ls` / `l` / `la` / `ll` / `lla` / `lt` / `lr` / `tree`はezaで表示。
- `rm`は`trash-put`でゴミ箱へ移動。`..` / `...` / `....`で親ディレクトリへ移動。
- fzfは高さ40%、reverse、border。ファイル・ディレクトリ検索はfd、パス補完はag。
- `Ctrl+R`で履歴、`Ctrl+T`でファイル、`Alt+C`でディレクトリ、`Ctrl+]`でghqのリポジトリを選択。
- `gfs` / `ghfs`でブランチ・PRを選択。`C`で標準出力をクリップボードへコピー。
- jenv、git-wt、mise、direnv、uvのシェル連携。
- `lg`でlazygitを起動し、選択したディレクトリへ移動。
- `dotup`で`chezmoi apply`を実行。

## Git・diff

Gitは`autocrlf=input`、UTF-8指定のvim、`pull.rebase=false`を設定しています。
`show-graph`でブランチのグラフを表示し、Git LFSとghの認証ヘルパーを使用します。
ghqのリポジトリ保存先は`~/go/src`と`~/src`です。
ユーザー名・メールアドレスは`~/.config/git/.gitconfig.local`へ記述します。

`~/.local/bin/delta`は、Homebrewまたはmiseのdeltaへ共通設定を渡すラッパーです。
`navigate=true`、`light=false`、`side-by-side=true`を指定しています。
Git設定にも同じ設定ファイルをincludeし、miseからdeltaが直接選ばれる場合にも適用します。
lazygitのpagerは`delta --dark --side-by-side --paging=never`です。

## 環境変数・CLIの設定

| 変数・設定 | 値 |
| --- | --- |
| `EDITOR` / `VISUAL` | `vim` |
| `PAGER` | `bat` |
| `LANG` | `ja_JP.UTF-8` |
| `GOPATH` / `GOBIN` | `~/go` / `~/go/bin` |
| `UV_PYTHON_PREFERENCE` | `only-managed` |
| `GEM_HOME` / `GEM_PATH` | `~/.gem` |
| `RUSTUP_HOME` | `$XDG_DATA_HOME/rustup` |
| `CARGO_HOME` | `$XDG_DATA_HOME/cargo` |
| `GRADLE_USER_HOME` | `$XDG_DATA_HOME/gradle` |
| `ANDROID_HOME` | `~/Library/Android/sdk` |
| `NDK_HOME` | `$ANDROID_HOME/ndk/26.1.10909125` |
| pnpm | `minimum-release-age=10080`、`block-exotic-subdeps=true` |
| bat | `TwoDark`、`less -FR` |
| ripgrep | 150文字で切り詰めプレビュー、`.git/*`除外、smart case |
| gh | SSHプロトコル、プロンプト有効 |

`~/.gem/bin`、`$CARGO_HOME/bin`、`~/.local/bin`をPATHへ追加します。
FVMの`~/fvm/default/bin`があれば追加し、macOSではAndroid platform-toolsと
`~/.pub-cache/bin`も追加します。macOSのJavaの選択はjenv、Rubyはmiseを使用します。
Ubuntuではmiseのshimsと`$XDG_DATA_HOME/dotfiles/bin`もPATHに追加します。

macOSのCocoaPodsは`~/.local/bin/pod`を経由し、`GEM_HOME`と`GEM_PATH`を除いて
Homebrew付属のRuby/Gem環境で起動します。シェル全体のGem設定はそのまま使用できます。
OSや端末ごとにSDKの場所が異なる場合は`local.zsh`で上書きしてください。

## tmux・Ghostty・iTerm2

tmuxはCtrl+B、インデックス1、viモード、マウス、escape time 0を設定しています。
Shift+矢印でペイン移動、`-` / `|`で分割、Ctrl+Oで前のウィンドウへ移動します。
コピー操作はmacOSの`pbcopy`と連携します。

GhosttyはCatppuccin Mocha、Monaspace Neon、フォントサイズ15を使用します。
テーマファイルのパスはmacOSのGhosttyアプリ内を指定しています。
Linuxで使用する場合はインストール先のテーマパスに合わせて調整してください。

iTerm2用のplistは`assets/iterm2/`にあります。iTerm2から必要に応じて読み込む参照用ファイルです。

## アプリが更新する設定

次のファイルはアプリ自身が書き換えるため、chezmoiの`create_`属性で未作成時だけ配置します。

- `~/.claude/settings.json`: コマンド・ファイル操作のallow / deny、プラグイン、statusline。
- `~/.config/herdr/config.toml`: onboarding無効、prefixはCtrl+O、pane_history無効、Hunk連携。

既存ファイルは再適用で上書きしません。Claude Codeの参照用テンプレートは
`~/.claude/settings.json.template`へ配布します。Herdrの初期設定は管理元の
`home/dot_config/herdr/create_config.toml`で確認できます。

初期設定を変更しても、配置済みのファイルには自動反映しません。手元のファイルと比較し、
必要な項目を取り込んでください。Herdrは`herdr server reload-config`で再読込します。

miseのグローバル設定`~/.config/mise/config.toml`はmiseコマンドで更新します。
`mise-tools`のツールと`experimental=true`を反映し、端末で追加したツールは保持します。

## プロジェクト環境

`direnv hook zsh`を有効にし、ディレクトリへ移動したときに`.envrc`を読み込みます。
初回と内容の変更後には`direnv allow`で許可してください。
Nixを利用するプロジェクト向けにはnix-direnv 3.1.0を配置します。
BashはmacOSではHomebrew版、UbuntuではOSの`/bin/bash`を使用します。
導入・使用例は[README](../README.md#個別プロジェクトでnixを使う)を参照してください。

## OS別の導入と更新

`~/.config/dotfiles/platform`に、chezmoiが判定した`darwin`または`ubuntu`を配置します。
`dotfiles`コマンドはこの値でパッケージ管理を切り替えます。UbuntuにはBrewfileを配布しません。
Ubuntu以外のLinuxは、設定生成時にエラーにします。

Ubuntuの基盤ツールは`apt-packages`、開発CLIは`mise-tools.ubuntu`に分けています。
Powerlevel10kとhistory substring searchはGitで取得し、他の2プラグインはaptから読み込みます。
Ubuntuのログイン・非ログインシェルはHomebrewを検出・実行しません。

# 既存Nix環境からの移行

この手順は、Home Manager / nix-darwinでこのdotfilesを適用していた端末向けです。
設定ファイルとツールの管理元をchezmoiとOS別のパッケージ管理へ移します。
**プロジェクトで使うNix本体、Nix daemon、`/nix`、各プロジェクトのflakeは削除しません。**
Nix本体のアンインストールコマンドは実行しないでください。

移行中は、現在開いているターミナルを最後まで残しておいてください。
シェルやGitの実行ファイルがNixの管理パスにあるため、先に代替ツールを導入してから
旧管理を解除します。既存のAndroid / Flutter / Rust SDKキャッシュは削除しません。

## 1. 管理用ツールを先に導入する

### macOS

既存のHomebrewを利用します。以下はApple Siliconの例です。
Intelなら`/usr/local/bin/brew`へ読み替えます。

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
cd ~/.dotfiles
bash scripts/bootstrap.sh --prepare

# 配置するBrewfileを一時ファイルに生成（まだホームの設定は変更しない）
brewfile=$(mktemp -t dotfiles.Brewfile.XXXXXX)
chezmoi --source "$PWD" cat "$HOME/.config/dotfiles/Brewfile" > "$brewfile"
brew bundle install --file "$brewfile" --no-upgrade
rm -f "$brewfile"
```

この段階でHomebrew版のgit / zsh / miseなどが利用できるようになります。

### Ubuntu / WSL2

Ubuntu 24.04以降で、aptのGit・Zshと、公式バイナリのchezmoi・miseを用意します。
この準備操作ではホームの設定ファイルを反映しません。

```bash
cd ~/.dotfiles
bash scripts/bootstrap.sh --prepare
export PATH="$HOME/.local/bin:$PATH"
```

ログインシェルがNixの管理パスになっている場合は、aptのZshへ変更します。

```bash
chsh -s /usr/bin/zsh
```

導入対象の全パッケージは[パッケージ一覧](packages.md)で確認できます。

## 2. 既存の管理リンクを確認して退避する

```bash
bash scripts/migrate-from-nix.sh --dry-run
bash scripts/migrate-from-nix.sh --apply
```

スクリプトはchezmoiの配置対象と旧Home Managerの補助ファイルを調べ、
Nixの管理パスを指すシンボリックリンクだけを退避します。
通常ファイル、Gitのローカル認証設定、Zshのローカル設定は変更しません。
バックアップ先は実行結果に表示されます。

```text
~/.local/state/dotfiles/nix-backup-日時-PID/
```

リンクをそのまま保存するほか、リンク先が存在するものは内容も`.contents`へコピーします。
そのため、将来Nixの旧世代を整理しても内容を確認できます。
通常ファイル内に独自に記述したNix store参照は自動で削除しません。
`~/.config/zsh/local.zsh`や手書きの`~/.zprofile`なども別途確認してください。

## 3. macOSではnix-darwinの管理を解除する

macOS以外は次の節へ進みます。

まずログインシェルが旧NixのZshになっていないか確認します。
移行後はmacOS付属のZshから同じ設定を読み込めます。

```bash
dscl . -read "/Users/$USER" UserShell
chsh -s /bin/zsh
```

nix-darwinが管理する`/etc/zshenv`、`/etc/zshrc`、PAM、システムへのリンクを解除します。
導入済みのuninstallerを使用し、表示される処理内容を確認して実行してください。

```bash
sudo /run/current-system/sw/bin/darwin-uninstaller
```

これはNix本体のアンインストールではありません。既存のHomebrewを削除する操作も
行いません。実行ファイルが存在しない場合は、使用していたnix-darwinの
[公式アンインストール手順](https://github.com/nix-darwin/nix-darwin#uninstalling)を確認してください。
旧設定を復活させる`darwin-rebuild switch`は、今後このリポジトリでは実行しません。

Home Managerを単独で使用していたUbuntuでも、以後の`home-manager switch`は停止します。
Home Managerの世代は動作確認後まで残せますが、実行ファイルを公開するプロファイルが
PATHに残っているとaptのコマンドより先に選ばれる場合があります。
`nix profile list`または`nix-env --query`で確認し、導入方法に応じて
Home Managerの`home-manager-path`エントリだけを解除してください。
Nixのプロジェクト用プロファイルやNix本体と区別せず、一括削除しないでください。

## 4. 新しい設定を適用する

```bash
cd ~/.dotfiles
bash scripts/bootstrap.sh

# macOSのみ: uninstaller後にTouch IDとRosettaを再設定
bash scripts/setup-macos.sh

exec zsh -l
```

未作成の端末固有ファイルがあればREADMEの手順で作成します。
`.claude/settings.json`とHerdrの設定は、既存の通常ファイルなら保持します。
Nixの管理リンクを退避した場合は、リポジトリの初期設定を実ファイルとして配置します。

## 5. 移行を確認する

```bash
# 共通ツールが旧Home Managerの実行ファイルではないことを確認
type -a git gh mise zsh pnpm delta
mise current

# macOSのみ
brew bundle check --file ~/.config/dotfiles/Brewfile

# Ubuntuのみ: aptとmiseの宣言を確認
cat ~/.config/dotfiles/apt-packages
cat ~/.config/dotfiles/mise-tools.ubuntu

# シェル設定の反映を確認
alias ls rm
printf '%s\n' "$ANDROID_HOME" "$NDK_HOME" "$RUSTUP_HOME" "$CARGO_HOME"

# Nixはプロジェクト用として引き続き利用できる
nix --version
```

macOSではHomebrew、Ubuntuではaptの`/usr/bin`とmise、
管理ツールは`~/.local/bin`の実行ファイルが選ばれることを確認します。
`nix`自体が`/nix/var/nix/profiles/default/bin/nix`にあるのは正しい状態です。

nix-darwin解除後に`nix`が見つからない場合は、使用しているNixインストーラーの
シェル連携を復元してください。一般的なmulti-userインストールでは、ログインシェルで
次のファイルを読み込むことで復帰できます。

```bash
# 存在する場合だけ使用する。必要ならlocal.zshへ記載する。
if [ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi
```

Nixプロジェクトに入り、`direnv reload`や普段のビルドを確認します。
Android / Flutterでは`fvm flutter doctor`、Javaは`jenv versions`、
iOSではXcodeとSimulatorの起動、tmuxではTouch IDとコピー操作も確認してください。

## 6. 運用を切り替える

- 設定変更: `chezmoi diff` → `chezmoi apply`（`dotup`）。
- パッケージ更新: `dotfiles update`。
- 古いバージョン・宣言外パッケージ: `dotfiles cleanup`で確認後に削除。
- Nixプロジェクトの依存更新: 各プロジェクト側で従来どおり実行。

旧`.config/zsh/plugins`や旧nix-direnvのリンクは移行スクリプトで退避済みです。
手書きファイルの`/nix/store/...`や`hm-session-vars.sh`参照が残っている場合は、
内容を確認して該当するシェルの初期化だけを整理します。
Nix daemonの初期化はプロジェクト用に必要なので、同時に消さないでください。

## 設定を戻したい場合

Gitで移行前のコミットを参照でき、退避したリンクと`.contents`から設定を取り出せます。
バックアップの実行結果を確認し、必要なファイルを個別に復元してください。
新環境で作成したローカル設定や、アプリが書き戻した設定を一括で上書きしないでください。

パッケージのバージョンは各管理ツールの更新に追随するため、Gitで設定を戻すだけでは
旧バージョンへ戻りません。旧Nixプロファイルの削除は全体の動作確認後に判断してください。

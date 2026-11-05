# AGENTS.md

このリポジトリはchezmoi + OS別パッケージ管理 + miseで管理する開発環境のdotfilesです。
macOSとUbuntu 24.04以降（WSL2上のUbuntuを含む）を対象とします。

## 基本方針

- ドキュメントと新しいコメントは日本語で記述する。
- dotfilesの適用・パッケージ管理にNix / Home Manager / nix-darwinを導入しない。
- 個別プロジェクトではNixを利用できる。Nix本体やdaemonを削除しない。
- ツール・環境変数・テーマ・キーバインドを依頼なしに変更しない。
- 既存のローカル設定・認証情報を読み出したりGitへ追加したりしない。

## 構成

- UbuntuではHomebrewをインストール・検出・実行しない。aptとmiseを使用する。
- `.chezmoiroot`: chezmoiのsource rootを`home/`にする。
- `home/dot_config/dotfiles/Brewfile`: macOSの全Homebrewパッケージ。
- `home/dot_config/dotfiles/apt-packages.tmpl`: Ubuntuの基盤パッケージ。
- `home/dot_config/dotfiles/mise-tools.ubuntu.tmpl`: Ubuntuの開発CLI。
- `home/dot_config/dotfiles/platform.tmpl`: OSの判定・対応外OSの拒否。
- `home/dot_config/dotfiles/mise-tools`: 共通のmise宣言（Node 24・pinact・Firebase）。
- `home/dot_config/zsh/`: シェル・Powerlevel10k・関数。
- `home/dot_local/bin/executable_dotfiles`: パッケージ導入・更新・整理コマンド。
- `home/dot_local/bin/executable_delta`: 既存のdeltaオプションを付加するラッパー。
- `home/run_after_10-install-tools.sh.tmpl`: 設定反映後の不足ツール導入。
- `scripts/bootstrap.sh`: OS別の初期セットアップ（--prepareで管理ツールだけ導入）。
- `scripts/migrate-from-nix.sh`: 旧管理リンクのプレビュー・バックアップ。
- `scripts/setup-macos.sh`: Touch ID / pam-reattach / Rosettaのシステム設定。
- `docs/`: 設定の詳細・パッケージ一覧・環境の移行。
- `vendor/nix-direnv/`: プロジェクト向け連携の上流情報・ライセンス。

chezmoiの`dot_`、`executable_`、`create_`、`.tmpl`の規約に従う。
rootのドキュメント・scripts・testsはホームへ配布しない。

## 操作

```bash
bash scripts/bootstrap.sh
chezmoi diff
chezmoi apply
# 短縮形: dotup

dotfiles update            # OSの管理対象 + グローバルmise
dotfiles update system
dotfiles update mise
dotfiles update bootstrap  # Ubuntuのchezmoi・mise・rustup本体
dotfiles cleanup           # 削除候補の表示のみ
dotfiles cleanup --force   # 確認後の削除
```

設定反映時はmacOSでHomebrewの更新・zap、Ubuntuでは宣言したaptパッケージの更新を行う。
両OSでmiseの宣言・導入・pruneを行う。Ubuntuで宣言外のOSパッケージを自動削除しない。
apt autoremoveはcleanup --forceで明示的に実行する。
macOSのシステム設定は`setup-macos.sh`で明示的に適用する。

## 設定の扱い

- `~/.config/git/.gitconfig.local`と`~/.config/zsh/local.zsh`は端末固有で管理外。
- Claude Code / Herdrはアプリが書き換えるため`create_`で初期配置だけ行う。
- miseのグローバル設定は書き込み可能な実ファイル。共通宣言以外の追加ツールを保持する。
- Ruby / Java / Flutterはmise / jenv / FVM。CocoaPodsは共通CLI。
- NDK指定は`26.1.10909125`。依頼なしに最新SDKへ切り替えない。
- プロジェクト用nix-direnvは同梱元・バージョン・ライセンスを維持する。

## 検証

```bash
python3 -m unittest discover -s tests -v
```

テストは一時ホームとbrew / apt / sudo / miseなどの代替コマンドで実行する。
Ubuntuの導入・更新・delta呼び出しでbrewが実行されないことを確認する。
実際のパッケージ導入・アプリ起動・sudoによるシステム設定変更をテストに含めない。
chezmoi実行ファイルは`CHEZMOI_BIN`で指定できる。
パッケージを変更した場合はOS別の一覧とREADME・パッケージ一覧の整合も確認する。

# herdr

Herdr の設定ファイルを管理します。

## ファイル

- `default.nix`: Home Manager で Herdr 設定ファイルを配置
- `config.toml`: `herdr --default-config` を元にした設定

## 機能

- `~/.config/herdr/config.toml` を配置
- プレフィックスキーを `ctrl+o` に変更
- Hunk 連携プラグインを自動的に導入
- `ctrl+o` の後に `d` を押すと、作業ツリーの差分を Hunk の分割ペインで表示

## 使い方

設定変更後に `nixup-p` または `nixup-w` を実行してください。
起動中の Herdr に反映する場合は `herdr server reload-config` を実行します。

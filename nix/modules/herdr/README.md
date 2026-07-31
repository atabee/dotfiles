# herdr

Herdr の設定ファイルを管理します。

## ファイル

- `default.nix`: Home Manager で Herdr 設定ファイルを初期配置
- `config.toml`: `herdr --default-config` を元にした設定

## 機能

- `~/.config/herdr/config.toml` がない場合だけ、書き込み可能な通常ファイルとして配置
- Herdr の設定画面から変更した内容を `config.toml` に保存可能
- 初回セットアップ画面を完了済みとして起動
- プレフィックスキーを `ctrl+o` に変更
- Hunk 連携プラグインを自動的に導入
- `ctrl+o` の後に `d` を押すと、作業ツリーの差分を Hunk の分割ペインで表示

## 使い方

`config.toml` は新しい環境での初回配置にだけ使われます。
配置後の設定は `~/.config/herdr/config.toml` または Herdr の設定画面から変更します。
起動中の Herdr にファイルの変更を反映する場合は `herdr server reload-config` を実行します。

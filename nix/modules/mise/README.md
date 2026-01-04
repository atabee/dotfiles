# mise

複数言語対応のランタイムバージョン管理ツール（旧rtx）

## ファイル

- `default.nix`: Nixモジュール設定

## 機能

- **複数言語対応**: Node.js、Python、Ruby、Go など多数のランタイムに対応
- **.tool-versions**: asdf互換の設定ファイル対応
- **自動切り替え**: ディレクトリ移動時に自動的にバージョン切り替え

## 使用方法

```bash
# ツールのインストール
mise install node@20
mise install python@3.11

# グローバル設定
mise use --global node@20
mise use --global python@3.11

# プロジェクト設定
mise use node@18
mise use python@3.10
```

## 設定

設定ファイル: `~/.config/mise/config.toml`

プロジェクトごとの設定: `.mise.toml` または `.tool-versions`

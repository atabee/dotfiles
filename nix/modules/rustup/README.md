# rustup

Rustツールチェーン管理ツール

## ファイル

- `default.nix`: Nixモジュール設定

## 機能

- **RUSTUP_HOME**: `~/.local/share/rustup`
- **CARGO_HOME**: `~/.local/share/cargo`
- **PATHの自動設定**: `~/.local/share/cargo/bin`

## 使用方法

```bash
# Rustのインストール
rustup install stable
rustup default stable

# ツールチェーンの管理
rustup update
rustup toolchain list

# コンポーネントの追加
rustup component add rustfmt
rustup component add clippy

# ターゲットの追加
rustup target add wasm32-unknown-unknown
```

## ディレクトリ

- ツールチェーン: `~/.local/share/rustup/toolchains/`
- Cargoバイナリ: `~/.local/share/cargo/bin/`

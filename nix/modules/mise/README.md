# mise - Polyglot Runtime Manager

複数のプログラミング言語のランタイムバージョンを管理するツール。asdfの高速な代替として開発されました。

## ファイル

- `default.nix`: miseのインストールとZsh統合設定

## 機能

- **複数言語対応**: Node.js、Python、Ruby、Go など多数の言語に対応
- **高速**: Rustで書かれており、asdfより高速に動作
- **互換性**: `.tool-versions` ファイルをサポート（asdf互換）
- **Zsh統合**: シェル起動時に自動的にactivate

## 使い方

### グローバルバージョンの設定

```bash
# Node.jsをインストール
mise use --global node@20

# Pythonをインストール
mise use --global python@3.12
```

### プロジェクト固有のバージョン設定

```bash
cd your-project
mise use node@18 python@3.11
```

これにより `.mise.toml` ファイルが作成され、プロジェクトディレクトリに入ると自動的に切り替わります。

### インストール済みのランタイム確認

```bash
# インストール済みのランタイム一覧
mise list

# 現在アクティブなバージョン
mise current

# 利用可能なバージョン一覧
mise ls-remote node
```

## パッケージ

- `mise`: Polyglot runtime manager

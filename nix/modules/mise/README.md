# mise - Polyglot Runtime Manager

複数のプログラミング言語のランタイムバージョンを管理するツール。asdfの高速な代替として開発されました。

## ファイル

- `default.nix`: miseのインストールとZsh統合設定

## 機能

- **複数言語対応**: Node.js、Python、Ruby、Go など多数の言語に対応
- **高速**: Rustで書かれており、asdfより高速に動作
- **互換性**: `.tool-versions` ファイルをサポート（asdf互換）
- **Zsh統合**: シェル起動時に自動的にactivate
- **書き込み可能な設定**: `config.toml` は通常ファイルとしてデプロイされ、`mise use -g` で自由に変更可能

## グローバル設定

`~/.config/mise/config.toml` は初回セットアップ時に `default.nix` の `miseConfigContent` から自動生成されます。
以降は通常の書き込み可能ファイルとして管理され、`mise use -g` での変更も Nix 更新時に上書きされません。

現在のデフォルト設定：

- **Ruby**: `3.4.8`
- **pinact**: `latest`
- **firebase**: `latest`

### ツールの追加方法

**方法1: `mise use -g` で直接追加（推奨）:**

```bash
mise use -g node@20
mise use -g python@3.12
```

これにより `~/.config/mise/config.toml` が更新され、Nix の再適用でも保持されます。

**方法2: `default.nix` を編集して初期設定を変更:**

`miseConfigContent` を編集してバージョンを指定：

```nix
miseConfigContent = ''
  [tools]
  ruby = "3.4.8"
  node = "20"
  python = "3.12"

  [settings]
  experimental = true
'';
```

> **注意:** `default.nix` の変更は `config.toml` が存在しない場合のみ反映されます。
> 既存の `config.toml` を更新するには、ファイルを削除してから `nixup-p` / `nixup-w` を実行してください。

## 使い方

### プロジェクト固有のバージョン設定

```bash
cd your-project
mise use ruby@3.2 node@18
```

これにより `.mise.toml` ファイルが作成され、プロジェクトディレクトリに入ると自動的に切り替わります。

### インストール済みのランタイム確認

```bash
# インストール済みのランタイム一覧
mise list

# 現在アクティブなバージョン
mise current

# 利用可能なバージョン一覧
mise ls-remote ruby
```

### 手動インストール

```bash
# 設定ファイルに基づいてインストール
mise install

# 特定のバージョンをインストール
mise install ruby@3.3.0
```

## パッケージ

- `mise`: Polyglot runtime manager

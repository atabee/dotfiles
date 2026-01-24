# mise - Polyglot Runtime Manager

複数のプログラミング言語のランタイムバージョンを管理するツール。asdfの高速な代替として開発されました。

## ファイル

- `default.nix`: miseのインストールとZsh統合設定

## 機能

- **複数言語対応**: Node.js、Python、Ruby、Go など多数の言語に対応
- **高速**: Rustで書かれており、asdfより高速に動作
- **互換性**: `.tool-versions` ファイルをサポート（asdf互換）
- **Zsh統合**: シェル起動時に自動的にactivate
- **宣言的管理**: `globalConfig`で指定したツールを自動インストール

## グローバル設定

現在、以下のツールがグローバルに設定されています：

- **Ruby**: `latest`（最新の安定版）

設定は`default.nix`の`programs.mise.globalConfig.tools`で管理されています。

### バージョンの変更方法

`default.nix`を編集してバージョンを指定：

```nix
globalConfig = {
  tools = {
    ruby = "3.3.0";  # 特定のバージョン
    # ruby = "latest";  # 最新版
    # 他のツールも追加可能
    # node = "20";
    # python = "3.12";
  };
};
```

変更後、`nixup-p`または`nixup-w`で適用すると、自動的に`mise install`が実行されます。

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

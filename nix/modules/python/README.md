# Python

Python開発環境とパッケージマネージャー

## インストールされるツール

- **uv**: 高速なPythonパッケージインストーラー・プロジェクト管理ツール

## 環境変数

- `UV_PYTHON_PREFERENCE`: `only-managed` - uvで管理されたPythonのみを使用
- `PATH`: `~/.local/bin` を追加（uvでインストールされたツール用）

## uvの使用方法

### プロジェクトの作成

```bash
# 新しいプロジェクトを作成
uv init my-project
cd my-project

# 既存のプロジェクトを初期化
uv init
```

### パッケージ管理

```bash
# パッケージをインストール
uv add requests

# 開発用パッケージをインストール
uv add --dev pytest

# パッケージをアンインストール
uv remove requests

# 依存関係をインストール
uv sync
```

### Pythonバージョン管理

```bash
# 利用可能なPythonバージョンを表示
uv python list

# 特定のPythonバージョンをインストール
uv python install 3.12

# プロジェクトのPythonバージョンを設定
uv python pin 3.12
```

### スクリプト実行

```bash
# 仮想環境でスクリプトを実行
uv run python script.py

# 仮想環境でコマンドを実行
uv run pytest
```

### ツールの実行

```bash
# 一時的にツールをインストールして実行
uv tool run black .

# ツールをグローバルにインストール
uv tool install black

# インストール済みツールを実行
black .
```

## 特徴

- **高速**: Rust実装による高速なパッケージ解決とインストール
- **統合**: パッケージ管理、仮想環境、Pythonバージョン管理を統合
- **互換性**: pip、pip-tools、poetry等の既存ツールと互換性あり
- **ロックファイル**: `uv.lock`で再現可能なビルドを実現

## 参考リンク

- [uv公式ドキュメント](https://docs.astral.sh/uv/)
- [GitHub](https://github.com/astral-sh/uv)

# ripgrep

高速なgrep代替ツール（`rg`コマンド）

## ファイル

- `default.nix`: Nixモジュール設定

## 機能

- **最大表示列**: 150文字
- **プレビュー**: 有効
- **.gitディレクトリ**: 自動除外
- **スマートケース**: 有効（小文字検索時は大文字小文字を区別しない）

## 使用方法

```bash
# ファイル内検索
rg "検索パターン"

# ファイルタイプを指定
rg --type rust "検索パターン"

# 正規表現検索
rg "log.*Error"

# 置換プレビュー
rg "old" --replace "new"
```

## オプション

設定済みのデフォルトオプションは`default.nix`の`programs.ripgrep.arguments`で定義されています。

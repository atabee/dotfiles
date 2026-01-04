# delta

Git diffの表示を見やすくするツール

## ファイル

- `default.nix`: Nixモジュール設定

## 機能

- **ナビゲーション**: 有効
- **Side-by-side表示**: 有効
- **ダークモード**: 有効
- **Git統合**: Git diffのデフォルトページャーとして自動設定

## 使用方法

```bash
# 通常のgit diffコマンドで自動的にdeltaが使用される
git diff
git log -p
git show
```

## カスタマイズ

`default.nix`の`programs.git.delta.options`セクションを編集して表示オプションを変更できます。

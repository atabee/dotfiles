# bat

シンタックスハイライト機能を持つ`cat`の代替ツール

## ファイル

- `default.nix`: Nixモジュール設定

## 機能

- **テーマ**: TwoDark
- **ページャー**: less -FR
- **エイリアス**: `cat`コマンドを`bat`にマッピング

## 使用方法

```bash
# ファイルを表示（シンタックスハイライト付き）
bat filename

# 従来のcatコマンドの代わりに使用可能
cat filename  # 実際にはbatが実行される
```

## カスタマイズ

`default.nix`の`programs.bat.config`セクションを編集してテーマやページャーを変更できます。

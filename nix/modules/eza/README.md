# eza

モダンな`ls`代替ツール（アイコン・Git統合付き）

## ファイル

- `default.nix`: Nixモジュール設定

## 機能

- **アイコン表示**: 自動
- **Git統合**: 有効
- **Zsh統合**: 有効

## エイリアス

Zshで以下のエイリアスが設定されています（`nix/programs/zsh/default.nix`）:

- `ls`: `eza --icons --git`
- `l`: `eza -1 --icons`
- `la`: `eza -lah --icons --git`
- `ll`: `eza -lh --icons --git`
- `lt`: `eza -lh --icons --git -snew`
- `lr`: `eza -lhR --icons --git`
- `tree`: `eza --tree --icons`

## 使用方法

```bash
ls       # アイコン付きで一覧表示
la       # 全ファイルを詳細表示
lt       # 更新日時でソート
tree     # ツリー表示
```

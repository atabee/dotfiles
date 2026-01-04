# utilities

小規模ユーティリティツール集

## ファイル

- `default.nix`: Nixモジュール設定

## 含まれるツール

### ファイル・ディレクトリ

- **fd**: 高速な`find`代替ツール
- **tree**: ディレクトリツリー可視化
- **trash-cli**: 安全な`rm`代替（削除ファイルをゴミ箱へ）
  - エイリアス: `rm` → `trash-put`
- **lv**: 強力なファイルビューア

### データ処理

- **jq**: JSONプロセッサ

### ダウンロード

- **aria2**: マルチプロトコル対応ダウンローダー

### 検索

- **silver-searcher** (`ag`): コード検索ツール（fzfで使用）

### Git

- **ghq**: Gitリポジトリ管理ツール

### 開発

- **uv**: 高速Pythonパッケージインストーラー

### Nix

- **nixfmt-rfc-style**: Nixコードフォーマッター

## 使用例

```bash
# fd - ファイル検索
fd pattern

# jq - JSON処理
cat data.json | jq '.items[] | .name'

# ghq - リポジトリ管理
ghq get github.com/user/repo
cd $(ghq root)/github.com/user/repo

# aria2 - ダウンロード
aria2c -x 10 https://example.com/file.zip
```

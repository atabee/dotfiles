# utilities

小規模ユーティリティとCLIツール集

## ファイル

- `default.nix`: Nixモジュール設定

## 含まれるツール

### ファイル・ディレクトリ

- **fd**: 高速な`find`代替ツール
- **tree**: ディレクトリツリー可視化
- **trash-cli**: 安全な`rm`代替（削除ファイルをゴミ箱へ）
- **lv**: 強力なファイルビューア
- **eza**: モダンな`ls`代替
  - Git統合、アイコン表示対応
  - Zsh統合有効

### ファイル閲覧

- **bat**: シンタックスハイライト付き`cat`
  - エイリアス: `cat` → `bat`
  - テーマ: TwoDark

### 検索・Grep

- **ripgrep** (`rg`): 高速な`grep`代替
  - スマートケース検索
  - `.git`ディレクトリを自動除外
- **silver-searcher** (`ag`): コード検索ツール（fzfで使用）

### Git関連

- **ghq**: Gitリポジトリ管理ツール
- **delta**: Git diff表示改善
  - サイドバイサイド表示
  - ナビゲーション機能
  - Git統合有効
- **gh**: GitHub CLI
  - SSH protocol使用
  - プロンプト有効

### データ処理

- **jq**: JSONプロセッサ

### ダウンロード

- **aria2**: マルチプロトコル対応ダウンローダー

### Nix

- **nixfmt**: Nixコードフォーマッター

## 使用例

```bash
# bat - シンタックスハイライト付き表示
bat README.md
cat README.md  # 自動的にbatが使用される

# eza - モダンなls
eza -la
ls -la  # Zsh統合により自動的にezaが使用される

# ripgrep - 高速検索
rg "pattern" --type rust

# delta - git diff（自動的に使用される）
git diff

# gh - GitHub CLI
gh repo list
gh pr create

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

## 特徴

このモジュールには、小規模で設定がシンプルなCLIツールをまとめています。言語環境（Node.js、Ruby、Python、Go、Rust）など、より複雑な設定が必要なものは個別のモジュールとして管理されています。

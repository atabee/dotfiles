# gh

GitHub公式CLIツール

## ファイル

- `default.nix`: Nixモジュール設定

## 機能

- **Git protocol**: SSH
- **プロンプト**: 有効

## 使用方法

```bash
# 初回ログイン
gh auth login

# リポジトリ操作
gh repo view
gh repo clone <repo>

# Issue管理
gh issue list
gh issue create

# Pull Request管理
gh pr list
gh pr create
gh pr view <number>
```

## 設定

認証情報は`~/.config/gh/`に保存されます。

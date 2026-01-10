# Git

Git バージョン管理設定（LFSサポート付き）

## ファイル

- `default.nix`: Nixモジュール設定
- `gitconfig.local.template`: ユーザー固有設定のテンプレート

## ローカル設定

テンプレートをコピーしてローカル設定を作成:

```bash
cp ~/.config/git/.gitconfig.local.template ~/.config/git/.gitconfig.local
```

`~/.config/git/.gitconfig.local`を編集してユーザー情報を設定:

```ini
[user]
    name = Your Name
    email = your.email@example.com

[credential]
    helper = osxkeychain  # macOS
    # helper = cache      # Linux
```

## 機能

- ghq統合（マルチルートリポジトリ管理）
- Git LFS フィルター設定
- UTF-8エンコーディングがデフォルト
- ローカルユーザー設定の分離（Gitで追跡しない）

## ghq ルート

設定済みのルート:
- `~/go/src`
- `~/src`

## パッケージ

- **git**: Gitバージョン管理システム
- **git-lfs**: Git Large File Storage

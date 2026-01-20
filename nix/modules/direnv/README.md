# direnv

プロジェクトごとの環境変数管理ツール

## ファイル

- `default.nix`: Nixモジュール設定

## 機能

- **自動環境読み込み**: ディレクトリに入るとき`.envrc`を自動実行
- **Zsh統合**: Zshシェルとのシームレスな統合
- **Nix統合**: nix-direnvによる高速なNix環境サポート
- **Nixキャッシング**: `use nix`コマンドの評価結果をキャッシュして高速化

## 使い方

### 基本的な使い方

プロジェクトディレクトリで`.envrc`ファイルを作成:

```bash
cd your-project
echo "export PROJECT_ENV=development" > .envrc
direnv allow
```

ディレクトリに入ると自動的に環境変数が読み込まれます。

### Nixプロジェクトでの使い方

`shell.nix`または`flake.nix`があるプロジェクトで:

```bash
echo "use nix" > .envrc
direnv allow
```

または、Flakesを使用する場合:

```bash
echo "use flake" > .envrc
direnv allow
```

nix-direnvが評価結果をキャッシュするため、2回目以降は即座に環境が読み込まれます。

## パッケージ

- **direnv**: 環境変数管理ツール
- **nix-direnv**: Nix統合プラグイン（自動的に有効化）

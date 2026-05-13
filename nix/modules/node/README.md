# pnpm

pnpmパッケージマネージャー

## ファイル

- `default.nix`: Nixモジュール設定

## インストールされるパッケージ

- **pnpm**: Fast, disk space efficient package manager

## 設定

`~/.config/pnpm/config.yaml` をHome Managerで管理します。

```yaml
minimumReleaseAge: 1440
blockExoticSubdeps: true
onlyBuiltDependencies: []
```

- `minimumReleaseAge`: 公開から1440分（1日）未満のパッケージバージョンを避ける
- `blockExoticSubdeps`: 推移依存のgit/tarball URLなどのexotic sourceをブロックする
- `onlyBuiltDependencies`: install scriptの実行を許可する依存を明示する（初期値は空）

## Node.js

Node.js本体はNixではインストールせず、`mise`モジュールで管理します。
バージョンを変更する場合は`nix/modules/mise/default.nix`を編集してください。

## 使用方法

### pnpm

```bash
# 依存関係をインストール
pnpm install

# パッケージを追加
pnpm add <package-name>

# スクリプトを実行
pnpm run <script>
```

## ディレクトリ

- pnpmストア: `~/.local/share/pnpm/store/`

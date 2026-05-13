# pnpm

pnpmパッケージマネージャー

## ファイル

- `default.nix`: Nixモジュール設定

## インストールされるパッケージ

- **pnpm**: Fast, disk space efficient package manager

## 設定

`~/.config/pnpm/rc` をHome Managerで管理します。

```ini
minimum-release-age=10080
block-exotic-subdeps=true
```

- `minimumReleaseAge`: 公開から10080分（1週間）未満のパッケージバージョンを避ける
- `blockExoticSubdeps`: 推移依存のgit/tarball URLなどのexotic sourceをブロックする
- `onlyBuiltDependencies`: pnpm 10では未指定時も依存パッケージのinstall scriptは許可リスト方式で扱われる。プロジェクトごとに`pnpm-workspace.yaml`で明示する

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

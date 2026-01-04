# Node.js

Node.js開発環境とグローバルパッケージ

## ファイル

- `default.nix`: Nixモジュール設定

## インストールされるパッケージ

- **nodejs_22**: Node.js v24 (LTS)
- **npm**: Node Package Manager

## 環境変数

- `NPM_CONFIG_PREFIX`: `~/.npm-global`
- PATH: `~/.npm-global/bin` を追加

## 使用方法

### npm（グローバルインストール）

```bash
# グローバルパッケージをインストール
npm install -g <package-name>

# インストール済みグローバルパッケージを確認
npm list -g --depth=0

# パッケージを更新
npm update -g <package-name>
```

## ディレクトリ

- グローバルパッケージ: `~/.npm-global/`
- npmキャッシュ: `~/.npm/`

# Ruby

Ruby開発環境とパッケージマネージャー

## ファイル

- `default.nix`: Nixモジュール設定

## インストールされるパッケージ

- **ruby**: Ruby言語本体
- **cocoapods**: iOS/macOSアプリの依存関係管理ツール

## 環境変数

- `GEM_HOME`: `~/.gem`
- `GEM_PATH`: `~/.gem`
- PATH: `~/.gem/bin` を追加

## 使用方法

### CocoaPods

```bash
# Podfileを作成
pod init

# 依存関係をインストール
pod install

# 依存関係を更新
pod update
```

## ディレクトリ

- Gemインストール先: `~/.gem/`
- CocoaPodsキャッシュ: `~/.cocoapods/`

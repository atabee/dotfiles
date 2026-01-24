# Ruby

Ruby開発環境の環境変数設定

## ファイル

- `default.nix`: Nixモジュール設定

## 概要

Rubyのインストールは**mise**で管理します。このモジュールはGem関連の環境変数を設定し、CocoaPods（macOSのみ）をインストールします。

## インストールされるパッケージ

- **cocoapods**: iOS/macOSアプリの依存関係管理ツール（macOSのみ、Nixパッケージ）

## 環境変数

- `GEM_HOME`: `~/.gem`
- `GEM_PATH`: `~/.gem`
- PATH: `~/.gem/bin` を追加

## 使用方法

### Rubyのインストール（miseを使用）

Rubyは`mise`モジュールで管理されています。バージョンを変更する場合は`nix/modules/mise/default.nix`を編集してください。

### Bundler

BundlerはRuby 2.6以降に標準で含まれています：

```bash
# Gemfileを作成
bundle init

# 依存関係をインストール
bundle install

# アプリケーションを実行
bundle exec ruby app.rb
```

### CocoaPods（macOS）

CocoaPodsはNixパッケージとしてインストールされます（macOSのみ）：

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

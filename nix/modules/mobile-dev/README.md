# mobile-dev

モバイルアプリ開発環境設定（オプション）

## ファイル

- `default.nix`: モバイル開発ツールの環境変数設定

## 対象ツール

- **Gradle**: ビルドツール
- **Android SDK**: Android開発キット
- **Flutter/Dart**: クロスプラットフォームアプリ開発
- **fvm**: Flutter Version Management（手動インストール）

## 使用方法

このモジュールは**オプション**です。モバイルアプリ開発をしない場合は、`home-manager.nix`の`imports`セクションからこのモジュールを削除してください。

## 環境変数

- `GRADLE_USER_HOME`: `~/.local/share/gradle`
- `ANDROID_HOME`: `~/Library/Android/sdk` (macOS)
- `NDK_HOME`: `~/Library/Android/sdk/ndk/26.1.10909125` (macOS)

## 必要な手動セットアップ

1. **Android SDK**: Android Studioからインストール
2. **Flutter**: 公式サイトからインストール
3. **fvm**: Flutterバージョン管理（オプション）
   ```bash
   dart pub global activate fvm
   ```

## 注意

macOS固有の設定が含まれています。Linuxで使用する場合は適宜パスを調整してください。

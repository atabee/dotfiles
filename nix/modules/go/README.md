# Go

Go言語開発環境

## ファイル

- `default.nix`: Nixモジュール設定

## 機能

- **GOPATH**: `~/go`
- **GOBIN**: `~/go/bin`
- **環境変数**: 自動設定

## ディレクトリ構造

```
~/go/
├── bin/     # コンパイル済みバイナリ
├── pkg/     # パッケージオブジェクト
└── src/     # ソースコード（ghqルートとしても使用）
```

## 使用方法

```bash
# パッケージのインストール
go install example.com/package@latest

# ビルド
go build

# テスト
go test
```

## ghq統合

`~/go/src`はghqのルートディレクトリとしても設定されています。

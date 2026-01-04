# Zsh

Powerlevel10kテーマとモダンなツール統合を備えたZ shell設定

## ファイル

- `default.nix`: Nixモジュール設定
- `p10k.zsh`: Powerlevel10kテーマ設定（85KB）
- `local.zsh.template`: マシン固有設定のテンプレート
- `functions/`: カスタムZsh関数
  - `copy.zsh`: クリップボード統合（Cパイプエイリアス）

## 機能

- **テーマ**: Powerlevel10k（インスタントプロンプト付き）
- **プラグイン**:
  - zsh-syntax-highlighting（構文ハイライト）
  - zsh-autosuggestions（自動補完候補）
  - zsh-history-substring-search（履歴検索）
- **エイリアス**: eza、trash-cliを使用したモダンな代替コマンド
- **履歴**: セッション間で共有、100,000エントリ保存
- **補完**: 大文字小文字を区別しない、XDG_CACHE_HOMEにキャッシュ

## ローカル設定

マシン固有の設定を作成:

```bash
cp nix/programs/zsh/local.zsh.template ~/.config/zsh/local.zsh
```

このファイルは自動的に読み込まれますが、Gitでは追跡されません。

## ディレクトリ構造

- 設定場所: `~/.config/zsh/`
- 履歴: `~/.zsh_history`
- キャッシュ: `~/.cache/zsh/`

## エイリアス

- `ls`, `l`, `la`, `ll`, `lt`, `lr`: ezaベースのファイル一覧
- `tree`: ezaツリー表示
- `rm`: trash-put（安全な削除）
- `..`, `...`, `....`: 素早いディレクトリ移動

## カスタム関数

- **クリップボードにコピー**: 出力を`C`で終了
  ```bash
  echo "hello" | C  # "hello"をクリップボードにコピー
  ```

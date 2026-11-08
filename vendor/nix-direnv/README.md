# nix-direnv

個別プロジェクトでの`use nix` / `use flake`を利用するため、
nix-direnv 3.1.0の未加工スクリプトを同梱しています。
dotfilesの適用・パッケージ導入にNixは使いません。

- 配置元: `home/dot_config/direnv/lib/nix-direnv.sh`
- 上流: <https://github.com/nix-community/nix-direnv/tree/3.1.0>
- 取得URL: <https://raw.githubusercontent.com/nix-community/nix-direnv/3.1.0/direnvrc>
- SHA-256: `c8c276395333ac56833e7eeaf27081645458a4bfdfd11707ce19b0fe2e9bb493`
- ライセンス: [MIT](LICENSE)

更新時は上流の変更を確認し、`direnvrc`とライセンスを取得して上記ファイルを
差し替え、バージョン・URL・SHA-256も更新してください。
`chezmoi apply`で反映後、Nixプロジェクトで`direnv reload`して確認します。

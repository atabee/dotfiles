{
  pkgs,
  lib,
  ...
}:
{
  # mise をインストール（シェル統合を含む）
  programs.mise = {
    enable = true;
  };

  # Nix 管理のツールを mise use --global で宣言する
  # ファイルの存在チェックなしに毎回実行されるため、ツール追加が確実に反映される
  # ユーザーが mise use で追加したツールは config.toml に保持される
  home.activation.miseConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${pkgs.mise}/bin:${pkgs.coreutils}/bin:/usr/bin:/usr/local/bin:$PATH"

    if command -v mise &> /dev/null; then
      # settings を設定（use より前に適用する必要がある）
      $DRY_RUN_CMD mise settings set experimental true

      # グローバルツールを宣言（既存のユーザー追加ツールは保持される）
      $DRY_RUN_CMD mise use --global node@24 pinact@latest firebase@latest
    fi
  '';

  # activation 時にツールを自動インストール
  home.activation.miseInstall = lib.hm.dag.entryAfter [ "writeBoundary" "miseConfig" ] ''
    export PATH="${pkgs.mise}/bin:${pkgs.coreutils}/bin:/usr/bin:/usr/local/bin:$PATH"

    if command -v mise &> /dev/null; then
      $DRY_RUN_CMD mise install --yes
      $DRY_RUN_CMD mise prune --yes
    fi
  '';
}

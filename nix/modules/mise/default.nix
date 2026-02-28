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
    export PATH="${pkgs.mise}/bin:$PATH"

    if command -v mise &> /dev/null; then
      # グローバルツールを宣言（既存のユーザー追加ツールは保持される）
      $DRY_RUN_CMD mise use --global ruby@3.4.8 pinact@latest firebase@latest

      # settings を設定
      $DRY_RUN_CMD mise settings set experimental true
    fi
  '';

  # activation 時にツールを自動インストール
  home.activation.miseInstall = lib.hm.dag.entryAfter [ "writeBoundary" "miseConfig" ] ''
    export PATH="${pkgs.mise}/bin:$PATH"

    if command -v mise &> /dev/null; then
      $DRY_RUN_CMD mise install --yes
    fi
  '';
}

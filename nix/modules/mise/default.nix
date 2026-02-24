{
  config,
  pkgs,
  lib,
  ...
}:

let
  # mise のグローバル設定内容
  # ツールを追加・変更する場合はここを編集する
  miseConfigContent = ''
    [tools]
    ruby = "3.4.8"
    pinact = "latest"
    firebase = "latest"

    [settings]
    experimental = true
  '';
in
{
  # mise をインストール（シェル統合を含む）
  # globalConfig は使用しない（Nix store の読み取り専用シンボリックリンクになり、
  # mise install / mise use が permission denied になるため）
  programs.mise = {
    enable = true;
  };

  # config.toml を通常の書き込み可能ファイルとしてデプロイする
  # これにより mise install / mise use が正常に動作する
  home.activation.miseConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    MISE_CONFIG_DIR="${config.xdg.configHome}/mise"
    MISE_CONFIG_FILE="$MISE_CONFIG_DIR/config.toml"

    mkdir -p "$MISE_CONFIG_DIR"

    # Nix store へのシンボリックリンクが残っている場合は削除する
    if [ -L "$MISE_CONFIG_FILE" ]; then
      rm "$MISE_CONFIG_FILE"
    fi

    # 通常ファイルが存在しない場合のみ新規作成する
    # （ユーザーが mise use で追加したツールを保持するため）
    if [ ! -f "$MISE_CONFIG_FILE" ]; then
      cat > "$MISE_CONFIG_FILE" << 'MISEEOF'
    ${miseConfigContent}
    MISEEOF
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

# Claude Code 設定モジュール
{ config, pkgs, lib, ... }:

{
  # テンプレートとしてデプロイ（参照用）
  home.file.".claude/settings.json.template".source = ./settings.json;

  # settings.json が存在しない場合のみテンプレートからコピー
  # Claude Code は設定ファイルへの書き込み権限が必要なため、
  # シンボリックリンクではなく実ファイルとして配置
  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -f "$HOME/.claude/settings.json" ] || [ -L "$HOME/.claude/settings.json" ]; then
      $DRY_RUN_CMD mkdir -p "$HOME/.claude"
      # シンボリックリンクの場合は削除してからコピー
      if [ -L "$HOME/.claude/settings.json" ]; then
        $DRY_RUN_CMD rm "$HOME/.claude/settings.json"
      fi
      $DRY_RUN_CMD cp "$HOME/.claude/settings.json.template" "$HOME/.claude/settings.json"
      $DRY_RUN_CMD chmod 644 "$HOME/.claude/settings.json"
    fi
  '';
}

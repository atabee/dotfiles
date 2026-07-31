{ config, lib, ... }:

{
  # Herdr はオンボーディング完了や設定画面の変更を config.toml に書き戻す。
  # Nix store への読み取り専用リンクにせず、未作成の場合だけ初期設定をコピーする。
  home.activation.initializeHerdrConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    config_dir="${config.home.homeDirectory}/.config/herdr"
    config_file="$config_dir/config.toml"

    run mkdir -p "$config_dir"
    if [ ! -e "$config_file" ]; then
      run cp "${./config.toml}" "$config_file"
      run chmod u+w "$config_file"
    fi
  '';

  # HerdrのGitHubプラグインは専用レジストリで管理されるため、未導入時だけ追加する。
  home.activation.installHerdrHunkPlugin = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
    herdr_bin="$(command -v herdr 2>/dev/null || true)"
    if [ -z "$herdr_bin" ]; then
      for candidate in /opt/homebrew/bin/herdr /usr/local/bin/herdr; do
        if [ -x "$candidate" ]; then
          herdr_bin="$candidate"
          break
        fi
      done
    fi

    if [ -n "$herdr_bin" ] \
      && ! "$herdr_bin" plugin list --plugin hunk.diff --json 2>/dev/null \
        | grep -Eq '"plugin_id"[[:space:]]*:[[:space:]]*"hunk.diff"'; then
      run "$herdr_bin" plugin install edmundmiller/herdr-plugin-hunk --yes
    fi
  '';
}

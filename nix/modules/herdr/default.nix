{ lib, ... }:

{
  home.file.".config/herdr/config.toml".source = ./config.toml;

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

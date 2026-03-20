# Claude Code 設定モジュール
{ config, pkgs, lib, profile ? "personal", ... }:

let
  # 共通プラグイン
  commonPlugins = {
    "example-skills@anthropic-agent-skills" = true;
    "swift-lsp@claude-plugins-official" = true;
    "context7@claude-plugins-official" = true;
    "commit-commands@claude-plugins-official" = true;
  };

  # personal プロファイル専用プラグイン
  personalPlugins = {
    "assets-plugin@personal-marketplace" = true;
  };

  enabledPlugins = commonPlugins // (lib.optionalAttrs (profile == "personal") personalPlugins);

  settings = {
    permissions = {
      allow = [
        "Bash(source:*)"
        "Bash(git:*)"
        "Bash(npm:*)"
        "Bash(npx:*)"
        "Bash(yarn:*)"
        "Bash(pnpm:*)"
        "Bash(bun:*)"
        "Bash(pip:*)"
        "Bash(python:*)"
        "Bash(python3:*)"
        "Bash(node:*)"
        "Bash(deno:*)"
        "Bash(cargo:*)"
        "Bash(rustc:*)"
        "Bash(go:*)"
        "Bash(mvn:*)"
        "Bash(gradle:*)"
        "Bash(make:*)"
        "Bash(cmake:*)"
        "Bash(jest:*)"
        "Bash(vitest:*)"
        "Bash(pytest:*)"
        "Bash(mocha:*)"
        "Bash(jasmine:*)"
        "Bash(cypress:*)"
        "Bash(playwright:*)"
        "Bash(eslint:*)"
        "Bash(prettier:*)"
        "Bash(black:*)"
        "Bash(flake8:*)"
        "Bash(mypy:*)"
        "Bash(tsc:*)"
        "Bash(rustfmt:*)"
        "Bash(gofmt:*)"
        "Bash(ls:*)"
        "Bash(cat:*)"
        "Bash(head:*)"
        "Bash(tail:*)"
        "Bash(grep:*)"
        "Bash(find:*)"
        "Bash(which:*)"
        "Bash(where:*)"
        "Bash(pwd:*)"
        "Bash(echo:*)"
        "Bash(printf:*)"
        "Bash(wc:*)"
        "Bash(sort:*)"
        "Bash(uniq:*)"
        "Bash(awk:*)"
        "Bash(sed:*)"
        "Bash(cut:*)"
        "Bash(tr:*)"
        "Bash(mkdir:*)"
        "Bash(touch:*)"
        "Bash(cp:*)"
        "Bash(mv:*)"
        "Bash(chmod:*)"
        "Bash(chown:*)"
        "Bash(docker:*)"
        "Bash(docker-compose:*)"
        "Bash(kubectl:*)"
        "Bash(helm:*)"
        "Bash(nvm:*)"
        "Bash(rbenv:*)"
        "Bash(pyenv:*)"
        "Bash(rustup:*)"
        "Bash(gh:*)"
        "Bash(hub:*)"
        "Bash(glab:*)"
        "Bash(heroku:*)"
        "Bash(vercel:*)"
        "Bash(netlify:*)"
        "Bash(ps:*)"
        "Bash(top:*)"
        "Bash(htop:*)"
        "Bash(df:*)"
        "Bash(du:*)"
        "Bash(free:*)"
        "Bash(uname:*)"
        "Bash(whoami:*)"
        "Bash(id:*)"
        "Bash(date:*)"
        "Bash(uptime:*)"
        "Bash(hg:*)"
        "Bash(svn:*)"
        "Bash(sqlite3:*)"
        "Bash(psql:*)"
        "Bash(mysql:*)"
        "Bash(redis-cli:*)"
        "Bash(mongo:*)"
        "Read"
        "Edit"
        "Create"
        "Write"
        "Delete"
        "Grep"
        "Glob"
        "LS"
        "WebFetch(domain:github.com)"
        "WebFetch(domain:docs.*)"
        "WebFetch(domain:api.*)"
        "WebFetch(domain:raw.githubusercontent.com)"
        "WebFetch(domain:stackoverflow.com)"
        "WebFetch(domain:developer.mozilla.org)"
        "mcp__*"
        "mcp__pencil"
      ];
      deny = [
        "Bash(sudo:*)"
        "Bash(git reset:*)"
        "Bash(git rebase:*)"
        "Read(id_rsa)"
        "Read(id_ed25519)"
        "Read(**/*token*)"
        "Read(**/*key*)"
        "Bash(rm -rf:*)"
        "Bash(rm -rf /)"
        "Bash(rm -rf ~)"
        "Bash(rm -rf ~/*)"
        "Bash(rm -rf /*)"
        "Read(.env)"
        "Read(.env.local)"
        "Read(.env.development)"
        "Read(.env.production)"
        "Read(**/.env)"
        "Read(**/.env.local)"
        "Read(**/.env.development)"
        "Read(**/.env.production)"
        "Read(**/*secret*)"
        "Write(.env)"
        "Write(.env.local)"
        "Write(.env.development)"
        "Write(.env.production)"
        "Write(**/.env)"
        "Write(**/.env.local)"
        "Write(**/.env.development)"
        "Write(**/.env.production)"
        "Write(**/*secret*)"
      ];
    };
    statusLine = {
      type = "command";
      command = "~/.claude/statusline.sh";
      padding = 0;
    };
    inherit enabledPlugins;
    hooks = {
      Notification = [
        {
          matcher = "";
          hooks = [
            {
              type = "command";
              command = "terminal-notifier -title 'Claude Code' -message 'Input needed' -sound Glass";
            }
          ];
        }
      ];
      Stop = [
        {
          matcher = "";
          hooks = [
            {
              type = "command";
              command = "terminal-notifier -title 'Claude Code' -message 'Task completed' -sound Hero";
            }
          ];
        }
      ];
    };
  };

  settingsJson = pkgs.writeText "claude-settings.json" (builtins.toJSON settings);
in
{
  # テンプレートとしてデプロイ（参照用）
  home.file.".claude/settings.json.template".source = settingsJson;

  # statusline.sh をシンボリックリンクでデプロイ（読み取り専用）
  home.file.".claude/statusline.sh" = {
    source = ./statusline.sh;
    executable = true;
  };

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

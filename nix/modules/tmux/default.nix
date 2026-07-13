{
  config,
  pkgs,
  lib,
  ...
}:

let
  clipboardCommand =
    if pkgs.stdenv.isDarwin then
      "pbcopy"
    else
      "if command -v clip.exe >/dev/null 2>&1; then clip.exe; elif command -v wl-copy >/dev/null 2>&1; then wl-copy; else xsel --input --clipboard; fi";
in
{
  programs.tmux = {
    enable = true;

    # 基本設定
    terminal = "screen-256color";
    escapeTime = 0;
    baseIndex = 1;

    # マウスサポート
    mouse = true;

    # vi モードキーバインド
    keyMode = "vi";

    # プレフィックスキー (Ctrl+b) - デフォルト
    prefix = "C-b";

    extraConfig = ''
      # 256色端末
      set -g terminal-overrides 'xterm:colors=256'

      # status line を更新する間隔を1秒にする
      set-option -g status-interval 1

      # ペインのインデックスを1から始める
      setw -g pane-base-index 1

      # アクティブなペインのみ白っぽく変更（真っ黒は232）
      set -g window-style 'bg=colour239'
      set -g window-active-style 'bg=colour234'

      # キーの割り当て変更
      ## prefix + -で水平分割
      bind - split-window -v

      ## prefix + |で垂直分割
      bind | split-window -h

      ## ウィンドウのトグル
      bind C-o last-window

      ## ペインの移動をprefixなしで行う（Shift + 矢印キー）
      bind -n S-left select-pane -L
      bind -n S-down select-pane -D
      bind -n S-up select-pane -U
      bind -n S-right select-pane -R

      # status lineの設定
      set -g window-status-current-style fg=colour0,bg=colour4

      # マウス操作
      bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'copy-mode -e'"
      bind -n WheelDownPane select-pane -t= \; send-keys -M

      # コマンドモードでの選択方法をvim風に変更
      setw -g mode-keys vi
      bind-key -T copy-mode-vi v send -X begin-selection

      # クリップボードとの連携 (macOS / WSL / Linux)
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${clipboardCommand}"
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "${clipboardCommand}"
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "${clipboardCommand}"
    '';
  };
}

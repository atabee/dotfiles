{ pkgs, lib, ... }:

{
  programs.lazygit = {
    enable = true;

    settings = {
      gui = {
        # side by side diff表示を有効化
        sideBySideDiffs = true;
      };

      git = {
        paging = {
          # deltaをpagerとして使用（side-by-sideはdelta側で設定済み）
          colorArg = "always";
          pager = "delta --dark --pager \"less -RF\"";
        };
      };
    };
  };
}

{ lib, ... }:

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
          # deltaをpagerとして使用（グローバル設定が引き継がれないため--side-by-sideを直接指定）
          # lazygit自身がpagingを管理するため--paging=neverでdelta側のpagerを無効化
          colorArg = "always";
          pager = "delta --dark --side-by-side --paging=never";
        };
      };
    };
  };
}

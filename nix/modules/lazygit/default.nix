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
          # deltaをpagerとして使用。--side-by-sideを明示指定（グローバル設定はlazygit経由では引き継がれないため）
          colorArg = "always";
          pager = "delta --side-by-side --pager \"less -RF\"";
        };
      };
    };
  };
}

# git switch + fzf でブランチをインタラクティブに切り替える
# ref: https://zenn.dev/tenkoma/articles/git-fuzzy-switch
function git-fuzzy-switch() {
    # 現在のブランチ名を取得
    local current_branch=$(git rev-parse --abbrev-ref HEAD)

    # ブランチ一覧(現在のブランチには "* "がついている)
    local branches=$(git branch --all)

    # (create from "current-branch")オプションを追加
    local selected=$(echo -e "${branches}\n  (create from \"${current_branch}\")" | fzf --height 80% --layout=reverse \
        --preview "if [[ {} != *\"create from\"* ]]; then git show-graph --color=always \$(echo {} | sed -E \"s/^[* ]?([^*]+).*/\1/\"); fi" \
        --preview-window=right:60% \
        --ansi)

    # キャンセルされた場合は終了
    [ -z "$selected" ] && return 1

    if [[ "$selected" == "  (create from \"${current_branch}\")" ]]; then
        # 新規ブランチ名の入力
        printf "Input new branch name: "
        read new_branch

        # 入力がない場合は終了
        [ -z "$new_branch" ] && return 1

        # 新規ブランチを作成してチェックアウト
        git switch -c "$new_branch"
    else
        # 選択したブランチから印と追加情報を削除して切り替え
        local branch_name=$(echo "$selected" | sed -E 's/^[* ]//' | sed -E 's/^[  ]//' | sed -E 's|remotes/origin/||')
        git switch "$branch_name"
    fi
}

alias gfs="git-fuzzy-switch"

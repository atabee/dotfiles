#! /usr/bin/env bash

is_exists() {
    which "$1" >/dev/null 2>&1
    return $?
}

install_fzf() {
    if is_exists "fzf" ; then
        return 0
    fi

    case "$(uname)" in
        *'Linux'*)
            pushd $DOTPATH
            curl -LSfs https://raw.githubusercontent.com/junegunn/fzf/master/install | bash -s  -- --bin
            popd
            ;;
        *'Darwin'*)
            install_brew
            brew install fzf
            ;;
        *)
            err "このOSでは使えません"
            exit 1
            ;;
    esac
}

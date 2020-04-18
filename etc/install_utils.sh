#! /usr/bin/env bash

is_exists() {
    which "$1" >/dev/null 2>&1
    return $?
}

install_brew() {
    if is_exists "brew" || [[ $(uname) != 'Darwin' ]] ; then
        return 0
    fi

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

install_git() {
    if is_exists "git" ; then
        return 0
    fi

    case "$(uname)" in
        *'Linux'*)
            if [[ -f /etc/os-release ]]; then
                sudo apt install git 
            fi
            ;;
        *'Darwin'*)
            install_brew
            brew install git
            ;;
        *)
            err "このOSでは使えません"
            exit 1
            ;;
    esac
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

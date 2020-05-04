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
    brew install cask
}

install_fzf() {
    if is_exists "fzf" ; then
        return 0
    fi

    case "$(uname)" in
        *'Linux'*)
            println "install fzf for linux..."
            pushd $DOTPATH
            curl -LSfs https://raw.githubusercontent.com/junegunn/fzf/master/install | bash -s  -- --bin
            popd
            ;;
        *'Darwin'*)
            println "install fzf for mac..."
            install_brew
            brew install fzf
            ;;
        *)
            err "このOSでは使えません"
            exit 1
            ;;
    esac
}

install_go() {
    if is_exists "go" ; then
        return 0
    fi

    case "$(uname)" in
        *'Linux'*)
            #TODO
            ;;
        *'Darwin'*)
            println "install go for mac os x..."
            install_brew
            brew install go
            ;;
        *)
            err "このOSでは使えません"
            exit 1
            ;;
    esac
}

install_ghq() {
    if is_exists "ghq" ; then
        return 0
    fi

    case "$(uname)" in
        *'Linux'*)
            #TODO
            ;;
        *'Darwin'*)
            println "install ghq for mac os x..."
            install_brew
            brew install ghq
            ;;
        *)
            err "このOSでは使えません"
            exit 1
            ;;
    esac
}

install_other() {
    case "$(uname)" in
        *'Linux'*)
            #TODO
            ;;
        *'Darwin'*)
            install_brew
            println "install lv for mac os x..."
            brew install lv
            ;;
        *)
            err "このOSでは使えません"
            exit 1
            ;;
    esac
}

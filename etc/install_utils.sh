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

install_vcode() {
    if is_exists "code" ; then
        return 0
    fi

    case "$(uname)" in
        *'Linux'*)
            #TODO
            ;;
        *'Darwin'*)
            println "install visual studio code for mac..."
            sudo xcodebuild -license accept
            install_brew
            brew update
            brew cask install visual-studio-code
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
            println "install fzf for linux..."
            pushd $DOTPATH
            curl -LSfs https://raw.githubusercontent.com/junegunn/fzf/master/install | bash -s  -- --bin
            popd
            ;;
        *'Darwin'*)
            println "install fzf for mac..."
            sudo xcodebuild -license accept
            install_brew
            brew install fzf
            ;;
        *)
            err "このOSでは使えません"
            exit 1
            ;;
    esac
}

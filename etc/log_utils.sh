#! /usr/bin/env bash

newline() {
    printf "\n"
}

println() {
    printf "\033[37;1m%s\033[m\n" "$*"
}

warning() {
    printf "\033[31m%s\033[m\n" "$*"
}

err() {
    printf "\033[31m%s\033[m\n" "✖ $*" 1>&2
}
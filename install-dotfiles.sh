#!/usr/bin/env bash

DOTFILES_DIR="$(dirname "${BASH_SOURCE}")"
BACKUP_DIR="${DOTFILES_DIR}/backup"

init_backup_dir() {
    mkdir -p "$BACKUP_DIR"
    pushd "$BACKUP_DIR"
    git init
    popd
}

commit_if_dirty() {
    pushd "$1"
    if [[ $(git diff --stat) != '' ]]; then
        git add --all
        git commit -m "dirty backup repo"
    fi
    popd
}

backup() {
    local srcFile="$1"
    local fileName=$(basename $1)
    local destFile="$BACKUP_DIR/$fileName"

    if [[ -f "$srcFile" ]]; then
        commit_if_dirty "$BACKUP_DIR"
        cp "$srcFile" "$destFile"

        pushd "$BACKUP_DIR"
        git add "${fileName}"
        git commit -m "file: ${fileName}"
        popd
    fi
}

if [[ ! -d "$BACKUP_DIR" ]]; then
    init_backup_dir
fi

backup $HOME/.zshrc
cp $DOTFILES_DIR/.zshrc $HOME

backup $HOME/Library/Preferences/com.googlecode.iterm2.plist
cp $DOTFILES_DIR/com.googlecode.iterm2.plist $HOME/Library/Preferences
defaults read com.googlecode.iterm2
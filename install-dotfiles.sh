#!/usr/bin/env bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE}")"; pwd)"
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
    local srcParent="$1"
    local srcFile="$2"
    echo "$srcParent/$srcFile"
    if [[ -f "$srcParent/$srcFile" ]]; then
        commit_if_dirty "$BACKUP_DIR"
        pushd "$srcParent"
        rsync -R "$srcFile" "$BACKUP_DIR"
        popd

        pushd "$BACKUP_DIR"
        git add "${srcFile}"
        git commit -m "file: ${srcFile}"
        popd
    fi
}

if [[ ! -d "$BACKUP_DIR" ]]; then
    init_backup_dir
fi

# .zshrc
if [[ "$SKIP_ZSH" != "true" && "$SKIP_ZSH" != "1" ]]; then
    backup "$HOME" .zshrc
    cp "$DOTFILES_DIR/.zshrc" "$HOME"
fi

# iTerm configuration
if [[ "$SKIP_ITERM" != "true" && "$SKIP_ITERM" != "1" ]]; then
    backup "$HOME/Library/Preferences" com.googlecode.iterm2.plist
    cp "$DOTFILES_DIR/com.googlecode.iterm2.plist" "$HOME/Library/Preferences"
    defaults read com.googlecode.iterm2
fi

# Starship Prompt configuration
if [[ "$SKIP_STARSHIP" != "true" && "$SKIP_STARSHIP" != "1" ]]; then
    mkdir -p "$HOME/.config" 
    backup "$HOME" .config/starship.toml
    cp "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"
fi
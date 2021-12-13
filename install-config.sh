#!/usr/bin/env bash

# make sure that DOTFILES_DIR is absolute so BACKUP_DIR 
# also works when switching the current directory
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

# backup srcParent srcFile
#
# Creates a backup copy of $srcParent/$srcFile into $BACKUP_DIR.
#
# It will also copy any sub-directory in $srcFile.
#
# For example: backup $HOME .config/xyz
# Copies .config/xyz into BACKUP_DIR
# 
# To copy xyz without .config:
# backup $HOME/.config xyz
backup() {
    local srcParent="$1"
    local srcFile="$2"

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

# From https://stackoverflow.com/a/8574392/346169
containsElement () {
    local e match="$1"
    shift
    for e; do [[ "$e" == "$match" ]] && return 0; done
    return 1
}

# Configurations
config_zsh() {
    backup "$HOME" .zshrc
    cp "$DOTFILES_DIR/.zshrc" "$HOME"
}

config_iterm() {
    backup "$HOME/Library/Preferences" com.googlecode.iterm2.plist
    cp "$DOTFILES_DIR/com.googlecode.iterm2.plist" "$HOME/Library/Preferences"
    defaults read com.googlecode.iterm2
}

config_starship() {
    mkdir -p "$HOME/.config" 
    backup "$HOME" .config/starship.toml
    cp "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"
}

# The available configuration functions without the config_ prefix
configs=(
    zsh
    iterm
    starship
)

# If there are no arguments install everything
if [[ $# -eq 0 ]]; then
    to_install=( "${configs[@]}" )
else
    to_install=( "$@" )
fi

# Validate the names of configurations to install
for config in "${to_install[@]}"; do
    if ! containsElement "${config}" "${configs[@]}"; then
        echo "Error: unknown configuration name: ${config}"
        echo
        echo "Available configurations: ${configs[@]}"
        exit 1
    fi
done

# Install each configuration
for config in "${to_install[@]}"; do
    "config_${config}"
done


#!/usr/bin/env bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE}")"; pwd)"
BACKUP_DIR="${DOTFILES_DIR}/backup"

cp "$HOME/Library/Preferences/com.googlecode.iterm2.plist" $DOTFILES_DIR
plutil -convert xml1 com.googlecode.iterm2.plist
#!/usr/bin/env bash

REPOSITORY=https://github.com/dfernandez79/dotfiles

# Make sure to cancel the whole script when Ctrl-C is pressed
trap "exit" INT

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- Brewfile start ---
brew bundle --no-lock --file=- <<EOF
tap "homebrew/cask-fonts"
tap "homebrew/cask-versions"

brew "antigen"
brew "ast-grep"
brew "sqlite"
brew "chezmoi"
brew "fnm"
brew "gh"
brew "git"
brew "pinentry"
brew "gnupg"
brew "graphviz"
brew "hyperfine"
brew "jq"
brew "lsd"
brew "mas"
brew "ollama"
brew "pastel"
brew "pinentry-mac"
brew "ripgrep"
brew "shfmt"
brew "sqllite"
brew "starship"
brew "zsh"

cask "appcleaner"
cask "chatgpt"
cask "figma"
cask "firefox-developer-edition"
cask "font-fira-code-nerd-font"
cask "gitup"
cask "google-chrome"
cask "handbrake"
cask "iterm2"
cask "keyboardcleantool"
cask "keycastr"
cask "obsidian"
cask "openvpn-connect"
cask "origami-studio"
cask "sf-symbols"
cask "slack"
cask "utm"
cask "visual-studio-code"
cask "vlc"
cask "zoom"

mas "CrystalFetch", id: 6454431289
mas "Gifski", id: 1351639930
mas "Grammarly for Safari", id: 1462114288
mas "Hidden Bar", id: 1452453066
mas "Keynote", id: 409183694
mas "Kindle", id: 302584613
mas "MindNode", id: 1289197285
mas "Moom", id: 419330170
mas "Numbers", id: 409203825
mas "Pages", id: 409201541
mas "PastePal", id: 1503446680
mas "Pixelmator Pro", id: 1289583905
mas "Streaks", id: 963034692
mas "WhatsApp", id: 1147396723
mas "Xcode", id: 497799835

vscode "anweber.vscode-httpyac"
vscode "bierner.comment-tagged-templates"
vscode "bierner.github-markdown-preview"
vscode "bierner.markdown-checkbox"
vscode "bierner.markdown-emoji"
vscode "bierner.markdown-footnotes"
vscode "bierner.markdown-mermaid"
vscode "bierner.markdown-preview-github-styles"
vscode "bierner.markdown-yaml-preamble"
vscode "davidanson.vscode-markdownlint"
vscode "dbaeumer.vscode-eslint"
vscode "eamodio.gitlens"
vscode "editorconfig.editorconfig"
vscode "esbenp.prettier-vscode"
vscode "figma.figma-vscode-extension"
vscode "foxundermoon.shell-format"
vscode "github.vscode-pull-request-github"
vscode "gruntfuggly.todo-tree"
vscode "ms-vsliveshare.vsliveshare"
vscode "orta.vscode-jest"
vscode "pflannery.vscode-versionlens"
vscode "pomdtr.excalidraw-editor"
vscode "stkb.rewrap"
vscode "streetsidesoftware.code-spell-checker"
vscode "streetsidesoftware.code-spell-checker-spanish"
vscode "styled-components.vscode-styled-components"
vscode "vitest.explorer"
vscode "vscode-icons-team.vscode-icons"
EOF
# --- Brewfile end ---

# Use the latest zsh version from Homebrew
if ! fgrep -q "${HOMEBREW_PREFIX}/bin/zsh" /etc/shells; then
    echo "Adding ${HOMEBREW_PREFIX}/bin/zsh to /etc/shells"
    echo "${HOMEBREW_PREFIX}/bin/zsh" | sudo tee -a /etc/shells
    chsh -s "${HOMEBREW_PREFIX}/bin/zsh"
fi

mkdir -p ~/Projects
chezmoi init --apply $REPOSITORY

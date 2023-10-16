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

brew "antigen"
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
brew "pinentry-mac"
brew "ripgrep"
brew "starship"
brew "zsh"

cask "appcleaner"
cask "font-fira-code-nerd-font"
cask "gitup"
cask "handbrake"
cask "iterm2"
cask "keycastr"
cask "obsidian"
cask "sf-symbols"
cask "utm"
cask "visual-studio-code"
cask "vlc"

mas "Gifski", id: 1351639930
mas "Hidden Bar", id: 1452453066
mas "Keynote", id: 409183694
mas "MindNode", id: 1289197285
mas "Moom", id: 419330170
mas "Numbers", id: 409203825
mas "Pages", id: 409201541
mas "Pixelmator Pro", id: 1289583905
mas "Streaks", id: 963034692
mas "WhatsApp", id: 1147396723
mas "Xcode", id: 497799835

vscode "bierner.github-markdown-preview"
vscode "bierner.markdown-checkbox"
vscode "bierner.markdown-emoji"
vscode "bierner.markdown-footnotes"
vscode "bierner.markdown-mermaid"
vscode "bierner.markdown-preview-github-styles"
vscode "bierner.markdown-yaml-preamble"
vscode "DavidAnson.vscode-markdownlint"
vscode "dbaeumer.vscode-eslint"
vscode "eamodio.gitlens"
vscode "EditorConfig.EditorConfig"
vscode "esbenp.prettier-vscode"
vscode "GitHub.vscode-pull-request-github"
vscode "Gruntfuggly.todo-tree"
vscode "humao.rest-client"
vscode "ms-vsliveshare.vsliveshare"
vscode "Orta.vscode-jest"
vscode "pflannery.vscode-versionlens"
vscode "stkb.rewrap"
vscode "streetsidesoftware.code-spell-checker"
vscode "streetsidesoftware.code-spell-checker-spanish"
vscode "styled-components.vscode-styled-components"
vscode "unifiedjs.vscode-mdx"
vscode "vscode-icons-team.vscode-icons"
EOF
# --- Brewfile end ---

# Use the latest zsh version from Homebrew
if ! fgrep -q "${HOMEBREW_PREFIX}/bin/zsh" /etc/shells; then
    echo "Adding ${HOMEBREW_PREFIX}/bin/zsh to /etc/shells"
    echo "${HOMEBREW_PREFIX}/bin/zsh" | sudo tee -a /etc/shells;
    chsh -s "${HOMEBREW_PREFIX}/bin/zsh";
fi;

mkdir -p ~/Projects
chezmoi init --apply $REPOSITORY

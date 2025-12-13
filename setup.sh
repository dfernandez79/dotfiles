#!/usr/bin/env bash

REPOSITORY=https://github.com/dfernandez79/dotfiles

# Make sure to cancel the whole script when Ctrl-C is pressed
trap "exit" INT

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- Brewfile start ---
brew bundle --no-lock --file=- <<EOF
tap "oven-sh/bun"

brew "antigen"
brew "chezmoi"
brew "fd"
brew "ffmpeg"
brew "fnm"
brew "fzf"
brew "gh"
brew "git"
brew "gnupg"
brew "graphviz"
brew "hyperfine"
brew "imagemagick"
brew "jq"
brew "lazygit"
brew "lsd"
brew "luarocks"
brew "mas"
brew "neovim"
brew "oven-sh/bun/bun"
brew "pinentry-mac"
brew "pinentry"
brew "ripgrep"
brew "shfmt"
brew "starship"
brew "tmux"
brew "tree-sitter-cli"
brew "typst"
brew "uv"
brew "zsh"

cask "chatgpt"
cask "claude"
cask "codex"

cask "figma"
cask "firefox@developer-edition"
cask "font-fira-code-nerd-font"
cask "ghostty"
cask "gitup-app"
cask "google-chrome"
cask "handbrake-app"
cask "keyboardcleantool"
cask "macwhisper"
cask "moom"
cask "obsidian"
cask "raycast"
cask "sf-symbols"
cask "slack"
cask "utm"
cask "visual-studio-code"

mas "Actions", id: 1586435171
mas "Affinity Designer 2", id: 1616831348
mas "CrystalFetch", id: 6454431289
mas "Developer", id: 640199958
mas "Gifski", id: 1351639930
mas "Hidden Bar", id: 1452453066
mas "Keynote", id: 409183694
mas "Kindle", id: 302584613
mas "Numbers", id: 409203825
mas "Pages", id: 409201541
mas "Pixelmator Pro", id: 1289583905
mas "Raycast Companion", id: 6738274497
mas "Velja", id: 1607635845
mas "WhatsApp", id: 310633997
mas "Xcode", id: 497799835

vscode "anthropic.claude-code"
vscode "astro-build.astro-vscode"
vscode "bierner.comment-tagged-templates"
vscode "bierner.github-markdown-preview"
vscode "bierner.markdown-checkbox"
vscode "bierner.markdown-emoji"
vscode "bierner.markdown-footnotes"
vscode "bierner.markdown-mermaid"
vscode "bierner.markdown-preview-github-styles"
vscode "bierner.markdown-yaml-preamble"
vscode "bradlc.vscode-tailwindcss"
vscode "bradlc.vscode-tailwindcss"
vscode "charliermarsh.ruff"
vscode "davidanson.vscode-markdownlint"
vscode "dbaeumer.vscode-eslint"
vscode "eamodio.gitlens"
vscode "esbenp.prettier-vscode"
vscode "foxundermoon.shell-format"
vscode "github.copilot-chat"
vscode "github.copilot"
vscode "github.github-vscode-theme"
vscode "github.vscode-github-actions"
vscode "github.vscode-pull-request-github"
vscode "gruntfuggly.todo-tree"
vscode "johnpapa.vscode-peacock"
vscode "mechatroner.rainbow-csv"
vscode "ms-ossdata.vscode-pgsql"
vscode "ms-python.debugpy"
vscode "ms-python.python"
vscode "ms-python.vscode-pylance"
vscode "ms-python.vscode-python-envs"
vscode "ms-toolsai.jupyter-keymap"
vscode "ms-toolsai.jupyter-renderers"
vscode "ms-toolsai.jupyter"
vscode "ms-toolsai.vscode-jupyter-cell-tags"
vscode "ms-toolsai.vscode-jupyter-slideshow"
vscode "ms-vscode.remote-explorer"
vscode "ms-vscode.remote-server"
vscode "ms-vscode.vscode-js-profile-flame"
vscode "pflannery.vscode-versionlens"
vscode "pomdtr.excalidraw-editor"
vscode "sdras.night-owl"
vscode "stkb.rewrap"
vscode "streetsidesoftware.code-spell-checker-spanish"
vscode "streetsidesoftware.code-spell-checker"
vscode "swiftlang.swift-vscode"
vscode "thedavej.night-owl-black"
vscode "unifiedjs.vscode-mdx"
vscode "vitest.explorer"
vscode "vscode-icons-team.vscode-icons"
vscode "yoavbls.pretty-ts-errors"
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

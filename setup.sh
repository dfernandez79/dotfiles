#!/usr/bin/env zsh

REPOSITORY=https://github.com/dfernandez79/dotfiles

set -euo pipefail

show_help() {
    cat <<EOF
Usage: setup.sh [OPTIONS]

Setup macOS with dotfiles and install packages via Homebrew.

OPTIONS:
    --skip-appstore    Skip Mac App Store applications installation
    --skip-vscode      Skip VSCode extensions installation
    --help             Show this help message

NOTES:
    Environment variables SKIP_APPSTORE and SKIP_VSCODE are still supported
    for remote execution (e.g., via curl). Command line arguments take
    precedence over environment variables.

EXAMPLES:
    ./setup.sh
    ./setup.sh --skip-appstore
    ./setup.sh --skip-vscode
    ./setup.sh --skip-appstore --skip-vscode

EOF
    exit 0
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-appstore)
            SKIP_APPSTORE=1
            shift
            ;;
        --skip-vscode)
            SKIP_VSCODE=1
            shift
            ;;
        --help)
            show_help
            ;;
        *)
            echo "Error: Unknown option: $1" >&2
            echo "Run 'setup.sh --help' for usage information." >&2
            exit 1
            ;;
    esac
done

# Make sure to cancel the whole script when Ctrl-C is pressed
trap "exit" INT TERM

log() {
    [[ -n ${DEBUG:-} ]] && printf '[INFO] %s\n' "$*" || true
}

# Install Homebrew if not already installed
if ! command -v brew &>/dev/null && [[ ! -x /opt/homebrew/bin/brew ]]; then
    log "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    log "Homebrew already installed, skipping"
fi

log "Configuring Homebrew shell environment"
eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="${HOMEBREW_PREFIX}/bin:$PATH"

# --- Brewfile start ---
log "Installing packages via brew bundle"

# Build Brewfile dynamically based on selections
BREWFILE=$(cat <<'BREWFILE_CORE'
tap "oven-sh/bun"

brew "antidote"
brew "ast-grep"
brew "chezmoi"
brew "d2"
brew "fd"
brew "ffmpeg"
brew "fnm"
brew "fzf"
brew "gh"
brew "git"
brew "gnupg"
brew "hyperfine"
brew "imagemagick"
brew "jq"
brew "lazygit"
brew "lsd"
brew "luarocks"
brew "mas"
brew "neovim"
brew "oven-sh/bun/bun"
brew "pandoc"
brew "pinentry-mac"
brew "pinentry"
brew "poppler"
brew "postgresql@18"
brew "ripgrep"
brew "ripgrep-all"
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
cask "copilot-cli"
cask "docker-desktop"
cask "figma"
cask "firefox@developer-edition"
cask "font-fira-code-nerd-font"
cask "ghostty"
cask "google-chrome"
cask "handbrake-app"
cask "keyboardcleantool"
cask "macwhisper"
cask "obsidian"
cask "raycast"
cask "sf-symbols"
cask "utm"
cask "visual-studio-code"
BREWFILE_CORE
)

if [[ -z ${SKIP_APPSTORE:-} ]]; then
    BREWFILE+=$(cat <<'BREWFILE_MAS'

mas "Actions", id: 1586435171
mas "CrystalFetch", id: 6454431289
mas "Developer", id: 640199958
mas "Gifski", id: 1351639930
mas "Hidden Bar", id: 1452453066
mas "iA Writer", id: 775737590
mas "Keynote", id: 361285480
mas "Kindle", id: 302584613
mas "Numbers", id: 361304891
mas "Pages", id: 361309726
mas "Pixelmator Pro", id: 1289583905
mas "Raycast Companion", id: 6738274497
mas "Tailscale", id: 1475387142
mas "Velja", id: 1607635845
mas "WhatsApp", id: 310633997
BREWFILE_MAS
)
fi

if [[ -z ${SKIP_VSCODE:-} ]]; then
    BREWFILE+=$(cat <<'BREWFILE_VSCODE'

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
vscode "biomejs.biome"
vscode "bradlc.vscode-tailwindcss"
vscode "charliermarsh.ruff"
vscode "davidanson.vscode-markdownlint"
vscode "daylerees.rainglow"
vscode "dbaeumer.vscode-eslint"
vscode "dnut.rewrap-revived"
vscode "eamodio.gitlens"
vscode "esbenp.prettier-vscode"
vscode "foxundermoon.shell-format"
vscode "github.copilot-chat"
vscode "github.github-vscode-theme"
vscode "github.vscode-github-actions"
vscode "github.vscode-pull-request-github"
vscode "gruntfuggly.todo-tree"
vscode "johnpapa.vscode-peacock"
vscode "llvm-vs-code-extensions.lldb-dap"
vscode "mechatroner.rainbow-csv"
vscode "ms-ossdata.vscode-pgsql"
vscode "ms-python.debugpy"
vscode "ms-python.python"
vscode "ms-python.vscode-pylance"
vscode "ms-python.vscode-python-envs"
vscode "ms-toolsai.jupyter"
vscode "ms-toolsai.jupyter-keymap"
vscode "ms-toolsai.jupyter-renderers"
vscode "ms-toolsai.vscode-jupyter-cell-tags"
vscode "ms-toolsai.vscode-jupyter-slideshow"
vscode "ms-vscode.remote-explorer"
vscode "ms-vscode.remote-server"
vscode "ms-vscode.vscode-js-profile-flame"
vscode "pflannery.vscode-versionlens"
vscode "pomdtr.excalidraw-editor"
vscode "redhat.vscode-xml"
vscode "sdras.night-owl"
vscode "sergeypushkin.filename-case"
vscode "streetsidesoftware.code-spell-checker"
vscode "streetsidesoftware.code-spell-checker-spanish"
vscode "styled-components.vscode-styled-components"
vscode "swiftlang.swift-vscode"
vscode "terrastruct.d2"
vscode "thedavej.night-owl-black"
vscode "unifiedjs.vscode-mdx"
vscode "vitest.explorer"
vscode "vscode-icons-team.vscode-icons"
vscode "yoavbls.pretty-ts-errors"
BREWFILE_VSCODE
)
fi

brew bundle --file=- <<< "$BREWFILE"
# --- Brewfile end ---

# Use the latest zsh version from Homebrew
if ! grep -q "${HOMEBREW_PREFIX}/bin/zsh" /etc/shells; then
    log "Adding ${HOMEBREW_PREFIX}/bin/zsh to /etc/shells"
    echo "${HOMEBREW_PREFIX}/bin/zsh" | sudo tee -a /etc/shells
    chsh -s "${HOMEBREW_PREFIX}/bin/zsh"
fi

log "Creating ~/Projects"
mkdir -p ~/Projects

log "Initializing chezmoi from $REPOSITORY"
chezmoi init --apply "$REPOSITORY"

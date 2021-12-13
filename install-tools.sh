#!/usr/bin/env bash

# Make sure to cancel the whole script when Ctrl-C is pressed
trap "exit" INT

# Check the availability of Homebrew and optionally install it
if ! [[ -x "$(command -v brew)" ]]; then
    read -p "Homebrew is not installed. Install Homebrew? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z "$REPLY" ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo
        echo "Installation cancelled:"
        echo "Check https://brew.sh/ to install Homebrew"
        exit 1
    fi
fi

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install zsh and set it as the default shell
brew install zsh
if ! fgrep -q "${BREW_PREFIX}/bin/zsh" /etc/shells; then
    echo "Adding ${BREW_PREFIX}/bin/zsh to /etc/shells"
    echo "${BREW_PREFIX}/bin/zsh" | sudo tee -a /etc/shells;
    chsh -s "${BREW_PREFIX}/bin/zsh";
fi;

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install tools using brew
tools=(
    git
    # https://github.com/BurntSushi/ripgrep
    ripgrep
    # https://starship.rs/
    starship
    # https://github.com/pyenv/pyenv
    pyenv
    # https://github.com/sharkdp/pastel
    pastel
    gnupg
    # https://the.exa.website/
    exa
    # https://go.dev/
    go
    # https://deno.land/
    deno
    # https://graphviz.org/
    graphviz
    # https://github.com/Schniz/fnm
    fnm
)

brew install ${tools[@]}

# Install Casks
brew tap homebrew/cask-fonts # https://www.nerdfonts.com/

casks=(
    appcleaner
    keycastr
    font-fira-code-nerd-font
    iterm2
    visual-studio-code
    handbrake
    kap
    vlc
    sourcetree
    obsidian
    sf-symbols
    postman
    virtualbox
)

brew install --cask ${casks[@]}

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# VSCode Extensions
DOTFILES_DIR="$(dirname "${BASH_SOURCE}")"
source "$DOTFILES_DIR/install-vscode-extensions.sh"
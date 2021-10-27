#!/usr/bin/env bash

# Check the availability of Homebrew and optionally install it
if ! [[ -x "$(command -v brew)" ]]; then
    read -p "Homebrew is not installed. Install Homebrew? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z "$REPLY" ]]; then
        echo INSTALL
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

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Install yarn 1.x
curl -o- -L https://yarnpkg.com/install.sh | bash

# Install other tools
# Ripgrep: https://github.com/BurntSushi/ripgrep
# Starship: https://starship.rs/
# Pyenv: https://github.com/pyenv/pyenv
# Pastel: https://github.com/sharkdp/pastel
brew install git ripgrep starship pyenv pastel gnupg rbenv

# Casks
brew install --cask appcleaner
brew install --cask keycastr
brew install --cask iterm2
brew install --cask visual-studio-code
brew install --cask handbrake
brew install --cask virtualbox
brew install --cask kap
brew install --cask vlc
brew install --cask sourcetree
brew install --cask obsidian

# Additional Casks

# https://www.nerdfonts.com/
brew tap homebrew/cask-fonts
brew install --cask font-fira-code-nerd-font

# VSCode Extensions
DOTFILES_DIR="$(dirname "${BASH_SOURCE}")"
source "$DOTFILES_DIR/install-vscode-extensions.sh"
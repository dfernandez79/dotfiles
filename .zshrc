eval "$(pyenv init --path)"

# ---------------------------------------------------------------------------
# Oh-My-Zsh
export ZSH="${HOME}/.oh-my-zsh"

DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
    aliases
    git
    npm
    gitfast
    ripgrep
)
source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

# ---------------------------------------------------------------------------
# NVM
export NVM_DIR="$HOME/.nvm"
[[ -r "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -r "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# ---------------------------------------------------------------------------
# PyEnv
eval "$(pyenv init -)"

# ---------------------------------------------------------------------------
# Paths
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$HOME/.bin:/usr/local/sbin:$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export CDPATH=~/Projects:.

# ---------------------------------------------------------------------------
# Other environment variables

# Cache the downloaded Chromium when using Puppeteer
export PUPPETEER_DOWNLOAD_PATH=~/.npm/chromium

# ---------------------------------------------------------------------------
# Aliases
alias sb="npmR storybook"
alias gcz="git cz"

# Load extra configuration
[[ -r "$HOME/.extra" ]] && source "$HOME/.extra"
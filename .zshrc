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

# ---------------------------------------------------------------------------
# NVM
export NVM_DIR="$HOME/.nvm"
[[ -r "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -r "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# auto load node versions when .nvmrc is present
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

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
alias ls="exa --group-directories-first"
alias ll="ls -lh --icons --git --no-user --no-permissions"
alias sb="npmR storybook"
alias c="code ."

# removes the -v flag in the oh-my-zsh git plugin
alias gc="git commit"

# restore the run-help command (aliased to man for some reason)
unalias run-help
autoload run-help

eval "$(starship init zsh)"
eval "$(rbenv init - zsh)"
source "$HOME/.cargo/env"

# exa colors: https://the.exa.website/docs/colour-themes
GRAY1='38;5;240'
GRAY2='38;5;244'
WHITE='38;5;253'
WHITE_EM='38;5;255'
HEADER='38;5;67'
GOLD='38;5;179'
EXA_COLORS_LIST=(
    "uu=${GRAY1}"
    "da=${GRAY2}"
    "hd=${HEADER}"
    "di=${WHITE_EM};1"
    "ur=${GRAY1}"
    "uw=${GRAY1}"
    "ue=${GRAY1}"
    "gr=${GRAY1}"
    "gw=${GRAY1}"
    "tr=${GRAY1}"
    "tw=${GRAY1}"
    "package.json=${GOLD}"
    "tsconfig.json=${GOLD}"
    "package-lock.json=${GRAY1}"
)
export EXA_COLORS="${(j|:|)EXA_COLORS_LIST}"

# Load extra configuration
[[ -r "$HOME/.extra" ]] && source "$HOME/.extra"
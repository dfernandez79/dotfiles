# ---------------------------------------------------------------------------
# Paths
export PATH="${HOME}/.bin:/Applications/Visual Studio Code.app/Contents/Resources/app/bin:${PATH}"
export CDPATH="${HOME}/Projects:."

# Homebrew will add itself to the PATH
if [[ "$(uname -m)" == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

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
# Startship Prompt
eval "$(starship init zsh)"

# ---------------------------------------------------------------------------
# FNM (replacement of NVM)
eval "$(fnm env --use-on-cd)"

# ---------------------------------------------------------------------------
# PyEnv
eval "$(pyenv init -)"

# ---------------------------------------------------------------------------
# Rust's Cargo
source "$HOME/.cargo/env"

# ---------------------------------------------------------------------------
# Other environment variables

# Cache the downloaded Chromium when using Puppeteer
export PUPPETEER_DOWNLOAD_PATH=~/.npm/chromium

# ---------------------------------------------------------------------------
# Aliases

alias ls="exa --group-directories-first"
alias ll="ls -lh --icons --git"
alias l="ll --no-user --no-permissions"
alias la="l -a"

alias sb="npmR storybook"
alias c="code ."

# removes the -v flag in the oh-my-zsh git plugin
alias gc="git commit"

# restore the run-help command (aliased to man for some reason)
unalias run-help
autoload run-help

# ---------------------------------------------------------------------------
# Exa Colors
# https://the.exa.website/docs/colour-themes

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

# ---------------------------------------------------------------------------
# Extra configuration
[[ -r "${HOME}/.extra" ]] && source "${HOME}/.extra"
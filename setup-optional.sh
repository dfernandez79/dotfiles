#!/usr/bin/env zsh

set -euo pipefail

trap "exit" INT TERM

# Install Claude Code
echo "Installing Claude Code..."
curl -fsSL https://claude.ai/install.sh | bash

# Install qmd
echo "Installing qmd..."
if ! command -v bun &>/dev/null; then
    echo "Error: bun is not available in the PATH — make sure to run this script in a shell that loads all the changes made by setup.sh" >&2
    exit 1
fi

bun install -g @tobilu/qmd

echo "Optional packages installed."

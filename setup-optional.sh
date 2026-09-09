#!/usr/bin/env zsh

set -euo pipefail

trap "exit" INT TERM

SCRIPT_DIR=${0:A:h}
EXTENSIONS_FILE="$SCRIPT_DIR/codium-extensions.txt"

# Check all required binaries before doing any work
MISSING=()
for cmd in bun gh codium; do
    command -v "$cmd" &>/dev/null || MISSING+=("$cmd")
done

if (( ${#MISSING[@]} > 0 )); then
    echo "Error: the following commands are not available in the PATH: ${MISSING[*]}" >&2
    echo "Make sure to run this script in a shell that loads all the changes made by setup.sh" >&2
    exit 1
fi

if [[ ! -f $EXTENSIONS_FILE ]]; then
    echo "Error: $EXTENSIONS_FILE not found" >&2
    exit 1
fi

# Install Claude Code
echo "Installing Claude Code..."
curl -fsSL https://claude.ai/install.sh | bash

# Install qmd
echo "Installing qmd..."
bun install -g @tobilu/qmd

# Install gh extensions
echo "Installing gh extensions..."
INSTALLED_GH_EXTENSIONS=$(gh extension list)
for extension in agynio/gh-pr-review github/gh-stack; do
    if grep -q "$extension" <<< "$INSTALLED_GH_EXTENSIONS"; then
        echo "  $extension already installed, skipping"
    else
        gh extension install "$extension"
    fi
done

# Install VSCodium extensions
echo "Installing VSCodium extensions..."
while IFS= read -r extension || [[ -n $extension ]]; do
    [[ -z ${extension// /} || $extension == \#* ]] && continue
    codium --install-extension "$extension" --force
done < "$EXTENSIONS_FILE"

echo "Optional packages installed."

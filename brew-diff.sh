#!/usr/bin/env zsh
# Dump the installed Homebrew packages to ./Brewfile and compare them with
# the Brewfile embedded in setup.sh (between the "Brewfile start/end"
# markers). Only taps, formulae, casks and App Store apps are compared.
#
# Usage: brew-diff.sh [--no-dump]
#   --no-dump   compare against the existing ./Brewfile instead of dumping

set -euo pipefail

cd "${0:A:h}"

dump=1
case "${1:-}" in
    --no-dump) dump=0 ;;
    "") ;;
    *) echo "Usage: brew-diff.sh [--no-dump]" >&2; exit 1 ;;
esac

if (( dump )); then
    HOMEBREW_NO_AUTO_UPDATE=1 brew bundle dump --force --file=Brewfile --tap --formula --cask --mas
    echo "Wrote $PWD/Brewfile"
fi

# Reduce Brewfile lines to comparable keys: `brew "name"`, or `mas id` for
# App Store apps (names can change, ids don't). Options such as
# `trusted: true` are ignored.
normalize() {
    sed -nE \
        -e 's/^[[:space:]]*mas[[:space:]]+"([^"]*)".*id:[[:space:]]*([0-9]+).*/mas \2 (\1)/p' \
        -e 't' \
        -e 's/^[[:space:]]*(tap|brew|cask)[[:space:]]+"([^"]+)".*/\1 "\2"/p' \
    | sort -u
}

# Compare App Store apps by id only.
key() { sed -E 's/^(mas [0-9]+).*/\1/' }

expected=$(sed -n '/^# --- Brewfile start ---$/,/^# --- Brewfile end ---$/p' setup.sh | normalize)
installed=$(normalize < Brewfile)

missing=$(comm -23 <(print -r -- "$expected" | key | sort) <(print -r -- "$installed" | key | sort))
extra=$(comm -13 <(print -r -- "$expected" | key | sort) <(print -r -- "$installed" | key | sort))

# Re-attach the app names to mas ids for display.
label() {
    local src=$1
    while IFS= read -r k; do
        [[ -z $k ]] && continue
        if [[ $k == mas\ * ]]; then
            print -r -- "$src" | grep -m1 -F "$k (" || print -r -- "$k"
        else
            print -r -- "$k"
        fi
    done
}

rc=0
if [[ -n $missing ]]; then
    echo "\nIn setup.sh but not installed:"
    print -r -- "$missing" | label "$expected" | sed 's/^/  - /'
    rc=1
fi
if [[ -n $extra ]]; then
    echo "\nInstalled but not in setup.sh:"
    print -r -- "$extra" | label "$installed" | sed 's/^/  + /'
    rc=1
fi
(( rc )) || echo "\nInstalled packages match setup.sh."
exit $rc

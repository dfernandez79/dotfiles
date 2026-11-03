#!/bin/sh
# Claude Code status line: profile, repo and branch on the left;
# context bar, model and effort on the right.
# Usage: claude-statusline.sh <profile-label>   (reads Claude's JSON on stdin)

profile="$1"
input=$(cat)
dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
[ -z "$dir" ] && dir=$(pwd)

if [ "$profile" = "work" ]; then
  color='\033[33m'   # yellow
else
  color='\033[36m'   # cyan
fi
reset='\033[0m'
dim='\033[2m'

case "$profile" in
  work) label='💼' ;;
  personal) label='🎨' ;;
  *) label="$profile" ;;
esac
out="${color}${label}${reset}"

branch=$(git -C "$dir" branch --show-current 2>/dev/null)
if [ -z "$branch" ]; then
  # Detached HEAD: show short commit, if inside a repo at all
  branch=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null)
fi

if [ -n "$branch" ]; then
  # Repo name from the main checkout, so worktrees still show the repo's name
  common=$(cd "$dir" && cd "$(git rev-parse --git-common-dir)" 2>/dev/null && pwd)
  repo=$(basename "$(dirname "$common")")
  out="$out \033[97m${repo}${reset} ${dim}·${reset} $branch"
fi

model=$(printf '%s' "$input" | jq -r '.model.display_name // empty')
effort=$(printf '%s' "$input" | jq -r '.effort.level // empty')
[ -n "$effort" ] && model="$model ${dim}[${effort}]${reset}"
right="$model"

# Context usage: prefer the precomputed percentage, else derive it.
ctx=$(printf '%s' "$input" | jq -r '
  .context_window as $c
  | if $c == null then empty
    elif $c.used_percentage != null then $c.used_percentage
    elif $c.current_usage != null and ($c.context_window_size // 0) > 0 then
      (($c.current_usage.input_tokens // 0)
       + ($c.current_usage.cache_creation_input_tokens // 0)
       + ($c.current_usage.cache_read_input_tokens // 0)) * 100 / $c.context_window_size
    else empty end
  | floor' 2>/dev/null)
if [ -n "$ctx" ]; then
  if [ "$ctx" -ge 80 ]; then ccol='\033[31m'
  elif [ "$ctx" -ge 50 ]; then ccol='\033[33m'
  else ccol='\033[32m'; fi
  # 5-cell bar, one cell per 20% (rounded)
  filled=$(( (ctx + 10) / 20 )); [ "$filled" -gt 5 ] && filled=5
  bar=""; i=0
  while [ "$i" -lt 5 ]; do
    if [ "$i" -lt "$filled" ]; then bar="${bar}▰"; else bar="${bar}▱"; fi
    i=$((i + 1))
  done
  seg="${ccol}${bar}${reset}"
  if [ -n "$right" ]; then right="$seg ${dim}·${reset} $right"; else right="$seg"; fi
fi

# Visible width of a string: expand escapes, strip colour codes, count
# characters. Emoji are counted separately (see below).
vis_width() {
  printf '%b' "$1" | sed $'s/\033\\[[0-9;]*m//g' | LC_ALL=en_US.UTF-8 wc -m | tr -d ' '
}

# Right-align: Claude Code sets COLUMNS to the terminal width.
cols=${COLUMNS:-$(tput cols 2>/dev/null)}
if [ -n "$right" ] && [ -n "$cols" ] && [ "$cols" -gt 0 ]; then
  # The profile emoji is 2 columns wide; measure the rest as text.
  lw=$(( $(vis_width "${out#*"$label"}") + 2 ))
  rw=$(vis_width "$right")
  # Claude Code draws the status line 5 columns narrower than COLUMNS
  # (measured), so subtract 6 for a 1-column right margin on screen.
  gap=$(( cols - lw - rw - 6 ))
  [ "$gap" -lt 2 ] && gap=2
  printf '%b%*s%b' "$out" "$gap" '' "$right"
elif [ -n "$right" ]; then
  printf '%b' "$out ${dim}·${reset} $right"
else
  printf '%b' "$out"
fi

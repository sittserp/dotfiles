#!/usr/bin/env bash
#
# Symlink every file under home/ into $HOME, mirroring the directory layout.
#   home/.gitconfig                         -> ~/.gitconfig
#   home/.hammerspoon/init.lua              -> ~/.hammerspoon/init.lua
#   home/Library/LaunchAgents/foo.plist     -> ~/Library/LaunchAgents/foo.plist
#
# Existing real files are moved aside to <name>.backup.<timestamp>; existing
# symlinks that already point at the right place are left alone. Nothing is
# ever deleted. Safe to re-run.
#
# Usage:  ./install.sh [--dry-run]

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$DOTFILES/home"
STAMP="$(date +%Y%m%d%H%M%S)"
DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

run() {
  if (( DRY_RUN )); then
    printf '  would run: %s\n' "$*"
  else
    "$@"
  fi
}

if [[ ! -d "$SRC" ]]; then
  echo "error: $SRC does not exist" >&2
  exit 1
fi

while IFS= read -r -d '' src; do
  rel="${src#"$SRC"/}"
  dest="$HOME/$rel"

  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    echo "ok       $rel (already linked)"
    continue
  fi

  if [[ -e "$dest" || -L "$dest" ]]; then
    echo "backup   $rel -> $rel.backup.$STAMP"
    run mv "$dest" "$dest.backup.$STAMP"
  fi

  run mkdir -p "$(dirname "$dest")"
  run ln -s "$src" "$dest"
  echo "link     $rel"
done < <(find "$SRC" -type f ! -name '.DS_Store' -print0)

# Seed the untracked local-overrides files so a fresh machine has somewhere
# to put secrets. Never overwrites an existing file.
for local_file in "$HOME/.zshrc.local" "$HOME/.gitconfig.local"; do
  if [[ ! -e "$local_file" ]]; then
    echo "seed     $(basename "$local_file")"
    if (( ! DRY_RUN )); then
      cat > "$local_file" <<'SEED'
# Machine-specific, never committed. Put tokens and work-only settings here.
SEED
      chmod 600 "$local_file"
    fi
  fi
done

cat <<'NOTE'

Done. Follow-ups that are deliberately not automated:
  - brew bundle install --file Brewfile     # install packages
  - launchctl unload ~/Library/LaunchAgents/com.local.KeyRemapping.plist
    launchctl load   ~/Library/LaunchAgents/com.local.KeyRemapping.plist
  - Reload Hammerspoon's config from its menu bar icon.
NOTE

#!/usr/bin/env bash
# install.sh — wire this repo into the current machine. Symlink-only: the repo
# stays the single source of truth; edits here are live everywhere. Idempotent.
#
#   ./install.sh              install (or repair) all links
#   ./install.sh --uninstall  remove the links this script manages
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DEST="${WF_BIN_DEST:-$HOME/.local/bin}"

# Claude config dir: explicit env > ~/.claude > ~/.config/claude
if [[ -n "${CLAUDE_CONFIG_DIR:-}" ]]; then
  CFG="$CLAUDE_CONFIG_DIR"
elif [[ -d "$HOME/.claude" ]]; then
  CFG="$HOME/.claude"
else CFG="$HOME/.config/claude"; fi
SKILLS_DEST="$CFG/skills"

if [[ "${1:-}" == "--uninstall" ]]; then
  for f in "$REPO"/bin/*; do
    link="$BIN_DEST/$(basename "$f")"
    [[ -L "$link" && "$(readlink -f "$link")" == "$(readlink -f "$f")" ]] && rm "$link" && echo "removed $link"
  done
  for d in "$REPO"/skills/*/; do
    link="$SKILLS_DEST/$(basename "$d")"
    [[ -L "$link" ]] && rm "$link" && echo "removed $link"
  done
  exit 0
fi

mkdir -p "$BIN_DEST" "$SKILLS_DEST"

echo "bin -> $BIN_DEST (symlinks)"
for f in "$REPO"/bin/*; do
  name="$(basename "$f")"
  [[ "$name" == "wf-env" || "$name" == *.py ]] && continue # sourced/imported, not invoked
  ln -sf "$f" "$BIN_DEST/$name" && chmod +x "$f"
  echo "  $name"
done

echo "skills -> $SKILLS_DEST (symlinks)"
for d in "$REPO"/skills/*/; do
  name="$(basename "$d")"
  ln -sfn "${d%/}" "$SKILLS_DEST/$name"
  echo "  $name"
done

case ":$PATH:" in
*":$BIN_DEST:"*) ;;
*)
  echo
  echo "NOTE: add to PATH:  export PATH=\"$BIN_DEST:\$PATH\""
  ;;
esac

# sanity: symlinked scripts must resolve templates through the repo
if ! grep -q 'readlink -f' "$REPO/bin/wf-env"; then
  echo
  echo "WARNING: bin/wf-env resolves WF_HERE without readlink -f —"
  echo "         symlinked scripts will fail to find templates/. Patch WF_HERE:"
  echo '         WF_HERE="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"'
fi

echo
echo "done. sanity checks:"
echo "  command -v wf-loop        → $(command -v wf-loop 2>/dev/null || echo 'NOT ON PATH')"
echo "  skills dir                → $SKILLS_DEST"
echo "  claude config dir in use  → $CFG"
